import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/locator.dart';
import '../../core/firebase/firebase_sync_service.dart';
import '../../core/services/device_service.dart';
import '../../features/home/presentation/widgets/appbar/CustomAppBar.dart';
import '../../features/home/presentation/widgets/appbar/sidedrawer.dart';
import '../../features/home/presentation/widgets/bottomNavigationBar.dart';

class MainAppShell extends StatefulWidget {
  final Widget child;

  const MainAppShell({super.key, required this.child});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  late final FirebaseSyncService _syncService;
  late final DeviceService _deviceService;

  @override
  void initState() {
    super.initState();
    _syncService = sl<FirebaseSyncService>();
    _deviceService = sl<DeviceService>();

    // On launch:
    //   1. Resolve which branch this device belongs to (Firebase lookup).
    //   2. Sync pending local data to Firebase.
    // Both are fire-and-forget from the UI's perspective — failures are logged.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _deviceService.resolveDeviceBranch();
      await _syncService.syncNow();
    });
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/outgoing')) return 1;
    if (location.startsWith('/cris')) return 2;
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
        context.go('/cris');
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
      appBar: CustomAppBar(
        syncNotifier: _syncService.isSyncing,
        onRefresh: () => _syncService.syncNow(),
      ),
      drawer: const ModernSideDrawer(),
      body: SafeArea(
        child: widget.child,
      ),
      bottomNavigationBar: ResponsiveBottomNavBar(
        selectedIndex: _calculateSelectedIndex(context),
        onItemSelected: (index) => _onItemTapped(index, context),
      ),
    );
  }
}
