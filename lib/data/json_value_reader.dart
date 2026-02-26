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
  if (value is List) {
    return value.map(asMap).where((item) => item.isNotEmpty).toList();
  } else if (value is Map) {
    // Firestore sometimes imports JSON arrays as Maps {"0": {...}, "1": {...}}
    // Sort keys if they are numeric to preserve order
    final keys = value.keys.toList()
      ..sort((a, b) => (int.tryParse(a.toString()) ?? 0)
          .compareTo(int.tryParse(b.toString()) ?? 0));
    final values = keys.map((k) => value[k]).toList();
    return values.map(asMap).where((item) => item.isNotEmpty).toList();
  }
  return const <Map<String, dynamic>>[];
}

List<String> asStringList(dynamic value) {
  if (value is List) {
    return value.whereType<String>().toList();
  } else if (value is Map) {
    final keys = value.keys.toList()
      ..sort((a, b) => (int.tryParse(a.toString()) ?? 0)
          .compareTo(int.tryParse(b.toString()) ?? 0));
    final values = keys.map((k) => value[k]).toList();
    return values.whereType<String>().toList();
  }
  return const <String>[];
}

String asString(dynamic value, [String fallback = '']) {
  return value is String ? value : fallback;
}
