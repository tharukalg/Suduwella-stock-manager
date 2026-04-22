import 'package:get_it/get_it.dart';
import 'package:api_client/api_client.dart';
import 'package:push_notifications/push_notifications.dart';
import '../config/app_config.dart';
import '../logger/app_logger.dart';

/// Global service locator — use [sl] everywhere.
final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final config = AppConfig.instance;

  AppLogger.configure(enabled: config.enableLogging, minLevel: LogLevel.debug);
  AppLogger.i('Initializing DI [${config.flavor.name.toUpperCase()}]', tag: 'DI');

  // ── Network ─────────────────────────────────────────────────
  sl.registerLazySingleton<ApiClient>(() => ApiClient(
    baseUrl:       config.baseUrl,
    enableLogging: config.enableLogging,
    // tokenProvider: () => sl<AuthRepository>().getToken(),
    // refreshToken:  () => sl<AuthRepository>().refreshToken(),
  ));

  // ── Notifications ────────────────────────────────────────────
  final notifications = PushNotificationService();
  await notifications.initialize(
    onNotificationTap: (res) => AppLogger.i('Tap: ${res.payload}', tag: 'Notification'),
  );
  sl.registerSingleton<PushNotificationService>(notifications);

  // ── Feature registrations (add below as you generate features) ──
  // Example after running: tharuka feat -n product
  //
  // sl.registerFactory(() => ProductRemoteDataSourceImpl(sl()));
  // sl.registerFactory<ProductRepository>(() => ProductRepositoryImpl(sl()));
  // sl.registerFactory(() => GetAllProducts(sl()));
  // sl.registerFactory(() => ProductBloc(getAll: sl()));

  AppLogger.i('DI ready ✓', tag: 'DI');
}
