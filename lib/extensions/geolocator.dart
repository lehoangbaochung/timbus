import 'dart:math';

import 'package:bus/exports/entities.dart';
import 'package:bus/repositories/app_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GeolocatorService {
  static Future<Position> getCurrentPosition() async {
    // if (!await Geolocator.isLocationServiceEnabled()) {
    //   return Future.error('Location services are disabled.');
    // }
    await Geolocator.requestPermission();
    final currentPosition = await Geolocator.getCurrentPosition();
    final lastKnownPosition = await Geolocator.getLastKnownPosition();
    return lastKnownPosition ?? currentPosition;
  }

  static Future<Iterable<Stop>> getNearestStops() async {
    final position = await getCurrentPosition();
    final stops = await appStorage.getAllStops();
    return stops.toList()
      ..sort((stop1, stop2) {
        final x1 = position.latitude - stop1.position.latitude;
        final y1 = position.longitude - stop1.position.longitude;
        final x2 = position.latitude - stop2.position.latitude;
        final y2 = position.longitude - stop2.position.longitude;
        final p = sqrt(pow(x1, 2) + pow(y1, 2));
        final q = sqrt(pow(x2, 2) + pow(y2, 2));
        return p.compareTo(q);
      });
  }

  static Future<Iterable<Route>> direct(Stop from, Stop to) async {
    final routes = await appStorage.getAllRoutes();
    for (final route in routes) {
      final inboundStops = await route.getTrip(TripOfRoute.inbound).stops;
      final outboundStops = await route.getTrip(TripOfRoute.outbound).stops;
      if (inboundStops.contains(from) && inboundStops.contains(to) || outboundStops.contains(from) && outboundStops.contains(to)) {
        return [route];
      } else {
        if (outboundStops.contains(from)) {}
      }
    }
    return [];
  }
}

extension PositionX on Position {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

extension PolylineX on List<List<num>> {
  List<LatLng> unpackPolyline() => map((point) => LatLng(point[0].toDouble(), point[1].toDouble())).toList();
}
