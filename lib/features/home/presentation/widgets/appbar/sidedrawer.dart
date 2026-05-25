import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';

class ModernSideDrawer extends StatelessWidget {
  const ModernSideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Drawer(
      // Background color is pulled from AppTheme's drawerTheme
      child: Column(
        children: [
          // Custom Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30, left: 24, right: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // Dynamic gradient based on theme's primary color
                colors: [primaryColor, primaryColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'User Profile',
                  style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'user@sim-mobile.com',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildDrawerItem(context, Icons.dashboard_rounded, 'Dashboard', true),
                _buildDrawerItem(context, Icons.settings_rounded, 'Settings', false),
                _buildDrawerItem(context, Icons.help_outline_rounded, 'Support', false),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Divider(height: 1),
                ),
                _buildDrawerItem(
                  context,
                  Icons.storage_rounded,
                  'DB Viewer',
                  false,
                  onTap: () => _promptDbViewerPassword(context),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Divider(height: 1),
                ),
                _buildDrawerItem(context, Icons.logout_rounded, 'Logout', false, isDestructive: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _promptDbViewerPassword(BuildContext context) {
    final controller = TextEditingController();
    bool obscure = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.storage_rounded, size: 20),
              SizedBox(width: 8),
              Text('DB Viewer'),
            ],
          ),
          content: TextField(
            controller: controller,
            obscureText: obscure,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => obscure = !obscure),
              ),
            ),
            onSubmitted: (_) => _validateAndOpen(ctx, controller.text),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => _validateAndOpen(ctx, controller.text),
              child: const Text('Open'),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndOpen(BuildContext ctx, String password) {
    Navigator.of(ctx).pop();
    ctx.push(Routes.dbViewer);
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    bool isSelected, {
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final color = isDestructive
        ? Colors.redAccent
        : (isSelected ? primaryColor : theme.colorScheme.onSurfaceVariant);

    return ListTile(
      leading: Icon(icon, color: color, size: 26),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontFamily: theme.textTheme.bodyMedium?.fontFamily,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 32),
      selected: isSelected,
      selectedTileColor: primaryColor.withOpacity(0.05),
      onTap: onTap,
    );
  }
}