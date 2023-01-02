import '/exports/entities.dart';
import '/repositories/app_storage.dart';

enum DayOfWeek {
  weekday,
  weekend,
}

class Trip {
  /// The money a passenger on public transportation has to pay.
  final int fare;

  final double distance;

  final String name;

 // final String polyline;

  final String description;

  final Map<DayOfWeek, Iterable<String>> schedule;

  dynamic _stops;

  Trip._({
    required this.name,
    //required this.polyline,
    required this.description,
    required this.fare,
    required this.distance,
    required this.schedule,
  });

  factory Trip.fromJson(Map<String, dynamic> fields) {
    final stopsString = fields['stops'] as String;
    final schedule = Map<String, String>.from(fields['schedule']);
    return Trip._(
      name: fields['name'],
      fare: fields['fare'],
      //polyline: '',
      distance: fields['distance'],
      description: fields['description'],
      schedule: {
        DayOfWeek.weekday: schedule['weekday']!.split(separator),
        DayOfWeek.weekend: schedule['weekend']!.split(separator),
      },
    ).._stops = stopsString.split(separator);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fare': fare,
      'distance': distance,
      //'polyline': polyline,
      'description': description,
      'schedule': {
        'weekday': schedule[DayOfWeek.weekday]!.join(separator),
        'weekend': schedule[DayOfWeek.weekend]!.join(separator),
      },
    };
  }

  String getActiveTime(DayOfWeek dayOfWeek) {
    final timeline = schedule[dayOfWeek] ?? [];
    return '${timeline.first} - ${timeline.last}';
  }

  Iterable<int> getTimes(DayOfWeek dayOfWeek) {
    int getDifference(String s1, String s2) {
      final n1 = s1.split(':').map((e) => int.tryParse(e) ?? 0);
      final n2 = s2.split(':').map((e) => int.tryParse(e) ?? 0);
      final m1 = Duration(hours: n1.first, minutes: n1.last).inMinutes;
      final m2 = Duration(hours: n2.first, minutes: n2.last).inMinutes;
      return m2 - m1;
    }

    final times = <int>{};
    final timeline = schedule[dayOfWeek] ?? {};
    for (var i = 0; i < timeline.length - 1; i++) {
      times.add(
        getDifference(
          timeline.elementAt(i),
          timeline.elementAt(i + 1),
        ),
      );
    }
    return times.toList()..sort();
  }

  Future<Iterable<Stop>> get stops async {
    if (_stops is Iterable<Stop>) return _stops;
    final stopsId = _stops as Iterable<String>;
    final stopsCollection = await appStorage.getAllStops();
    return stopsId.map(
      (id) => stopsCollection.singleWhere(
        (stop) => stop.id == id,
        orElse: () => Stop.empty,
      ),
    );
  }
}
