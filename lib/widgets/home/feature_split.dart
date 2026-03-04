import 'package:flutter/material.dart';
import 'package:sushi_jiro_template/data/json_value_reader.dart';
import 'package:sushi_jiro_template/theme/app_theme.dart';
import 'package:sushi_jiro_template/widgets/common/wireframe_primitives.dart';

class FeatureSplit extends StatelessWidget {
  const FeatureSplit({super.key, required this.isCompact, required this.data});

  final bool isCompact;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final rawImageUrl = asString(data['imageUrl']);
    final imgRegExp = RegExp(r'src="([^"]+)"');
    final match = imgRegExp.firstMatch(rawImageUrl);
    final imageUrl =
        match != null ? (match.group(1) ?? rawImageUrl) : rawImageUrl;
    final imageFallback = asString(
      data['imageFallbackLabel'],
      'Heritage Image',
    );

    final content = isCompact
        ? Column(
            children: [
              _FeatureImage(imageUrl: imageUrl, fallbackLabel: imageFallback),
              _FeatureCopy(isCompact: isCompact, data: data),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: _FeatureImage(
                  imageUrl: imageUrl,
                  fallbackLabel: imageFallback,
                ),
              ),
              Expanded(
                child: _FeatureCopy(isCompact: isCompact, data: data),
              ),
            ],
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _FeatureImage extends StatelessWidget {
  const _FeatureImage({required this.imageUrl, required this.fallbackLabel});

  final String imageUrl;
  final String fallbackLabel;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _fallbackImage();
    }

    return Image.network(
      imageUrl,
      height: 400,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _fallbackImage();
      },
    );
  }

  Widget _fallbackImage() {
    return PlaceholderBox(
      height: 400,
      label: fallbackLabel,
      fill: AppColors.surfaceMuted,
      border: false,
      borderRadius: 0,
      textStyle: const TextStyle(
        fontStyle: FontStyle.italic,
        color: Color(0xFF9CA3AF),
      ),
    );
  }
}

class _FeatureCopy extends StatelessWidget {
  const _FeatureCopy({required this.isCompact, required this.data});

  final bool isCompact;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    String extractBody(dynamic bodyData) {
      if (bodyData is String) return bodyData;
      final bodyList = asMapList(bodyData);
      if (bodyList.isNotEmpty) {
        // Check if it's the rich text block format
        final firstBlock = bodyList.first;
        final children = asMapList(firstBlock['children']);
        if (children.isNotEmpty) {
          return asString(children.first['content']);
        }
      }
      return '';
    }

    final eyebrow = asString(data['eyebrow'], 'OUR HERITAGE').toUpperCase();
    final title = asString(data['title'], 'A Legacy of Taste');

    final extractedBody = extractBody(data['body']);
    final body = extractedBody.isNotEmpty
        ? extractedBody
        : asString(data['body'], asStringList(data['bodyLines']).join(' '));
    final linkLabel = asString(
      data['linkLabel'],
      'READ OUR STORY',
    ).toUpperCase();

    return SizedBox(
      height: isCompact ? null : 400,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 22 : 34,
          vertical: isCompact ? 26 : 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow,
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.2,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: isCompact ? 40 : 50,
                height: 1.05,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              body,
              style: const TextStyle(
                fontSize: 13,
                height: 1.7,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 18),
            _StoryLink(label: linkLabel),
          ],
        ),
      ),
    );
  }
}

class _StoryLink extends StatelessWidget {
  const _StoryLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(bottom: 3),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.accent, width: 2)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
