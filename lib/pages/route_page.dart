import 'package:bus/app/app_pages.dart';
import 'package:bus/extensions/appearance.dart';
import 'package:bus/extensions/context.dart';
import 'package:bus/repositories/app_storage.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import '/exports/entities.dart';
import '/exports/widgets.dart';
import '/extensions/geolocator.dart';
import '/extensions/polyline.dart';

class RoutePage extends StatefulWidget {
  final Route route;
  final TripOfRoute tripOfRoute;

  const RoutePage(
    this.route, {
    super.key,
    this.tripOfRoute = TripOfRoute.outbound,
  });

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  late final route = widget.route;
  late var tripOfRoute = widget.tripOfRoute;

  final mapController = MapController();
  final fullscreenMode = ValueNotifier(false);
  var currentStop = 0;
  var isWeekday = true;
  final currentTab = ValueNotifier(1);

  @override
  Widget build(BuildContext context) {
    final trip = route.getTrip(tripOfRoute);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text('Tuyến ${route.id}'),
        actions: [
          StatefulBuilder(
            builder: (context, setState) {
              return FutureBuilder(
                future: appStorage.getFavoriteRoutes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final routes = snapshot.requireData.toList();
                    final unsaved = !routes.contains(route);
                    return IconButton(
                      tooltip: appStorage.localize(73),
                      icon: Icon(unsaved ? Icons.star_border : Icons.star),
                      onPressed: () async {
                        if (unsaved) {
                          context.showSnackBar(appStorage.localize(33));
                          await appStorage.setFavoriteRoutes(routes..add(route));
                        } else {
                          context.showSnackBar(appStorage.localize(34));
                          await appStorage.setFavoriteRoutes(routes..remove(route));
                        }
                        setState(() {});
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        key: UniqueKey(),
        future: trip.stops,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final stops = snapshot.requireData.toList();
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          zoom: 15,
                          onMapReady: () {
                            mapController.moveAndRotate(
                              stops.first.position,
                              mapController.zoom,
                              0,
                            );
                          },
                        ),
                        children: [
                          // Map
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          // Line
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                strokeWidth: 3,
                                color: appStorage.paint(0),
                                points: decodePolyline(
                                  encodePolyline(
                                    stops.map((stop) => stop.position),
                                  ),
                                ).toList(),
                              ),
                            ],
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
                          MarkerLayer(
                            markers: stops.map((stop) {
                              final index = stops.indexOf(stop);
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
                                        color: currentStop == index ? appStorage.paint(1) : appStorage.paint(0),
                                      ),
                                    ),
                                    onPressed: () => AppPages.push(context, AppPages.stop.path, stop),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      // Locator button
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            mini: true,
                            tooltip: appStorage.localize(11),
                            child: const Icon(Icons.my_location),
                            onPressed: () async {
                              final position = await GeolocatorService.getCurrentPosition();
                              mapController.moveAndRotate(position.toLatLng(), mapController.zoom, 0);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: fullscreenMode,
                  builder: (context, value, child) {
                    if (value == true) {
                      return ListTile(
                        tileColor: Colors.orangeAccent,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                        title: Text(
                          route.getName(tripOfRoute),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                        ),
                        leading: IconButton(
                          tooltip: appStorage.localize(15),
                          color: Colors.white,
                          icon: const Icon(Icons.swap_vert),
                          onPressed: () {
                            setState(() {
                              currentStop = 0;
                              switch (tripOfRoute) {
                                case TripOfRoute.outbound:
                                  tripOfRoute = TripOfRoute.inbound;
                                  break;
                                case TripOfRoute.inbound:
                                  tripOfRoute = TripOfRoute.outbound;
                                  break;
                              }
                            });
                          },
                        ),
                        trailing: IconButton(
                          tooltip: appStorage.localize(74),
                          color: appStorage.paint(1),
                          icon: const Icon(Icons.fullscreen_exit),
                          onPressed: () => fullscreenMode.value = false,
                        ),
                      );
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: DefaultTabController(
                        length: 3,
                        initialIndex: currentTab.value,
                        child: Scaffold(
                          appBar: AppBar(
                            titleSpacing: 0,
                            centerTitle: true,
                            backgroundColor: Colors.orangeAccent,
                            title: Text(
                              route.getName(tripOfRoute),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                            ),
                            leading: IconButton(
                              icon: const Icon(Icons.swap_vert),
                              tooltip: appStorage.localize(15),
                              onPressed: () {
                                setState(() {
                                  currentStop = 0;
                                  switch (tripOfRoute) {
                                    case TripOfRoute.outbound:
                                      tripOfRoute = TripOfRoute.inbound;
                                      break;
                                    case TripOfRoute.inbound:
                                      tripOfRoute = TripOfRoute.outbound;
                                      break;
                                  }
                                });
                              },
                            ),
                            actions: [
                              IconButton(
                                icon: const Icon(Icons.fullscreen),
                                onPressed: () => fullscreenMode.value = true,
                                tooltip: fullscreenMode.value ? appStorage.localize(74) : appStorage.localize(75),
                              ),
                            ],
                            bottom: ColoredTabBar(
                              color: Theme.of(context).colorScheme.primary,
                              child: TabBar(
                                indicatorColor: Theme.of(context).colorScheme.onPrimary,
                                onTap: (index) => currentTab.value = index,
                                tabs: [
                                  Tab(
                                    text: appStorage.localize(17),
                                  ),
                                  Tab(
                                    text: appStorage.localize(18),
                                  ),
                                  Tab(
                                    text: appStorage.localize(19),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          body: TabBarView(
                            children: [
                              // schedule
                              StatefulBuilder(
                                builder: (context, setState) {
                                  final schedule = trip.schedule[isWeekday ? DayOfWeek.weekday : DayOfWeek.weekend] ?? [];
                                  return Stack(
                                    children: [
                                      ListView.builder(
                                        itemCount: schedule.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                              schedule.elementAt(index),
                                            ),
                                            leading: const CircleAvatar(
                                              foregroundColor: Colors.blue,
                                              child: Icon(Icons.schedule),
                                            ),
                                          );
                                        },
                                      ),
                                      Positioned(
                                        right: 16,
                                        bottom: 16,
                                        child: ToggleButtons(
                                          direction: Axis.vertical,
                                          isSelected: [isWeekday, !isWeekday],
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                              ),
                                              child: Text(
                                                appStorage.localize(28),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                              ),
                                              child: Text(
                                                appStorage.localize(29),
                                              ),
                                            ),
                                          ],
                                          onPressed: (value) {
                                            setState(() {
                                              isWeekday = value == 0 ? true : false;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              // stops
                              Stepper(
                                key: UniqueKey(),
                                currentStep: currentStop,
                                controlsBuilder: (_, __) => Container(),
                                onStepTapped: (index) {
                                  currentStop = index;
                                  final stop = stops.elementAt(index);
                                  mapController.moveAndRotate(stop.position, mapController.zoom, 0);
                                },
                                steps: stops.map((stop) {
                                  final index = stops.indexOf(stop);
                                  return Step(
                                    title: Text(stop.name),
                                    subtitle: stop.description.isEmpty || stop.name == stop.description ? null : Text(stop.description),
                                    content: const SizedBox.shrink(),
                                    isActive: index == 0 || index == stops.length - 1,
                                  );
                                }).toList(),
                              ),
                              // Details
                              ListView(
                                children: [
                                  // agency
                                  FutureBuilder(
                                    future: route.agency,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final agency = snapshot.requireData;
                                        return ListTile(
                                          leading: CircleAvatar(
                                            foregroundColor: appStorage.paint(0),
                                            child: const Icon(Icons.factory),
                                          ),
                                          title: Text(
                                            appStorage.localize(20),
                                          ),
                                          trailing: const Icon(Icons.arrow_right),
                                          subtitle: Text(agency == null ? appStorage.localize(72) : agency.name),
                                          onTap: () => agency == null ? null : AppPages.push(context, AppPages.agency.path, agency),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  // timeline
                                  ListTile(
                                    leading: CircleAvatar(
                                      foregroundColor: appStorage.paint(0),
                                      child: const Icon(Icons.timeline),
                                    ),
                                    title: Text(
                                      appStorage.localize(21),
                                    ),
                                    subtitle: Text(
                                      '${trip.getTimes(DayOfWeek.weekday).join(' - ')} ${appStorage.localize(26)}',
                                    ),
                                  ),
                                  // fare
                                  ListTile(
                                    leading: CircleAvatar(
                                      foregroundColor: appStorage.paint(0),
                                      child: const Icon(Icons.attach_money),
                                    ),
                                    title: Text(
                                      appStorage.localize(22),
                                    ),
                                    subtitle: Text('${trip.fare} ${appStorage.localize(27)}'),
                                  ),
                                  // distance
                                  ListTile(
                                    leading: CircleAvatar(
                                      foregroundColor: appStorage.paint(0),
                                      child: const Icon(Icons.linear_scale_rounded),
                                    ),
                                    title: Text(
                                      appStorage.localize(23),
                                    ),
                                    subtitle: Text('${trip.distance} km'),
                                  ),
                                  // timelapse
                                  ListTile(
                                    leading: CircleAvatar(
                                      foregroundColor: appStorage.paint(0),
                                      child: const Icon(Icons.timelapse),
                                    ),
                                    title: Text(
                                      appStorage.localize(24),
                                    ),
                                    subtitle: Text(
                                      trip.getActiveTime(DayOfWeek.weekday),
                                    ),
                                  ),
                                  // description
                                  ListTile(
                                    leading: CircleAvatar(
                                      foregroundColor: appStorage.paint(0),
                                      child: const Icon(Icons.route),
                                    ),
                                    title: Text(
                                      appStorage.localize(25),
                                    ),
                                    subtitle: Text(
                                      trip.description,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
          return centeredLoadingIndicator;
        },
      ),
    );
  }
}
