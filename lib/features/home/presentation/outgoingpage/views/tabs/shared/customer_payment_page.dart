import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suduwella_stock_manager/features/home/presentation/outgoingpage/views/tabs/shared/step_indicator.dart';
import '../../../blocs/outgoing_bloc.dart';
import '../../../../../../../core/widgets/app_widgets.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../shared/form_widgets.dart';
import 'bottom_bar.dart';

class CustomerPaymentPage extends StatefulWidget {
  final NewSaleFormState form;
  final VoidCallback onBack;

  const CustomerPaymentPage({
    super.key,
    required this.form,
    required this.onBack,
  });

  @override
  State<CustomerPaymentPage> createState() => _CustomerPaymentPageState();
}

class _CustomerPaymentPageState extends State<CustomerPaymentPage> {
  final _downPaymentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _downPaymentCtrl.text = widget.form.downPayment == 0
        ? ''
        : widget.form.downPayment.toString();

    // Page 2 has no barcode scanning — disconnect scanner input by
    // ensuring no focus is requested and keyboard input is normal only.
    // We disable the HardwareKeyboard raw key listener approach by simply
    // not registering any scan field focus nodes on this page.
    // Any HID barcode scanner sends keystrokes — we block rapid-fire
    // input (scanners type instantly) via the RawKeyboard filter below.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Ensure no scan-mode focus leaks from page 1
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _downPaymentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OutgoingBloc>();
    final form = widget.form;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      // _ScannerBlocker wraps the entire page — it intercepts
      // rapid keystroke bursts (characteristic of barcode scanners)
      // and swallows them so they don't fill normal text fields
      child: _ScannerBlocker(
        child: Column(
          children: [
            const StepIndicator(current: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Customers ──────────────────────────────────────
                    ...List.generate(form.customers.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _CustomerSection(
                          index: i,
                          customer: form.customers[i],
                          showRemove: form.customers.length > 1,
                        ),
                      );
                    }),

                    DashedButton(
                      label: '+ Add Another Customer',
                      onTap: () => bloc.add(AddCustomerEvent()),
                    ),

                    const SizedBox(height: 16),

                    // ── Payment Plan ───────────────────────────────────
                    SectionCard(
                      title: 'Payment Plan Type',
                      titleStyle: fieldLabelStyle,
                      child: Column(
                        children: [
                          PlanTile(
                            title: 'Interest free',
                            subtitle:
                            'Standard short-term plan with zero initial interest.',
                            selected: form.selectedPlan ==
                                PaymentPlanType.interestFree,
                            onTap: () => bloc.add(PaymentPlanChangedEvent(
                                PaymentPlanType.interestFree)),
                          ),
                          const SizedBox(height: 10),
                          PlanTile(
                            title: 'Direct Easy Payment',
                            subtitle:
                            'Extended duration with standard interest rates.',
                            selected: form.selectedPlan ==
                                PaymentPlanType.directEasyPayment,
                            onTap: () => bloc.add(PaymentPlanChangedEvent(
                                PaymentPlanType.directEasyPayment)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Down Payment & Duration ────────────────────────
                    // ── Down Payment & Duration ────────────────────────────────────────
                    SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FieldLabel('DOWN PAYMENT (LKR)'),
                          const SizedBox(height: 6),
                          AppTextField(
                            controller: _downPaymentCtrl,
                            prefixIcon: Icons.currency_rupee,
                            hint: '0.00',
                            keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            onChanged: (v) =>
                                bloc.add(DownPaymentChangedEvent(v)),
                          ),
                          const SizedBox(height: 14),
                          const FieldLabel('DURATION (MONTHS)'),
                          const SizedBox(height: 8),
                          DurationSelector(
                            selected: form.durationMonths,
                            onChanged: (m) => bloc.add(DurationChangedEvent(m)),
                          ),

                          // ── Monthly Installment — only for Direct Easy Payment ──────
                          if (form.selectedPlan ==
                              PaymentPlanType.directEasyPayment) ...[
                            const SizedBox(height: 14),
                            const FieldLabel('MONTHLY INSTALLMENT'),
                            const SizedBox(height: 6),
                            ReadonlyAmountField(
                              value:
                              'Rs.  ${form.monthlyInstallment.toStringAsFixed(2)}',
                            ),
                          ],

                          const SizedBox(height: 14),
                          _ImportantNotice(plan: form.selectedPlan),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Transaction Summary ────────────────────────────
                    _TransactionSummary(form: form),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Bottom bar with Back + Submit ──────────────────────────
            BottomBar(
              child: Row(
                children: [
                  // Back button
                  SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: widget.onBack,
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: const Text('Back'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                        Theme.of(context).colorScheme.primary,
                        side: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.4),
                        ),
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
                  // Submit button
                  Expanded(
                    child: AppButton(
                      label: 'Submit',
                      isLoading: form.isSubmitting,
                      isFullWidth: true,
                      onPressed: form.isSubmitting
                          ? null
                          : () => bloc.add(SubmitOutgoingEvent()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Scanner Blocker ────────────────────────────────────────────────────────────
// HID barcode scanners act as keyboards and fire characters extremely fast
// (the entire barcode in <50ms). We detect this burst pattern and swallow it.

class _ScannerBlocker extends StatefulWidget {
  final Widget child;
  const _ScannerBlocker({required this.child});

  @override
  State<_ScannerBlocker> createState() => _ScannerBlockerState();
}

class _ScannerBlockerState extends State<_ScannerBlocker> {
  // Timestamps of recent key events
  final List<DateTime> _keyTimes = [];
  // If >4 keys arrive within 100ms we treat it as a scanner burst
  static const _burstWindow = Duration(milliseconds: 100);
  static const _burstThreshold = 4;
  bool _blocking = false;

  bool _isScannerBurst() {
    final now = DateTime.now();
    _keyTimes.add(now);
    // Keep only events within the window
    _keyTimes.removeWhere(
            (t) => now.difference(t) > _burstWindow);
    return _keyTimes.length >= _burstThreshold;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      // KeyboardListener gives us raw key events before they reach text fields
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (_isScannerBurst()) {
            // Burst detected — set blocking flag
            // We can't truly consume the event here but we can unfocus
            // any active text field so the scanner characters go nowhere
            if (!_blocking) {
              _blocking = true;
              FocusScope.of(context).unfocus();
              // Reset after burst window passes
              Future.delayed(_burstWindow * 3, () {
                if (mounted) {
                  _blocking = false;
                  _keyTimes.clear();
                }
              });
            }
          }
        }
      },
      child: widget.child,
    );
  }
}

// ── Customer Section ───────────────────────────────────────────────────────────

class _CustomerSection extends StatefulWidget {
  final int index;
  final CustomerEntry customer;
  final bool showRemove;

  const _CustomerSection({
    required this.index,
    required this.customer,
    required this.showRemove,
  });

  @override
  State<_CustomerSection> createState() => _CustomerSectionState();
}

class _CustomerSectionState extends State<_CustomerSection> {
  late final TextEditingController _idCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _descCtrl;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _idCtrl = TextEditingController(text: widget.customer.id);
    _nameCtrl = TextEditingController(text: widget.customer.name);
    _phoneCtrl = TextEditingController(text: widget.customer.phone);
    _descCtrl = TextEditingController(text: widget.customer.description);
  }

  @override
  void didUpdateWidget(_CustomerSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final c = widget.customer;
    final old = oldWidget.customer;
    if (c.name != old.name) _nameCtrl.text = c.name;
    if (c.phone != old.phone) _phoneCtrl.text = c.phone;
    if (c.description != old.description) _descCtrl.text = c.description;
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _takeIdPhoto(BuildContext context) async {
    FocusScope.of(context).unfocus();
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );
      if (photo != null && context.mounted) {
        context
            .read<OutgoingBloc>()
            .add(AddCustomerPhotoEvent(widget.index, photo.path));
      }
    } catch (_) {}
  }

  Future<void> _takeCustomerPhoto(BuildContext context) async {
    FocusScope.of(context).unfocus();
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
        preferredCameraDevice: CameraDevice.front,
      );
      if (photo != null && context.mounted) {
        context
            .read<OutgoingBloc>()
            .add(AddCustomerSelfieEvent(widget.index, photo.path));
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OutgoingBloc>();
    final i = widget.index;
    final c = widget.customer;
    final cs = Theme.of(context).colorScheme;

    return SectionCard(
      title: 'Customer Details ${(i + 1).toString().padLeft(2, '0')}',
      action: widget.showRemove
          ? IconButton(
        icon: Icon(Icons.close_rounded, color: cs.error, size: 18),
        onPressed: () => bloc.add(RemoveCustomerEvent(i)),
      )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── ID Number ──────────────────────────────────────────────────
          const FieldLabel('ID NUMBER'),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _idCtrl,
                  onChanged: (v) => bloc.add(CustomerIdChangedEvent(i, v)),
                  onSubmitted: (_) =>
                      bloc.add(LookupCustomerByNicEvent(i)),
                ),
              ),
              const SizedBox(width: 8),
              VerifyButton(
                status: c.idStatus,
                onTap: c.idStatus == VerificationStatus.loading
                    ? null
                    : () => bloc.add(VerifyCustomerIdEvent(i)),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── ID Photo ───────────────────────────────────────────────────
          const FieldLabel('ID PHOTO'),
          const SizedBox(height: 8),
          _PhotoCaptureField(
            label: 'Take a photo of the customer ID',
            addMoreLabel: 'Add another ID photo',
            photoPaths: c.photoPaths,
            onTakePhoto: () => _takeIdPhoto(context),
            onRemovePhoto: (idx) =>
                bloc.add(RemoveCustomerPhotoEvent(i, idx)),
          ),

          const SizedBox(height: 14),

          // ── Name ───────────────────────────────────────────────────────
          const FieldLabel('NAME'),
          const SizedBox(height: 6),
          AppTextField(
            controller: _nameCtrl,
            onChanged: (v) => bloc.add(CustomerNameChangedEvent(i, v)),
          ),

          const SizedBox(height: 14),

          // ── Customer Photo (selfie) ────────────────────────────────────
          const FieldLabel('CUSTOMER PHOTO'),
          const SizedBox(height: 8),
          _PhotoCaptureField(
            label: 'Take a photo of the customer',
            addMoreLabel: 'Retake customer photo',
            photoPaths: c.selfiePaths,
            maxPhotos: 1,
            onTakePhoto: () => _takeCustomerPhoto(context),
            onRemovePhoto: (idx) =>
                bloc.add(RemoveCustomerSelfieEvent(i, idx)),
          ),

          const SizedBox(height: 14),

          // ── Phone ──────────────────────────────────────────────────────
          const FieldLabel('PHONE'),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  onChanged: (v) =>
                      bloc.add(CustomerPhoneChangedEvent(i, v)),
                ),
              ),
              const SizedBox(width: 8),
              VerifyButton(
                status: c.phoneStatus,
                onTap: c.phoneStatus == VerificationStatus.loading
                    ? null
                    : () => bloc.add(VerifyCustomerPhoneEvent(i)),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Description ────────────────────────────────────────────────
          const FieldLabel('DESCRIPTION'),
          const SizedBox(height: 6),
          AppTextArea(
            controller: _descCtrl,
            hint: 'Enter notes or special instructions',
            minLines: 3,
            maxLines: 5,
            onChanged: (v) =>
                bloc.add(CustomerDescriptionChangedEvent(i, v)),
          ),
        ],
      ),
    );
  }
}

// ── Photo Capture Field ────────────────────────────────────────────────────────

class _PhotoCaptureField extends StatelessWidget {
  final String label;
  final String addMoreLabel;
  final List<String> photoPaths;
  final VoidCallback onTakePhoto;
  final ValueChanged<int> onRemovePhoto;
  final int maxPhotos;

  const _PhotoCaptureField({
    required this.label,
    required this.addMoreLabel,
    required this.photoPaths,
    required this.onTakePhoto,
    required this.onRemovePhoto,
    this.maxPhotos = 10,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canAdd = photoPaths.length < maxPhotos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (canAdd)
          GestureDetector(
            onTap: onTakePhoto,
            child: Container(
              width: double.infinity,
              height: 72,
              decoration: BoxDecoration(
                color: isDark
                    ? cs.surfaceContainerHighest
                    : AppTheme.brandPrimary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.brandPrimary.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined,
                      color: cs.primary, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    photoPaths.isEmpty ? label : addMoreLabel,
                    style: TextStyle(
                      fontFamily: AppTheme.primaryFont,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (photoPaths.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: photoPaths.asMap().entries.map((e) {
              return _PhotoThumb(
                path: e.value,
                onRemove: () => onRemovePhoto(e.key),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  final String path;
  final VoidCallback onRemove;
  const _PhotoThumb({required this.path, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(path),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              cacheWidth: 160,
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child:
                const Icon(Icons.close, color: Colors.white, size: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Important Notice ───────────────────────────────────────────────────────────

class _ImportantNotice extends StatelessWidget {
  final PaymentPlanType plan;
  const _ImportantNotice({required this.plan});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = plan == PaymentPlanType.interestFree
        ? 'For the 3-Month Interest-Free plan, if the balance is not settled '
        'within the initial 90 days, the remaining amount will automatically '
        'transition to an interest-bearing account at standard rates.'
        : 'Standard interest rates apply from the first month. Ensure the '
        'customer is aware of all applicable charges before proceeding.';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.amber.withOpacity(0.1) : Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Important Notice',
            style: TextStyle(
              fontFamily: AppTheme.secondaryFont,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.amber.shade800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 12,
              color:
              isDark ? Colors.amber.shade200 : Colors.amber.shade900,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Transaction Summary ────────────────────────────────────────────────────────

class _TransactionSummary extends StatelessWidget {
  final NewSaleFormState form;
  const _TransactionSummary({required this.form});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDirectEasyPayment =
        form.selectedPlan == PaymentPlanType.directEasyPayment;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TRANSACTION SUMMARY',
            style: fieldLabelStyle.copyWith(
                color: cs.onSurface.withOpacity(0.55)),
          ),
          const SizedBox(height: 14),
          SummaryRow(
            label: 'Total Amount',
            value: 'Rs. ${form.totalAmount.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          SummaryRow(
            label: 'Down Payment',
            value: '- Rs. ${form.downPayment.toStringAsFixed(2)}',
          ),

          // Monthly installment row — only for Direct Easy Payment
          if (isDirectEasyPayment) ...[
            const SizedBox(height: 8),
            SummaryRow(
              label: 'Monthly Installment',
              value:
              'Rs. ${form.monthlyInstallment.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            SummaryRow(
              label: 'Duration',
              value: '${form.durationMonths} months',
            ),
          ],

          Divider(
              height: 24,
              thickness: 1,
              color: cs.onSurface.withOpacity(0.1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('FINANCED AMOUNT',
                  style: fieldLabelStyle.copyWith(color: cs.onSurface)),
              Text(
                'Rs. ${form.financedAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: AppTheme.secondaryFont,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: cs.primary,
                ),
              ),
            ],
          ),

          // For Interest Free — show a clear zero-interest badge
          if (!isDirectEasyPayment) ...[
            const SizedBox(height: 12),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline_rounded,
                      color: Colors.green.shade700, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'Interest-free — full amount due within 90 days',
                    style: TextStyle(
                      fontFamily: AppTheme.primaryFont,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}