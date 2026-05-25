import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/database/daos/app_settings_dao.dart';
import '../../../../../core/database/daos/branch_dao.dart';
import '../../../../../core/database/daos/cris_dao.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  final AppSettingsDao _appSettingsDao;
  final BranchDao _branchDao;
  final CrisDao _crisDao;

  Timer? _clockTimer;

  HomepageBloc({
    required AppSettingsDao appSettingsDao,
    required BranchDao branchDao,
    required CrisDao crisDao,
  })  : _appSettingsDao = appSettingsDao,
        _branchDao = branchDao,
        _crisDao = crisDao,
        super(const HomepageInitial()) {
    on<HomepageInitializeEvent>(_onInitialize);
    on<HomepageRefreshEvent>(_onRefresh);
    on<HomepageTickEvent>(_onTick);
  }

  Future<void> _onInitialize(
    HomepageInitializeEvent event,
    Emitter<HomepageState> emit,
  ) async {
    final branchCode = await _appSettingsDao.getActiveBranch();
    final branch = await _branchDao.getById(branchCode);
    final alertCount = await _crisDao.getActiveAlertCount();
    final lastSyncedAt = await _appSettingsDao.getLastSyncedAt();

    emit(HomepageLoaded(
      branchName: branch?.name ?? branchCode,
      currentTime: DateTime.now(),
      crisAlertCount: alertCount,
      lastSyncedAt: lastSyncedAt,
    ));

    _clockTimer?.cancel();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(HomepageTickEvent(DateTime.now()));
    });
  }

  void _onTick(HomepageTickEvent event, Emitter<HomepageState> emit) {
    final current = state;
    if (current is HomepageLoaded) {
      emit(current.copyWith(currentTime: event.now));
    }
  }

  Future<void> _onRefresh(
    HomepageRefreshEvent event,
    Emitter<HomepageState> emit,
  ) async {
    final current = state;
    if (current is! HomepageLoaded) return;
    final alertCount = await _crisDao.getActiveAlertCount();
    final now = DateTime.now();
    await _appSettingsDao.setLastSyncedAt(now);
    emit(current.copyWith(crisAlertCount: alertCount, lastSyncedAt: now));
  }

  @override
  Future<void> close() {
    _clockTimer?.cancel();
    return super.close();
  }
}