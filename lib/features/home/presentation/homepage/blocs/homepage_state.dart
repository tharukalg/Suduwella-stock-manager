part of 'homepage_bloc.dart';

@immutable
sealed class HomepageState {
  const HomepageState();
}

final class HomepageInitial extends HomepageState {
  const HomepageInitial();
}

final class HomepageLoaded extends HomepageState {
  final String branchName;
  final DateTime currentTime;
  final int crisAlertCount;
  final DateTime? lastSyncedAt;

  const HomepageLoaded({
    required this.branchName,
    required this.currentTime,
    required this.crisAlertCount,
    this.lastSyncedAt,
  });

  HomepageLoaded copyWith({
    String? branchName,
    DateTime? currentTime,
    int? crisAlertCount,
    DateTime? lastSyncedAt,
  }) {
    return HomepageLoaded(
      branchName: branchName ?? this.branchName,
      currentTime: currentTime ?? this.currentTime,
      crisAlertCount: crisAlertCount ?? this.crisAlertCount,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}

final class HomepageError extends HomepageState {
  final String message;
  const HomepageError(this.message);
}