import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/widgets/item_card.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  String _getImageForProduct(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('coca')) return 'assets/images/coca.png';
    if (lower.contains('monster')) return 'assets/images/monster.png';
    return 'assets/images/default.png';
  }

  String _getNutriscoreImage(String? score) {
    switch (score) {
      case 'A': return 'assets/images/nutriscore_a.png';
      case 'B': return 'assets/images/nutriscore_b.png';
      case 'C': return 'assets/images/nutriscore_c.png';
      case 'D': return 'assets/images/nutriscore_d.png';
      case 'E': return 'assets/images/nutriscore_e.png';
      default: return 'assets/images/nutriscore_unknown.png';
    }
  }

  Future<void> _confirmDelete(BuildContext context, String productId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Supprimer ce produit ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('produits').doc(productId).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produit supprimé')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance.collection('produits').snapshots();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Erreur: ${snapshot.error}'));

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('Aucun produit'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return ItemCard(
                title: data['name'] ?? 'Sans nom',
                description: data['description'] ?? '',
                price: (data['price'] ?? 0).toDouble(),
                imageAsset: _getImageForProduct(data['name'] ?? ''),
                nutriscore: _getNutriscoreImage(data['nutriscore'] ?? ''),
                onDelete: () => _confirmDelete(context, doc.id), // bouton delete visible
              );
            },
          );
        },
      ),
    );
  }
}