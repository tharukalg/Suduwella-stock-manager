import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

// ─── AppTextField ─────────────────────────────────────────────────────────────

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.color,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.textInputAction,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final bool showPasswordToggle;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  /// Accent color for border, label, and icons when focused.
  final Color? color;
  final String? errorText;
  final bool enabled;
  final bool readOnly;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final bool autofocus;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focus;
  late final AnimationController _ctrl;
  bool _obscure = false;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _focus = widget.focusNode ?? FocusNode();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!mounted) return;
    final focused = _focus.hasFocus;
    if (focused == _hasFocus) return;
    setState(() => _hasFocus = focused);
    focused ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focus.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  Color get _accent => widget.color ?? AppTheme.brandPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasError = widget.errorText != null;

    final borderColor = hasError
        ? theme.colorScheme.error
        : _hasFocus
            ? _accent
            : (isDark
                ? Colors.white.withOpacity(0.15)
                : Colors.black.withOpacity(0.12));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: widget.enabled
                ? (isDark ? const Color(0xFF1E1E2E) : Colors.white)
                : (isDark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.04)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: _hasFocus ? 2.0 : 1.5,
            ),
            boxShadow: (_hasFocus && widget.enabled)
                ? [
                    BoxShadow(
                      color: _accent.withOpacity(0.14),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focus,
            obscureText: _obscure,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            maxLength: widget.maxLength,
            textInputAction: widget.textInputAction,
            autofocus: widget.autofocus,
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 15,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              labelStyle: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 14,
                color: _hasFocus
                    ? _accent
                    : (isDark ? Colors.white54 : Colors.black45),
                fontWeight: FontWeight.w500,
              ),
              hintStyle: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 14,
                color: isDark
                    ? Colors.white.withOpacity(0.3)
                    : Colors.black.withOpacity(0.3),
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _hasFocus
                          ? _accent
                          : (isDark ? Colors.white38 : Colors.black38),
                      size: 20,
                    )
                  : null,
              suffixIcon: _buildSuffix(isDark),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              counterText: '',
              filled: false,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          _ErrorLabel(text: widget.errorText!, color: theme.colorScheme.error),
        ],
      ],
    );
  }

  Widget? _buildSuffix(bool isDark) {
    if (widget.showPasswordToggle) {
      return IconButton(
        icon: Icon(
          _obscure
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: isDark ? Colors.white38 : Colors.black38,
          size: 20,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
        splashRadius: 20,
      );
    }
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: _hasFocus
              ? _accent
              : (isDark ? Colors.white38 : Colors.black38),
          size: 20,
        ),
        onPressed: widget.onSuffixTap,
        splashRadius: 20,
      );
    }
    return null;
  }
}

// ─── AppTextArea ──────────────────────────────────────────────────────────────

class AppTextArea extends StatefulWidget {
  const AppTextArea({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.minLines = 3,
    this.maxLines = 6,
    this.maxLength,
    this.showCounter = false,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.color,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final bool showCounter;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final Color? color;
  final String? errorText;
  final bool enabled;
  final bool readOnly;

  @override
  State<AppTextArea> createState() => _AppTextAreaState();
}

class _AppTextAreaState extends State<AppTextArea>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focus;
  late final AnimationController _ctrl;
  int _charCount = 0;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focus = widget.focusNode ?? FocusNode();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _focus.addListener(_onFocusChange);
    if (widget.showCounter) {
      widget.controller?.addListener(_onTextChange);
    }
  }

  void _onFocusChange() {
    if (!mounted) return;
    final focused = _focus.hasFocus;
    if (focused == _hasFocus) return;
    setState(() => _hasFocus = focused);
    focused ? _ctrl.forward() : _ctrl.reverse();
  }

  void _onTextChange() {
    if (mounted) setState(() => _charCount = widget.controller!.text.length);
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focus.dispose();
    widget.controller?.removeListener(_onTextChange);
    _ctrl.dispose();
    super.dispose();
  }

  Color get _accent => widget.color ?? AppTheme.brandPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasError = widget.errorText != null;

    final borderColor = hasError
        ? theme.colorScheme.error
        : _hasFocus
            ? _accent
            : (isDark
                ? Colors.white.withOpacity(0.15)
                : Colors.black.withOpacity(0.12));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: widget.enabled
                ? (isDark ? const Color(0xFF1E1E2E) : Colors.white)
                : (isDark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.04)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: _hasFocus ? 2.0 : 1.5,
            ),
            boxShadow: (_hasFocus && widget.enabled)
                ? [
                    BoxShadow(
                      color: _accent.withOpacity(0.14),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              TextFormField(
                controller: widget.controller,
                focusNode: _focus,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                validator: widget.validator,
                onChanged: (v) {
                  widget.onChanged?.call(v);
                  if (widget.showCounter) {
                    setState(() => _charCount = v.length);
                  }
                },
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                style: TextStyle(
                  fontFamily: AppTheme.primaryFont,
                  fontSize: 15,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w500,
                  height: 1.55,
                ),
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hint,
                  labelStyle: TextStyle(
                    fontFamily: AppTheme.primaryFont,
                    fontSize: 14,
                    color: _hasFocus
                        ? _accent
                        : (isDark ? Colors.white54 : Colors.black45),
                    fontWeight: FontWeight.w500,
                  ),
                  hintStyle: TextStyle(
                    fontFamily: AppTheme.primaryFont,
                    fontSize: 14,
                    color: isDark
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.3),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    widget.showCounter && widget.maxLength != null ? 30 : 16,
                  ),
                  counterText: '',
                  filled: false,
                ),
              ),
              if (widget.showCounter && widget.maxLength != null)
                Positioned(
                  bottom: 8,
                  right: 14,
                  child: Text(
                    '$_charCount / ${widget.maxLength}',
                    style: TextStyle(
                      fontFamily: AppTheme.primaryFont,
                      fontSize: 11,
                      color: isDark
                          ? Colors.white.withOpacity(0.35)
                          : Colors.black.withOpacity(0.35),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          _ErrorLabel(text: widget.errorText!, color: theme.colorScheme.error),
        ],
      ],
    );
  }
}

// ─── AppButton ────────────────────────────────────────────────────────────────

enum AppButtonVariant { primary, outline, ghost }

enum AppButtonSize { small, medium, large }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.color,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.size = AppButtonSize.medium,
    this.borderRadius,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  /// Accent color — drives fill, border, text and icon colors depending on variant.
  final Color? color;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final AppButtonSize size;
  final double? borderRadius;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _press, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  Color get _accent => widget.color ?? AppTheme.brandPrimary;
  bool get _disabled => widget.onPressed == null || widget.isLoading;

  double get _height => switch (widget.size) {
        AppButtonSize.small => 40,
        AppButtonSize.medium => 52,
        AppButtonSize.large => 60,
      };

  double get _fontSize => switch (widget.size) {
        AppButtonSize.small => 13,
        AppButtonSize.medium => 15,
        AppButtonSize.large => 16,
      };

  double get _iconSize => switch (widget.size) {
        AppButtonSize.small => 16,
        AppButtonSize.medium => 18,
        AppButtonSize.large => 20,
      };

  EdgeInsets get _hPad => switch (widget.size) {
        AppButtonSize.small => const EdgeInsets.symmetric(horizontal: 16),
        AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: 28),
        AppButtonSize.large => const EdgeInsets.symmetric(horizontal: 36),
      };

  void _down(TapDownDetails _) => _press.forward();
  void _up(TapUpDetails _) => _press.reverse();
  void _cancel() => _press.reverse();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = widget.borderRadius ?? 14.0;

    Widget btn = ScaleTransition(
      scale: _scale,
      child: switch (widget.variant) {
        AppButtonVariant.primary => _primary(isDark, r),
        AppButtonVariant.outline => _outline(isDark, r),
        AppButtonVariant.ghost => _ghost(isDark, r),
      },
    );

    return widget.isFullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }

  Widget _primary(bool isDark, double r) {
    final off = _disabled;
    return GestureDetector(
      onTapDown: off ? null : _down,
      onTapUp: off ? null : _up,
      onTapCancel: off ? null : _cancel,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: off
                ? null
                : LinearGradient(
                    colors: [
                      _accent,
                      Color.lerp(_accent, Colors.black, 0.18)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            color: off
                ? (isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.08))
                : null,
            borderRadius: BorderRadius.circular(r),
            boxShadow: off
                ? null
                : [
                    BoxShadow(
                      color: _accent.withOpacity(0.38),
                      blurRadius: 16,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: InkWell(
            onTap: off ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(r),
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.08),
            child: _Content(
              label: widget.label,
              icon: widget.icon,
              trailingIcon: widget.trailingIcon,
              isLoading: widget.isLoading,
              height: _height,
              hPad: _hPad,
              fontSize: _fontSize,
              iconSize: _iconSize,
              textColor: off
                  ? (isDark
                      ? Colors.white.withOpacity(0.3)
                      : Colors.black.withOpacity(0.3))
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _outline(bool isDark, double r) {
    final off = _disabled;
    final fg = off
        ? (isDark
            ? Colors.white.withOpacity(0.2)
            : Colors.black.withOpacity(0.2))
        : _accent;

    return GestureDetector(
      onTapDown: off ? null : _down,
      onTapUp: off ? null : _up,
      onTapCancel: off ? null : _cancel,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: fg, width: 2),
            borderRadius: BorderRadius.circular(r),
          ),
          child: InkWell(
            onTap: off ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(r),
            splashColor: _accent.withOpacity(0.1),
            highlightColor: _accent.withOpacity(0.05),
            child: _Content(
              label: widget.label,
              icon: widget.icon,
              trailingIcon: widget.trailingIcon,
              isLoading: widget.isLoading,
              height: _height,
              hPad: _hPad,
              fontSize: _fontSize,
              iconSize: _iconSize,
              textColor: fg,
            ),
          ),
        ),
      ),
    );
  }

  Widget _ghost(bool isDark, double r) {
    final off = _disabled;
    final fg = off
        ? (isDark
            ? Colors.white.withOpacity(0.2)
            : Colors.black.withOpacity(0.2))
        : _accent;

    return GestureDetector(
      onTapDown: off ? null : _down,
      onTapUp: off ? null : _up,
      onTapCancel: off ? null : _cancel,
      child: InkWell(
        onTap: off ? null : widget.onPressed,
        borderRadius: BorderRadius.circular(r),
        splashColor: _accent.withOpacity(0.1),
        highlightColor: _accent.withOpacity(0.05),
        child: _Content(
          label: widget.label,
          icon: widget.icon,
          trailingIcon: widget.trailingIcon,
          isLoading: widget.isLoading,
          height: _height,
          hPad: _hPad,
          fontSize: _fontSize,
          iconSize: _iconSize,
          textColor: fg,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.label,
    required this.isLoading,
    required this.height,
    required this.hPad,
    required this.fontSize,
    required this.iconSize,
    required this.textColor,
    this.icon,
    this.trailingIcon,
  });

  final String label;
  final bool isLoading;
  final double height;
  final EdgeInsets hPad;
  final double fontSize;
  final double iconSize;
  final Color textColor;
  final IconData? icon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: hPad,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              ),
              const SizedBox(width: 10),
            ] else if (icon != null) ...[
              Icon(icon, color: textColor, size: iconSize),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTheme.secondaryFont,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: 0.2,
              ),
            ),
            if (!isLoading && trailingIcon != null) ...[
              const SizedBox(width: 8),
              Icon(trailingIcon, color: textColor, size: iconSize),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── AppDropdown ──────────────────────────────────────────────────────────────

class AppDropdownItem<T> {
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.isDisabled = false,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool isDisabled;
}

class AppDropdown<T> extends StatefulWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.label,
    this.hint,
    this.prefixIcon,
    this.color,
    this.errorText,
    this.enabled = true,
    this.maxDropdownHeight = 220.0,
    this.searchable = false,
  });

  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?> onChanged;
  final T? value;

  /// Shown as floating label when value is selected, as placeholder when not.
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Color? color;
  final String? errorText;
  final bool enabled;
  final double maxDropdownHeight;
  final bool searchable;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlay;
  final _link = LayerLink();
  bool _isOpen = false;
  bool _showAbove = false;
  late final AnimationController _ctrl;
  late final Animation<double> _sizeAnim;
  late final Animation<double> _fadeAnim;
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 160),
    );
    _sizeAnim = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _overlay?.remove();
    _overlay = null;
    _ctrl.dispose();
    _search.dispose();
    super.dispose();
  }

  Color get _accent => widget.color ?? AppTheme.brandPrimary;

  AppDropdownItem<T>? get _selected {
    if (widget.value == null) return null;
    try {
      return widget.items.firstWhere((e) => e.value == widget.value);
    } catch (_) {
      return null;
    }
  }

  void _toggle() {
    if (!widget.enabled) return;
    _isOpen ? _close() : _open();
  }

  void _open() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final size = box.size;
    final pos = box.localToGlobal(Offset.zero);
    final screenH = MediaQuery.of(context).size.height;
    _showAbove = (screenH - pos.dy - size.height) < widget.maxDropdownHeight + 12 &&
        pos.dy > (screenH - pos.dy - size.height);
    _search.clear();
    _overlay = _buildOverlay(size);
    Overlay.of(context).insert(_overlay!);
    setState(() => _isOpen = true);
    _ctrl.forward();
  }

  Future<void> _close() async {
    if (!_isOpen) return;
    await _ctrl.reverse();
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() => _isOpen = false);
  }

  OverlayEntry _buildOverlay(Size triggerSize) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final above = _showAbove;
    return OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _close,
            ),
          ),
          CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            targetAnchor: above ? Alignment.topLeft : Alignment.bottomLeft,
            followerAnchor: above ? Alignment.bottomLeft : Alignment.topLeft,
            offset: Offset(0, above ? -6 : 6),
            child: Material(
              color: Colors.transparent,
              child: RepaintBoundary(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SizeTransition(
                    sizeFactor: _sizeAnim,
                    axisAlignment: above ? 1.0 : -1.0,
                    child: _DropdownPanel<T>(
                      items: widget.items,
                      selectedValue: widget.value,
                      accentColor: _accent,
                      isDark: isDark,
                      width: triggerSize.width,
                      maxHeight: widget.maxDropdownHeight,
                      searchable: widget.searchable,
                      searchCtrl: _search,
                      onSelect: (item) {
                        _close();
                        widget.onChanged(item.value);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasError = widget.errorText != null;
    final sel = _selected;

    final borderColor = hasError
        ? theme.colorScheme.error
        : _isOpen
            ? _accent
            : (isDark
                ? Colors.white.withOpacity(0.15)
                : Colors.black.withOpacity(0.12));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CompositedTransformTarget(
          link: _link,
          child: GestureDetector(
            onTap: _toggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 56,
              decoration: BoxDecoration(
                color: widget.enabled
                    ? (isDark ? const Color(0xFF1E1E2E) : Colors.white)
                    : (isDark
                        ? Colors.white.withOpacity(0.04)
                        : Colors.black.withOpacity(0.04)),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: borderColor,
                  width: _isOpen ? 2.0 : 1.5,
                ),
                boxShadow: (_isOpen && widget.enabled)
                    ? [
                        BoxShadow(
                          color: _accent.withOpacity(0.14),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.prefixIcon != null ? 12 : 16,
                ),
                child: Row(
                  children: [
                    if (widget.prefixIcon != null) ...[
                      Icon(
                        widget.prefixIcon,
                        color: _isOpen
                            ? _accent
                            : (isDark ? Colors.white38 : Colors.black38),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: sel != null
                          ? Row(
                              children: [
                                if (sel.icon != null) ...[
                                  Icon(sel.icon, color: _accent, size: 18),
                                  const SizedBox(width: 8),
                                ],
                                Expanded(
                                  child: Text(
                                    sel.label,
                                    style: TextStyle(
                                      fontFamily: AppTheme.primaryFont,
                                      fontSize: 15,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF1A1A2E),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              widget.hint ?? widget.label ?? 'Select an option',
                              style: TextStyle(
                                fontFamily: AppTheme.primaryFont,
                                fontSize: 14,
                                color: isDark
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.black.withOpacity(0.35),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                    const SizedBox(width: 6),
                    AnimatedRotation(
                      turns: _isOpen ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: _isOpen
                            ? _accent
                            : (isDark ? Colors.white54 : Colors.black54),
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          _ErrorLabel(text: widget.errorText!, color: theme.colorScheme.error),
        ],
      ],
    );
  }
}

// ─── Dropdown internals ───────────────────────────────────────────────────────

class _DropdownPanel<T> extends StatefulWidget {
  const _DropdownPanel({
    required this.items,
    required this.selectedValue,
    required this.accentColor,
    required this.isDark,
    required this.width,
    required this.maxHeight,
    required this.searchable,
    required this.searchCtrl,
    required this.onSelect,
  });

  final List<AppDropdownItem<T>> items;
  final T? selectedValue;
  final Color accentColor;
  final bool isDark;
  final double width;
  final double maxHeight;
  final bool searchable;
  final TextEditingController searchCtrl;
  final void Function(AppDropdownItem<T>) onSelect;

  @override
  State<_DropdownPanel<T>> createState() => _DropdownPanelState<T>();
}

class _DropdownPanelState<T> extends State<_DropdownPanel<T>> {
  late List<AppDropdownItem<T>> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    if (widget.searchable) widget.searchCtrl.addListener(_filter);
  }

  @override
  void dispose() {
    if (widget.searchable) widget.searchCtrl.removeListener(_filter);
    super.dispose();
  }

  void _filter() {
    final q = widget.searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.items
          : widget.items.where((e) => e.label.toLowerCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.08),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(widget.isDark ? 0.45 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.searchable) _buildSearch(),
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 6),
                shrinkWrap: true,
                itemCount: _filtered.isEmpty ? 1 : _filtered.length,
                itemBuilder: (_, i) {
                  if (_filtered.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'No results',
                          style: TextStyle(
                            fontFamily: AppTheme.primaryFont,
                            fontSize: 13,
                            color: widget.isDark
                                ? Colors.white38
                                : Colors.black38,
                          ),
                        ),
                      ),
                    );
                  }
                  final item = _filtered[i];
                  return _DropdownTile<T>(
                    item: item,
                    isSelected: item.value == widget.selectedValue,
                    accentColor: widget.accentColor,
                    isDark: widget.isDark,
                    onTap: widget.onSelect,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
      child: TextField(
        controller: widget.searchCtrl,
        autofocus: true,
        style: TextStyle(
          fontFamily: AppTheme.primaryFont,
          fontSize: 14,
          color: widget.isDark ? Colors.white : const Color(0xFF1A1A2E),
        ),
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(
            fontFamily: AppTheme.primaryFont,
            fontSize: 14,
            color: widget.isDark
                ? Colors.white.withOpacity(0.3)
                : Colors.black.withOpacity(0.3),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: widget.isDark ? Colors.white38 : Colors.black38,
            size: 18,
          ),
          filled: true,
          fillColor: widget.isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          isDense: true,
        ),
      ),
    );
  }
}

class _DropdownTile<T> extends StatelessWidget {
  const _DropdownTile({
    required this.item,
    required this.isSelected,
    required this.accentColor,
    required this.isDark,
    required this.onTap,
  });

  final AppDropdownItem<T> item;
  final bool isSelected;
  final Color accentColor;
  final bool isDark;
  final void Function(AppDropdownItem<T>) onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = item.isDisabled
        ? (isDark
            ? Colors.white.withOpacity(0.25)
            : Colors.black.withOpacity(0.25))
        : isSelected
            ? accentColor
            : (isDark ? Colors.white : const Color(0xFF1A1A2E));

    return InkWell(
      onTap: item.isDisabled ? null : () => onTap(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: isSelected
            ? accentColor.withOpacity(0.08)
            : Colors.transparent,
        child: Row(
          children: [
            if (item.icon != null) ...[
              Icon(item.icon, color: textColor, size: 18),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontFamily: AppTheme.primaryFont,
                  fontSize: 14,
                  color: textColor,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, color: accentColor, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Shared ───────────────────────────────────────────────────────────────────

class _ErrorLabel extends StatelessWidget {
  const _ErrorLabel({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: color, size: 14),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}