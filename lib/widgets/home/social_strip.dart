import 'package:flutter/material.dart';
import 'package:sushi_jiro_template/data/json_value_reader.dart';
import 'package:sushi_jiro_template/theme/app_theme.dart';
import 'package:sushi_jiro_template/widgets/common/wireframe_primitives.dart';

class SocialStrip extends StatelessWidget {
  const SocialStrip({super.key, required this.isCompact, required this.data});

  final bool isCompact;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final title = asString(data['title'], 'Follow Our Journey');
    final handle = asString(data['handle'], '@SushiZen');
    final cta = asMap(data['cta']);
    final ctaLabel = asString(
      cta['label'],
      'Follow on Instagram',
    ).toUpperCase();
    final galleryImageUrls = asStringList(data['galleryImageUrls']);
    final safeImages = galleryImageUrls.isNotEmpty
        ? galleryImageUrls
        : List<String>.filled(8, '');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            children: [
              Text.rich(
                TextSpan(
                  text: '$title ',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                  children: [
                    TextSpan(
                      text: handle,
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isCompact ? 4 : 8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: safeImages.length,
                itemBuilder: (context, index) {
                  final imageUrl = safeImages[index];
                  if (imageUrl.isEmpty) {
                    return const PlaceholderBox(
                      height: 130,
                      label: '',
                      fill: Color(0xFFF1F5F9),
                      borderColor: Color(0xFFE2E8F0),
                      borderRadius: 0,
                    );
                  }

                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const PlaceholderBox(
                        height: 130,
                        label: '',
                        fill: Color(0xFFF1F5F9),
                        borderColor: Color(0xFFE2E8F0),
                        borderRadius: 0,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 28),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(240, 46),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                child: Text(
                  ctaLabel,
                  style: const TextStyle(
                    letterSpacing: 1.2,
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
