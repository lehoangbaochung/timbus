import '/exports/entities.dart';
import '/repositories/app_storage.dart';

enum TripOfRoute {
  /// Traveling toward a particular place, especially when returning to the original point of departure.
  inbound,

  /// Traveling away from a particular place, especially on the first leg of a return journey.
  outbound,
}

// ignore: must_be_immutable
class Route extends Comparable {
  static final Map<String, Route> _shelf = {};

  final Trip inbound;
  final Trip outbound;

  dynamic _agency;

  Route._(
    super.id, {
    required this.inbound,
    required this.outbound,
  });

  factory Route.fromJson(String id, Map<String, dynamic> json) {
    return _shelf.putIfAbsent(id, () {
      return Route._(
        id,
        inbound: Trip.fromJson(json['inbound']),
        outbound: Trip.fromJson(json['outbound']),
      ).._agency = json['agency'];
    });
  }

  Map<String, dynamic> toJson() {
    return {
      id: {
        'agency': _agency is Agency ? _agency.id : _agency,
        'inbound': inbound.toJson(),
        'outbound': outbound.toJson(),
      },
    };
  }

  /// Returns the name of this [Route].
  String getName([TripOfRoute tripOfRoute = TripOfRoute.outbound]) {
    switch (tripOfRoute) {
      case TripOfRoute.outbound:
        return '${outbound.name} - ${inbound.name}';
      case TripOfRoute.inbound:
        return '${inbound.name} - ${outbound.name}';
    }
  }

  /// Returns the turn of this [Route].
  Trip getTrip(TripOfRoute tripOfRoute) {
    switch (tripOfRoute) {
      case TripOfRoute.outbound:
        return outbound;
      case TripOfRoute.inbound:
        return inbound;
    }
  }

  /// Returns the [agency] of this [Route].
  Future<Agency?> get agency async {
    if (_agency is Agency) return _agency;
    final agencies = await appStorage.getAllAgencies();
    for (final agency in agencies) {
      if (_agency == agency.id) {
        return _agency = agency;
      }
    }
    return null;
  }
}
