import 'package:flutter/material.dart';
import 'package:sushi_jiro_template/data/json_value_reader.dart';
import 'package:sushi_jiro_template/theme/app_theme.dart';

class NoticeSection extends StatelessWidget {
  const NoticeSection({super.key, required this.isCompact, required this.data});

  final bool isCompact;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    String extractMessage(dynamic msgData) {
      if (msgData is String) return msgData;
      if (msgData is List && msgData.isNotEmpty) {
        final firstBlock = asMap(msgData.first);
        final children = asMapList(firstBlock['children']);
        if (children.isNotEmpty) {
          return asString(children.first['content']);
        }
      }
      return '';
    }

    final label = asString(data['label'], 'DINING NOTICE').toUpperCase();
    final headline = asString(data['headline']);
    final message = extractMessage(data['message']);
    final body = headline.isEmpty ? message : '$headline. $message';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 18 : 24,
              vertical: isCompact ? 18 : 22,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                left: BorderSide(color: AppColors.accent, width: 4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  body,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    height: 1.7,
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
