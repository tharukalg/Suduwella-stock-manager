part of 'cris_bloc.dart';

@immutable
sealed class CrisEvent {}

class CrisInitialLoadEvent extends CrisEvent {}

// Search
class CrisSearchQueryChangedEvent extends CrisEvent {
  final String query;
  CrisSearchQueryChangedEvent(this.query);
}

class CrisSearchEvent extends CrisEvent {}

class CrisClearSearchEvent extends CrisEvent {}

// Filter
class CrisFilterChangedEvent extends CrisEvent {
  final CrisFilterType filter;
  CrisFilterChangedEvent(this.filter);
}

// Add new CRIS entry form
class CrisAddDNumberChangedEvent extends CrisEvent {
  final String value;
  CrisAddDNumberChangedEvent(this.value);
}

class CrisAddBNumberChangedEvent extends CrisEvent {
  final String value;
  CrisAddBNumberChangedEvent(this.value);
}

class CrisAddBalanceChangedEvent extends CrisEvent {
  final String value;
  CrisAddBalanceChangedEvent(this.value);
}

class CrisAddNicChangedEvent extends CrisEvent {
  final String value;
  CrisAddNicChangedEvent(this.value);
}

class CrisAddStatusChangedEvent extends CrisEvent {
  final CrisStatus status;
  CrisAddStatusChangedEvent(this.status);
}

class CrisSubmitNewEntryEvent extends CrisEvent {}