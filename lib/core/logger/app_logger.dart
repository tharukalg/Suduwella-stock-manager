import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error, wtf }

class AppLogger {
  AppLogger._();

  static bool     _enabled  = kDebugMode;
  static LogLevel _minLevel = LogLevel.debug;

  static void configure({bool enabled = true, LogLevel minLevel = LogLevel.debug}) {
    _enabled  = enabled;
    _minLevel = minLevel;
  }

  static void d(String msg, {String? tag, Object? data}) => _log(LogLevel.debug,   msg, tag: tag, data: data);
  static void i(String msg, {String? tag, Object? data}) => _log(LogLevel.info,    msg, tag: tag, data: data);
  static void w(String msg, {String? tag, Object? data}) => _log(LogLevel.warning, msg, tag: tag, data: data);

  static void e(String msg, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, msg, tag: tag, data: error);
    if (stackTrace != null && _enabled) debugPrint('  ↳ $stackTrace');
  }

  static void wtf(String msg, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.wtf, msg, tag: tag, data: error);
    if (stackTrace != null && _enabled) debugPrint('  ↳ $stackTrace');
  }

  static void _log(LogLevel level, String msg, {String? tag, Object? data}) {
    if (!_enabled || level.index < _minLevel.index) return;
    final cfg       = _cfg(level);
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final tagStr    = tag != null ? ' [$tag]' : '';
    final dataStr   = data != null ? '\n    ↳ $data' : '';
    debugPrint('${cfg.emoji} ${cfg.label} $timestamp$tagStr  $msg$dataStr');
  }
}

class _Cfg { final String emoji, label; const _Cfg(this.emoji, this.label); }

_Cfg _cfg(LogLevel l) => switch (l) {
  LogLevel.debug   => const _Cfg('🔍', '[DBG]'),
  LogLevel.info    => const _Cfg('💡', '[INF]'),
  LogLevel.warning => const _Cfg('⚠️ ', '[WRN]'),
  LogLevel.error   => const _Cfg('🔴', '[ERR]'),
  LogLevel.wtf     => const _Cfg('💀', '[WTF]'),
};
