import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../../shared/widgets/item_card.dart';
import '../../data/product_provider.dart';

class VotePage extends ConsumerWidget {
  final String distribId;
  const VotePage({super.key, required this.distribId});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final votesAsync = ref.watch(votesProvider(distribId));
    final productsAsync = ref.watch(productsProvider);
    final voteAction = ref.read(voteActionProvider);

    return Scaffold(
      body: Column(
        children: [
          const AppHeader(title: "Votez pour un produit"),
          Expanded(
            child: votesAsync.when(
              data: (votes) => productsAsync.when(
                data: (products) => ListView.builder(
                  itemCount: votes.length,
                  itemBuilder: (context, index) {
                    final productId = votes.keys.elementAt(index);
                    final voteCount = votes[productId] ?? 0;

                    final product = products[productId];

                    return ItemCard(
                      title: product?['name'] ?? productId,
                      description: product?['description'] ?? '',
                      price: (product?['price'] ?? 0).toDouble(),
                      votes: voteCount,
                      imageAsset: _getImageForProduct(productId),
                      nutriscore: _getNutriscoreImage(product?['nutriscore']),
                      onVote: () => voteAction(distribId, productId),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Erreur produits: $e')),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur votes: $e')),
            ),
          ),
        ],
      ),
    );
  }
}