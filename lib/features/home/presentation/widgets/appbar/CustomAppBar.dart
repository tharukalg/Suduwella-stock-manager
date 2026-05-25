import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../../core/database/db_viewer_page.dart';

// ── App Bar ───────────────────────────────────────────────────────────────────

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onRefresh;
  final ValueNotifier<bool> syncNotifier;

  const CustomAppBar({
    super.key,
    required this.onRefresh,
    required this.syncNotifier,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  Timer? _holdTimer;

  void _onTitlePressDown(TapDownDetails _) {
    _holdTimer = Timer(const Duration(seconds: 5), _triggerDevAccess);
  }

  void _onTitlePressUp(TapUpDetails _) => _cancelTimer();
  void _onTitlePressCancel() => _cancelTimer();

  void _cancelTimer() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  Future<void> _triggerDevAccess() async {
    _cancelTimer();
    if (!mounted) return;

    final controller = TextEditingController();
    bool obscure = true;

    final granted = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.lock_rounded, color: Colors.red[700], size: 22),
              const SizedBox(width: 10),
              const Text('Developer Access',
                  style: TextStyle(fontSize: 17)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This area is restricted.\nEnter the admin password to continue.',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                obscureText: obscure,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 20,
                    ),
                    onPressed: () =>
                        setDialogState(() => obscure = !obscure),
                  ),
                ),
                onSubmitted: (_) => Navigator.pop(
                    ctx, controller.text == 'admin@123'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.red[800]),
              onPressed: () =>
                  Navigator.pop(ctx, controller.text == 'admin@123'),
              child: const Text('Unlock'),
            ),
          ],
        ),
      ),
    );

    controller.dispose();

    if (granted == true && mounted) {
      Navigator.push<void>(
        context,
        MaterialPageRoute(builder: (_) => const DbViewerPage()),
      );
    } else if (granted == false && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect password'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTapDown: _onTitlePressDown,
        onTapUp: _onTitlePressUp,
        onTapCancel: _onTitlePressCancel,
        child: const Text('SIM Mobile'),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          height: 1.0,
        ),
      ),
      actions: [
        AnimatedRefreshIcon(
          onRefresh: widget.onRefresh,
          syncNotifier: widget.syncNotifier,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

// ── Animated refresh icon ─────────────────────────────────────────────────────

class AnimatedRefreshIcon extends StatefulWidget {
  final VoidCallback onRefresh;
  final ValueNotifier<bool> syncNotifier;

  const AnimatedRefreshIcon({
    super.key,
    required this.onRefresh,
    required this.syncNotifier,
  });

  @override
  State<AnimatedRefreshIcon> createState() => _AnimatedRefreshIconState();
}

class _AnimatedRefreshIconState extends State<AnimatedRefreshIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    widget.syncNotifier.addListener(_onSyncChanged);

    // If sync is already running when the widget mounts, start spinning.
    if (widget.syncNotifier.value) {
      _controller.repeat();
    }
  }

  void _onSyncChanged() {
    if (!mounted) return;
    if (widget.syncNotifier.value) {
      // Sync started — spin continuously.
      _controller.repeat();
    } else {
      // Sync finished — complete the current revolution, then stop cleanly.
      final remaining = 1.0 - _controller.value;
      final remainingMs = (remaining * 900).round();
      _controller
          .animateTo(
            1.0,
            duration: Duration(milliseconds: remainingMs),
            curve: Curves.linear,
          )
          .then((_) {
        if (mounted) _controller.reset();
      });
    }
  }

  @override
  void dispose() {
    widget.syncNotifier.removeListener(_onSyncChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: IconButton(
        icon: const Icon(Icons.sync_rounded, size: 28),
        // Tapping manually triggers a sync; the notifier drives the animation.
        onPressed: widget.onRefresh,
        splashRadius: 24,
      ),
    );
  }
}
