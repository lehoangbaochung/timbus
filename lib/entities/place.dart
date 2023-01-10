import 'package:bus/exports/entities.dart';

class Place extends Comparable {
  static final Map<String, Place> _shelf = {};

  final String name;
  final String description;
  final Iterable<String> images;

  dynamic _stops;

  Place._(
    super.id, {
    required this.name,
    required this.description,
    required this.images,
  });

  factory Place.fromJson(String id, Map<String, dynamic> fields) {
    return _shelf.putIfAbsent(id, () {
      return Place._(
        id,
        name: fields['name'],
        description: fields['description'],
        images: List.from(fields['images']),
      ).._stops = fields['stops'] ?? '';
    });
  }

  Map<String, dynamic> toJson() {
    final stops = _stops as Iterable<Stop>;
    return {
      id: {
        'name': name,
        'description': description,
        'images': images,
        'stops': stops.map((stop) => stop.id).join(separator),
      },
    };
  }

  String get thumbnail => images.first;
}
