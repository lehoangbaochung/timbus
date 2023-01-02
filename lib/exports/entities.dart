import 'package:flutter/foundation.dart';

export '/entities/article.dart';
export '/entities/agency.dart';
export '/entities/place.dart';
export '/entities/route.dart';
export '/entities/stop.dart';
export '/entities/trip.dart';

const empty = '';
const separator = ',';

/// Interface used by types that have an intrinsic ordering.
@immutable
abstract class Comparable {
  final String id;

  const Comparable(this.id);

  @override
  String toString() => '$runtimeType ($id)';

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Comparable && runtimeType == other.runtimeType && id == other.id;
}

extension ComparableX<T extends Comparable> on Iterable<T> {
  /// A [List] of the [T] objects in this [Iterable] in sort order by the id.
  List<T> get sorted {
    return toList()
      ..sort(
        (a, b) {
          final aId = int.tryParse(a.id) ?? 0;
          final bId = int.tryParse(b.id) ?? 0;
          return aId.compareTo(bId);
        },
      );
  }
}
