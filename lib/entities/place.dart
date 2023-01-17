import 'package:bus/repositories/app_storage.dart';
import 'package:latlong2/latlong.dart';

import '/exports/entities.dart';

class Place extends Comparable {
  static final Map<String, Place> _shelf = {};

  final String name;
  final String website;
  final LatLng position;
  final String description;
  final Iterable<String> images;

  dynamic _stops;

  Place._(
    super.id, {
    required this.name,
    required this.website,
    required this.position,
    required this.description,
    required this.images,
  });

  factory Place.fromJson(String id, Map<String, dynamic> fields) {
    return _shelf.putIfAbsent(id, () {
      final stopsString = fields['stops'] as String;
      final positionString = fields['position'] as String;
      final positionNumbers = positionString.split(separator).map((e) => double.tryParse(e) ?? 0);
      return Place._(
        id,
        name: fields['name'],
        website: fields['website'],
        description: fields['description'],
        images: Iterable.castFrom(fields['images']),
        position: LatLng(positionNumbers.first, positionNumbers.last),
      ).._stops = stopsString.split(separator);
    });
  }

  Map<String, dynamic> toJson() {
    final stops = _stops as Iterable<Stop>;
    return {
      id: {
        'name': name,
        'website': website,
        'description': description,
        'images': images,
        'stops': stops.map((stop) => stop.id).join(separator),
        'position': '${position.latitude}$separator${position.longitude}',
      },
    };
  }

  Future<Iterable<Stop>> getStops() async {
    if (_stops is Iterable<Stop>) return _stops;
    final stops = <Stop>[];
    final stopsId = _stops as Iterable<String>;
    final stopsCollection = await appStorage.getAllStops();
    for (final stopId in stopsId) {
      stops.addAll(
        stopsCollection.where(
          (stop) => stop.id == stopId,
        ),
      );
    }
    return _stops = stops;
  }
}
