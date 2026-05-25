import 'package:get_it/get_it.dart';
import 'package:api_client/api_client.dart';
import 'package:push_notifications/push_notifications.dart';
import '../config/app_config.dart';
import '../database/database_helper.dart';
import '../database/daos/app_settings_dao.dart';
import '../database/daos/b2b_dao.dart';
import '../database/daos/branch_dao.dart';
import '../database/daos/cris_dao.dart';
import '../database/daos/customer_dao.dart';
import '../database/daos/easy_payment_dao.dart';
import '../database/daos/incoming_stock_dao.dart';
import '../database/daos/product_dao.dart';
import '../database/daos/sale_dao.dart';
import '../database/daos/stock_item_dao.dart';
import '../database/daos/device_registration_dao.dart';
import '../database/daos/sync_queue_dao.dart';
import '../firebase/firebase_sync_service.dart';
import '../services/device_service.dart';
import '../logger/app_logger.dart';
import '../../features/home/presentation/homepage/blocs/homepage_bloc.dart';
import '../../features/home/presentation/Cris/blocs/cris_bloc.dart';
import '../../features/home/presentation/stockpage/blocs/stock_bloc.dart';
import '../../features/home/presentation/outgoingpage/blocs/outgoing_bloc.dart';

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

  // ── Local database ───────────────────────────────────────────────
  sl.registerSingleton<DatabaseHelper>(DatabaseHelper.instance);
  await sl<DatabaseHelper>().database; // open + create tables on startup

  // ── DAOs (all depend on DatabaseHelper) ─────────────────────────
  sl.registerLazySingleton(() => AppSettingsDao(sl()));
  sl.registerLazySingleton(() => BranchDao(sl()));
  sl.registerLazySingleton(() => ProductDao(sl()));
  sl.registerLazySingleton(() => StockItemDao(sl()));
  sl.registerLazySingleton(() => CustomerDao(sl()));
  sl.registerLazySingleton(() => SaleDao(sl()));
  sl.registerLazySingleton(() => EasyPaymentDao(sl()));
  sl.registerLazySingleton(() => B2bDao(sl()));
  sl.registerLazySingleton(() => CrisDao(sl()));
  sl.registerLazySingleton(() => IncomingStockDao(sl()));
  sl.registerLazySingleton(() => SyncQueueDao(sl()));
  sl.registerLazySingleton(() => DeviceRegistrationDao(sl()));

  // ── Device & Firebase services ───────────────────────────────────────────
  sl.registerLazySingleton<DeviceService>(
    () => DeviceService(appSettingsDao: sl(), deviceDao: sl()),
  );
  sl.registerLazySingleton<FirebaseSyncService>(
    () => FirebaseSyncService(dbHelper: sl()),
  );

  // ── BLoCs (factories → fresh instance per page) ─────────────────
  sl.registerFactory(() => HomepageBloc(
        appSettingsDao: sl(),
        branchDao: sl(),
        crisDao: sl(),
      ));
  sl.registerFactory(() => CrisBloc(
        crisDao: sl(),
        customerDao: sl(),
      ));
  sl.registerFactory(() => StockBloc(
        stockItemDao: sl(),
        productDao: sl(),
        incomingStockDao: sl(),
        appSettingsDao: sl(),
      ));
  sl.registerFactory(() => OutgoingBloc(
        saleDao: sl(),
        customerDao: sl(),
        stockItemDao: sl(),
        easyPaymentDao: sl(),
        b2bDao: sl(),
        appSettingsDao: sl(),
        productDao: sl(),
      ));

  AppLogger.i('DI ready ✓', tag: 'DI');
}
