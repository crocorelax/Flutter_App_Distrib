import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDistribPage extends StatefulWidget {
  const AddDistribPage({super.key});

  @override
  State<AddDistribPage> createState() => _AddDistribPageState();
}

class _AddDistribPageState extends State<AddDistribPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController maxProductsController = TextEditingController();

  bool isLoading = false;

  // Générer un ID aléatoire A1B2C3
  String generateDistribId() {
    final rand = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String getLetter() => letters[rand.nextInt(letters.length)];
    String getDigit() => rand.nextInt(10).toString();

    return '${getLetter()}${getDigit()}${getLetter()}${getDigit()}${getLetter()}${getDigit()}';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final distribId = generateDistribId();
      final location = locationController.text.trim();
      final maxProducts = int.parse(maxProductsController.text.trim());

      final firestore = FirebaseFirestore.instance;

      // Créer le distributeur
      await firestore
          .collection('distributeurs')
          .doc(distribId)
          .set({
        'name': 'Distributeur $distribId',
        'location': location,
        'maxProducts': maxProducts,
      });

      // Récupérer les produits globaux
      final produitsSnapshot = await firestore
          .collection('produits')
          .limit(maxProducts)
          .get();

      // Copier les produits dans le distributeur
      Map<String, int> votesMap = {};

      for (var doc in produitsSnapshot.docs) {
        final data = doc.data();

        await firestore
            .collection('distributeurs')
            .doc(distribId)
            .collection('produits')
            .doc(doc.id)
            .set(data);

        // initialiser les votes à 0 avec le BON id
        votesMap[doc.id] = 0;
      }

      // Créer le document votes
      await firestore
          .collection('votes')
          .doc(distribId)
          .set(votesMap);

      // Feedback UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Distributeur $distribId ajouté')),
      );

      locationController.clear();
      maxProductsController.clear();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    locationController.dispose();
    maxProductsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Emplacement',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: maxProductsController,
              decoration: const InputDecoration(
                labelText: 'Nombre maximum de produits',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Champ requis' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              child: Text(isLoading ? 'Ajout en cours...' : 'Ajouter Distributeur'),
            ),
          ],
        ),
      ),
    );
  }
}