import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {
  final searchController = TextEditingController();

  final allProducts = <Map<String, String>>[
    {
      'title': 'MacBook Air 15 Pro',
      'image': 'https://picsum.photos/seed/macbook/150',
    },
    {
      'title': 'Hp Intel Core I10',
      'image': 'https://picsum.photos/seed/hp/150',
    },
    {
      'title': 'JBL Tube 489',
      'image': 'https://picsum.photos/seed/jbl/150',
    },
  ];


  var filteredProducts = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredProducts.value = allProducts;
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.value = allProducts;
    } else {
      filteredProducts.value = allProducts
          .where((p) => p['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
