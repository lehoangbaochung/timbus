import 'package:flutter/material.dart';

import '../app/localizations.dart';
import '/entities/agency.dart';
import '/exports/widgets.dart';
import '/extensions/context.dart';

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
                            )
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
                    tabBar: TabBar(
                      indicatorColor: Theme.of(context).colorScheme.onPrimary,
                      tabs: [
                        Tab(
                          text: AppLocalizations.localize(8),
                        ),
                        Tab(
                          text: AppLocalizations.localize(19),
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
                    MenuTile(
                      leading: Icons.phone,
                      trailing: Icons.open_in_new,
                      title: 'Điện thoại',
                      subtitle: agency.phone,
                      onTap: () => context.launch('tel:${agency.phone}'),
                    ),
                    MenuTile(
                      leading: Icons.fax,
                      trailing: Icons.open_in_new,
                      title: 'Fax',
                      subtitle: agency.fax,
                      onTap: () => context.launch('tel:${agency.fax}'),
                    ),
                    MenuTile(
                      leading: Icons.email,
                      trailing: Icons.open_in_new,
                      title: 'Email',
                      subtitle: agency.email,
                      onTap: () => context.launch('mailto:${agency.email}'),
                    ),
                    MenuTile(
                      leading: Icons.map,
                      trailing: Icons.open_in_new,
                      title: 'Địa chỉ',
                      subtitle: agency.address,
                      onTap: () => context.launch('https://www.google.com/maps/search/${agency.address}'),
                    ),
                    MenuTile(
                      leading: Icons.web,
                      trailing: Icons.open_in_new,
                      title: 'Website',
                      subtitle: agency.website,
                      onTap: () => context.launch(agency.website),
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
