part of 'app_storage.dart';

class _RemoteStorage implements _RemoteRepository {
  late final shelf = <String, dynamic>{};
  late final database = FirebaseFirestore.instance;

  static const article = 'article';
  static const agency = 'agency';
  static const place = 'place';
  static const route = 'route';
  static const stop = 'stop';

  @override
  Future<Iterable<Agency>> getAllAgencies() async {
    if (shelf.containsKey(agency)) return shelf[agency];
    final query = await database
        .collection(agency)
        .withConverter(
          toFirestore: (obj, _) => obj.toJson(),
          fromFirestore: (doc, _) => Agency.fromJson(
            doc.id,
            doc.data()!,
          ),
        )
        .get();
    return shelf[agency] = query.docs.map((doc) => doc.data()).sorted;
  }

  @override
  Future<Iterable<Article>> getAllArticles() async {
    if (shelf.containsKey(article)) return shelf[article];
    final query = await database
        .collection(article)
        .withConverter(
          toFirestore: (obj, _) => obj.toJson(),
          fromFirestore: (doc, _) => Article.fromJson(
            doc.id,
            doc.data()!,
          ),
        )
        .get();
    return shelf[article] = query.docs.map((doc) => doc.data()).sorted.reversed;
  }

  @override
  Future<Iterable<Place>> getAllPlaces() async {
    if (shelf.containsKey(place)) return shelf[place];
    final query = await database
        .collection(place)
        .withConverter(
          toFirestore: (obj, _) => obj.toJson(),
          fromFirestore: (doc, _) => Place.fromJson(
            doc.id,
            doc.data()!,
          ),
        )
        .get();
    return shelf[place] = query.docs.map((doc) => doc.data()).sorted;
  }

  @override
  Future<Iterable<Route>> getAllRoutes() async {
    if (shelf.containsKey(route)) return shelf[route];
    final query = await database
        .collection(route)
        .withConverter(
          toFirestore: (obj, _) => obj.toJson(),
          fromFirestore: (doc, _) => Route.fromJson(
            doc.id,
            doc.data()!,
          ),
        )
        .get();
    return shelf[route] = query.docs.map((doc) => doc.data());
  }

  @override
  Future<Iterable<Stop>> getAllStops() async {
    if (shelf.containsKey(stop)) return shelf[stop];
    final query = await database
        .collection(stop)
        .withConverter(
          toFirestore: (obj, _) => obj.toJson(),
          fromFirestore: (doc, _) => Stop.fromJson(
            doc.id,
            doc.data()!,
          ),
        )
        .get();
    return shelf[stop] = query.docs.map((doc) => doc.data()).sorted;
  }
}
