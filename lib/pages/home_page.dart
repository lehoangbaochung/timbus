import 'package:bus/app/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import '../app/pages.dart';
import '/extensions/geolocator.dart';
import '/repositories/app_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.localize(0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            tooltip: AppLocalizations.localize(2),
            onPressed: () => AppPages.push(context, AppPages.favorite.path),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [],
              ),
            ),
            ListTile(
              selected: true,
              minLeadingWidth: 0,
              leading: const Icon(Icons.home),
              title: Text(
                AppLocalizations.localize(3),
              ),
              onTap: () => AppPages.pop(context),
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text(
                AppLocalizations.localize(4),
              ),
              leading: const Icon(Icons.manage_search),
              onTap: () {
                AppPages.pop(context);
                AppPages.push(context, AppPages.lookup.path);
              },
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text(
                AppLocalizations.localize(5),
              ),
              leading: const Icon(Icons.newspaper),
              onTap: () {
                AppPages.pop(context);
                AppPages.push(context, AppPages.article.path);
              },
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text(
                AppLocalizations.localize(6),
              ),
              leading: const Icon(Icons.settings),
              onTap: () {
                AppPages.pop(context);
                AppPages.push(context, AppPages.settings.path);
              },
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text(
                AppLocalizations.localize(7),
              ),
              leading: const Icon(Icons.person),
              onTap: () {
                AppPages.pop(context);
                AppPages.push(context, AppPages.feedback.path);
              },
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text(
                AppLocalizations.localize(8),
              ),
              leading: const Icon(Icons.info),
              onTap: () {
                AppPages.pop(context);
                AppPages.push(context, AppPages.about.path);
              },
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text(
                AppLocalizations.localize(9),
              ),
              leading: const Icon(Icons.help),
              onTap: () {
                AppPages.pop(context);
                AppPages.push(context, AppPages.help.path);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            tooltip: AppLocalizations.localize(10),
            child: const Icon(Icons.directions),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: DirectionPage(),
              );
            },
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: null,
            tooltip: AppLocalizations.localize(11),
            child: const Icon(Icons.my_location),
            onPressed: () async {
              final position = await GeolocatorService.getCurrentPosition();
              mapController.moveAndRotate(position.toLatLng(), mapController.zoom, 0);
            },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          zoom: 15,
          minZoom: 13,
          maxZoom: 18,
          onMapReady: () async {
            final position = await GeolocatorService.getCurrentPosition();
            mapController.moveAndRotate(position.toLatLng(), mapController.zoom, 0);
          },
        ),
        children: [
          // Map
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          // Locator
          StreamBuilder(
            stream: Geolocator.getPositionStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final position = snapshot.requireData;
                return CircleLayer(
                  circles: [
                    CircleMarker(
                      point: position.toLatLng(),
                      radius: 40,
                      borderStrokeWidth: 40,
                      useRadiusInMeter: true,
                      color: Colors.blue,
                      borderColor: Colors.blue.withOpacity(0.4),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Stops
          FutureBuilder(
            future: appStorage.getAllStops(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final stops = snapshot.requireData;
                return MarkerLayer(
                  markers: stops.map((stop) {
                    return Marker(
                      width: 80,
                      height: 80,
                      point: stop.position,
                      builder: (context) {
                        return IconButton(
                          icon: const CircleAvatar(
                            foregroundColor: Colors.blue,
                            child: Icon(
                              Icons.bus_alert,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () => AppPages.push(context, AppPages.stop.path, stop),
                        );
                      },
                    );
                  }).toList(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
