import 'package:bus/extensions/appearance.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import '/app/app_pages.dart';
import '/exports/entities.dart';
import '/exports/widgets.dart';
import '/extensions/context.dart';
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
          appStorage.localize(0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () => AppPages.push(context, AppPages.favorite.path),
            tooltip: appStorage.localize(2),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            FutureBuilder(
              future: appStorage.getAllPlaces(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final place = snapshot.requireData.random;
                  return DrawerHeader(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          place.thumbnail,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ColoredBox(
                          color: const Color(0x44000000),
                          child: ListTile(
                            dense: true,
                            selected: true,
                            selectedColor: Colors.white,
                            title: Text(
                              place.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              place.description,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.arrow_right),
                            onTap: () {
                              AppPages.pop(context);
                              AppPages.push(context, AppPages.place.path + AppPages.detail.path, place);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const DrawerHeader(
                  child: centeredLoadingIndicator,
                );
              },
            ),
            ListTile(
              selected: true,
              minLeadingWidth: 0,
              leading: const Icon(Icons.home),
              title: Text(
                appStorage.localize(3),
              ),
              onTap: () => AppPages.pop(context),
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text(
                appStorage.localize(4),
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
                appStorage.localize(5),
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
                appStorage.localize(6),
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
                appStorage.localize(8),
              ),
              leading: const Icon(Icons.place),
              onTap: () {
                AppPages.pop(context);
                AppPages.push(context, AppPages.place.path);
              },
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text(
                appStorage.localize(7),
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
                appStorage.localize(9),
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
            tooltip: appStorage.localize(10),
            child: const Icon(Icons.directions),
            onPressed: () => AppPages.push(context, AppPages.direction.path),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: null,
            tooltip: appStorage.localize(11),
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
                      color: appStorage.paint(0),
                      borderColor: appStorage.paint(0).withOpacity(0.4),
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
                          icon: CircleAvatar(
                            foregroundColor: appStorage.paint(0),
                            child: Icon(
                              Icons.bus_alert,
                              color: appStorage.paint(0),
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
