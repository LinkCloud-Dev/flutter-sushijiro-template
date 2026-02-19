import 'package:flutter/material.dart';
import 'package:sushi_jiro_template/data/json_value_reader.dart';
import 'package:sushi_jiro_template/theme/app_theme.dart';

class TopBarSection extends StatelessWidget {
  const TopBarSection({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 900;
    final logo = asMap(data['logo']);
    final primaryLogo = asString(
      logo['textPrimary'],
      asString(logo['text'], 'SUSHI'),
    ).toUpperCase();
    final accentLogo = asString(logo['textAccent'], 'ZEN').toUpperCase();
    final navItems = asMapList(data['items']);
    final navLabels = navItems
        .map((item) => asString(item['label']).toUpperCase())
        .where((item) => item.isNotEmpty)
        .toList();

    final safeLabels = navLabels.isNotEmpty
        ? navLabels
        : const ['MENU', 'RESERVATIONS', 'OUR STORY'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.borderSoft)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: primaryLogo,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -1.1,
                  ),
                  children: [
                    TextSpan(
                      text: accentLogo,
                      style: const TextStyle(color: AppColors.accent),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (isCompact)
                _NavLink(label: safeLabels.first)
              else
                Row(
                  children: safeLabels
                      .take(3)
                      .map(
                        (label) => Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: _NavLink(label: label),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        textStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.4,
        ),
      ),
      child: Text(label),
    );
  }
}
