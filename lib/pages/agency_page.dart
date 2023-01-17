import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/entities/agency.dart';
import '/exports/widgets.dart';
import '/repositories/app_storage.dart';

class AgencyPage extends StatelessWidget {
  final Agency agency;

  const AgencyPage(this.agency, {super.key});

  @override
  Widget build(BuildContext context) {
    var imageIndex = 0;
    final imageController = PageController(initialPage: imageIndex);
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height / 3,
                  flexibleSpace: FlexibleSpaceBar(
                    background: StatefulBuilder(
                      builder: (context, setState) {
                        final images = agency.images.toList();
                        return Stack(
                          children: [
                            PageView.builder(
                              controller: imageController,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  images.elementAt(index),
                                  fit: BoxFit.cover,
                                );
                              },
                              onPageChanged: (index) => setState(() => imageIndex = index),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: images.map((image) {
                                  final index = images.indexOf(image);
                                  return InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 4,
                                      ),
                                      child: Icon(
                                        size: 12,
                                        imageIndex == index ? Icons.circle : Icons.circle_outlined,
                                        color: imageIndex == index ? Colors.blue : Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        imageIndex = index;
                                        imageController.animateToPage(
                                          imageIndex,
                                          curve: Curves.easeInOut,
                                          duration: const Duration(milliseconds: 500),
                                        );
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SliverAppBar(
                  pinned: true,
                  titleSpacing: 0,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.orangeAccent,
                  title: Text(
                    agency.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                  ),
                  bottom: ColoredTabBar(
                    color: Theme.of(context).colorScheme.primary,
                    child: TabBar(
                      indicatorColor: Theme.of(context).colorScheme.onPrimary,
                      tabs: [
                        Tab(
                          text: appStorage.localize(37),
                        ),
                        Tab(
                          text: appStorage.localize(19),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(agency.description),
                ),
                ListView(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.call),
                      ),
                      trailing: const SizedBox(
                        height: double.infinity,
                        child: Icon(Icons.open_in_new),
                      ),
                      title: Text(
                        appStorage.localize(88),
                      ),
                      subtitle: Text(agency.phone),
                      onTap: () async {
                        await launchUrl(
                          Uri.parse('tel:${agency.phone}'),
                        );
                      },
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.fax),
                      ),
                      trailing: const SizedBox(
                        height: double.infinity,
                        child: Icon(Icons.open_in_new),
                      ),
                      title: Text(
                        appStorage.localize(89),
                      ),
                      subtitle: Text(agency.fax),
                      onTap: () async {
                        await launchUrl(
                          Uri.parse('tel:${agency.phone}'),
                        );
                      },
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.email),
                      ),
                      trailing: const SizedBox(
                        height: double.infinity,
                        child: Icon(Icons.open_in_new),
                      ),
                      title: Text(
                        appStorage.localize(90),
                      ),
                      subtitle: Text(agency.email),
                      onTap: () async {
                        await launchUrl(
                          Uri.parse('mailto:${agency.email}'),
                        );
                      },
                    ),
                    ListTile(
                      leading: const SizedBox(
                        height: double.infinity,
                        child: CircleAvatar(
                          child: Icon(Icons.map),
                        ),
                      ),
                      trailing: const SizedBox(
                        height: double.infinity,
                        child: Icon(Icons.open_in_new),
                      ),
                      title: Text(
                        appStorage.localize(91),
                      ),
                      subtitle: Text(agency.address),
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(
                            'https://www.google.com/maps/search/${agency.address}',
                          ),
                        );
                      },
                    ),
                    ListTile(
                      isThreeLine: true,
                      leading: const SizedBox(
                        height: double.infinity,
                        child: CircleAvatar(
                          child: Icon(Icons.web),
                        ),
                      ),
                      trailing: const SizedBox(
                        height: double.infinity,
                        child: Icon(Icons.open_in_new),
                      ),
                      title: Text(
                        appStorage.localize(92),
                      ),
                      subtitle: Text(agency.website),
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(agency.website),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
