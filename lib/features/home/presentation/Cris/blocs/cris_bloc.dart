import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/database/daos/cris_dao.dart';
import '../../../../../core/database/daos/customer_dao.dart';

part 'cris_event.dart';
part 'cris_state.dart';

class CrisBloc extends Bloc<CrisEvent, CrisState> {
  final CrisDao _crisDao;
  final CustomerDao _customerDao;

  CrisBloc({
    required CrisDao crisDao,
    required CustomerDao customerDao,
  })  : _crisDao = crisDao,
        _customerDao = customerDao,
        super(CrisInitial()) {
    on<CrisInitialLoadEvent>(_onInitialLoad);
    on<CrisSearchQueryChangedEvent>(_onSearchQueryChanged);
    on<CrisSearchEvent>(_onSearch);
    on<CrisClearSearchEvent>(_onClearSearch);
    on<CrisFilterChangedEvent>(_onFilterChanged);
    on<CrisAddDNumberChangedEvent>(_onAddDNumberChanged);
    on<CrisAddBNumberChangedEvent>(_onAddBNumberChanged);
    on<CrisAddBalanceChangedEvent>(_onAddBalanceChanged);
    on<CrisAddNicChangedEvent>(_onAddNicChanged);
    on<CrisAddStatusChangedEvent>(_onAddStatusChanged);
    on<CrisSubmitNewEntryEvent>(_onSubmitNewEntry);
  }

  CrisLoaded get _loaded =>
      state is CrisLoaded ? state as CrisLoaded : CrisLoaded();

  // Converts a DAO model to the BLoC state type.
  CrisRecord _toRecord(CrisRecordModel m) => CrisRecord(
        dNumber: m.dNumber,
        bNumber: m.bNumber,
        balance: m.balance,
        status: switch (m.status) {
          CrisStatus.overdue => CrisRecordStatus.overdue,
          CrisStatus.review => CrisRecordStatus.review,
          CrisStatus.settled => CrisRecordStatus.settled,
        },
      );

  Future<void> _onInitialLoad(
      CrisInitialLoadEvent e, Emitter<CrisState> emit) async {
    final models = await _crisDao.getAll();
    emit(CrisLoaded(manifest: models.map(_toRecord).toList()));
  }

  void _onSearchQueryChanged(
      CrisSearchQueryChangedEvent e, Emitter<CrisState> emit) {
    emit(_loaded.copyWith(
      searchQuery: e.query,
      searchNotFound: false,
      clearSearchResult: true,
    ));
  }

  Future<void> _onSearch(
      CrisSearchEvent e, Emitter<CrisState> emit) async {
    final query = _loaded.searchQuery.trim();
    if (query.isEmpty) return;

    emit(_loaded.copyWith(isSearching: true, clearSearchResult: true));

    // Look up customer by NIC then return all their CRIS records.
    final customer = await _customerDao.getByNic(query);
    if (customer == null) {
      emit(_loaded.copyWith(
        isSearching: false,
        searchNotFound: true,
        clearSearchResult: true,
      ));
      return;
    }

    final records = await _crisDao.getByCustomer(customer.id);
    emit(_loaded.copyWith(
      isSearching: false,
      searchResult: CrisSearchResult(
        idNumber: customer.nic,
        name: customer.name,
        records: records.map(_toRecord).toList(),
      ),
    ));
  }

  void _onClearSearch(CrisClearSearchEvent e, Emitter<CrisState> emit) {
    emit(_loaded.copyWith(
      searchQuery: '',
      clearSearchResult: true,
      searchNotFound: false,
    ));
  }

  void _onFilterChanged(CrisFilterChangedEvent e, Emitter<CrisState> emit) {
    emit(_loaded.copyWith(activeFilter: e.filter));
  }

  // ── Add new CRIS entry ────────────────────────────────────────────────────

  void _onAddDNumberChanged(
          CrisAddDNumberChangedEvent e, Emitter<CrisState> emit) =>
      emit(_loaded.copyWith(
          addForm: _loaded.addForm.copyWith(dNumber: e.value)));

  void _onAddBNumberChanged(
          CrisAddBNumberChangedEvent e, Emitter<CrisState> emit) =>
      emit(_loaded.copyWith(
          addForm: _loaded.addForm.copyWith(bNumber: e.value)));

  void _onAddBalanceChanged(
          CrisAddBalanceChangedEvent e, Emitter<CrisState> emit) =>
      emit(_loaded.copyWith(
          addForm: _loaded.addForm.copyWith(balance: e.value)));

  void _onAddNicChanged(
          CrisAddNicChangedEvent e, Emitter<CrisState> emit) =>
      emit(_loaded.copyWith(
          addForm: _loaded.addForm.copyWith(nic: e.value)));

  void _onAddStatusChanged(
          CrisAddStatusChangedEvent e, Emitter<CrisState> emit) =>
      emit(_loaded.copyWith(
          addForm: _loaded.addForm.copyWith(status: e.status)));

  Future<void> _onSubmitNewEntry(
      CrisSubmitNewEntryEvent e, Emitter<CrisState> emit) async {
    final form = _loaded.addForm;
    emit(_loaded.copyWith(addForm: form.copyWith(isSubmitting: true)));

    try {
      // Optionally link to a customer by NIC.
      String? customerId;
      if (form.nic.trim().isNotEmpty) {
        final customer = await _customerDao.getByNic(form.nic.trim());
        customerId = customer?.id;
      }

      final record = CrisRecordModel.create(
        dNumber: form.dNumber.trim(),
        bNumber: form.bNumber.trim(),
        balance: double.tryParse(form.balance.trim()) ?? 0,
        customerId: customerId,
        status: form.status,
      );
      await _crisDao.insert(record);

      final updated = await _crisDao.getAll();
      emit(_loaded.copyWith(
        manifest: updated.map(_toRecord).toList(),
        addForm: const CrisAddForm(),
        justSubmittedMessage: 'CRIS entry added',
      ));
    } catch (_) {
      emit(_loaded.copyWith(addForm: form.copyWith(isSubmitting: false)));
    }
  }
}