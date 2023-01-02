import 'package:flutter/material.dart';

import '../app/localizations.dart';
import '/entities/article.dart';
import '../app/pages.dart';
import '/exports/widgets.dart';
import '/extensions/context.dart';
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
            AppLocalizations.localize(5),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: AppLocalizations.localize(76),
                icon: const Icon(Icons.directions_bus),
              ),
              Tab(
                text: AppLocalizations.localize(77),
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
                            AppLocalizations.localize(71),
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
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  article.thumbnail,
                                ),
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
                            AppLocalizations.localize(71),
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
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  article.thumbnail,
                                ),
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
  final Article article;

  const ArticleDetailPage(this.article, {super.key});

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
                background: Image.network(
                  article.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
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
              onTap: () => context.launch(article.source),
              onLongPress: () => context.copyToClipboard(article.source),
            ),
          ],
        ),
      ),
    );
  }
}
