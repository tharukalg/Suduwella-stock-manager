library push_notifications;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

export 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show NotificationResponse, NotificationDetails, AndroidNotificationDetails,
         DarwinNotificationDetails, Importance, Priority, RepeatInterval;

class PushNotificationService {
  static final PushNotificationService _i = PushNotificationService._();
  factory PushNotificationService() => _i;
  PushNotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize({Function(NotificationResponse)? onNotificationTap}) async {
    tz.initializeTimeZones();
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS:     DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true),
        macOS:   DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: onNotificationTap,
    );
    debugPrint('🔔 PushNotificationService ready');
  }

  Future<bool> requestPermission() async {
    final a = await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    final i = await _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);
    return a ?? i ?? false;
  }

  Future<void> show({int id = 0, required String title, required String body, String? payload, NotificationDetails? details}) =>
      _plugin.show(id, title, body, details ?? _defaults(), payload: payload);

  Future<void> showProgress({required int id, required String title, required String body, required int progress, int maxProgress = 100}) =>
      _plugin.show(id, title, body, NotificationDetails(android: AndroidNotificationDetails('progress', 'Progress', importance: Importance.low, priority: Priority.low, showProgress: true, maxProgress: maxProgress, progress: progress, onlyAlertOnce: true)));

  Future<void> showBigText({int id = 0, required String title, required String body, required String bigText, String? payload}) =>
      _plugin.show(id, title, body, NotificationDetails(android: AndroidNotificationDetails('big_text', 'Detailed', styleInformation: BigTextStyleInformation(bigText, contentTitle: title, summaryText: body))), payload: payload);

  Future<void> schedule({int id = 0, required String title, required String body, required DateTime at, String? payload, String? timeZoneName}) =>
      _plugin.zonedSchedule(id, title, body, tz.TZDateTime.from(at, timeZoneName != null ? tz.getLocation(timeZoneName) : tz.local), _defaults(), payload: payload, androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);

  Future<void> scheduleRepeating({int id = 0, required String title, required String body, required RepeatInterval interval, String? payload}) =>
      _plugin.periodicallyShow(id, title, body, interval, _defaults(), androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, payload: payload);

  Future<void> cancel(int id) => _plugin.cancel(id);
  Future<void> cancelAll()    => _plugin.cancelAll();
  Future<List<PendingNotificationRequest>> pending() => _plugin.pendingNotificationRequests();
  Future<List<ActiveNotification>>         active()  => _plugin.getActiveNotifications();

  NotificationDetails _defaults() => const NotificationDetails(
    android: AndroidNotificationDetails('default', 'General', importance: Importance.high, priority: Priority.high),
    iOS:     DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
  );
}
