import 'package:latlong2/latlong.dart';

import '/exports/entities.dart';
import '/repositories/app_storage.dart';

class Stop extends Comparable {
  static final Map<String, Stop> _shelf = {};
  static final Stop empty = Stop._(
    '0',
    name: '',
    description: '',
    position: LatLng(0, 0),
  );

  final String name;
  final String description;
  final LatLng position;

  dynamic _routes;

  Stop._(
    super.id, {
    required this.name,
    required this.description,
    required this.position,
  });

  factory Stop.fromJson(String id, Map<String, dynamic> json) {
    return _shelf.putIfAbsent(id, () {
      final positionString = json['position'] as String;
      final positionNumbers = positionString.split(separator).map((e) => double.tryParse(e) ?? 0);
      return Stop._(
        id,
        name: json['name'],
        description: json['description'] ?? '',
        position: LatLng(positionNumbers.first, positionNumbers.last),
      );
    });
  }

  Map<String, dynamic> toJson() {
    return {
      id: {
        'name': name,
        'description': description,
        'position': '${position.latitude}$separator${position.longitude}',
      },
    };
  }

  Future<Map<Route, TripOfRoute>> getRoutes([TripOfRoute? tripOfRoute]) async {
    if (_routes is Map<Route, TripOfRoute>) return _routes;
    _routes = <Route, TripOfRoute>{};
    final routesCollection = await appStorage.getAllRoutes();
    for (final route in routesCollection) {
      final inBoundStops = await route.inbound.stops;
      final outBoundStops = await route.outbound.stops;
      if (inBoundStops.any((stop) => stop.id == id)) _routes[route] = TripOfRoute.inbound;
      if (outBoundStops.any((stop) => stop.id == id)) _routes[route] = TripOfRoute.outbound;
    }
    return _routes!;
  }
}
