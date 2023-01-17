import 'package:flutter/material.dart';

import '/app/app_pages.dart';
import '/exports/entities.dart';
import '/exports/widgets.dart';
import '/extensions/geolocator.dart';
import '/repositories/app_storage.dart';

// ignore: must_be_immutable
class DirectionPage extends StatelessWidget {
  DirectionPage({super.key, this.from, this.to});

  Stop? from, to;
  late final toTextController = TextEditingController(text: to?.name);
  late final fromTextController = TextEditingController(text: from?.name);

  bool get disabled => from == null || to == null;

  @override
  Widget build(BuildContext context) {
    var selected = true;
    var submitted = false;
    return SafeArea(
      child: Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                // top-bar
                Card(
                  child: Column(
                    children: [
                      // from textfield
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => AppPages.pop(context),
                            icon: const Icon(Icons.arrow_back),
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              autofocus: from == null || to == null,
                              controller: fromTextController,
                              decoration: InputDecoration(
                                hintText: appStorage.localize(67),
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                suffixIcon: Visibility(
                                  visible: from != null,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        from = null;
                                        submitted = false;
                                        fromTextController.clear();
                                      });
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ),
                              ),
                              onTap: () {
                                selected = true;
                                submitted = false;
                              },
                            ),
                          ),
                          IconButton(
                            tooltip: appStorage.localize(11),
                            icon: const Icon(Icons.my_location),
                            onPressed: () async {
                              final nearestStops = await GeolocatorService.getNearestStops();
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    title: Text(
                                      appStorage.localize(79),
                                    ),
                                    children: nearestStops
                                        .map((stop) {
                                          final isEmptyDescription = stop.description.isEmpty || stop.name == stop.description;
                                          return ListTile(
                                            leading: const Icon(Icons.bus_alert),
                                            title: Text(stop.name),
                                            subtitle: isEmptyDescription ? null : Text(stop.description),
                                            onTap: () {
                                              Navigator.pop(context);
                                              if (selected) {
                                                from = stop;
                                                fromTextController.text = stop.name;
                                              } else {
                                                to = stop;
                                                toTextController.text = stop.name;
                                              }
                                              setState(() {});
                                            },
                                          );
                                        })
                                        .take(3)
                                        .toList(),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: disabled
                                ? null
                                : () {
                                    setState(() {
                                      final stop = from;
                                      from = to;
                                      to = stop;
                                      toTextController.text = to!.name;
                                      fromTextController.text = from!.name;
                                    });
                                  },
                            icon: const Icon(Icons.swap_vert),
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              autofocus: from != null,
                              controller: toTextController,
                              decoration: InputDecoration(
                                hintText: appStorage.localize(68),
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                suffixIcon: Visibility(
                                  visible: to != null,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        to = null;
                                        submitted = false;
                                        toTextController.clear();
                                      });
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ),
                              ),
                              onTap: () {
                                selected = false;
                                submitted = false;
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: disabled
                                ? null
                                : () {
                                    setState(() {
                                      submitted = true;
                                    });
                                  },
                            icon: const Icon(Icons.directions),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: !submitted
                      ? FutureBuilder(
                          future: appStorage.getAllStops(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final stops = snapshot.requireData;
                              return ListView.builder(
                                itemCount: stops.length,
                                itemBuilder: (context, index) {
                                  final stop = stops.elementAt(index);
                                  final isEmpty = stop.description.isEmpty || stop.name == stop.description;
                                  return ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(Icons.bus_alert),
                                    ),
                                    title: Text(stop.name),
                                    subtitle: isEmpty ? null : Text(stop.description),
                                    onTap: () {
                                      if (selected) {
                                        from = stop;
                                        fromTextController.text = stop.name;
                                      } else {
                                        to = stop;
                                        toTextController.text = stop.name;
                                      }
                                      setState(() {});
                                    },
                                  );
                                },
                              );
                            }
                            return centeredLoadingIndicator;
                          },
                        )
                      : FutureBuilder(
                          future: Future.wait([
                            from!.getRoutes(),
                            to!.getRoutes(),
                          ]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final fromRoutes = snapshot.requireData.first;
                              final toRoutes = snapshot.requireData.last;
                              final routes = snapshot.requireData
                                  .expand((entry) => entry.keys)
                                  .where(
                                    (route) => fromRoutes.keys.contains(route) && toRoutes.keys.contains(route),
                                  )
                                  .toSet()
                                  .toList();
                              return ListView(
                                children: [
                                  const SizedBox(height: 4),
                                  // from
                                  ExpansionTile(
                                    initiallyExpanded: true,
                                    leading: const Icon(Icons.directions_bus),
                                    title: Text(
                                      appStorage.localize(64),
                                    ),
                                    children: fromRoutes.entries.map((entry) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          child: Text(
                                            entry.key.id,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        title: Text(
                                          entry.key.getName(entry.value),
                                        ),
                                        onTap: () => AppPages.push(context, AppPages.route.path, entry.key),
                                      );
                                    }).toList(),
                                  ),
                                  // to
                                  ExpansionTile(
                                    initiallyExpanded: true,
                                    leading: const Icon(Icons.directions_bus),
                                    title: Text(
                                      appStorage.localize(65),
                                    ),
                                    children: toRoutes.entries.map((e) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          child: Text(
                                            e.key.id,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        title: Text(e.key.getName(e.value)),
                                        onTap: () => AppPages.push(context, AppPages.route.path, e.key),
                                      );
                                    }).toList(),
                                  ),
                                  // common
                                  Visibility(
                                    visible: routes.isNotEmpty,
                                    child: ExpansionTile(
                                      initiallyExpanded: true,
                                      leading: const Icon(Icons.directions_bus),
                                      title: Text(
                                        appStorage.localize(63),
                                      ),
                                      children: routes.map((route) {
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            child: Text(
                                              route.id,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          title: Text(route.getName()),
                                          onTap: () => AppPages.push(context, AppPages.route.path, route),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
