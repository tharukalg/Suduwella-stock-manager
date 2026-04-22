import 'package:flutter/material.dart';

enum SnackbarType { success, error, warning, info }

class AppSnackbar {
  AppSnackbar._();

  static void showSuccess(BuildContext ctx, String msg, {String? action, VoidCallback? onAction}) =>
      _show(ctx, msg, SnackbarType.success, action: action, onAction: onAction);
  static void showError(BuildContext ctx, String msg, {String? action, VoidCallback? onAction}) =>
      _show(ctx, msg, SnackbarType.error, action: action, onAction: onAction);
  static void showWarning(BuildContext ctx, String msg, {String? action, VoidCallback? onAction}) =>
      _show(ctx, msg, SnackbarType.warning, action: action, onAction: onAction);
  static void showInfo(BuildContext ctx, String msg, {String? action, VoidCallback? onAction}) =>
      _show(ctx, msg, SnackbarType.info, action: action, onAction: onAction);

  static void _show(BuildContext ctx, String msg, SnackbarType type, {String? action, VoidCallback? onAction}) {
    final cfg = _cfg(type);
    ScaffoldMessenger.of(ctx)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        duration: const Duration(seconds: 4),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [cfg.from, cfg.to], begin: Alignment.centerLeft, end: Alignment.centerRight),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: cfg.from.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 6))],
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
              child: Icon(cfg.icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(cfg.label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.4)),
              const SizedBox(height: 2),
              Text(msg, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
            ])),
            if (action != null)
              TextButton(
                onPressed: () { ScaffoldMessenger.of(ctx).hideCurrentSnackBar(); onAction?.call(); },
                style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.white.withOpacity(0.2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: Text(action, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
          ]),
        ),
      ));
  }
}

class _Cfg { final Color from, to; final IconData icon; final String label;
  const _Cfg(this.from, this.to, this.icon, this.label); }

_Cfg _cfg(SnackbarType t) => switch (t) {
  SnackbarType.success => const _Cfg(Color(0xFF00B09B), Color(0xFF96C93D), Icons.check_circle_rounded,  'SUCCESS'),
  SnackbarType.error   => const _Cfg(Color(0xFFFF416C), Color(0xFFFF4B2B), Icons.cancel_rounded,        'ERROR'),
  SnackbarType.warning => const _Cfg(Color(0xFFF7971E), Color(0xFFFFD200), Icons.warning_rounded,       'WARNING'),
  SnackbarType.info    => const _Cfg(Color(0xFF4776E6), Color(0xFF8E54E9), Icons.info_rounded,          'INFO'),
};
