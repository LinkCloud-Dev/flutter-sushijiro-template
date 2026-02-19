import 'package:flutter/material.dart';
import 'package:sushi_jiro_template/pages/home_page.dart';
import 'package:sushi_jiro_template/theme/app_theme.dart';

void main() {
  runApp(const SushiJiroApp());
}

class SushiJiroApp extends StatelessWidget {
  const SushiJiroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomePage(),
    );
  }
}
