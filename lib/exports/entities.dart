import 'dart:math';

export '/entities/article.dart';
export '/entities/agency.dart';
export '/entities/place.dart';
export '/entities/route.dart';
export '/entities/stop.dart';
export '/entities/trip.dart';

const empty = '';
const combine = '-';
const separator = ',';

/// Interface used by types that have an intrinsic ordering.
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
  static final _random = Random();

  Iterable<T> get shuffled => toList()..shuffle(_random);

  T get random => _random.nextBool() ? shuffled.first : shuffled.last;

  /// An [Iterable] of the [T] objects in sort order by the `id`.
  Iterable<T> get sorted {
    return toList()
      ..sort(
        (a, b) {
          final aId = int.tryParse(a.id) ?? int.tryParse(a.id.substring(0, a.id.length - 1)) ?? 0;
          final bId = int.tryParse(b.id) ?? int.tryParse(b.id.substring(0, b.id.length - 1)) ?? 0;
          return aId.compareTo(bId);
        },
      );
  }
}
