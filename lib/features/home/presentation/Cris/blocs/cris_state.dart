part of 'cris_bloc.dart';

enum CrisFilterType { all, overdue, review }

enum CrisRecordStatus { overdue, review, settled }

// ── CRIS Record ───────────────────────────────────────────────────────────────

class CrisRecord {
  final String dNumber;      // e.g. 200035402367
  final String bNumber;      // e.g. B Number: 88402
  final double balance;
  final CrisRecordStatus status;

  const CrisRecord({
    required this.dNumber,
    required this.bNumber,
    required this.balance,
    required this.status,
  });
}

// ── Search Result ─────────────────────────────────────────────────────────────

class CrisSearchResult {
  final String idNumber;
  final String name;
  final List<CrisRecord> records;

  const CrisSearchResult({
    required this.idNumber,
    required this.name,
    required this.records,
  });
}

// ── Add Form State ────────────────────────────────────────────────────────────

class CrisAddForm {
  final String dNumber;
  final String bNumber;
  final String balance;
  final String nic;
  final CrisStatus status;
  final bool isSubmitting;

  const CrisAddForm({
    this.dNumber = '',
    this.bNumber = '',
    this.balance = '',
    this.nic = '',
    this.status = CrisStatus.overdue,
    this.isSubmitting = false,
  });

  bool get canSubmit =>
      dNumber.trim().isNotEmpty &&
      bNumber.trim().isNotEmpty &&
      balance.trim().isNotEmpty;

  CrisAddForm copyWith({
    String? dNumber,
    String? bNumber,
    String? balance,
    String? nic,
    CrisStatus? status,
    bool? isSubmitting,
  }) =>
      CrisAddForm(
        dNumber: dNumber ?? this.dNumber,
        bNumber: bNumber ?? this.bNumber,
        balance: balance ?? this.balance,
        nic: nic ?? this.nic,
        status: status ?? this.status,
        isSubmitting: isSubmitting ?? this.isSubmitting,
      );
}

// ── Root States ───────────────────────────────────────────────────────────────

@immutable
sealed class CrisState {}

final class CrisInitial extends CrisState {}

final class CrisLoaded extends CrisState {
  final String searchQuery;
  final bool isSearching;
  final CrisSearchResult? searchResult;
  final bool searchNotFound;
  final List<CrisRecord> manifest;
  final CrisFilterType activeFilter;
  final CrisAddForm addForm;
  final String? justSubmittedMessage;

  List<CrisRecord> get filteredManifest => switch (activeFilter) {
    CrisFilterType.overdue =>
        manifest.where((r) => r.status == CrisRecordStatus.overdue).toList(),
    CrisFilterType.review =>
        manifest.where((r) => r.status == CrisRecordStatus.review).toList(),
    CrisFilterType.all => manifest,
  };

   CrisLoaded({
    this.searchQuery = '',
    this.isSearching = false,
    this.searchResult,
    this.searchNotFound = false,
    this.manifest = const [],
    this.activeFilter = CrisFilterType.all,
    this.addForm = const CrisAddForm(),
    this.justSubmittedMessage,
  });

  CrisLoaded copyWith({
    String? searchQuery,
    bool? isSearching,
    CrisSearchResult? searchResult,
    bool? searchNotFound,
    List<CrisRecord>? manifest,
    CrisFilterType? activeFilter,
    CrisAddForm? addForm,
    String? justSubmittedMessage,
    bool clearSearchResult = false,
  }) {
    return CrisLoaded(
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      searchResult: clearSearchResult ? null : searchResult ?? this.searchResult,
      searchNotFound: searchNotFound ?? this.searchNotFound,
      manifest: manifest ?? this.manifest,
      activeFilter: activeFilter ?? this.activeFilter,
      addForm: addForm ?? this.addForm,
      justSubmittedMessage: justSubmittedMessage,
    );
  }
}