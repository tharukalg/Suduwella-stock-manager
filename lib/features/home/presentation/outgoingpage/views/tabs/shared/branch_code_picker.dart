import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_theme.dart';

class BranchCodePicker extends StatelessWidget {
  final List<String> codes;
  final String selected;
  final ValueChanged<String> onChanged;

  const BranchCodePicker({
    super.key,
    required this.codes,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: cs.onSurface.withOpacity(0.12),
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: cs.onSurface.withOpacity(0.5),
          ),
          dropdownColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          style: TextStyle(
            fontFamily: AppTheme.primaryFont,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
          ),
          items: codes.map((code) {
            return DropdownMenuItem<String>(
              value: code,
              child: Text(
                '$code-',
                style: TextStyle(
                  fontFamily: AppTheme.primaryFont,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}