import 'package:bus/app/pages.dart';
import 'package:bus/extensions/context.dart';
import 'package:bus/repositories/app_storage.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import '/app/localizations.dart';
import '/exports/entities.dart';
import '/exports/widgets.dart';
import '/extensions/geolocator.dart';
import '/extensions/polylines.dart';

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
                      tooltip: AppLocalizations.localize(73),
                      icon: Icon(unsaved ? Icons.star_border : Icons.star),
                      onPressed: () async {
                        if (unsaved) {
                          context.showSnackBar(AppLocalizations.localize(33));
                          await appStorage.setFavoriteRoutes(routes..add(route));
                        } else {
                          context.showSnackBar(AppLocalizations.localize(34));
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
                                color: Colors.blue,
                                points: unpackPolyline(
                                  decodePolyline(
                                    encodePolyline(
                                      stops.map((stop) {
                                        final position = stop.position;
                                        return [position.latitude, position.longitude];
                                      }).toList(),
                                    ),
                                  ),
                                ),
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
                                      foregroundColor: Colors.blue,
                                      child: Icon(
                                        Icons.bus_alert,
                                        color: currentStop == index ? Colors.orangeAccent : Colors.blue,
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
                            tooltip: AppLocalizations.localize(11),
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
                          tooltip: AppLocalizations.localize(15),
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
                          tooltip: AppLocalizations.localize(74),
                          color: Colors.white,
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
                              tooltip: AppLocalizations.localize(15),
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
                                tooltip: AppLocalizations.localize(29),
                                onPressed: () => fullscreenMode.value = true,
                              ),
                            ],
                            bottom: ColoredTabBar(
                              color: Theme.of(context).colorScheme.primary,
                              tabBar: TabBar(
                                indicatorColor: Theme.of(context).colorScheme.onPrimary,
                                onTap: (index) => currentTab.value = index,
                                tabs: [
                                  Tab(
                                    text: AppLocalizations.localize(17),
                                  ),
                                  Tab(
                                    text: AppLocalizations.localize(18),
                                  ),
                                  Tab(
                                    text: AppLocalizations.localize(19),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          body: TabBarView(
                            children: [
                              // Schedule
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
                                                AppLocalizations.localize(26),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                              ),
                                              child: Text(
                                                AppLocalizations.localize(27),
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
                              // Stops
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
                                          leading: const CircleAvatar(
                                            foregroundColor: Colors.blue,
                                            child: Icon(Icons.factory),
                                          ),
                                          title: Text(
                                            AppLocalizations.localize(20),
                                          ),
                                          trailing: const Icon(Icons.arrow_right),
                                          subtitle: Text(agency == null ? AppLocalizations.localize(72) : agency.name),
                                          onTap: () => agency == null ? null : AppPages.push(context, AppPages.agency.path, agency),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  // timeline
                                  ListTile(
                                    leading: const CircleAvatar(
                                      foregroundColor: Colors.blue,
                                      child: Icon(Icons.timeline),
                                    ),
                                    title: Text(
                                      AppLocalizations.localize(21),
                                    ),
                                    subtitle: Text(
                                      '${trip.getTimes(DayOfWeek.weekday).join(' - ')} ${AppLocalizations.localize(23)}',
                                    ),
                                  ),
                                  // fare
                                  ListTile(
                                    leading: const CircleAvatar(
                                      foregroundColor: Colors.blue,
                                      child: Icon(Icons.attach_money),
                                    ),
                                    title: Text(
                                      AppLocalizations.localize(22),
                                    ),
                                    subtitle: Text('${trip.fare} ${AppLocalizations.localize(73)}'),
                                  ),
                                  // distance
                                  ListTile(
                                    leading: const CircleAvatar(
                                      foregroundColor: Colors.blue,
                                      child: Icon(Icons.linear_scale_rounded),
                                    ),
                                    title: Text(
                                      AppLocalizations.localize(24),
                                    ),
                                    subtitle: Text('${trip.distance} km'),
                                  ),
                                  // timelapse
                                  ListTile(
                                    leading: const CircleAvatar(
                                      foregroundColor: Colors.blue,
                                      child: Icon(Icons.timelapse),
                                    ),
                                    title: Text(
                                      AppLocalizations.localize(25),
                                    ),
                                    subtitle: Text(
                                      trip.getActiveTime(DayOfWeek.weekday),
                                    ),
                                  ),
                                  // description
                                  ListTile(
                                    leading: const CircleAvatar(
                                      foregroundColor: Colors.blue,
                                      child: Icon(Icons.route),
                                    ),
                                    title: Text(
                                      AppLocalizations.localize(28),
                                    ),
                                    subtitle: Text(trip.description),
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
