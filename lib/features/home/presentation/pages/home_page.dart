import 'package:flutter/material.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/app_snackbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final config = AppConfig.instance;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(config.appName),
            floating: true,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: config.isDev ? Colors.orange.withOpacity(0.15) : config.isQa ? Colors.blue.withOpacity(0.15) : Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: config.isDev ? Colors.orange : config.isQa ? Colors.blue : Colors.green),
                ),
                child: Text(
                  config.flavor.name.toUpperCase(),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2,
                    color: config.isDev ? Colors.orange : config.isQa ? Colors.blue : Colors.green),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(delegate: SliverChildListDelegate([
              Center(
                child: Column(children: [
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [cs.primary, cs.tertiary], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [BoxShadow(color: cs.primary.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 8))],
                    ),
                    child: const Icon(Icons.rocket_launch_rounded, size: 56, color: Colors.white),
                  ),
                  const SizedBox(height: 32),
                  Text('Architecture Ready', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(config.baseUrl, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.4), fontFamily: 'monospace')),
                  const SizedBox(height: 48),
                ]),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Snackbars', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      FilledButton.icon(onPressed: () => AppSnackbar.showSuccess(context, 'Everything working!'), icon: const Icon(Icons.check_circle_rounded, size: 18), label: const Text('Success')),
                      FilledButton.tonal(onPressed: () => AppSnackbar.showError(context, 'Something went wrong.'), child: const Text('Error')),
                      OutlinedButton(onPressed: () => AppSnackbar.showWarning(context, 'Proceed with caution.'), child: const Text('Warning')),
                      TextButton(onPressed: () => AppSnackbar.showInfo(context, 'Here is some info.'), child: const Text('Info')),
                    ]),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Config', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _row(context, 'Flavor',       config.flavor.name),
                    _row(context, 'Base URL',     config.baseUrl),
                    _row(context, 'Logging',      config.enableLogging.toString()),
                    _row(context, 'Debug Banner', config.showDebugBanner.toString()),
                  ]),
                ),
              ),
            ])),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      const Spacer(),
      Text(value, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontFamily: 'monospace')),
    ]),
  );
}
