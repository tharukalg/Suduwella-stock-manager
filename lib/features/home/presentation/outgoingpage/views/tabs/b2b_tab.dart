import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/app_widgets.dart';
import '../../blocs/outgoing_bloc.dart';
import 'shared/form_widgets.dart';
import 'shared/scan_field.dart';

class B2BTab extends StatelessWidget {
  const B2BTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OutgoingBloc, OutgoingState, B2BFormState?>(
      selector: (s) => s is OutgoingLoaded ? s.b2b : null,
      builder: (context, form) {
        if (form == null) return const SizedBox.shrink();
        return _B2BForm(form: form);
      },
    );
  }
}

class _B2BForm extends StatefulWidget {
  final B2BFormState form;
  const _B2BForm({required this.form});

  @override
  State<_B2BForm> createState() => _B2BFormState();
}

class _B2BFormState extends State<_B2BForm> {
  late final TextEditingController _modelNoCtrl;
  late final TextEditingController _serialNoCtrl;
  late final TextEditingController _notesCtrl;

  final _modelNoFocus = FocusNode();
  final _serialNoFocus = FocusNode();

  static const _branches = ['KH', 'KL', 'JK', 'KK', 'HH', 'LL'];

  @override
  void initState() {
    super.initState();
    _modelNoCtrl = TextEditingController(text: widget.form.modelNo);
    _serialNoCtrl = TextEditingController(text: widget.form.serialNo);
    _notesCtrl = TextEditingController(text: widget.form.notes);
  }

  // Sync controllers when the bloc clears the fields after adding an item
  @override
  void didUpdateWidget(_B2BForm old) {
    super.didUpdateWidget(old);
    if (widget.form.modelNo != old.form.modelNo &&
        widget.form.modelNo.isEmpty) {
      _modelNoCtrl.clear();
    }
    if (widget.form.serialNo != old.form.serialNo &&
        widget.form.serialNo.isEmpty) {
      _serialNoCtrl.clear();
    }
    if (widget.form.notes != old.form.notes && widget.form.notes.isEmpty) {
      _notesCtrl.clear();
    }
  }

  @override
  void dispose() {
    _modelNoCtrl.dispose();
    _serialNoCtrl.dispose();
    _notesCtrl.dispose();
    _modelNoFocus.dispose();
    _serialNoFocus.dispose();
    super.dispose();
  }

  bool get _canAdd =>
      _modelNoCtrl.text.trim().isNotEmpty &&
          _serialNoCtrl.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OutgoingBloc>();
    final form = widget.form;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          // ── Scrollable body ──────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Business / Branch ──────────────────────────────────
                  SectionCard(
                    title: 'Business',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldLabel('SELECT DESTINATION BRANCH'),
                        const SizedBox(height: 8),
                        _BranchDropdown(
                          branches: _branches,
                          selected: form.destinationBranch,
                          onChanged: (b) =>
                              bloc.add(B2BDestinationBranchChangedEvent(b)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Item Details ───────────────────────────────────────
                  SectionCard(
                    title: 'Item Details',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Add button (top-right style like screenshot)
                        Align(
                          alignment: Alignment.centerRight,
                          child: _AddButton(
                            enabled: _canAdd,
                            onPressed: () {
                              if (!_canAdd) return;
                              FocusScope.of(context).unfocus();
                              bloc.add(B2BAddItemEvent());
                            },
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Model No
                        const FieldLabel('MODEL NO'),
                        const SizedBox(height: 6),
                        ScanField(
                          controller: _modelNoCtrl,
                          focusNode: _modelNoFocus,
                          hint: 'Scan or enter',
                          onChanged: (v) {
                            bloc.add(B2BModelNoChangedEvent(v));
                            setState(() {});
                          },
                          onSubmitted: (_) =>
                              _serialNoFocus.requestFocus(),
                        ),

                        const SizedBox(height: 14),

                        // Serial No
                        const FieldLabel('SERIAL NUMBER (SN)'),
                        const SizedBox(height: 6),
                        ScanField(
                          controller: _serialNoCtrl,
                          focusNode: _serialNoFocus,
                          hint: 'Scan or enter',
                          onChanged: (v) {
                            bloc.add(B2BSerialNoChangedEvent(v));
                            setState(() {});
                          },
                          onSubmitted: (_) =>
                              FocusScope.of(context).unfocus(),
                        ),

                        const SizedBox(height: 14),

                        // Notes
                        const FieldLabel('MAKE / ENTRY NOTES'),
                        const SizedBox(height: 6),
                        AppTextArea(
                          controller: _notesCtrl,
                          hint: 'Optional notes…',
                          minLines: 3,
                          maxLines: 5,
                          onChanged: (v) =>
                              bloc.add(B2BNotesChangedEvent(v)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Current Transfer (cart) ────────────────────────────
                  _CartSection(items: form.items),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Bottom confirm bar ─────────────────────────────────────────
          _ConfirmBar(form: form, bloc: bloc),
        ],
      ),
    );
  }
}

// ── Branch Dropdown ───────────────────────────────────────────────────────────

class _BranchDropdown extends StatelessWidget {
  final List<String> branches;
  final String selected;
  final ValueChanged<String> onChanged;

  const _BranchDropdown({
    required this.branches,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHighest : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.onSurface.withOpacity(0.12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected.isEmpty ? null : selected,
          hint: Text(
            'Select branch...',
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 14,
              color: cs.onSurface.withOpacity(0.4),
            ),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: cs.onSurface.withOpacity(0.5)),
          style: TextStyle(
            fontFamily: AppTheme.primaryFont,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
          dropdownColor:
          isDark ? cs.surfaceContainerHigh : Colors.white,
          borderRadius: BorderRadius.circular(12),
          items: branches
              .map((b) => DropdownMenuItem(
            value: b,
            child: Text(b),
          ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

// ── Add to Transfer List button ───────────────────────────────────────────────

class _AddButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _AddButton({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.45,
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('Add to Transfer List'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.brandPrimary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppTheme.brandPrimary,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          padding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontFamily: AppTheme.primaryFont,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// ── Cart Section ──────────────────────────────────────────────────────────────

class _CartSection extends StatelessWidget {
  final List<B2BCartItem> items;
  const _CartSection({required this.items});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
          // Header
          Padding(
            padding:
            const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Text(
                  'Current Transfer',
                  style: TextStyle(
                    fontFamily: AppTheme.secondaryFont,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: items.isEmpty
                        ? cs.onSurface.withOpacity(0.08)
                        : AppTheme.brandPrimary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${items.length} ${items.length == 1 ? 'ITEM' : 'ITEMS'}',
                    style: TextStyle(
                      fontFamily: AppTheme.primaryFont,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: items.isEmpty
                          ? cs.onSurface.withOpacity(0.45)
                          : AppTheme.brandPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Empty state
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 44,
                      color: cs.onSurface.withOpacity(0.2),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No items added yet',
                      style: TextStyle(
                        fontFamily: AppTheme.primaryFont,
                        fontSize: 13,
                        color: cs.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            Divider(
                height: 1,
                color: cs.onSurface.withOpacity(0.07)),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: cs.onSurface.withOpacity(0.07)),
              itemBuilder: (context, i) =>
                  _CartItemTile(item: items[i], index: i),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

// ── Cart Item Tile ────────────────────────────────────────────────────────────

class _CartItemTile extends StatelessWidget {
  final B2BCartItem item;
  final int index;

  const _CartItemTile({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OutgoingBloc>();
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Index badge
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppTheme.brandPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.brandPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Model No
                Text(
                  item.modelNo,
                  style: TextStyle(
                    fontFamily: AppTheme.primaryFont,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                // Serial No
                Row(
                  children: [
                    Icon(Icons.tag_rounded,
                        size: 12,
                        color: cs.onSurface.withOpacity(0.4)),
                    const SizedBox(width: 4),
                    Text(
                      item.serialNo,
                      style: TextStyle(
                        fontFamily: AppTheme.primaryFont,
                        fontSize: 12,
                        color: cs.onSurface.withOpacity(0.55),
                      ),
                    ),
                  ],
                ),
                if (item.notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.notes,
                    style: TextStyle(
                      fontFamily: AppTheme.primaryFont,
                      fontSize: 12,
                      color: cs.onSurface.withOpacity(0.45),
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Remove button
          IconButton(
            onPressed: () => bloc.add(B2BRemoveItemEvent(item.id)),
            icon: Icon(
              Icons.remove_circle_outline_rounded,
              color: cs.error.withOpacity(0.7),
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

// ── Bottom Confirm Bar ────────────────────────────────────────────────────────

class _ConfirmBar extends StatelessWidget {
  final B2BFormState form;
  final OutgoingBloc bloc;

  const _ConfirmBar({required this.form, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canSubmit = form.items.isNotEmpty &&
        form.destinationBranch.isNotEmpty &&
        !form.isSubmitting;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        border:
        Border(top: BorderSide(color: cs.onSurface.withOpacity(0.08))),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          )
        ],
      ),
      child: Row(
        children: [
          // Item count chip
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: form.items.isEmpty
                  ? cs.onSurface.withOpacity(0.06)
                  : AppTheme.brandPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${form.items.length} items',
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: form.items.isEmpty
                    ? cs.onSurface.withOpacity(0.4)
                    : AppTheme.brandPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppButton(
              label: 'Confirm B2B Transfer',
              isLoading: form.isSubmitting,
              isFullWidth: true,
              onPressed: canSubmit
                  ? () => bloc.add(SubmitB2BEvent())
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}