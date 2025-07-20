// product_details_binding.dart
import 'package:get/get.dart';
import 'product_details_controller.dart';

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final productId = Get.parameters['id'] ?? '';
    Get.put(ProductDetailsController(productId), tag: productId); // ✅ use tag
  }
}

