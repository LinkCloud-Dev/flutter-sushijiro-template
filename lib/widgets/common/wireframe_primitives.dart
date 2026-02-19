import 'package:flutter/material.dart';
import 'package:sushi_jiro_template/theme/app_theme.dart';

class LabelChip extends StatelessWidget {
  const LabelChip({
    super.key,
    required this.label,
    required this.width,
    this.height = 30,
    this.backgroundColor = AppColors.surfaceMuted,
    this.borderColor = AppColors.borderSoft,
    this.textStyle,
    this.borderRadius = 6,
  });

  final String label;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color borderColor;
  final TextStyle? textStyle;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        label,
        style:
            textStyle ??
            const TextStyle(
              fontSize: 10,
              letterSpacing: 0.8,
              color: AppColors.textPrimary,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ThickLine extends StatelessWidget {
  const ThickLine({
    super.key,
    required this.width,
    this.color = AppColors.textPrimary,
    this.height = 6,
  });

  final double width;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(height: height, width: width, color: color),
    );
  }
}

class PlaceholderBox extends StatelessWidget {
  const PlaceholderBox({
    super.key,
    this.width,
    required this.height,
    required this.label,
    this.fill = AppColors.surfaceMuted,
    this.border = true,
    this.borderColor = AppColors.borderSoft,
    this.borderRadius = 12,
    this.textStyle,
  });

  final double? width;
  final double height;
  final String label;
  final Color fill;
  final bool border;
  final Color borderColor;
  final double borderRadius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        border: border ? Border.all(color: borderColor) : null,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        label,
        style:
            textStyle ??
            const TextStyle(
              fontSize: 12,
              letterSpacing: 0.3,
              color: AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
