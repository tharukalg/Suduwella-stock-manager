import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/locator.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_widgets.dart';
import '../../outgoingpage/views/tabs/shared/form_widgets.dart';
import '../../outgoingpage/views/tabs/shared/scan_field.dart';
import '../blocs/stock_bloc.dart';

class StockPage extends StatelessWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StockBloc>()..add(StockInitialLoadEvent()),
      child: const _StockView(),
    );
  }
}

class _StockView extends StatelessWidget {
  const _StockView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StockBloc, StockState>(
      // Only re-run listener when justSubmittedMessage actually changes
      listenWhen: (prev, curr) =>
      curr is StockLoaded && curr.justSubmittedMessage != null,
      listener: (context, state) {
        if (state is StockLoaded && state.justSubmittedMessage != null) {
          // Close the bottom sheet first, then show the snackbar on the page
          Navigator.of(context, rootNavigator: true).popUntil((route) {
            return route.isFirst || route is! ModalBottomSheetRoute;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.justSubmittedMessage!,
                style: const TextStyle(fontFamily: AppTheme.primaryFont),
              ),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      buildWhen: (prev, curr) => curr is StockLoaded,
      builder: (context, state) {
        if (state is! StockLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _StockScaffold(state: state);
      },
    );
  }
}

// ── Main Scaffold ─────────────────────────────────────────────────────────────

class _StockScaffold extends StatelessWidget {
  final StockLoaded state;
  const _StockScaffold({required this.state});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? cs.surface : const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _StockHeader(state: state)),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: state.filteredItems.isEmpty
                        ? SliverToBoxAdapter(
                        child: _EmptyState(query: state.searchQuery))
                        : SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (ctx, i) => _StockCard(
                          item: state.filteredItems[i],
                          branch: state.activeBranch,
                        ),
                        childCount: state.filteredItems.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _IncomingStockCard(form: state.incomingForm),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _StockHeader extends StatefulWidget {
  final StockLoaded state;
  const _StockHeader({required this.state});

  @override
  State<_StockHeader> createState() => _StockHeaderState();
}

class _StockHeaderState extends State<_StockHeader> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.state.searchQuery);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StockBloc>();
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Stock',
            style: TextStyle(
              fontFamily: AppTheme.secondaryFont,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Real-time quantitative analysis of operational\ninventory across physical branch locations.',
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 12,
              color: cs.onSurface.withOpacity(0.5),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? cs.surfaceContainerHigh
                  : const Color(0xFFECEFF4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: _ctrl,
              onChanged: (v) => bloc.add(StockSearchQueryChangedEvent(v)),
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 14,
                color: cs.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Scan or type , Model Name...',
                hintStyle: TextStyle(
                  fontFamily: AppTheme.primaryFont,
                  fontSize: 14,
                  color: cs.onSurface.withOpacity(0.35),
                ),
                prefixIcon: Icon(Icons.search_rounded,
                    size: 20, color: cs.onSurface.withOpacity(0.45)),
                suffixIcon: widget.state.searchQuery.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.close_rounded,
                      size: 18,
                      color: cs.onSurface.withOpacity(0.4)),
                  onPressed: () {
                    _ctrl.clear();
                    bloc.add(StockSearchQueryChangedEvent(''));
                  },
                )
                    : null,
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stock Card ────────────────────────────────────────────────────────────────

class _StockCard extends StatelessWidget {
  final StockItem item;
  final String branch;
  const _StockCard({required this.item, required this.branch});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final units = item.branchStock[branch] ?? 0;
    final isZero = units == 0;
    final borderColor =
    isZero ? const Color(0xFFE53E3E) : const Color(0xFF38A169);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _ProductThumbnail(
                        imagePath: item.imagePath, isZero: isZero),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: TextStyle(
                              fontFamily: AppTheme.primaryFont,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                          if (item.modelNo.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      color: cs.onSurface.withOpacity(0.35),
                                      shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'MODEL NO : ${item.modelNo}',
                                  style: TextStyle(
                                    fontFamily: AppTheme.primaryFont,
                                    fontSize: 11,
                                    color: cs.onSurface.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                    height: 20,
                    thickness: 1,
                    color: cs.onSurface.withOpacity(0.06)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$branch BRANCH',
                          style: TextStyle(
                            fontFamily: AppTheme.primaryFont,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: isZero
                                ? const Color(0xFFE53E3E)
                                : cs.onSurface.withOpacity(0.45),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              units.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontFamily: AppTheme.secondaryFont,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: isZero
                                    ? const Color(0xFFE53E3E)
                                    : cs.onSurface,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'UNITS',
                              style: TextStyle(
                                fontFamily: AppTheme.primaryFont,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                                color: isZero
                                    ? const Color(0xFFE53E3E).withOpacity(0.7)
                                    : cs.onSurface.withOpacity(0.45),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Product Thumbnail ─────────────────────────────────────────────────────────

class _ProductThumbnail extends StatelessWidget {
  final String? imagePath;
  final bool isZero;
  const _ProductThumbnail({this.imagePath, required this.isZero});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isZero
        ? const Color(0xFFE53E3E).withOpacity(0.06)
        : isDark
        ? cs.surfaceContainerHighest
        : const Color(0xFFECEFF4);

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: imagePath != null
          ? ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(imagePath!, fit: BoxFit.cover))
          : Icon(Icons.devices_other_rounded,
          size: 28,
          color: isZero
              ? const Color(0xFFE53E3E).withOpacity(0.4)
              : cs.onSurface.withOpacity(0.25)),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 52, color: cs.onSurface.withOpacity(0.2)),
            const SizedBox(height: 12),
            Text(
              query.isEmpty ? 'No stock items' : 'No results for "$query"',
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 14,
                color: cs.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Incoming Stock Bottom Card ────────────────────────────────────────────────

class _IncomingStockCard extends StatelessWidget {
  final IncomingStockForm form;
  const _IncomingStockCard({required this.form});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => BlocProvider.value(
          value: context.read<StockBloc>(),
          child: _IncomingStockSheet(form: form),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
            20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: AppTheme.brandPrimary,
          borderRadius:
          const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: AppTheme.brandPrimary.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, -4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle),
              child: const Icon(Icons.add_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Incoming Stock',
                    style: TextStyle(
                      fontFamily: AppTheme.primaryFont,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Log a new item or recovered unit',
                    style: TextStyle(
                        fontFamily: AppTheme.primaryFont,
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.72)),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_up_rounded,
                color: Colors.white.withOpacity(0.6), size: 28),
          ],
        ),
      ),
    );
  }
}

// ── Incoming Stock Sheet ──────────────────────────────────────────────────────

class _IncomingStockSheet extends StatelessWidget {
  final IncomingStockForm form;
  const _IncomingStockSheet({required this.form});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<StockBloc, StockState>(
      builder: (context, state) {
        final currentForm =
        state is StockLoaded ? state.incomingForm : form;

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
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        'Incoming Stock',
                        style: TextStyle(
                          fontFamily: AppTheme.secondaryFont,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded,
                            color: cs.onSurface.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _IncomingTabBar(active: currentForm.activeTab),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: currentForm.activeTab == IncomingStockTab.newItem
                        ? _NewItemForm(form: currentForm)
                        : _RecoveredItemForm(form: currentForm),
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

// ── Tab Bar ───────────────────────────────────────────────────────────────────

class _IncomingTabBar extends StatelessWidget {
  final IncomingStockTab active;
  const _IncomingTabBar({required this.active});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StockBloc>();
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color:
        isDark ? cs.surfaceContainerHighest : const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _TabChip(
            label: 'New Item',
            icon: Icons.add_box_outlined,
            isActive: active == IncomingStockTab.newItem,
            onTap: () =>
                bloc.add(IncomingTabChangedEvent(IncomingStockTab.newItem)),
          ),
          _TabChip(
            label: 'Recovered Item',
            icon: Icons.recycling_rounded,
            isActive: active == IncomingStockTab.recoveredItem,
            onTap: () => bloc.add(
                IncomingTabChangedEvent(IncomingStockTab.recoveredItem)),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  const _TabChip(
      {required this.label,
        required this.icon,
        required this.isActive,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? cs.surfaceContainerHigh : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isActive && !isDark
                ? [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 1))
            ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 15,
                  color: isActive
                      ? AppTheme.brandPrimary
                      : cs.onSurface.withOpacity(0.45)),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTheme.primaryFont,
                  fontSize: 13,
                  fontWeight:
                  isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppTheme.brandPrimary
                      : cs.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── New Item Form ─────────────────────────────────────────────────────────────

class _NewItemForm extends StatefulWidget {
  final IncomingStockForm form;
  const _NewItemForm({required this.form});

  @override
  State<_NewItemForm> createState() => _NewItemFormState();
}

class _NewItemFormState extends State<_NewItemForm> {
  late final TextEditingController _serialCtrl;
  late final TextEditingController _modelCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  final _serialFocus = FocusNode();
  final _modelFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _serialCtrl = TextEditingController(text: widget.form.newSerialNo);
    _modelCtrl = TextEditingController(text: widget.form.newModelNo);
    _nameCtrl = TextEditingController(text: widget.form.newProductName);
    _priceCtrl = TextEditingController(text: widget.form.newPrice);
  }

  @override
  void dispose() {
    _serialCtrl.dispose();
    _modelCtrl.dispose();
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _serialFocus.dispose();
    _modelFocus.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _serialCtrl.text.trim().isNotEmpty &&
          _modelCtrl.text.trim().isNotEmpty &&
          _nameCtrl.text.trim().isNotEmpty &&
          _priceCtrl.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StockBloc>();
    final isSubmitting = widget.form.newIsSubmitting;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoBanner(
          icon: Icons.add_box_outlined,
          message:
          'Register a brand new unit entering inventory for the first time.',
          color: AppTheme.brandPrimary,
        ),
        const SizedBox(height: 20),
        const FieldLabel('SERIAL NUMBER (SN)'),
        const SizedBox(height: 6),
        ScanField(
          controller: _serialCtrl,
          focusNode: _serialFocus,
          hint: 'Scan or enter serial number',
          onChanged: (v) {
            bloc.add(NewItemSerialNoChangedEvent(v));
            setState(() {});
          },
          onSubmitted: (_) => _modelFocus.requestFocus(),
        ),
        const SizedBox(height: 14),
        const FieldLabel('MODEL NO'),
        const SizedBox(height: 6),
        ScanField(
          controller: _modelCtrl,
          focusNode: _modelFocus,
          hint: 'Scan or enter model number',
          onChanged: (v) {
            bloc.add(NewItemModelNoChangedEvent(v));
            setState(() {});
          },
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
        ),
        const SizedBox(height: 14),
        const FieldLabel('PRODUCT NAME'),
        const SizedBox(height: 6),
        AppTextField(
          controller: _nameCtrl,
          hint: 'Enter product name',
          prefixIcon: Icons.inventory_2_outlined,
          onChanged: (v) {
            bloc.add(NewItemProductNameChangedEvent(v));
            setState(() {});
          },
        ),
        const SizedBox(height: 14),
        const FieldLabel('PRICE (LKR)'),
        const SizedBox(height: 6),
        AppTextField(
          controller: _priceCtrl,
          hint: 'Enter product price',
          prefixIcon: Icons.attach_money_rounded,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (v) {
            bloc.add(NewItemPriceChangedEvent(v));
            setState(() {});
          },
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: 'Add to Stock',
            isLoading: isSubmitting,
            isFullWidth: true,
            onPressed: (_canSubmit && !isSubmitting)
                ? () => bloc.add(SubmitNewItemEvent())
                : null,
          ),
        ),
      ],
    );
  }
}

// ── Recovered Item Form ───────────────────────────────────────────────────────

class _RecoveredItemForm extends StatefulWidget {
  final IncomingStockForm form;
  const _RecoveredItemForm({required this.form});

  @override
  State<_RecoveredItemForm> createState() => _RecoveredItemFormState();
}

class _RecoveredItemFormState extends State<_RecoveredItemForm> {
  late final TextEditingController _serialCtrl;
  late final TextEditingController _modelCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  final _serialFocus = FocusNode();
  final _modelFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _serialCtrl = TextEditingController(text: widget.form.recSerialNo);
    _modelCtrl = TextEditingController(text: widget.form.recModelNo);
    _nameCtrl = TextEditingController(text: widget.form.recProductName);
    _priceCtrl = TextEditingController(text: widget.form.recPrice);
  }

  @override
  void dispose() {
    _serialCtrl.dispose();
    _modelCtrl.dispose();
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _serialFocus.dispose();
    _modelFocus.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _serialCtrl.text.trim().isNotEmpty &&
          _modelCtrl.text.trim().isNotEmpty &&
          _nameCtrl.text.trim().isNotEmpty &&
          _priceCtrl.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StockBloc>();
    final isSubmitting = widget.form.recIsSubmitting;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoBanner(
          icon: Icons.recycling_rounded,
          message:
          'Log a unit that has been physically recovered from a customer and returned to stock.',
          color: Colors.orange.shade700,
        ),
        const SizedBox(height: 20),
        const FieldLabel('SERIAL NUMBER (SN)'),
        const SizedBox(height: 6),
        ScanField(
          controller: _serialCtrl,
          focusNode: _serialFocus,
          hint: 'Scan or enter serial number',
          onChanged: (v) {
            bloc.add(RecItemSerialNoChangedEvent(v));
            setState(() {});
          },
          onSubmitted: (_) => _modelFocus.requestFocus(),
        ),
        const SizedBox(height: 14),
        const FieldLabel('MODEL NO'),
        const SizedBox(height: 6),
        ScanField(
          controller: _modelCtrl,
          focusNode: _modelFocus,
          hint: 'Scan or enter model number',
          onChanged: (v) {
            bloc.add(RecItemModelNoChangedEvent(v));
            setState(() {});
          },
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
        ),
        const SizedBox(height: 14),
        const FieldLabel('PRODUCT NAME'),
        const SizedBox(height: 6),
        AppTextField(
          controller: _nameCtrl,
          hint: 'Enter product name',
          prefixIcon: Icons.inventory_2_outlined,
          onChanged: (v) {
            bloc.add(RecItemProductNameChangedEvent(v));
            setState(() {});
          },
        ),
        const SizedBox(height: 14),
        const FieldLabel('PRICE (LKR)'),
        const SizedBox(height: 6),
        AppTextField(
          controller: _priceCtrl,
          hint: 'Enter product price',
          prefixIcon: Icons.attach_money_rounded,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (v) {
            bloc.add(RecItemPriceChangedEvent(v));
            setState(() {});
          },
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: 'Log Recovered Item',
            isLoading: isSubmitting,
            isFullWidth: true,
            onPressed: (_canSubmit && !isSubmitting)
                ? () => bloc.add(SubmitRecoveredItemEvent())
                : null,
          ),
        ),
      ],
    );
  }
}

// ── Info Banner ───────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;
  const _InfoBanner(
      {required this.icon, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  fontFamily: AppTheme.primaryFont,
                  fontSize: 12,
                  color: color,
                  height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}