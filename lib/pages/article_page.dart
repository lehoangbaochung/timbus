import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app/app_pages.dart';
import '/entities/article.dart';
import '/exports/widgets.dart';
import '/repositories/app_storage.dart';

class ArticleMasterPage extends StatelessWidget {
  const ArticleMasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          title: Text(
            appStorage.localize(5),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: appStorage.localize(35),
                icon: const Icon(Icons.directions_bus),
              ),
              Tab(
                text: appStorage.localize(36),
                icon: const Icon(Icons.newspaper_sharp),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Primary articles
            FutureBuilder(
              future: appStorage.getAllArticles(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final articles = snapshot.requireData.where((article) => article.primary);
                  return articles.isEmpty
                      ? Center(
                          child: Text(
                            appStorage.localize(71),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles.elementAt(index);
                            return ListTile(
                              title: Text(
                                article.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                article.content,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: CachedNetworkImage(
                                imageUrl: article.thumbnail,
                                placeholder: (_, __) {
                                  return const CircleAvatar(
                                    child: Icon(Icons.newspaper),
                                  );
                                },
                                imageBuilder: (_, imageProvider) {
                                  return CircleAvatar(
                                    backgroundImage: imageProvider,
                                  );
                                },
                              ),
                              onTap: () => AppPages.push(context, AppPages.article.path + AppPages.detail.path, article),
                            );
                          },
                        );
                }
                return centeredLoadingIndicator;
              },
            ),
            // Secondary articles
            FutureBuilder(
              future: appStorage.getAllArticles(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final articles = snapshot.requireData.where((article) => !article.primary);
                  return articles.isEmpty
                      ? Center(
                          child: Text(
                            appStorage.localize(71),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles.elementAt(index);
                            return ListTile(
                              title: Text(
                                article.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                article.content,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: CachedNetworkImage(
                                imageUrl: article.thumbnail,
                                placeholder: (_, __) {
                                  return const CircleAvatar(
                                    child: Icon(Icons.newspaper),
                                  );
                                },
                                imageBuilder: (_, imageProvider) {
                                  return CircleAvatar(
                                    backgroundImage: imageProvider,
                                  );
                                },
                              ),
                              onTap: () => AppPages.push(context, AppPages.article.path + AppPages.detail.path, article),
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

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage(this.article, {super.key});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height / 3,
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: article.thumbnail,
                  placeholder: (_, __) => centeredLoadingIndicator,
                  errorWidget: (_, __, ___) {
                    return const Center(
                      child: Icon(Icons.newspaper),
                    );
                  },
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      article.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(article.content),
                  ],
                ),
              ),
            ),
            ListTile(
              minLeadingWidth: 0,
              tileColor: Colors.orangeAccent,
              leading: const Icon(
                Icons.link,
                color: Colors.white,
              ),
              trailing: const Icon(
                Icons.open_in_new,
                color: Colors.white,
              ),
              title: Text(
                article.source,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () async {
                await launchUrl(
                  Uri.parse(article.source),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
