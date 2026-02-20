import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sushi_jiro_template/data/json_value_reader.dart';
import 'package:sushi_jiro_template/theme/app_theme.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key, required this.isCompact, required this.data});

  final bool isCompact;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final columns = asMapList(data['columns']);
    final safeColumns = columns.isNotEmpty
        ? columns
        : <Map<String, dynamic>>[
            {
              'title': 'VISIT US',
              'bodyLines': [
                '123 Zen Garden Lane',
                'Kyoto District, NY 10001',
                '+1 (555) 000-ZEN',
              ],
            },
            {
              'title': 'HOURS',
              'bodyLines': [
                'Mon-Thu: 5pm - 10pm',
                'Fri-Sat: 5pm - 11pm',
                'Sun: Closed',
              ],
            },
          ];
    final socialLinks = asMapList(data['socialLinks']);
    final brand = asMap(data['brand']);
    final logoPrimary = asString(brand['textPrimary'], 'SUSHI').toUpperCase();
    final logoAccent = asString(brand['textAccent'], 'ZEN').toUpperCase();
    final tagline = asString(
      brand['tagline'],
      'Defining the pinnacle of Japanese dining since 2010.',
    );
    final copyright = asString(
      data['copyright'],
      '© 2024 SUSHIZEN RESTAURANT GROUP. ALL RIGHTS RESERVED.',
    );

    return Container(
      width: double.infinity,
      color: AppColors.footerSurface,
      margin: const EdgeInsets.only(top: 28),
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Divider(
                thickness: 1.2,
                height: 1.2,
                color: AppColors.accent,
              ),
              const SizedBox(height: 44),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  runSpacing: 28,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    ...safeColumns.take(2).map(
                          (column) => _FooterCol(
                            title: asString(column['title']).toUpperCase(),
                            bodyLines: asStringList(column['bodyLines']),
                          ),
                        ),
                    _FooterSocial(links: socialLinks),
                    _FooterBrand(
                      logoPrimary: logoPrimary,
                      logoAccent: logoAccent,
                      tagline: tagline,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 38),
              Text(
                copyright,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 10,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterCol extends StatelessWidget {
  const _FooterCol({required this.title, required this.bodyLines});

  final String title;
  final List<String> bodyLines;

  @override
  Widget build(BuildContext context) {
    final safeBodyLines = bodyLines.isNotEmpty ? bodyLines : const ['-'];
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.7,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            safeBodyLines.join('\n'),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterSocial extends StatelessWidget {
  const _FooterSocial({required this.links});

  final List<Map<String, dynamic>> links;

  @override
  Widget build(BuildContext context) {
    final safeLinks = links.isNotEmpty
        ? links
        : const [
            {'platform': 'IG'},
            {'platform': 'FB'},
            {'platform': 'TW'},
          ];

    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SOCIAL',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.7,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: safeLinks
                .take(3)
                .map(
                  (link) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _MiniIcon(
                      label: asString(link['platform'], '?').toUpperCase(),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand({
    required this.logoPrimary,
    required this.logoAccent,
    required this.tagline,
  });

  final String logoPrimary;
  final String logoAccent;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: logoPrimary,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -1.0,
              ),
              children: [
                TextSpan(
                  text: logoAccent,
                  style: const TextStyle(color: AppColors.accent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            tagline,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 10,
              letterSpacing: 1.2,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniIcon extends StatefulWidget {
  const _MiniIcon({required this.label});

  final String label;

  @override
  State<_MiniIcon> createState() => _MiniIconState();
}

class _MiniIconState extends State<_MiniIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    String iconPath = '';
    switch (widget.label.toUpperCase()) {
      case 'IG':
        iconPath = 'assets/icons/instagram.svg';
        break;
      case 'FB':
        iconPath = 'assets/icons/facebook.svg';
        break;
      case 'TW':
        iconPath = 'assets/icons/twitter.svg';
        break;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.accent
              : const Color.fromRGBO(255, 255, 255, 0.16),
          borderRadius: BorderRadius.circular(999),
        ),
        child: iconPath.isNotEmpty
            ? SvgPicture.asset(
                iconPath,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  _isHovered ? AppColors.surface : AppColors.textPrimary,
                  BlendMode.srcIn,
                ),
              )
            : Text(
                widget.label,
                style: TextStyle(
                  fontSize: 10,
                  color: _isHovered ? AppColors.surface : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
