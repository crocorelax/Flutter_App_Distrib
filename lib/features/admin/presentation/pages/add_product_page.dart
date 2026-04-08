import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedNutriscore;
  bool isLoading = false;

  final List<String> nutriscores = ['A', 'B', 'C', 'D', 'E'];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || selectedNutriscore == null) return;

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('produits').add({
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'nutriscore': selectedNutriscore,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit ajouté')),
      );

      nameController.clear();
      descriptionController.clear();
      setState(() => selectedNutriscore = null);

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
    nameController.dispose();
    descriptionController.dispose();
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
            // Nom
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du produit',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Champ requis' : null,
            ),

            const SizedBox(height: 20),

            // Description
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Champ requis' : null,
            ),

            const SizedBox(height: 20),

            // Nutriscore
            DropdownButtonFormField<String>(
              value: selectedNutriscore,
              decoration: const InputDecoration(
                labelText: 'Nutriscore',
                border: OutlineInputBorder(),
              ),
              items: nutriscores.map((score) {
                return DropdownMenuItem(
                  value: score,
                  child: Text(score),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedNutriscore = value);
              },
              validator: (value) =>
                  value == null ? 'Sélectionner un nutriscore' : null,
            ),

            const SizedBox(height: 30),

            // Bouton
            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              child: Text(
                isLoading ? 'Ajout...' : 'Ajouter produit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}