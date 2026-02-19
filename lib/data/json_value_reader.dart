Map<String, dynamic> asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val));
  }
  return <String, dynamic>{};
}

List<Map<String, dynamic>> asMapList(dynamic value) {
  if (value is! List) {
    return const <Map<String, dynamic>>[];
  }
  return value.map(asMap).where((item) => item.isNotEmpty).toList();
}

List<String> asStringList(dynamic value) {
  if (value is! List) {
    return const <String>[];
  }
  return value.whereType<String>().toList();
}

String asString(dynamic value, [String fallback = '']) {
  return value is String ? value : fallback;
}
