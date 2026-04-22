import 'package:flutter/material.dart';

class ResponsiveBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const ResponsiveBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 65,
          child: Row(
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, 'HOME'),
              _buildNavItem(1, Icons.arrow_outward_rounded, 'OUTGOING'),
              _buildNavItem(2, Icons.qr_code_scanner_rounded, 'ENTRY'),
              _buildNavItem(3, Icons.inventory_2_outlined, 'STOCK'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;

    // Design matching colors
    final activeColor = const Color(0xFF1C4291);
    final activeBackground = const Color(0xFFE2EBF6);
    final inactiveColor = const Color(0xFFA5B2BE);

    return Expanded(
      child: GestureDetector(
        onTap: () => onItemSelected(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isSelected ? activeBackground : Colors.transparent,
            border: Border(
              top: BorderSide(
                color: isSelected ? activeColor : Colors.transparent,
                width: 3.0,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? activeColor : inactiveColor,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}