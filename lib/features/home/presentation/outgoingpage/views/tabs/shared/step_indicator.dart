import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_theme.dart';

class StepIndicator extends StatelessWidget {
  final int current; // 0 or 1

  const StepIndicator({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: cs.onSurface.withOpacity(0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          _Step(
            number: 1,
            label: 'Product',
            isActive: current == 0,
            isDone: current > 0,
          ),
          _StepConnector(filled: current > 0),
          _Step(
            number: 2,
            label: 'Customer & Payment',
            isActive: current == 1,
            isDone: false,
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isDone;

  const _Step({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final circleColor = isActive || isDone
        ? AppTheme.brandPrimary
        : cs.onSurface.withOpacity(0.15);

    final labelColor = isActive
        ? AppTheme.brandPrimary
        : cs.onSurface.withOpacity(isDone ? 0.6 : 0.35);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check_rounded,
                color: Colors.white, size: 14)
                : Text(
              '$number',
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isActive || isDone
                    ? Colors.white
                    : cs.onSurface.withOpacity(0.4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppTheme.primaryFont,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool filled;
  const _StepConnector({required this.filled});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: filled
              ? AppTheme.brandPrimary
              : cs.onSurface.withOpacity(0.12),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}