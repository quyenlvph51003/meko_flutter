import 'package:flutter/material.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:pinput/pinput.dart';

class AppInputOtp extends StatelessWidget {
  const AppInputOtp({
    super.key,
    this.length = 6,
    this.controller,
    this.focusNode,
    this.onCompleted,
    this.onChanged,
    this.validator,
    this.autofocus = true,
    this.obscureText = false,
  });

  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool autofocus;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final Color cMain = AppColor.cMain;
    final isDark = theme.brightness == Brightness.dark;

    const double wEmpty = 46, hEmpty = 54;
    const double wFilled = 52, hFilled = 60;
    const double wFocus = 56, hFocus = 64;

    final borderRadius = BorderRadius.circular(12);

    final defaultPin = PinTheme(
      width: wEmpty,
      height: hEmpty,
      textStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: borderRadius,
      ),
    );

    final submittedPin = defaultPin.copyWith(
      width: wFilled,
      height: hFilled,
      textStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: isDark ? Colors.white : Colors.black87,
      ),
      decoration: BoxDecoration(
        color: Color.alphaBlend(cMain.withOpacity(0.10), cs.surface),
        borderRadius: borderRadius,
      ),
    );

    final focusedPin = submittedPin.copyWith(
      width: wFocus,
      height: hFocus,
      decoration: BoxDecoration(
        color: Color.alphaBlend(cMain.withOpacity(0.14), cs.surfaceContainerHigh),
        borderRadius: borderRadius,
        border: Border.all(color: cMain, width: 1.5),
      ),
    );

    final errorPin = submittedPin.copyWith(
      decoration: BoxDecoration(
        color: Color.alphaBlend(cs.error.withOpacity(0.10), cs.surface),
        borderRadius: borderRadius,
        border: Border.all(color: cs.error, width: 1.5),
      ),
    );

    return Pinput(
      length: length,
      controller: controller,
      focusNode: focusNode,
      defaultPinTheme: defaultPin,
      submittedPinTheme: submittedPin,
      focusedPinTheme: focusedPin,
      errorPinTheme: errorPin,
      separatorBuilder: (context) => const SizedBox(width: 12),
      showCursor: true,
      cursor: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 2,
          height: 22,
          margin: const EdgeInsets.only(bottom: 8),
          color: cMain,
        ),
      ),
      keyboardType: TextInputType.number,
      autofillHints: const [AutofillHints.oneTimeCode],
      pinAnimationType: PinAnimationType.scale,
      animationDuration: const Duration(milliseconds: 140),
      animationCurve: Curves.easeOutCubic,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      onChanged: onChanged,
      onCompleted: onCompleted,
      validator: validator ?? (v) => (v?.length ?? 0) == length ? null : 'Mã chưa đủ $length số',
    );
  }
}