import 'package:flutter/material.dart' hide Route;
import 'package:go_router/go_router.dart';

import '../pages/about_page.dart';
import '../pages/agency_page.dart';
import '../pages/article_page.dart';
import '../pages/favorite_page.dart';
import '../pages/feedback_page.dart';
import '../pages/help_page.dart';
import '../pages/home_page.dart';
import '../pages/lookup_page.dart';
import '../pages/place_page.dart';
import '../pages/route_page.dart';
import '../pages/settings_page.dart';
import '../pages/stop_page.dart';
import '../exports/entities.dart';

export '../pages/direction_page.dart';
export '../pages/search_page.dart';

enum AppPages {
  about,
  agency,
  article,
  favorite,
  feedback,
  help,
  home,
  lookup,
  place,
  route,
  settings,
  stop,
  detail;

  String get path => '/$name';

  /// Pop the top-most route off the [Navigator] that most tightly encloses the given [context].
  static void pop(BuildContext context) => Navigator.pop(context);

  /// Push a [path] onto the stack with an optional [data] object.
  static void push(BuildContext context, String path, [dynamic data]) => context.push(path, extra: data);

  static GoRouter get routerConfig {
    return GoRouter(
      initialLocation: AppPages.home.path,
      routes: [
        GoRoute(
          path: AppPages.home.path,
          builder: (_, __) => const HomePage(),
        ),
        GoRoute(
          path: AppPages.help.path,
          builder: (_, __) => const HelpPage(),
        ),
        GoRoute(
          path: AppPages.about.path,
          builder: (_, __) => const AboutPage(),
        ),
        GoRoute(
          path: AppPages.lookup.path,
          builder: (_, __) => const LookupPage(),
        ),
        GoRoute(
          path: AppPages.favorite.path,
          builder: (_, __) => const FavoritePage(),
        ),
        GoRoute(
          path: AppPages.feedback.path,
          builder: (_, __) => const FeedbackPage(),
        ),
        GoRoute(
          path: AppPages.settings.path,
          builder: (_, __) => const SettingsPage(),
        ),
        GoRoute(
          path: AppPages.agency.path,
          builder: (_, state) => AgencyPage(state.extra as Agency),
        ),
        GoRoute(
          path: AppPages.route.path,
          builder: (_, state) => RoutePage(state.extra as Route),
        ),
        GoRoute(
          path: AppPages.stop.path,
          builder: (_, state) => StopPage(state.extra as Stop),
        ),
        GoRoute(
          path: AppPages.article.path,
          builder: (_, __) => const ArticleMasterPage(),
          routes: [
            GoRoute(
              path: AppPages.detail.name,
              builder: (_, state) => ArticleDetailPage(state.extra as Article),
            ),
          ],
        ),
        GoRoute(
          path: AppPages.place.path,
          builder: (_, __) => const PlaceMasterPage(),
          routes: [
            GoRoute(
              path: AppPages.detail.name,
              builder: (_, state) => PlaceDetailPage(state.extra as Place),
            ),
          ],
        ),
      ],
    );
  }
}
