import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/locator.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const App());
}
