import 'dart:math';

// Generates a time-sortable unique ID without external packages.
// Format: <13-char hex timestamp>-<16-char random hex>
String generateId() {
  final ts = DateTime.now().millisecondsSinceEpoch.toRadixString(16).padLeft(13, '0');
  final rng = Random.secure();
  final suffix = List.generate(8, (_) => rng.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  return '$ts-$suffix';
}

int nowMs() => DateTime.now().millisecondsSinceEpoch;
