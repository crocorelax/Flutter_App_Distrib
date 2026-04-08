import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_header.dart';
import 'pages/add_distributor_page.dart';
import 'pages/add_product_page.dart';
import 'pages/distributor_list_page.dart';
import 'pages/product_list_page.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  // Index de la page courante
  int _currentIndex = 0;

  // Liste des pages admin
  final List<Widget> _pages = const [
    AddDistribPage(),
    AddProductPage(),
    DistributorListPage(),
    ProductListPage(),
  ];

  // Titres correspondants pour le header
  final List<String> _titles = const [
    'Ajouter un distributeur',
    'Ajouter un produit',
    'Liste des distributeurs',
    'Liste des produits',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: _titles[_currentIndex]), // header commun
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Add Distrib',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Distrib List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Product List',
          ),
        ],
      ),
    );
  }
}