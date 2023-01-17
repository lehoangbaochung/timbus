import 'package:flutter/material.dart' hide Route;

import '/exports/entities.dart';
import '../app/app_pages.dart';
import '/exports/widgets.dart';
import '/repositories/app_storage.dart';

class SearchPage extends SearchDelegate<String> {
  SearchPage()
      : super(
          searchFieldStyle: const TextStyle(),
          searchFieldLabel: appStorage.localize(78),
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Visibility(
        visible: query.isNotEmpty,
        child: IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear),
          tooltip: appStorage.localize(69),
        ),
      ),
      IconButton(
        onPressed: query.isEmpty ? null : () => showResults(context),
        icon: const Icon(Icons.search),
        tooltip: appStorage.localize(78),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, query),
      tooltip: appStorage.localize(46),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return query.isEmpty
        ? buildSuggestions(context)
        : FutureBuilder(
            future: Future.wait([
              appStorage.getAllRoutes(),
              appStorage.getAllStops(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final datas = snapshot.requireData;
                final routes = List<Route>.from(datas.elementAt(0));
                final stops = List<Stop>.from(datas.elementAt(1));
                final lowerCaseQuery = query.toLowerCase();
                final results = [
                  ...routes.where(
                    (route) => route.id.toLowerCase().contains(lowerCaseQuery) || route.getName().toLowerCase().contains(lowerCaseQuery),
                  ),
                  ...stops.where(
                    (stop) => stop.name.toLowerCase().contains(lowerCaseQuery) || stop.description.toLowerCase().contains(lowerCaseQuery),
                  ),
                ];
                return results.isEmpty
                    ? Center(
                        child: Text(
                          appStorage.localize(77),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      )
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final result = results.elementAt(index);
                          if (result is Route) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                child: Text(
                                  result.id,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              title: Text(result.getName()),
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                AppPages.push(context, AppPages.route.path, result);
                              },
                            );
                          } else if (result is Stop) {
                            return ListTile(
                              leading: const CircleAvatar(
                                foregroundColor: Colors.blue,
                                child: Icon(Icons.bus_alert),
                              ),
                              title: Text(result.name),
                              subtitle: result.description.isEmpty || result.name == result.description ? null : Text(result.description),
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                AppPages.push(context, AppPages.stop.path, result);
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      );
              }
              return centeredLoadingIndicator;
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query.isEmpty
        ? Center(
            child: Text(
              appStorage.localize(76),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        : FutureBuilder(
            future: Future.wait([
              appStorage.getAllRoutes(),
              appStorage.getAllStops(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final datas = snapshot.requireData;
                final routes = List<Route>.from(datas.elementAt(0));
                final stops = List<Stop>.from(datas.elementAt(1));
                final lowerCaseQuery = query.toLowerCase();
                final results = [
                  ...routes.where(
                    (route) => route.id.toLowerCase().contains(lowerCaseQuery) || route.getName().toLowerCase().contains(lowerCaseQuery),
                  ),
                  ...stops.where(
                    (stop) => stop.name.toLowerCase().contains(lowerCaseQuery) || stop.description.toLowerCase().contains(lowerCaseQuery),
                  ),
                ];
                return results.isEmpty
                    ? const SizedBox.shrink()
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final result = results.elementAt(index);
                          if (result is Route) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                child: Text(
                                  result.id,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              title: Text(result.getName()),
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                AppPages.push(context, AppPages.route.path, result);
                              },
                            );
                          } else if (result is Stop) {
                            return ListTile(
                              leading: const CircleAvatar(
                                foregroundColor: Colors.blue,
                                child: Icon(Icons.bus_alert),
                              ),
                              title: Text(result.name),
                              subtitle: result.description.isEmpty || result.name == result.description ? null : Text(result.description),
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                AppPages.push(context, AppPages.stop.path, result);
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      );
              }
              return centeredLoadingIndicator;
            },
          );
  }
}
