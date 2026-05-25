part of 'homepage_bloc.dart';

@immutable
sealed class HomepageEvent {}

class HomepageInitializeEvent extends HomepageEvent {}

class HomepageRefreshEvent extends HomepageEvent {}

class HomepageTickEvent extends HomepageEvent {
  final DateTime now;
  HomepageTickEvent(this.now);
}