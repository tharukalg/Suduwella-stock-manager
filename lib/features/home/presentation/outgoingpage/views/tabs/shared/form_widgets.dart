import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_theme.dart';
import '../../../blocs/outgoing_bloc.dart';


// ── Label style constant (used across tabs) ───────────────────────────────────

const fieldLabelStyle = TextStyle(
  fontFamily: AppTheme.primaryFont,
  fontSize: 11,
  fontWeight: FontWeight.w600,
  letterSpacing: 1.1,
);

// ── FieldLabel ────────────────────────────────────────────────────────────────

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: fieldLabelStyle.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
      ),
    );
  }
}

// ── SectionCard ───────────────────────────────────────────────────────────────

class SectionCard extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final Widget? action;
  final Widget child;

  const SectionCard({
    super.key,
    this.title,
    this.titleStyle,
    this.action,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Container(
                  width: 3,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppTheme.brandPrimary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title!,
                    style: (titleStyle ??
                        const TextStyle(
                          fontFamily: AppTheme.secondaryFont,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ))
                        .copyWith(color: cs.onSurface),
                  ),
                ),
                if (action != null) action!,
              ],
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
}

// ── ReadonlyAmountField ───────────────────────────────────────────────────────

class ReadonlyAmountField extends StatelessWidget {
  final String value;
  const ReadonlyAmountField({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark
            ? cs.surfaceContainerHighest
            : AppTheme.brandPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.onSurface.withOpacity(0.1)),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontFamily: AppTheme.primaryFont,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
      ),
    );
  }
}

// ── DurationSelector ──────────────────────────────────────────────────────────

class DurationSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const DurationSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _options = [3, 6, 12, 18, 24, 36];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _options.map((m) {
        final isSelected = m == selected;
        return GestureDetector(
          onTap: () => onChanged(m),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.brandPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? AppTheme.brandPrimary
                    : cs.onSurface.withOpacity(0.2),
              ),
            ),
            child: Text(
              '$m',
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isSelected ? Colors.white : cs.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── VerifyButton ──────────────────────────────────────────────────────────────

class VerifyButton extends StatelessWidget {
  final VerificationStatus status;
  final VoidCallback? onTap;

  const VerifyButton({super.key, required this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isVerified = status == VerificationStatus.verified;
    final isLoading = status == VerificationStatus.loading;

    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:
          isVerified ? Colors.green.shade600 : AppTheme.brandPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
              strokeWidth: 2, color: Colors.white),
        )
            : Text(
          isVerified ? 'Verified' : 'Verify',
          style: const TextStyle(
            fontFamily: AppTheme.primaryFont,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── IconActionButton ──────────────────────────────────────────────────────────

class IconActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const IconActionButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Icon(icon, color: cs.onSurfaceVariant, size: 20),
        ),
      ),
    );
  }
}

// ── CameraPlaceholder ─────────────────────────────────────────────────────────

class CameraPlaceholder extends StatelessWidget {
  final VoidCallback? onTap;
  const CameraPlaceholder({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: isDark
              ? cs.surfaceContainerHighest
              : AppTheme.brandPrimary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.brandPrimary.withOpacity(0.15),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined,
                color: cs.onSurface.withOpacity(0.45), size: 22),
            const SizedBox(width: 10),
            Text(
              'Take a picture\nof the customer',
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 13,
                color: cs.onSurface.withOpacity(0.55),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── DashedButton ──────────────────────────────────────────────────────────────

class DashedButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const DashedButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.brandPrimary.withOpacity(0.35),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTheme.primaryFont,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: cs.primary,
          ),
        ),
      ),
    );
  }
}

// ── PlanTile ──────────────────────────────────────────────────────────────────

class PlanTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const PlanTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.brandPrimary.withOpacity(isDark ? 0.2 : 0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppTheme.brandPrimary
                : cs.onSurface.withOpacity(0.15),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: AppTheme.secondaryFont,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: selected ? cs.primary : cs.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 12,
                color: cs.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── SummaryRow ────────────────────────────────────────────────────────────────

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const SummaryRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 13,
              color: cs.onSurface.withOpacity(0.7),
            )),
        Text(value,
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            )),
      ],
    );
  }
}