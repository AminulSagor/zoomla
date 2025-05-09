import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductUploadController extends GetxController {
  final productNameController = TextEditingController();
  final brandNameController = TextEditingController();
  final modelNameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final offerController = TextEditingController();
  final deliveryChargeController = TextEditingController();
  final minBulkPurchaseController = TextEditingController();
  final variantsController = TextEditingController();
  final tagsController = TextEditingController();
  final stockStatusController = TextEditingController();
  final descriptionController = TextEditingController();

  // Dropdown state
  final categories = ["Electronics", "Fashion", "Furniture"].obs;
  final subCategories = <String>[].obs;

  final selectedCategory = RxnString();
  final selectedSubCategory = RxnString();

  void updateSubCategories(String? category) {
    selectedCategory.value = category;
    if (category == "Electronics") {
      subCategories.value = ["Mobile", "Laptop", "Camera"];
    } else if (category == "Fashion") {
      subCategories.value = ["Men", "Women", "Kids"];
    } else if (category == "Furniture") {
      subCategories.value = ["Chair", "Table", "Bed"];
    } else {
      subCategories.clear();
    }
    selectedSubCategory.value = null;
  }
}

