import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/Cris/views/CrisPage.dart';
import '../../features/home/presentation/homepage/views/home_page.dart';
import '../../features/home/presentation/outgoingpage/views/outgoing_page.dart';
import '../../features/home/presentation/stockpage/views/stock_page.dart';
import '../database/db_viewer_page.dart';
import '../theme/MainAppShell.dart';

abstract class Routes {
  static const home = '/';
  static const outgoing = '/outgoing';
  static const cris = '/cris';
  static const stock = '/stock';

  static const fullScreenDetails = '/details';
  static const dbViewer = '/db-viewer';
}

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.home,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainAppShell(child: child);
        },
        routes: [
          GoRoute(
            path: Routes.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: Routes.outgoing,
            builder: (context, state) =>
                const OutgoingPage(),
          ),
          GoRoute(
            path: Routes.cris,
            builder: (context, state) => const CrisPage(),
          ),
          GoRoute(
            path: Routes.stock,
            builder: (context, state) => const StockPage(),
          )
        ],
      ),
      GoRoute(
        path: Routes.fullScreenDetails,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Full Screen Page')),
            body: const Center(
                child: Text('No bottom nav or global app bar here!')),
          );
        },
      ),
      GoRoute(
        path: Routes.dbViewer,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DbViewerPage(),
      ),
    ],
  );
}
