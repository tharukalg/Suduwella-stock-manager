import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import '../../dataconnect_generated/generated.dart';
import '../database/daos/app_settings_dao.dart';
import '../database/daos/device_registration_dao.dart';
import '../database/database_utils.dart';
import '../logger/app_logger.dart';

const _tag = 'DeviceService';

/// Manages the permanent device identity (UUID) and its Firebase-registered
/// branch assignment.
///
/// Flow on every app launch:
///   1. [getOrCreateDeviceId] — reads device UUID from [app_settings]; generates
///      and persists one if this is the first launch.
///   2. [resolveDeviceBranch] — queries Firebase for the branch mapping, caches
///      the result locally, and updates [active_branch] in [app_settings].
///      Falls back to the local cache when Firebase is unreachable.
///
/// Admin registration:
///   Call [registerDevice] from the dev screen to write the branch mapping to
///   Firebase and update [active_branch] immediately.
class DeviceService {
  DeviceService({
    required AppSettingsDao appSettingsDao,
    required DeviceRegistrationDao deviceDao,
  })  : _settingsDao = appSettingsDao,
        _deviceDao = deviceDao;

  final AppSettingsDao _settingsDao;
  final DeviceRegistrationDao _deviceDao;

  ExampleConnector get _connector => ExampleConnector.instance;

  static const _deviceIdKey = 'device_id';

  // ── Device ID ───────────────────────────────────────────────────────────────

  /// Returns the permanent device UUID. Generates and persists it on first call.
  Future<String> getOrCreateDeviceId() async {
    final existing = await _settingsDao.get(_deviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;

    final newId = generateId();
    await _settingsDao.set(_deviceIdKey, newId);
    AppLogger.i('Generated new device ID: $newId', tag: _tag);
    return newId;
  }

  // ── Branch resolution ───────────────────────────────────────────────────────

  /// Queries Firebase for this device's branch registration.
  ///
  /// On success: updates [active_branch] in [app_settings] and writes to the
  /// local [device_registrations] table.
  ///
  /// On failure (network error / not registered): falls back to the local
  /// cache. If no cache exists, [active_branch] is left unchanged (defaulting
  /// to whatever was seeded — 'KH').
  ///
  /// Returns the resolved branch code, or null if the device is not yet
  /// registered in Firebase.
  Future<String?> resolveDeviceBranch() async {
    final deviceId = await getOrCreateDeviceId();
    AppLogger.d('Resolving branch for device $deviceId', tag: _tag);

    try {
      await _ensureSignedIn();

      final result = await _connector
          .getDeviceRegistration(id: deviceId)
          .execute(fetchPolicy: QueryFetchPolicy.serverOnly);

      final registrations = result.data.deviceRegistrations;
      if (registrations.isEmpty) {
        AppLogger.w(
          'Device $deviceId not registered in Firebase — using fallback branch',
          tag: _tag,
        );
        return await _fallbackBranch(deviceId);
      }

      final reg = registrations.first;
      final branchCode = reg.branchCode;

      // Cache locally so the app works offline after first registration.
      final now = nowMs();
      await _deviceDao.upsert(DeviceRegistrationModel(
        id: reg.id,
        branchCode: branchCode,
        deviceLabel: reg.deviceLabel,
        createdAt: now,
        updatedAt: reg.updatedAt.toInt(),
      ));

      // Make the branch active immediately.
      await _settingsDao.setActiveBranch(branchCode);
      AppLogger.i('Device $deviceId → branch $branchCode', tag: _tag);
      return branchCode;
    } catch (e, st) {
      AppLogger.e(
        'Firebase branch lookup failed: $e',
        tag: _tag,
        error: e,
        stackTrace: st,
      );
      return await _fallbackBranch(deviceId);
    }
  }

  Future<String?> _fallbackBranch(String deviceId) async {
    final cached = await _deviceDao.get(deviceId);
    if (cached != null) {
      AppLogger.d('Using cached branch: ${cached.branchCode}', tag: _tag);
      await _settingsDao.setActiveBranch(cached.branchCode);
      return cached.branchCode;
    }
    AppLogger.w('No local cache for device $deviceId', tag: _tag);
    return null; // caller keeps whatever active_branch is currently set
  }

  // ── Admin registration ──────────────────────────────────────────────────────

  /// Registers (or re-registers) this device to [branchCode] in Firebase.
  ///
  /// [deviceLabel] is an optional human-readable name (e.g. "KH POS 1").
  ///
  /// Throws if the Firebase call fails — let the UI handle the error.
  Future<void> registerDevice(String branchCode, {String? deviceLabel}) async {
    final deviceId = await getOrCreateDeviceId();
    final now = nowMs();

    await _ensureSignedIn();

    await _connector
        .upsertDeviceRegistration(
          id: deviceId,
          branchCode: branchCode,
          createdAt: now.toDouble(),
          updatedAt: now.toDouble(),
        )
        .deviceLabel(deviceLabel)
        .execute();

    // Update local cache.
    await _deviceDao.upsert(DeviceRegistrationModel(
      id: deviceId,
      branchCode: branchCode,
      deviceLabel: deviceLabel,
      createdAt: now,
      updatedAt: now,
    ));

    // Apply immediately.
    await _settingsDao.setActiveBranch(branchCode);
    AppLogger.i('Device $deviceId registered to branch $branchCode', tag: _tag);
  }

  // ── Auth ────────────────────────────────────────────────────────────────────

  Future<void> _ensureSignedIn() async {
    if (FirebaseAuth.instance.currentUser == null) {
      AppLogger.d('No Firebase user — signing in anonymously', tag: _tag);
      await FirebaseAuth.instance.signInAnonymously();
    }
  }
}
