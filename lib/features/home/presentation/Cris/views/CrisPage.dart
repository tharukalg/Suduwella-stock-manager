import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/daos/cris_dao.dart';
import '../../../../../core/di/locator.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_widgets.dart';
import '../blocs/cris_bloc.dart';
import '../../outgoingpage/views/tabs/shared/form_widgets.dart';

class CrisPage extends StatelessWidget {
  const CrisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CrisBloc>()..add(CrisInitialLoadEvent()),
      child: const _CrisView(),
    );
  }
}

class _CrisView extends StatelessWidget {
  const _CrisView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CrisBloc, CrisState>(
      listenWhen: (_, curr) =>
          curr is CrisLoaded && curr.justSubmittedMessage != null,
      listener: (context, state) {
        if (state is CrisLoaded && state.justSubmittedMessage != null) {
          Navigator.of(context, rootNavigator: true)
              .popUntil((r) => r.isFirst || r is! ModalBottomSheetRoute);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.justSubmittedMessage!,
                style: const TextStyle(fontFamily: AppTheme.primaryFont)),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 3),
          ));
        }
      },
      buildWhen: (_, curr) => curr is CrisLoaded,
      builder: (context, state) {
        if (state is! CrisLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _CrisScaffold(state: state);
      },
    );
  }
}

void _openAddSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<CrisBloc>(),
      child: const _AddCrisSheet(),
    ),
  );
}

class _CrisScaffold extends StatelessWidget {
  final CrisLoaded state;
  const _CrisScaffold({required this.state});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? cs.surface : const Color(0xFFF5F5F7),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // ── Header ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: _CrisHeader(state: state),
                ),

                // ── Search section ─────────────────────────────────────
                SliverToBoxAdapter(
                  child: _SearchSection(state: state),
                ),

                // ── Search result (if any) ─────────────────────────────
                if (state.searchResult != null)
                  SliverToBoxAdapter(
                    child: _SearchResultCard(result: state.searchResult!),
                  ),

                // ── Active Debt Manifest ───────────────────────────────
                SliverToBoxAdapter(
                  child: _ManifestSection(state: state),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),

          // ── Create New CRIS Entry bottom card ──────────────────────
          const _CreateCrisCard(),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _CrisHeader extends StatelessWidget {
  final CrisLoaded state;
  const _CrisHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? cs.surface : Colors.white,
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Text(
                'CRIS',
                style: TextStyle(
                  fontFamily: AppTheme.secondaryFont,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              const Spacer(),
              // Add to CRIS button
              ElevatedButton.icon(
                onPressed: () => _openAddSheet(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add to CRIS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:  AppTheme.brandPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(
                    fontFamily: AppTheme.primaryFont,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Live indicator
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'LIVE SYSTEM ACCESS • ALERT STATE',
                style: TextStyle(
                  fontFamily: AppTheme.primaryFont,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: cs.onSurface.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Search Section ────────────────────────────────────────────────────────────

class _SearchSection extends StatefulWidget {
  final CrisLoaded state;
  const _SearchSection({required this.state});

  @override
  State<_SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<_SearchSection> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.state.searchQuery);
  }

  @override
  void didUpdateWidget(_SearchSection old) {
    super.didUpdateWidget(old);
    if (widget.state.searchQuery.isEmpty &&
        old.state.searchQuery.isNotEmpty) {
      _ctrl.clear();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CrisBloc>();
    final state = widget.state;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(Icons.manage_search_rounded,
                    size: 16, color: cs.onSurface.withOpacity(0.5)),
                const SizedBox(width: 6),
                Text(
                  'SEARCH BY ID NUMBER',
                  style: TextStyle(
                    fontFamily: AppTheme.primaryFont,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: cs.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? cs.surfaceContainerHighest
                    : const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _ctrl,
                onChanged: (v) =>
                    bloc.add(CrisSearchQueryChangedEvent(v)),
                onSubmitted: (_) => bloc.add(CrisSearchEvent()),
                textInputAction: TextInputAction.search,
                style: TextStyle(
                  fontFamily: AppTheme.primaryFont,
                  fontSize: 14,
                  color: cs.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. 200023212V',
                  hintStyle: TextStyle(
                    fontFamily: AppTheme.primaryFont,
                    fontSize: 14,
                    color: cs.onSurface.withOpacity(0.35),
                  ),
                  prefixIcon: Icon(
                    Icons.tag_rounded,
                    size: 18,
                    color: cs.onSurface.withOpacity(0.4),
                  ),
                  suffixIcon: state.searchQuery.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.close_rounded,
                        size: 18,
                        color: cs.onSurface.withOpacity(0.4)),
                    onPressed: () =>
                        bloc.add(CrisClearSearchEvent()),
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Search button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: state.isSearching
                    ? null
                    : () => bloc.add(CrisSearchEvent()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandPrimary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                  const Color(0xFF1A1A2E).withOpacity(0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: state.isSearching
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Search',
                      style: TextStyle(
                        fontFamily: AppTheme.primaryFont,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded,
                        size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Search Result Card ────────────────────────────────────────────────────────

class _SearchResultCard extends StatelessWidget {
  final CrisSearchResult result;
  const _SearchResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withOpacity(0.2)),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.person_outline_rounded,
                color: cs.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.name,
                  style: TextStyle(
                    fontFamily: AppTheme.primaryFont,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  result.idNumber,
                  style: TextStyle(
                    fontFamily: AppTheme.primaryFont,
                    fontSize: 12,
                    color: cs.onSurface.withOpacity(0.55),
                  ),
                ),
              ],
            ),
          ),
          // Record count badge
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: cs.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${result.records.length} records',
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cs.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Active Debt Manifest Section ──────────────────────────────────────────────

class _ManifestSection extends StatelessWidget {
  final CrisLoaded state;
  const _ManifestSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CrisBloc>();
    final cs = Theme.of(context).colorScheme;
    final records = state.filteredManifest;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Debt Manifest',
                      style: TextStyle(
                        fontFamily: AppTheme.secondaryFont,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Showing most recent unsettled records',
                      style: TextStyle(
                        fontFamily: AppTheme.primaryFont,
                        fontSize: 11,
                        color: cs.onSurface.withOpacity(0.45),
                      ),
                    ),
                  ],
                ),
              ),
              // Filter button
              _FilterButton(
                current: state.activeFilter,
                onChanged: (f) =>
                    bloc.add(CrisFilterChangedEvent(f)),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Records list
          if (records.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'No records match this filter',
                  style: TextStyle(
                    fontFamily: AppTheme.primaryFont,
                    fontSize: 13,
                    color: cs.onSurface.withOpacity(0.4),
                  ),
                ),
              ),
            )
          else
            ...records.map((r) => _ManifestCard(record: r)),
        ],
      ),
    );
  }
}

// ── Filter Button ─────────────────────────────────────────────────────────────

class _FilterButton extends StatelessWidget {
  final CrisFilterType current;
  final ValueChanged<CrisFilterType> onChanged;

  const _FilterButton({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _showFilterSheet(context),
      child: Row(
        children: [
          Icon(Icons.filter_list_rounded,
              size: 16, color: cs.onSurface.withOpacity(0.6)),
          const SizedBox(width: 4),
          Text(
            'FILTER',
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: cs.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.onSurface.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Filter Records',
                  style: TextStyle(
                    fontFamily: AppTheme.secondaryFont,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                for (final f in CrisFilterType.values)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      _filterIcon(f),
                      color: current == f
                          ? cs.primary
                          : cs.onSurface.withOpacity(0.5),
                    ),
                    title: Text(
                      _filterLabel(f),
                      style: TextStyle(
                        fontFamily: AppTheme.primaryFont,
                        fontWeight: current == f
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: current == f
                            ? cs.primary
                            : cs.onSurface,
                      ),
                    ),
                    trailing: current == f
                        ? Icon(Icons.check_rounded, color: cs.primary)
                        : null,
                    onTap: () {
                      Navigator.pop(ctx);
                      onChanged(f);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _filterLabel(CrisFilterType f) => switch (f) {
    CrisFilterType.all => 'All Records',
    CrisFilterType.overdue => 'Overdue Only',
    CrisFilterType.review => 'Under Review',
  };

  IconData _filterIcon(CrisFilterType f) => switch (f) {
    CrisFilterType.all => Icons.list_rounded,
    CrisFilterType.overdue => Icons.warning_amber_rounded,
    CrisFilterType.review => Icons.rate_review_rounded,
  };
}

// ── Manifest Card ─────────────────────────────────────────────────────────────

class _ManifestCard extends StatelessWidget {
  final CrisRecord record;
  const _ManifestCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isOverdue = record.status == CrisRecordStatus.overdue;
    final statusColor =
    isOverdue ? const Color(0xFFE53E3E) : const Color(0xFFD97706);
    final statusLabel = isOverdue ? 'OVERDUE' : 'REVIEW';
    final statusIcon =
    isOverdue ? Icons.warning_amber_rounded : Icons.rate_review_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: statusColor, width: 4),
        ),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // D-Number
                      Text(
                        record.dNumber,
                        style: TextStyle(
                          fontFamily: AppTheme.primaryFont,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface.withOpacity(0.7),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // B-Number
                      Text(
                        'B Number: ${record.bNumber}',
                        style: TextStyle(
                          fontFamily: AppTheme.primaryFont,
                          fontSize: 11,
                          color: cs.onSurface.withOpacity(0.45),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Balance
                      Text(
                        '\$${_formatAmount(record.balance)}',
                        style: TextStyle(
                          fontFamily: AppTheme.secondaryFont,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 13, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontFamily: AppTheme.primaryFont,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    final formatted = amount.toStringAsFixed(2);
    final parts = formatted.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
    );
    return '$intPart.${parts[1]}';
  }
}

// ── Create New CRIS Entry Card ────────────────────────────────────────────────

class _CreateCrisCard extends StatelessWidget {
  const _CreateCrisCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openAddSheet(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          20,
          18,
          20,
          18 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFCC2936),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          children: [
            // Plus icon circle
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Create New CRIS Entry',
                    style: TextStyle(
                      fontFamily: AppTheme.primaryFont,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Initiate immediate lock protocol for new D-Number.',
                    style: TextStyle(
                      fontFamily: AppTheme.primaryFont,
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.75),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Decorative icon
            Icon(
              Icons.lock_outline_rounded,
              color: Colors.white.withOpacity(0.3),
              size: 36,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Add CRIS Entry Sheet ──────────────────────────────────────────────────────

class _AddCrisSheet extends StatefulWidget {
  const _AddCrisSheet();

  @override
  State<_AddCrisSheet> createState() => _AddCrisSheetState();
}

class _AddCrisSheetState extends State<_AddCrisSheet> {
  late final TextEditingController _dNumberCtrl;
  late final TextEditingController _bNumberCtrl;
  late final TextEditingController _balanceCtrl;
  late final TextEditingController _nicCtrl;

  @override
  void initState() {
    super.initState();
    _dNumberCtrl = TextEditingController();
    _bNumberCtrl = TextEditingController();
    _balanceCtrl = TextEditingController();
    _nicCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _dNumberCtrl.dispose();
    _bNumberCtrl.dispose();
    _balanceCtrl.dispose();
    _nicCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CrisBloc, CrisState>(
      builder: (context, state) {
        final form =
            state is CrisLoaded ? state.addForm : const CrisAddForm();
        final bloc = context.read<CrisBloc>();

        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? cs.surfaceContainerHigh : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.onSurface.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCC2936).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add_alert_rounded,
                            color: Color(0xFFCC2936), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'New CRIS Entry',
                          style: TextStyle(
                            fontFamily: AppTheme.secondaryFont,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded,
                            color: cs.onSurface.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldLabel('D NUMBER'),
                        const SizedBox(height: 6),
                        AppTextField(
                          controller: _dNumberCtrl,
                          hint: 'e.g. 200035402367',
                          prefixIcon: Icons.tag_rounded,
                          onChanged: (v) =>
                              bloc.add(CrisAddDNumberChangedEvent(v)),
                        ),
                        const SizedBox(height: 14),
                        const FieldLabel('B NUMBER'),
                        const SizedBox(height: 6),
                        AppTextField(
                          controller: _bNumberCtrl,
                          hint: 'e.g. 88402',
                          prefixIcon: Icons.numbers_rounded,
                          onChanged: (v) =>
                              bloc.add(CrisAddBNumberChangedEvent(v)),
                        ),
                        const SizedBox(height: 14),
                        const FieldLabel('OUTSTANDING BALANCE (LKR)'),
                        const SizedBox(height: 6),
                        AppTextField(
                          controller: _balanceCtrl,
                          hint: '0.00',
                          prefixIcon: Icons.currency_rupee_rounded,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          onChanged: (v) =>
                              bloc.add(CrisAddBalanceChangedEvent(v)),
                        ),
                        const SizedBox(height: 14),
                        const FieldLabel('CUSTOMER NIC (OPTIONAL)'),
                        const SizedBox(height: 6),
                        AppTextField(
                          controller: _nicCtrl,
                          hint: 'Link to existing customer',
                          prefixIcon: Icons.person_outline_rounded,
                          onChanged: (v) =>
                              bloc.add(CrisAddNicChangedEvent(v)),
                        ),
                        const SizedBox(height: 14),
                        const FieldLabel('STATUS'),
                        const SizedBox(height: 8),
                        _StatusPicker(
                          selected: form.status,
                          onChanged: (s) =>
                              bloc.add(CrisAddStatusChangedEvent(s)),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            label: 'Add to CRIS',
                            isLoading: form.isSubmitting,
                            isFullWidth: true,
                            color: const Color(0xFFCC2936),
                            onPressed:
                                (form.canSubmit && !form.isSubmitting)
                                    ? () =>
                                        bloc.add(CrisSubmitNewEntryEvent())
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Status Picker ─────────────────────────────────────────────────────────────

class _StatusPicker extends StatelessWidget {
  final CrisStatus selected;
  final ValueChanged<CrisStatus> onChanged;

  const _StatusPicker({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatusChip(
          label: 'Overdue',
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFE53E3E),
          isSelected: selected == CrisStatus.overdue,
          onTap: () => onChanged(CrisStatus.overdue),
        ),
        const SizedBox(width: 10),
        _StatusChip(
          label: 'Under Review',
          icon: Icons.rate_review_rounded,
          color: const Color(0xFFD97706),
          isSelected: selected == CrisStatus.review,
          onTap: () => onChanged(CrisStatus.review),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: isSelected ? color : color.withOpacity(0.5)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : color.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}