import 'package:get/get.dart';
import '../storage/token_storage.dart';
import 'approved_product_service.dart';

class ApprovedProductController extends GetxController {
  final approvedProducts = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final filteredProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final token = await TokenStorage.getToken();
      if (token == null) throw Exception('Token not found');

      final data = await ApprovedProductService.fetchApprovedProducts(token);
      approvedProducts.value = data;
      filteredProducts.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts(String query) {
    filteredProducts.value = approvedProducts.where((product) {
      return product["product_name"]
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();
  }
}
