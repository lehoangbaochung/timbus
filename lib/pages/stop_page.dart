import 'package:bus/app/localizations.dart';
import 'package:bus/extensions/context.dart';
import 'package:bus/repositories/app_storage.dart';
import 'package:flutter/material.dart';

import '/exports/entities.dart';
import '/app/pages.dart';
import '/exports/widgets.dart';

class StopPage extends StatelessWidget {
  final Stop stop;

  const StopPage(this.stop, {super.key});

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
            AppLocalizations.localize(13),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: AppLocalizations.localize(30),
              ),
              Tab(
                text: AppLocalizations.localize(31),
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
                            context.showSnackBar(AppLocalizations.localize(33));
                            await appStorage.setFavoriteStops(stops..add(stop));
                          } else {
                            context.showSnackBar(AppLocalizations.localize(34));
                            await appStorage.setFavoriteStops(stops..remove(stop));
                          }
                          setState(() {});
                        },
                        icon: Icon(unsaved ? Icons.star_border : Icons.star),
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
                      AppLocalizations.localize(32),
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
                                  AppLocalizations.localize(71),
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
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
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
              textColor: Colors.white,
              tileColor: Colors.orangeAccent,
              leading: const Icon(
                Icons.bus_alert,
                color: Colors.white,
              ),
              trailing: const Icon(
                Icons.more_vert,
                color: Colors.white,
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
