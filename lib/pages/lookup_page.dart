import 'package:bus/extensions/context.dart';
import 'package:flutter/material.dart';

import '/app/app_pages.dart';
import '/exports/widgets.dart';
import '/repositories/app_storage.dart';

class LookupPage extends StatelessWidget {
  const LookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              appStorage.localize(4),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: appStorage.localize(12),
                  icon: const Icon(Icons.directions_bus),
                ),
                Tab(
                  text: appStorage.localize(13),
                  icon: const Icon(Icons.bus_alert),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () => AppPages.push(context, AppPages.help.path),
                tooltip: appStorage.localize(9),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: appStorage.localize(78),
            child: const Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: SearchPage(),
            ),
          ),
          body: TabBarView(
            children: [
              // Routes
              FutureBuilder(
                future: appStorage.getAllRoutes(),
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
                              final route = routes.elementAt(index);
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: context.primaryColor,
                                  foregroundColor: context.secondaryColor,
                                  child: Text(
                                    route.id,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                title: Text(route.getName()),
                                onTap: () => AppPages.push(context, AppPages.route.path, route),
                              );
                            },
                          );
                  }
                  return centeredLoadingIndicator;
                },
              ),
              // Stops
              FutureBuilder(
                future: appStorage.getAllStops(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final stops = snapshot.requireData;
                    return stops.isEmpty
                        ? Center(
                            child: Text(
                              appStorage.localize(71),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : ListView.builder(
                            itemCount: stops.length,
                            itemBuilder: (context, index) {
                              final stop = stops.elementAt(index);    
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: context.primaryColor,
                                  foregroundColor: context.secondaryColor,
                                  child: const Icon(Icons.bus_alert),
                                ),
                                title: Text(stop.name),
                                subtitle: stop.description.isEmpty || stop.name == stop.description ? null : Text(stop.description),
                                onTap: () => AppPages.push(context, AppPages.stop.path, stop),
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
      ),
    );
  }
}
