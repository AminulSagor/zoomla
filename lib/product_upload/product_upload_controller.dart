import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jumla/product_upload/product_upload_service.dart';
import '../routes.dart';
import '../storage/token_storage.dart';
import 'category_service.dart';

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

  final categories = <String>[].obs;
  final subCategories = <Map<String, String>>[].obs; // Each map = {'id': '123', 'name': 'Laptop'}


  final selectedCategory = RxnString();
  final selectedSubCategory = RxnString();
  final pickedImages = <File>[].obs;
  final pickedImage = Rx<File?>(null);

  final variantControllers = <TextEditingController>[TextEditingController()].obs;
  final tagInputController = TextEditingController();
  final tags = <String>[].obs;


  final colorOptions = ["Red", "Green", "Blue", "Black", "White"];
  final selectedColors = <String>[].obs;

  final categoryMap = <String, String>{}.obs; // category name => id

  int get totalTagLength => tags.fold(0, (sum, tag) => sum + tag.length);
  final isLoading = false.obs;


  @override
  void onInit() {
    super.onInit();
    fetchAndSetCategories();
  }

  Future<void> fetchAndSetCategories() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) throw Exception("Token missing");

      final fetched = await CategoryService.fetchCategories(token); // returns List<Map>
      categoryMap.value = {
        for (var e in fetched)
          e['category'] ?? '': e['id'] ?? ''
      };

      categories.value = categoryMap.keys.toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories');
    }
  }

  Future<void> updateSubCategories(String? categoryName) async {
    selectedCategory.value = categoryName;
    selectedSubCategory.value = null;

    final categoryId = categoryMap[categoryName];
    if (categoryId == null) return;

    try {
      final token = await TokenStorage.getToken();
      if (token == null) throw Exception("Token missing");

      final subs = await CategoryService.fetchSubCategories(categoryId, token);
      subCategories.value = subs;
    } catch (e) {
      subCategories.clear();
      Get.snackbar('Error', 'Failed to load sub-categories');
    }
  }

  void addVariantFieldIfNeeded(int index) {
    final current = variantControllers[index];
    if (index == variantControllers.length - 1 && current.text.trim().isNotEmpty) {
      variantControllers.add(TextEditingController());
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && pickedImages.length < 10) {
      pickedImages.add(File(pickedFile.path));
    }
  }

  Future<bool> uploadProduct() async {
    isLoading.value = true;
    try {
      final token = await TokenStorage.getToken();
      if (token == null) throw Exception("Token missing");

      final response = await ProductUploadService.uploadProduct(
        token: token,
        subCategoryId: selectedSubCategory.value!,
        productName: productNameController.text.trim(),
        brand: brandNameController.text.trim(),
        model: modelNameController.text.trim(),
        price: priceController.text.trim(),
        stock: stockStatusController.text.trim(),
        delCharge: deliveryChargeController.text.trim(),
        description: descriptionController.text.trim(),
        colors: selectedColors,
        variants: variantControllers.map((c) => c.text.trim()).where((v) => v.isNotEmpty).toList(),
        keywords: tags,
        images: pickedImages,
      );

      if (response['status'] == 'success') {
        Get.offAllNamed(AppRoutes.homePage);
        return true;
      } else {
        Get.snackbar('Error', response['message'] ?? 'Unknown error');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
    finally {
      isLoading.value = false; // hide loader
    }
  }


}
