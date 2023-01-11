import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '/exports/entities.dart';
import '/repositories/app_storage.dart';

class GeolocatorService {
  static Future<Position> getCurrentPosition() async {
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
        final a = sqrt(pow(x1, 2) + pow(y1, 2));
        final b = sqrt(pow(x2, 2) + pow(y2, 2));
        return a.compareTo(b);
      });
  }

  static Future<Iterable<Route>> direct(Stop from, Stop to) async {
    final routes = await appStorage.getAllRoutes();
    for (final route in routes) {
      final inboundStops = await route.getTrip(TripOfRoute.inbound).stops;
      final outboundStops = await route.getTrip(TripOfRoute.outbound).stops;
      if ((inboundStops.contains(from) && inboundStops.contains(to)) ||
          (outboundStops.contains(from) && outboundStops.contains(to)) ||
          (inboundStops.contains(from) && outboundStops.contains(to)) ||
          (outboundStops.contains(from) && inboundStops.contains(to))) {
        return [route];
      } else {
        //final routes = <Route>[];
      }
    }
    return [];
  }
}

extension PositionX on Position {
  LatLng toLatLng() => LatLng(latitude, longitude);
}
