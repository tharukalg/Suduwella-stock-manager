import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/outgoing_bloc.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/app_widgets.dart';
import '../shared/form_widgets.dart';

class PlanAdjustmentPage extends StatefulWidget {
  final EasyPaymentFormState form;
  const PlanAdjustmentPage({super.key, required this.form});

  @override
  State<PlanAdjustmentPage> createState() => _PlanAdjustmentPageState();
}

class _PlanAdjustmentPageState extends State<PlanAdjustmentPage> {
  late final TextEditingController _installmentCtrl;
  late final TextEditingController _monthsCtrl;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _installmentCtrl = TextEditingController(
      text: widget.form.monthlyInstallment > 0
          ? widget.form.monthlyInstallment.toStringAsFixed(0)
          : '',
    );
    _monthsCtrl = TextEditingController(
      text: widget.form.remainingMonths > 0
          ? widget.form.remainingMonths.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _installmentCtrl.dispose();
    _monthsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OutgoingBloc>();
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionCard(
                    title: 'Plan Adjustment',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Remaining months
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FieldLabel('REMAINING MONTHS'),
                                  const SizedBox(height: 8),
                                  _PlanField(
                                    controller: _monthsCtrl,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (v) => bloc.add(
                                      EasyPaymentRemainingMonthsChangedEvent(
                                          int.tryParse(v) ?? 0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Monthly installment
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FieldLabel('MONTHLY\nINSTALLMENT (LKR)'),
                                  const SizedBox(height: 8),
                                  _PlanField(
                                    controller: _installmentCtrl,
                                    keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}')),
                                    ],
                                    onChanged: (v) => bloc.add(
                                      EasyPaymentInstallmentChangedEvent(
                                          double.tryParse(v) ?? 0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bill summary reference
                  if (widget.form.bill != null)
                    _BillSummaryCard(bill: widget.form.bill!),
                ],
              ),
            ),
          ),

          // ── Bottom bar ───────────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              12 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: isDark ? cs.surfaceContainerHigh : Colors.white,
              border: Border(
                  top: BorderSide(color: cs.onSurface.withOpacity(0.08))),
            ),
            child: Row(
              children: [
                // Back
                SizedBox(
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => bloc.add(EasyPaymentSearchEvent()),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Back'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.primary,
                      side: BorderSide(
                          color: cs.primary.withOpacity(0.4)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(
                        fontFamily: AppTheme.primaryFont,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Update Plan
                Expanded(
                  child: AppButton(
                    label: 'Update Plan',
                    isLoading: _isUpdating,
                    isFullWidth: true,
                    onPressed: _isUpdating
                        ? null
                        : () {
                      setState(() => _isUpdating = true);
                      bloc.add(EasyPaymentUpdatePlanEvent());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Plan Input Field ──────────────────────────────────────────────────────────
// Styled to match the UI screenshot — larger text, light background

class _PlanField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String> onChanged;

  const _PlanField({
    required this.controller,
    required this.keyboardType,
    required this.inputFormatters,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? cs.surfaceContainerHighest
            : AppTheme.brandPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.onSurface.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        style: TextStyle(
          fontFamily: AppTheme.primaryFont,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}

// ── Bill Summary Reference Card ───────────────────────────────────────────────

class _BillSummaryCard extends StatelessWidget {
  final EasyPaymentBillDetails bill;
  const _BillSummaryCard({required this.bill});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BILL REFERENCE',
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
              color: cs.onSurface.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 10),
          _RefRow(
            label: 'Bill No.',
            value: bill.billNumber,
          ),
          const SizedBox(height: 6),
          _RefRow(
            label: 'Current Balance',
            value: 'Rs. ${bill.currentBalance.toStringAsFixed(0)}',
            highlight: true,
          ),
          const SizedBox(height: 6),
          _RefRow(
            label: 'Total Paid',
            value: 'Rs. ${bill.totalPaid.toStringAsFixed(0)}',
          ),
        ],
      ),
    );
  }
}

class _RefRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _RefRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 13,
              color: cs.onSurface.withOpacity(0.6),
            )),
        Text(value,
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 13,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
              color: highlight ? cs.primary : cs.onSurface,
            )),
      ],
    );
  }
}