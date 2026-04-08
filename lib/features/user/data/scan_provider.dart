import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final scanProvider = NotifierProvider<ScanNotifier, bool>(ScanNotifier.new);

class ScanNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // false = not processing
  }

  Future<bool> validateCode(String code) async {
    if (state) return false;

    state = true;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('distributeurs')
          .doc(code)
          .get();

      return doc.exists;
    } finally {
      state = false;
    }
  }
}