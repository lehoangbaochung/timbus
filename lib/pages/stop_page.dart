import 'package:bus/app/app_theme.dart';
import 'package:bus/extensions/context.dart';
import 'package:bus/repositories/app_storage.dart';
import 'package:flutter/material.dart';

import '/exports/entities.dart';
import '../app/app_pages.dart';
import '/exports/widgets.dart';

class StopPage extends StatelessWidget {
  const StopPage(this.stop, {super.key});

  final Stop stop;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          title: Text(
            appStorage.localize(13),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: appStorage.localize(30),
              ),
              Tab(
                text: appStorage.localize(31),
              ),
            ],
          ),
          actions: [
            StatefulBuilder(
              builder: (context, setState) {
                return FutureBuilder(
                  future: appStorage.getFavoriteStops(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final stops = snapshot.requireData.toList();
                      final unsaved = !stops.contains(stop);
                      return IconButton(
                        onPressed: () async {
                          if (unsaved) {
                            context.showSnackBar(appStorage.localize(33));
                            await appStorage.setFavoriteStops(stops..add(stop));
                          } else {
                            context.showSnackBar(appStorage.localize(34));
                            await appStorage.setFavoriteStops(stops..remove(stop));
                          }
                          setState(() {});
                        },
                        icon: Icon(unsaved ? Icons.star_border : Icons.star),
                        tooltip: unsaved ? appStorage.localize(72) : appStorage.localize(73),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  // Upcoming routes
                  Center(
                    child: Text(
                      appStorage.localize(32),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  // Passing routes
                  FutureBuilder(
                    future: stop.getRoutes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final routes = snapshot.requireData;
                        return routes.isEmpty
                            ? Center(
                                child: Text(
                                  appStorage.localize(71),
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              )
                            : ListView.builder(
                                itemCount: routes.length,
                                itemBuilder: (context, index) {
                                  final route = routes.keys.elementAt(index);
                                  return ListTile(
                                    title: Text(
                                      route.getName(routes[route]!),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: appTheme.primaryColor,
                                      foregroundColor: appTheme.onSecondaryColor,
                                      child: Text(route.id),
                                    ),
                                    onTap: () => AppPages.push(context, AppPages.route.path, route),
                                  );
                                },
                              );
                      }
                      return centeredLoadingIndicator;
                    },
                  ),
                ],
              ),
            ),
            // Stop name
            ListTile(
              minLeadingWidth: 0,
              tileColor: Colors.orangeAccent,
              leading: const Icon(
                Icons.bus_alert,
                color: Colors.white,
              ),
              trailing: InkWell(
                child: const Icon(Icons.more_vert),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text(
                          stop.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              AppPages.push(
                                context,
                                AppPages.direction.path,
                                {'from': stop},
                              );
                            },
                            child: Text(
                              appStorage.localize(84),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              AppPages.push(
                                context,
                                AppPages.direction.path,
                                {'to': stop},
                              );
                            },
                            child: Text(
                              appStorage.localize(85),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              title: Text(
                stop.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
