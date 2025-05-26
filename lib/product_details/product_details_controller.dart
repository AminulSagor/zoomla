import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  final images = [
    'assets/png/headphone.png',
    'assets/png/headphone.png',
    'assets/png/headphone.png',
    'assets/png/headphone.png',
  ];

  var selectedImageIndex = 0.obs;
  var selectedColor = 'blue'.obs;
  var quantity = 1.obs;

  final suggestedProducts = [
    {'name': 'Wireless Headset', 'image': 'assets/png/headphone.png', 'price': 100},
    {'name': 'Wireless Headset', 'image': 'assets/png/headphone.png', 'price': 100},
  ].obs;
}
