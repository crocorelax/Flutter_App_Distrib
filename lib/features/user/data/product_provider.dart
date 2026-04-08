import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final votesProvider = StreamProvider.family<Map<String, int>, String>((ref, distribId) {
  return FirebaseFirestore.instance
      .collection('votes')
      .doc(distribId)
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists) return {};

        final data = snapshot.data() as Map<String, dynamic>;

        return data.map((key, value) => MapEntry(key, value as int));
      });
});

final productsProvider = StreamProvider<Map<String, Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('produits')
      .snapshots()
      .map((snapshot) {
        return {
          for (var doc in snapshot.docs)
            doc.id: doc.data(),
        };
      });
});

final voteActionProvider = Provider((ref) {
  return (String distribId, String productId) async {
    final refDoc = FirebaseFirestore.instance.collection('votes').doc(distribId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(refDoc);

      if (!snapshot.exists) {
        transaction.set(refDoc, {productId: 1});
      } else {
        final data = snapshot.data() as Map<String, dynamic>;
        final current = data[productId] ?? 0;

        transaction.update(refDoc, {
          productId: current + 1,
        });
      }
    });
  };
});