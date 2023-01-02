import 'package:flutter/material.dart';

import '../app/localizations.dart';
import '../app/pages.dart';
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
              AppLocalizations.localize(4),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: AppLocalizations.localize(12),
                  icon: const Icon(Icons.directions_bus),
                ),
                Tab(
                  text: AppLocalizations.localize(13),
                  icon: const Icon(Icons.bus_alert),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () => AppPages.push(context, AppPages.help.path),
                tooltip: AppLocalizations.localize(9),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: AppLocalizations.localize(78),
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
                              AppLocalizations.localize(71),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : ListView.builder(
                            itemCount: routes.length,
                            itemBuilder: (context, index) {
                              final route = routes.elementAt(index);
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
                            },
                          );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Vui lòng kiểm tra lại kết nối mạng',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
                              AppLocalizations.localize(71),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : ListView.builder(
                            itemCount: stops.length,
                            itemBuilder: (context, index) {
                              final stop = stops.elementAt(index);
                              return ListTile(
                                leading: const CircleAvatar(
                                  foregroundColor: Colors.blue,
                                  child: Icon(Icons.bus_alert),
                                ),
                                title: Text(stop.name),
                                subtitle: stop.name == stop.description ? null : Text(stop.description),
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
