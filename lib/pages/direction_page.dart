import 'package:bus/app/pages.dart';
import 'package:flutter/material.dart';

import '/app/localizations.dart';
import '/exports/entities.dart';
import '/exports/widgets.dart';
import '/extensions/geolocator.dart';
import '/repositories/app_storage.dart';

class DirectionPage extends SearchDelegate<String> {
  Stop? from, to;
  final directionFocusNode = FocusNode();
  late final directionTextController = TextEditingController(text: to?.name);

  DirectionPage({this.from, this.to})
      : super(
          searchFieldStyle: const TextStyle(),
          searchFieldLabel: AppLocalizations.localize(67),
        );

  bool get enabled => query.isNotEmpty && directionTextController.text.isNotEmpty;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: AppLocalizations.localize(46),
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.blue,
      ),
      onPressed: () => close(context, query),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Visibility(
        visible: query.isNotEmpty,
        child: IconButton(
          tooltip: AppLocalizations.localize(69),
          icon: const Icon(Icons.clear),
          onPressed: () => query = empty,
        ),
      ),
      IconButton(
        tooltip: AppLocalizations.localize(11),
        icon: const Icon(
          Icons.my_location,
          color: Colors.blue,
        ),
        onPressed: () async {
          final nearestStops = await GeolocatorService.getNearestStops();
          await showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text(
                  AppLocalizations.localize(79),
                ),
                children: nearestStops
                    .map((stop) {
                      return MenuTile(
                        leading: Icons.bus_alert,
                        trailing: Icons.call_made,
                        title: stop.name,
                        subtitle: stop.description.isEmpty || stop.name == stop.description ? null : stop.description,
                        onTap: () {
                          from = stop;
                          query = stop.name;
                          Navigator.pop(context);
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
    ];
  }

  @override
  PreferredSizeWidget buildBottom(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: TextField(
        focusNode: directionFocusNode,
        controller: directionTextController..addListener(() => query = query),
        decoration: InputDecoration(
          hintText: AppLocalizations.localize(68),
        ),
      ),
      leading: IconButton(
        tooltip: AppLocalizations.localize(15),
        icon: Icon(
          Icons.swap_vert,
          color: !enabled ? Colors.grey : Colors.blue,
        ),
        onPressed: !enabled
            ? null
            : () {
                final stop = from;
                from = to;
                to = stop;
                final text = query;
                query = directionTextController.text;
                directionTextController
                  ..text = text
                  ..selection = TextSelection.collapsed(
                    offset: directionTextController.text.length,
                  );
              },
      ),
      actions: [
        Visibility(
          visible: directionTextController.text.isNotEmpty,
          child: IconButton(
            tooltip: AppLocalizations.localize(69),
            icon: const Icon(Icons.clear),
            onPressed: () => directionTextController.clear(),
          ),
        ),
        IconButton(
          tooltip: AppLocalizations.localize(10),
          icon: Icon(
            Icons.directions,
            color: !enabled ? Colors.grey : Colors.blue,
          ),
          onPressed: !enabled ? null : () => showResults(context),
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: appStorage.getAllStops(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final stops = !directionFocusNode.hasPrimaryFocus
              ? snapshot.requireData.where(
                  (stop) => stop.name.contains(query) || stop.description.contains(query),
                )
              : snapshot.requireData.where(
                  (stop) => stop.name.contains(directionTextController.text) || stop.description.contains(directionTextController.text),
                );
          return ListView.builder(
            itemCount: stops.length,
            itemBuilder: (context, index) {
              final stop = stops.elementAt(index);
              return MenuTile(
                leading: Icons.bus_alert,
                trailing: Icons.call_made,
                title: stop.name,
                subtitle: stop.name == stop.description ? null : stop.description,
                onTap: () {
                  if (!directionFocusNode.hasPrimaryFocus) {
                    from = stop;
                    query = stop.name;
                  } else {
                    to = stop;
                    directionTextController
                      ..text = stop.name
                      ..selection = TextSelection.collapsed(
                        offset: directionTextController.text.length,
                      );
                  }
                },
              );
            },
          );
        }
        return centeredLoadingIndicator;
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return from == null || to == null
        ? Center(
            child: Text(
              'Điểm dừng đã chọn không chính xác',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        : FutureBuilder(
            future: GeolocatorService.direct(from!, to!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final routes = snapshot.requireData.toList();
                return routes.isEmpty
                    ? Text(
                        AppLocalizations.localize(71),
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
              return centeredLoadingIndicator;
            },
          );
  }
}
