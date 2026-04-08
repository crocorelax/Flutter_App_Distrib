import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final int? votes;
  final String imageAsset;
  final VoidCallback? onVote;
  final VoidCallback? onDelete; 
  final String? nutriscore; 

  const ItemCard({
    super.key,
    required this.title,
    required this.description,
    this.price = 0,
    this.votes,
    required this.imageAsset,
    this.onVote,
    this.onDelete,
    this.nutriscore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image produit
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageAsset,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),

            // Texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),
                  if (nutriscore != null)
                    Image.asset(
                      nutriscore!,
                      width: 150,
                      height: 40,
                      fit: BoxFit.contain,
                    ),

                  const SizedBox(height: 8),
                  if (price > 0)
                    Text(
                      "Prix: \$${price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),

                ],
              ),
            ),

            const SizedBox(width: 10),

            // Votes et suppression
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (votes != null)
                  Column(
                    children: [
                      Text(
                        votes.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (onVote != null)
                        IconButton(
                          icon: const Icon(
                            Icons.thumb_up,
                            color: Color(0xFF80B8C5),
                          ),
                          onPressed: onVote,
                        ),
                    ],
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                    iconSize: 40,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}