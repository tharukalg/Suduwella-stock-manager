import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/widgets/appbar/CustomAppBar.dart';
import '../../features/home/presentation/widgets/appbar/sidedrawer.dart';
import '../../features/home/presentation/widgets/bottomNavigationBar.dart';

class MainAppShell extends StatelessWidget {
  final Widget child;

  const MainAppShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/outgoing')) return 1;
    if (location.startsWith('/entry')) return 2;
    if (location.startsWith('/stock')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/outgoing');
        break;
      case 2:
        context.go('/entry');
        break;
      case 3:
        context.go('/stock');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top],
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        onRefresh: () {
          print("Refreshing from shell...");
        },
      ),
      drawer: const ModernSideDrawer(),
      body: SafeArea(
        child: child,
      ),
      bottomNavigationBar: ResponsiveBottomNavBar(
        selectedIndex: _calculateSelectedIndex(context),
        onItemSelected: (index) => _onItemTapped(index, context),
      ),
    );
  }
}
