import '/exports/entities.dart';

class Agency extends Comparable {
  static final Map<String, Agency> _shelf = {};

  final String name;
  final String email;
  final String address;
  final String fax;
  final String phone;
  final String website;
  final String description;
  final Iterable<String> images;

  const Agency._(
    super.id, {
    required this.name,
    required this.fax,
    required this.phone,
    required this.email,
    required this.address,
    required this.website,
    required this.description,
    required this.images,
  });

  factory Agency.fromJson(String id, Map<String, dynamic> fields) {
    return _shelf.putIfAbsent(id, () {
      return Agency._(
        id,
        name: fields['name'],
        fax: fields['fax'],
        phone: fields['phone'],
        email: fields['email'],
        address: fields['address'],
        website: fields['website'],
        description: fields['description'],
        images: Iterable.castFrom(fields['images']),
      );
    });
  }

  Map<String, dynamic> toJson() {
    return {
      id: {
        'name': name,
        'fax': fax,
        'phone': phone,
        'email': email,
        'address': address,
        'website': website,
        'description': description,
        'images': images,
      },
    };
  }
}
