import 'package:flutter/material.dart';
import 'package:sushi_jiro_template/data/json_value_reader.dart';
import 'package:sushi_jiro_template/theme/app_theme.dart';

class ContentCardGrid extends StatelessWidget {
  const ContentCardGrid({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final cards = asMapList(data['cards']);
    final safeCards = cards.isNotEmpty
        ? cards
        : <Map<String, dynamic>>[
            {
              'title': 'Nigiri Selection',
              'description':
                  'Pure fish over seasoned rice, the essence of simplicity.',
              'imageFallbackLabel': 'Nigiri Image',
            },
            {
              'title': 'Signature Rolls',
              'description':
                  'Creative combinations that redefine flavor boundaries.',
              'imageFallbackLabel': 'Rolls Image',
            },
            {
              'title': 'Fresh Sashimi',
              'description':
                  'The highest grade of raw fish served with precision.',
              'imageFallbackLabel': 'Sashimi Image',
            },
          ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final isDesktop = width >= 1000;
              final isTablet = width >= 680 && width < 1000;
              const gap = 20.0;
              final cardWidth = isDesktop
                  ? (width - (gap * 2)) / 3
                  : isTablet
                      ? (width - gap) / 2
                      : width;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: safeCards.map((card) {
                  final rawDesc = asString(card['description']);
                  // Try to parse img src manually since it's merged into description
                  final imgRegExp = RegExp(r'src="([^"]+)"');
                  final match = imgRegExp.firstMatch(rawDesc);

                  // Extract text without the HTML tags
                  final textDesc =
                      rawDesc.replaceAll(RegExp(r'<[^>]*>'), '').trim();

                  return ContentCard(
                    width: cardWidth,
                    imageLabel: asString(
                      card['imageFallbackLabel'],
                      asString(card['title'], 'Image'),
                    ),
                    imageUrl: match != null
                        ? match.group(1) ?? asString(card['imageUrl'])
                        : asString(card['imageUrl']),
                    title: asString(card['title'], 'Menu Item'),
                    description: textDesc.isEmpty
                        ? asString(card['description'])
                        : textDesc,
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.width,
    required this.imageLabel,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  final double width;
  final String imageLabel;
  final String imageUrl;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 5,
            child: imageUrl.isEmpty
                ? _CardImageFallback(label: imageLabel)
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _CardImageFallback(label: imageLabel);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.65,
                    color: AppColors.textMuted,
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

class _CardImageFallback extends StatelessWidget {
  const _CardImageFallback({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: const Color(0xFFF8FAFC),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
      ),
    );
  }
}
