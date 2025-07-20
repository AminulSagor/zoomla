import 'package:get/get.dart';
import 'product_details_service.dart';

class ProductDetailsController extends GetxController {
  final String productId;

  ProductDetailsController(String? inputId)
      : productId = (inputId != null && inputId.isNotEmpty) ? inputId : "33";
  final images = <String>[].obs;
  final reviews = <Map<String, dynamic>>[].obs;
  final colors = <Map<String, dynamic>>[].obs;
  final variants = <Map<String, dynamic>>[].obs;


  var productName = ''.obs;
  var price = ''.obs;
  var stock = ''.obs;
  var description = ''.obs;
  var storeName = ''.obs;
  var quantity = 1.obs;
  var selectedColor = ''.obs;
  var selectedImageIndex = 0.obs;
  var isLoading = false.obs;
  var brandName = ''.obs;
  var discount = ''.obs;
  var discountPrice = ''.obs;
  var model = ''.obs;
  var sellerId = ''.obs;
  var subCategoryId = ''.obs;
  var isAddingToCart = false.obs;
  final isOutOfStockTapped = false.obs;







  @override
  void onInit() {
    super.onInit();
    if (productId.isNotEmpty) {
      loadProductDetails(productId);
    } else {
      print('❌ Product ID is empty in controller. Skipping fetch.');
    }
  }

  Future<void> loadProductDetails(String productId) async {
    try {
      print('🔍 Starting to load product details for productId: $productId');
      isLoading.value = true;

      final data = await ProductDetailsService.fetchProductDetails(productId);

      if (data == null) {
        print('⚠️ No product data received from API.');
        return;
      }

      print('✅ Product data received: $data');

      productName.value = data['product_name'] ?? '';
      price.value = data['price'] ?? '0';
      stock.value = data['stock'] ?? '0';
      description.value = data['description'] ?? '';
      storeName.value = data['store_name'] ?? '';
      discount.value = data['discount'] ?? '';
      discountPrice.value = data['discount_price']?.toString() ?? price.value;
      model.value = data['model'] ?? '';
      sellerId.value = data['seller_id'] ?? '';
      subCategoryId.value = data['sub_category_id'] ?? '';

      print('📊 Product basic fields set successfully');

      colors.value = List<Map<String, dynamic>>.from(data['colors'] ?? []);
      selectedColor.value = colors.isNotEmpty ? colors.first['id'] : '';

      images.value = List<String>.from(data['images'] ?? []);
      selectedImageIndex.value = 0;
      variants.value = List<Map<String, dynamic>>.from(data['variants'] ?? []);

      reviews.value = List<Map<String, dynamic>>.from(data['reviews'] ?? []);

      print('🎨 Colors, images, variants, and reviews set successfully');



    } catch (e, stackTrace) {
      print('❌ Error loading product details for ID $productId: $e');
      print('🛠️ Stack Trace: $stackTrace');
    } finally {
      isLoading.value = false;
      print('🔚 Finished loading product details for productId: $productId');
    }
  }

  Future<void> updateProduct({
    required String price,
    required String stock,
  }) async {
    try {
      isLoading.value = true;

      final success = await ProductDetailsService.updateProduct(
        productId: productId,
        price: price,
        stock: stock,
      );

      if (success) {
        Get.back(); // close dialog
        await loadProductDetails(productId); // refresh data
        Get.snackbar("Success", "Product updated");
      } else {
        Get.snackbar("Error", "Failed to update product");
      }
    } catch (e) {
      print("❌ Error updating product: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }


}
