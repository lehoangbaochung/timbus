import 'package:flutter/material.dart';

import '/exports/entities.dart';

class PlaceMasterPage extends StatelessWidget {
  const PlaceMasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          title: const Text('Địa điểm'),
        ),
      ),
    );
  }
}

class PlaceDetailPage extends StatelessWidget {
  final Place place;

  const PlaceDetailPage(this.place, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
