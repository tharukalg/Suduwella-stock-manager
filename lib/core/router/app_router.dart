import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../theme/MainAppShell.dart';

abstract class Routes {
  static const home = '/';
  static const outgoing = '/outgoing';
  static const entry = '/entry';
  static const stock = '/stock';

  static const fullScreenDetails = '/details';
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
                const Center(child: Text('Outgoing Page')),
          ),
          GoRoute(
            path: Routes.entry,
            builder: (context, state) =>
                const Center(child: Text('Entry Page')),
          ),
          GoRoute(
            path: Routes.stock,
            builder: (context, state) =>
                const Center(child: Text('Stock Page')),
          ),
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
    ],
  );
}
