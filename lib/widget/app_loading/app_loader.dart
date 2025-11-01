import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    Key? key,
    this.size = 28,
    this.strokeWidth = 3,
    this.color = const Color(0xFF66BB6A),
    this.padding = const EdgeInsets.symmetric(vertical: 24),
    this.height = 100,
    this.label,
    this.labelStyle,
  }) : super(key: key);

  final double size;
  final double strokeWidth;
  final Color color;
  final EdgeInsetsGeometry padding;
  final double? height;
  final String? label;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  strokeWidth: strokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              if (label != null) const SizedBox(height: 12),
              if (label != null)
                Text(
                  label!,
                  style: labelStyle ??
                      Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: color, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
