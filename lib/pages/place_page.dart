import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/app/app_pages.dart';
import '/exports/entities.dart';
import '/exports/widgets.dart';
import '/repositories/app_storage.dart';

class PlaceMasterPage extends StatelessWidget {
  const PlaceMasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          title: Text(
            appStorage.localize(8),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: appStorage.localize(46),
                icon: const Icon(Icons.place),
              ),
              Tab(
                text: appStorage.localize(2),
                icon: const Icon(Icons.favorite),
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
        body: TabBarView(
          children: [
            // Routes
            FutureBuilder(
              future: appStorage.getAllPlaces(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final places = snapshot.requireData.shuffled;
                  return places.isEmpty
                      ? Center(
                          child: Text(
                            appStorage.localize(71),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : ListView.builder(
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            final place = places.elementAt(index);
                            return ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: place.thumbnail,
                                placeholder: (_, __) {
                                  return const CircleAvatar(
                                    child: Icon(Icons.place),
                                  );
                                },
                                imageBuilder: (context, imageProvider) {
                                  return CircleAvatar(
                                    backgroundImage: imageProvider,
                                  );
                                },
                              ),
                              title: Text(
                                place.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                place.description,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () => AppPages.push(context, AppPages.place.path + AppPages.detail.path, place),
                            );
                          },
                        );
                }
                return centeredLoadingIndicator;
              },
            ),
            // Favorites
            FutureBuilder(
              future: appStorage.getAllPlaces(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final places = <Place>[];
                  return places.isEmpty
                      ? Center(
                          child: Text(
                            appStorage.localize(71),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : ListView.builder(
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            final place = places.elementAt(index);
                            return ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: place.thumbnail,
                                placeholder: (_, __) {
                                  return const CircleAvatar(
                                    child: Icon(Icons.place),
                                  );
                                },
                                imageBuilder: (_, imageProvider) {
                                  return CircleAvatar(
                                    backgroundImage: imageProvider,
                                  );
                                },
                              ),
                              title: Text(
                                place.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                place.description,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () => AppPages.push(context, AppPages.place.path + AppPages.detail.path, place),
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

class PlaceDetailPage extends StatelessWidget {
  const PlaceDetailPage(this.place, {super.key});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.star_border),
            tooltip: appStorage.localize(72),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: place.thumbnail,
              placeholder: (_, __) {
                return const Center(
                  child: Icon(Icons.place),
                );
              },
            ),
          ),
          AppBar(
            primary: false,
            title: Center(
              child: Text(
                place.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.orangeAccent,
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: ColoredTabBar(
                  color: Theme.of(context).colorScheme.primary,
                  child: TabBar(
                    indicatorColor: Theme.of(context).colorScheme.onPrimary,
                    tabs: [
                      Tab(
                        text: appStorage.localize(37),
                      ),
                      Tab(
                        text: appStorage.localize(79),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Text(place.description),
                    ),
                    FutureBuilder(
                      future: place.getStops(),
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
                                      leading: const CircleAvatar(
                                        foregroundColor: Colors.blue,
                                        child: Icon(Icons.bus_alert),
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
          ),
        ],
      ),
    );
  }
}
