import 'package:cloud_firestore/cloud_firestore.dart';

class HomeContentRepository {
  // Use the exact document path shown in the Firestore Console
  static const String documentPath =
      'stores/36844bb8-2912-435e-aa0d-9e1bd94351db/website/template1';

  const HomeContentRepository();

  Future<Map<String, dynamic>> loadRaw() async {
    // Fetch the deeply nested document directly using its full path
    final docSnapshot =
        await FirebaseFirestore.instance.doc(documentPath).get();

    if (!docSnapshot.exists) {
      throw FormatException('Firestore document $documentPath does not exist.');
    }

    final data = docSnapshot.data();
    if (data == null) {
      throw FormatException('Firestore document $documentPath is empty.');
    }

    return data;
  }

  Stream<Map<String, dynamic>> streamRaw() {
    return FirebaseFirestore.instance
        .doc(documentPath)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        throw FormatException(
            'Firestore document $documentPath does not exist.');
      }
      final data = snapshot.data();
      if (data == null) {
        throw FormatException('Firestore document $documentPath is empty.');
      }
      return data;
    });
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
