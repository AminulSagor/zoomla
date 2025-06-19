import 'package:get/get.dart';

class ConfirmOrderController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;
  var subTotal = 0.0.obs;
  var deliveryCharge = 20.0.obs;
  var deliveryTime = ''.obs;

  double get total => subTotal.value + deliveryCharge.value;

  @override
  void onInit() {
    products.value = [
      {
        'name': 'Plant Pot',
        'brand': 'GreenLeaf',
        'price': 25.0,
        'qty': 2,
        'image': 'assets/png/headphone.png',
      },
      {
        'name': 'Rooting Hormone',
        'brand': 'Tri Gardening',
        'price': 100.0,
        'qty': 200,
        'image': 'assets/png/headphone.png',
      },
      {
        'name': 'Rooting Hormone',
        'brand': 'Tri Gardening',
        'price': 100.0,
        'qty': 200,
        'image': 'assets/png/headphone.png',
      },
      {
        'name': 'Rooting Hormone',
        'brand': 'Tri Gardening',
        'price': 100.0,
        'qty': 200,
        'image': 'assets/png/headphone.png',
      },
      {
        'name': 'Rooting Hormone',
        'brand': 'Tri Gardening',
        'price': 100.0,
        'qty': 200,
        'image': 'assets/png/headphone.png',
      },
      {
        'name': 'Rooting Hormone',
        'brand': 'Tri Gardening',
        'price': 100.0,
        'qty': 200,
        'image': 'assets/png/headphone.png',
      },
      {
        'name': 'Rooting Hormone',
        'brand': 'Tri Gardening',
        'price': 100.0,
        'qty': 200,
        'image': 'assets/png/headphone.png',
      },
      {
        'name': 'Rooting Hormone',
        'brand': 'Tri Gardening',
        'price': 100.0,
        'qty': 200,
        'image': 'assets/png/headphone.png',
      },
    ];

    subTotal.value = products.fold(0.0, (sum, item) => sum + (item['price'] * item['qty']));
    super.onInit();
  }
}
