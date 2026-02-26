import 'package:flutter/material.dart';
import 'package:sushi_jiro_template/data/json_value_reader.dart';
import 'package:sushi_jiro_template/theme/app_theme.dart';
import 'package:sushi_jiro_template/widgets/common/wireframe_primitives.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.isCompact, required this.data});

  final bool isCompact;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final media = asMap(data['media']);
    final cta = asMap(data['cta']);
    final headingPrefix = asString(
      data['headlinePrefix'],
      asString(data['headline'], 'Experience the Art of'),
    );
    final headingAccent = asString(data['headlineAccent'], 'Sushi');
    final subheadline = asString(
      data['subheadline'],
      'Hand-crafted excellence delivered from our kitchen to your table.',
    );
    final ctaLabel = asString(cta['label'], 'Order Online').toUpperCase();
    final rawImageUrl = asString(
      media['primaryImageUrl'], // Original JSON location
      asString(data['imageUrl']), // The root location the user might have used
    );
    final imgRegExp = RegExp(r'src="([^"]+)"');
    final match = imgRegExp.firstMatch(rawImageUrl);
    final imageUrl =
        match != null ? (match.group(1) ?? rawImageUrl) : rawImageUrl;
    final imageAlt = asString(
      media['fallbackLabel'],
      'Premium Dining Experience',
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final headingSize = isCompact ? 44.0 : 72.0;
        final accentSize = isCompact ? 52.0 : 76.0;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isCompact ? 32 : 64,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      text: headingPrefix,
                      style: TextStyle(
                        fontSize: headingSize,
                        height: 1.08,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.3,
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        TextSpan(
                          text: '\n$headingAccent',
                          style: TextStyle(
                            fontSize: accentSize,
                            color: AppColors.accent,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 26),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 740),
                    child: Text(
                      subheadline,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                        height: 1.75,
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.surface,
                      minimumSize: const Size(170, 50),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        fontSize: 12,
                      ),
                    ),
                    child: Text(ctaLabel),
                  ),
                  const SizedBox(height: 62),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageUrl.isEmpty
                        ? PlaceholderBox(
                            height: isCompact ? 240 : 360,
                            label: imageAlt,
                            fill: AppColors.surfaceMuted,
                            borderColor: AppColors.surfaceMuted,
                            borderRadius: 12,
                          )
                        : Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: isCompact ? 240 : 360,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return PlaceholderBox(
                                height: isCompact ? 240 : 360,
                                label: imageAlt,
                                fill: AppColors.surfaceMuted,
                                borderColor: AppColors.surfaceMuted,
                                borderRadius: 12,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
