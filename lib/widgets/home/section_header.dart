import 'package:flutter/material.dart';
import 'package:sushi_jiro_template/data/json_value_reader.dart';
import 'package:sushi_jiro_template/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.isCompact, required this.data});

  final bool isCompact;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final title = asString(data['title'], 'Masterfully Prepared');
    final description = asString(
      data['description'],
      'Every piece of sushi at SushiZen is a testament to tradition, quality, and creativity.',
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isCompact ? 28 : 34,
              horizontal: isCompact ? 24 : 42,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.accent, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isCompact ? 34 : 44,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.7,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
