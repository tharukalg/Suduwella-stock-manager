import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suduwella_stock_manager/features/home/presentation/outgoingpage/views/tabs/shared/scan_field.dart';
import 'package:suduwella_stock_manager/features/home/presentation/outgoingpage/views/tabs/shared/step_indicator.dart';
import '../../../blocs/outgoing_bloc.dart';
import '../../../../../../../core/widgets/app_widgets.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../shared/form_widgets.dart';
import 'bottom_bar.dart';
import 'branch_code_picker.dart';


class ProductPage extends StatefulWidget {
  final NewSaleFormState form;
  final VoidCallback onNext;

  const ProductPage({
    super.key,
    required this.form,
    required this.onNext,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _modelNoCtrl = TextEditingController();
  final _serialNoCtrl = TextEditingController();
  final _productNameCtrl = TextEditingController();

  final _modelNoFocus = FocusNode();
  final _serialNoFocus = FocusNode();

  static const _branchCodes = ['KH', 'KL', 'JK', 'KK', 'HH', 'LL'];
  String _selectedBranch = 'KH';

  @override
  void initState() {
    super.initState();
    _modelNoCtrl.text = widget.form.modelNo;
    _serialNoCtrl.text = widget.form.serialNo;
    _productNameCtrl.text = widget.form.productName;

    final existing = widget.form.blNumber;
    for (final code in _branchCodes) {
      if (existing.startsWith(code)) {
        _selectedBranch = code;
        break;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _modelNoFocus.requestFocus();
    });
  }

  @override
  void didUpdateWidget(ProductPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.form.productName != oldWidget.form.productName) {
      _productNameCtrl.text = widget.form.productName;
    }
  }

  @override
  void dispose() {
    _modelNoCtrl.dispose();
    _serialNoCtrl.dispose();
    _productNameCtrl.dispose();
    _modelNoFocus.dispose();
    _serialNoFocus.dispose();
    super.dispose();
  }

  bool get _canProceed =>
      _modelNoCtrl.text.trim().isNotEmpty &&
          _serialNoCtrl.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OutgoingBloc>();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          const StepIndicator(current: 0),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionCard(
                    title: 'Product Details',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ── Model No ──────────────────────────────────────
                        const FieldLabel('MODEL NO'),
                        const SizedBox(height: 6),
                        ScanField(
                          controller: _modelNoCtrl,
                          focusNode: _modelNoFocus,
                          hint: 'Scan or enter',
                          onChanged: (v) {
                            bloc.add(ModelNoChangedEvent(v));
                            setState(() {});
                          },
                          onSubmitted: (_) {
                            // Jump to serial no — ScanField will hide keyboard
                            _serialNoFocus.requestFocus();
                          },
                        ),
                        const SizedBox(height: 14),

                        // ── Serial No ─────────────────────────────────────
                        const FieldLabel('SN (SERIAL NUMBER)'),
                        const SizedBox(height: 6),
                        ScanField(
                          controller: _serialNoCtrl,
                          focusNode: _serialNoFocus,
                          hint: 'Scan or enter',
                          onChanged: (v) {
                            bloc.add(SerialNoChangedEvent(v));
                            setState(() {});
                          },
                          onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        ),
                        const SizedBox(height: 14),

                        // ── Product Name + B/L Number ─────────────────────
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FieldLabel('PRODUCT NAME'),
                                  const SizedBox(height: 6),
                                  AppTextField(
                                    controller: _productNameCtrl,
                                    readOnly: true,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FieldLabel('B/L NUMBER'),
                                  const SizedBox(height: 6),
                                  BranchCodePicker(
                                    codes: _branchCodes,
                                    selected: _selectedBranch,
                                    onChanged: (code) {
                                      setState(() => _selectedBranch = code);
                                      bloc.add(BLNumberChangedEvent('$code-'));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Tip banner ─────────────────────────────────────────
                  const _ScanTip(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Bottom Next button ─────────────────────────────────────────
          BottomBar(
            child: AppButton(
              label: 'Next — Customer & Payment',
              isFullWidth: true,
              trailingIcon: Icons.arrow_forward_rounded,
              onPressed: _canProceed ? widget.onNext : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Scan tip banner ────────────────────────────────────────────────────────────

class _ScanTip extends StatelessWidget {
  const _ScanTip();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? cs.primary.withOpacity(0.1)
            : cs.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.barcode_reader, color: cs.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Scan the product barcode to auto-fill Model No and Serial Number. '
                  'Tap a field to type manually, or just scan — no tap needed.',
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 12,
                color: cs.primary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}