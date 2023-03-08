import '/exports/entities.dart';
import '/repositories/app_storage.dart';

class Place extends Comparable {
  static final Map<String, Place> _shelf = {};

  final String name;
  final String description;
  final String thumbnail;

  dynamic _stops;

  Place._(
    super.id, {
    required this.name,
    required this.description,
    required this.thumbnail,
  });

  factory Place.fromJson(String id, Map<String, dynamic> fields) {
    return _shelf.putIfAbsent(id, () {
      final stopsString = fields['stops'] as String;
      return Place._(
        id,
        name: fields['name'],
        description: fields['description'],
        thumbnail: fields['thumbnail'],
      ).._stops = stopsString.split(separator);
    });
  }

  Map<String, dynamic> toJson() {
    final stops = _stops as Iterable<Stop>;
    return {
      id: {
        'name': name,
        'description': description,
        'thumbnail': thumbnail,
        'stops': stops.map((stop) => stop.id).join(separator),
      },
    };
  }

  Future<Iterable<Stop>> getStops() async {
    if (_stops is Iterable<Stop>) return _stops;
    final stops = <Stop>[];
    final stopsId = _stops as Iterable<String>;
    final stopsCollection = await appStorage.getAllStops();
    for (final stopId in stopsId) {
      for (final stop in stopsCollection) {
        if (stop.id == stopId) {
          stops.add(stop);
          break;
        }
      }
    }
    return _stops = stops;
  }
}
