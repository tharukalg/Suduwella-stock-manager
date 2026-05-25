import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../../core/theme/app_theme.dart';

class ScanField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;

  const ScanField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.onChanged,
    this.onSubmitted,
  });

  @override
  State<ScanField> createState() => _ScanFieldState();
}

class _ScanFieldState extends State<ScanField> {
  bool _hasFocus = false;

  // Tracks whether the soft keyboard is currently shown for this field.
  // false  → scanner mode  (field focused, keyboard hidden)
  // true   → manual mode   (field focused, keyboard visible)
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  // ── Focus listener ─────────────────────────────────────────────────────────

  void _onFocusChange() {
    if (!mounted) return;
    final focused = widget.focusNode.hasFocus;
    setState(() {
      _hasFocus = focused;
      if (!focused) _keyboardVisible = false; // reset on blur
    });

    // When focus arrives from outside (e.g. programmatic requestFocus or
    // jumping here after barcode submit), always start in scanner mode.
    if (focused) {
      Future.microtask(
            () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
      );
    }
  }

  // ── Tap handler ────────────────────────────────────────────────────────────

  void _handleTap() {
    if (!_hasFocus) {
      // First tap: focus the field but stay in scanner mode.
      widget.focusNode.requestFocus();
      // _onFocusChange will fire and hide the keyboard.
    } else {
      // Second tap (already focused): user wants to type manually.
      setState(() => _keyboardVisible = true);
      SystemChannels.textInput.invokeMethod('TextInput.show');
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hasFocus
                ? AppTheme.brandPrimary
                : cs.onSurface.withOpacity(0.12),
            width: _hasFocus ? 2.0 : 1.5,
          ),
          boxShadow: _hasFocus
              ? [
            BoxShadow(
              color: AppTheme.brandPrimary.withOpacity(0.18),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,

          // Always editable so the HID barcode scanner can write into the field.
          // The soft keyboard is controlled separately via TextInput channel.
          readOnly: false,
          showCursor: true,

          // Block the TextField's own tap from opening the keyboard —
          // our GestureDetector above handles all tap logic.
          onTap: () {
            if (!_keyboardVisible) {
              // Prevent Flutter from showing the keyboard on internal tap.
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            }
          },

          onChanged: widget.onChanged,
          onSubmitted: (v) {
            widget.onSubmitted?.call(v);
            // After scanner submits, hide keyboard and reset to scanner mode.
            setState(() => _keyboardVisible = false);
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },

          textInputAction: TextInputAction.next,
          style: TextStyle(
            fontFamily: AppTheme.primaryFont,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 14,
              color: isDark
                  ? Colors.white.withOpacity(0.3)
                  : Colors.black.withOpacity(0.3),
            ),
            // Icon subtly indicates current mode
            suffixIcon: Icon(
              _keyboardVisible ? Icons.keyboard_rounded : Icons.barcode_reader,
              color: _hasFocus
                  ? AppTheme.brandPrimary
                  : cs.onSurface.withOpacity(0.35),
              size: 20,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}