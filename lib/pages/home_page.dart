import 'package:flutter/material.dart';
import 'package:sushi_jiro_template/data/home_content_repository.dart';
import 'package:sushi_jiro_template/data/json_value_reader.dart';
import 'package:sushi_jiro_template/widgets/home/content_card_grid.dart';
import 'package:sushi_jiro_template/widgets/home/feature_split.dart';
import 'package:sushi_jiro_template/widgets/home/footer_section.dart';
import 'package:sushi_jiro_template/widgets/home/hero_section.dart';
import 'package:sushi_jiro_template/widgets/home/notice_section.dart';
import 'package:sushi_jiro_template/widgets/home/section_header.dart';
import 'package:sushi_jiro_template/widgets/home/social_strip.dart';
import 'package:sushi_jiro_template/widgets/home/top_bar_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<Map<String, dynamic>> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = const HomeContentRepository().loadRaw();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load home content JSON.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final content = snapshot.data ?? <String, dynamic>{};
        final navigation = asMap(content['navigation']);
        final hero = asMap(content['hero']);
        final intro = asMap(content['intro']);
        final contentSection = asMap(content['contentSection']);
        final feature = asMap(content['feature']);
        final social = asMap(content['social']);
        final notice = asMap(content['notice']);
        final footer = asMap(content['footer']);

        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 900;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    TopBarSection(data: navigation),
                    HeroSection(isCompact: isCompact, data: hero),
                    SectionHeader(isCompact: isCompact, data: intro),
                    ContentCardGrid(data: contentSection),
                    FeatureSplit(isCompact: isCompact, data: feature),
                    SocialStrip(isCompact: isCompact, data: social),
                    NoticeSection(isCompact: isCompact, data: notice),
                    FooterSection(isCompact: isCompact, data: footer),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
