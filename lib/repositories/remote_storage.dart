part of 'app_storage.dart';

class _RemoteStorage implements _RemoteRepository {
  late final _shelf = <String, dynamic>{};
  late final _database = FirebaseFirestore.instance;

  static const article = 'article';
  static const agency = 'agency';
  static const place = 'place';
  static const route = 'route';
  static const stop = 'stop';

  @override
  Future<Iterable<Agency>> getAllAgencies() async {
    if (_shelf.containsKey(agency)) return _shelf[agency];
    final query = await _database
        .collection(agency)
        .withConverter(
          toFirestore: (obj, _) => obj.toJson(),
          fromFirestore: (doc, _) => Agency.fromJson(
            doc.id,
            doc.data()!,
          ),
        )
        .get();
    return _shelf[agency] = query.docs.map((doc) => doc.data()).sorted;
  }

  @override
  Future<Iterable<Article>> getAllArticles() async {
    if (_shelf.containsKey(article)) return _shelf[article];
    final query = await _database
        .collection(article)
        .withConverter(
          toFirestore: (obj, _) => obj.toJson(),
          fromFirestore: (doc, _) => Article.fromJson(
            doc.id,
            doc.data()!,
          ),
        )
        .get();
    return _shelf[article] = query.docs.map((doc) => doc.data()).sorted.toList().reversed;
  }

  @override
  Future<Iterable<Place>> getAllPlaces() async {
    if (_shelf.containsKey(place)) return _shelf[place];
    final query = await _database
        .collection(place)
        .withConverter(
          toFirestore: (obj, _) => obj.toJson(),
          fromFirestore: (doc, _) => Place.fromJson(
            doc.id,
            doc.data()!,
          ),
        )
        .get();
    return _shelf[place] = query.docs.map((doc) => doc.data()).sorted;
  }

  @override
  Future<Iterable<Route>> getAllRoutes() async {
    if (_shelf.containsKey(route)) return _shelf[route];
    final query = await _database
        .collection(route)
        .withConverter(
          toFirestore: (obj, _) => obj.toJson(),
          fromFirestore: (doc, _) => Route.fromJson(
            doc.id,
            doc.data()!,
          ),
        )
        .get();
    return _shelf[route] = query.docs.map((doc) => doc.data()).sorted;
  }

  @override
  Future<Iterable<Stop>> getAllStops() async {
    if (_shelf.containsKey(stop)) return _shelf[stop];
    final query = await _database
        .collection(stop)
        .withConverter(
          toFirestore: (obj, _) => obj.toJson(),
          fromFirestore: (doc, _) => Stop.fromJson(
            doc.id,
            doc.data()!,
          ),
        )
        .get();
    return _shelf[stop] = query.docs.map((doc) => doc.data()).sorted;
  }
}
