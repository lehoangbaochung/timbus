import 'package:bus/app/pages.dart';
import 'package:bus/extensions/context.dart';
import 'package:bus/repositories/app_storage.dart';
import 'package:flutter/material.dart' hide Route;

import '/app/localizations.dart';
import '/exports/widgets.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          title: Text(
            AppLocalizations.localize(2),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const Icon(Icons.directions_bus),
                text: AppLocalizations.localize(12),
              ),
              Tab(
                icon: const Icon(Icons.bus_alert),
                text: AppLocalizations.localize(13),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Routes
            FutureBuilder(
              future: appStorage.getFavoriteRoutes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final routes = snapshot.requireData.toList();
                  return routes.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.localize(71),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : StatefulBuilder(builder: (context, setState) {
                          return ListView.builder(
                            itemCount: routes.length,
                            itemBuilder: (context, index) {
                              final route = routes.elementAt(index);
                              return ListTile(
                                title: Text(
                                  route.getName(),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  child: Text(route.id),
                                ),
                                trailing: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            '${AppLocalizations.localize(14)} ${route.id}: ${route.getName()}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          content: Text(
                                            AppLocalizations.localize(87),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text(
                                                AppLocalizations.localize(70),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                context.showSnackBar(
                                                  AppLocalizations.localize(86),
                                                );
                                                await appStorage.setFavoriteRoutes(
                                                  routes..remove(route),
                                                );
                                                setState(() {});
                                              },
                                              child: Text(
                                                AppLocalizations.localize(69),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                onTap: () => AppPages.push(context, AppPages.route.path, route),
                              );
                            },
                          );
                        });
                }
                return centeredLoadingIndicator;
              },
            ),
            // Stops
            FutureBuilder(
              future: appStorage.getFavoriteStops(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final stops = snapshot.requireData.toList();
                  return stops.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.localize(71),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : StatefulBuilder(
                          builder: (context, setState) {
                            return ListView.builder(
                              itemCount: stops.length,
                              itemBuilder: (context, index) {
                                final stop = stops.elementAt(index);
                                return ListTile(
                                  title: Text(stop.name),
                                  subtitle: Text(stop.description),
                                  leading: const CircleAvatar(
                                    foregroundColor: Colors.blue,
                                    child: Icon(Icons.directions_bus),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              stop.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            content: Text(
                                              AppLocalizations.localize(87),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text(
                                                  AppLocalizations.localize(70),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  context.showSnackBar(
                                                    AppLocalizations.localize(86),
                                                  );
                                                  await appStorage.setFavoriteStops(
                                                    stops..remove(stop),
                                                  );
                                                  setState(() {});
                                                },
                                                child: Text(
                                                  AppLocalizations.localize(69),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  onTap: () => AppPages.push(context, AppPages.stop.path, stop),
                                );
                              },
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
    );
  }
}
