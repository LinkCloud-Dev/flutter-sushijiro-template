import 'dart:convert';

import 'package:flutter/services.dart';

class HomeContentRepository {
  static const String assetPath = 'assets/data/home_content.json';

  const HomeContentRepository();

  Future<Map<String, dynamic>> loadRaw() async {
    final jsonString = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('home_content.json must be a JSON object.');
    }
    return decoded;
  }

  Future<Map<String, dynamic>> loadSection(String key) async {
    final root = await loadRaw();
    final section = root[key];
    if (section is! Map<String, dynamic>) {
      throw FormatException('Section "$key" is missing or not an object.');
    }
    return section;
  }
}
