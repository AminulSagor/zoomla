import 'package:get/get.dart';
import '../storage/token_storage.dart';
import 'pending_product_service.dart';

class PendingProductController extends GetxController {
  final isLoading = true.obs;
  final pendingProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPendingProducts();
  }

  Future<void> loadPendingProducts() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) throw Exception("Token missing");

      final products = await PendingProductService.fetchPendingProducts(token);
      pendingProducts.value = products;
    } catch (e) {
      pendingProducts.clear();
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}