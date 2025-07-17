// confirm_order_controller.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'approve_order_service.dart';
import 'order_details_service.dart';

class ConfirmOrderController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;
  var subTotal = 0.0.obs;
  var deliveryCharge = 20.0.obs;
  var deliveryTime = ''.obs;

  double get total => subTotal.value + deliveryCharge.value;

  late final String orderId;
  late final String customerName;
  late final String customerPhone;
  late final String customerAddress;
  late final String orderDate; // to hold created_at

  final TextEditingController deliveryTimeController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    orderId = Get.arguments['order_id'] ?? '';
    customerName = args['name'] ?? '';
    customerPhone = args['phone'] ?? '';
    customerAddress = args['address'] ?? '';
    orderDate = args['created_at'] ?? '';
    if (orderId.isNotEmpty) {
      fetchOrderDetails(orderId);
    } else {
      Get.snackbar("Error", "Order ID not found");
      print("❌ order_id argument is null or empty.");
    }
    fetchOrderDetails(orderId);
  }

  void fetchOrderDetails(String orderId) async {
    try {
      final items = await OrderDetailsService.fetchOrderDetails(orderId);
      products.assignAll(items);

      // Convert price and qty to calculate subtotal
      double total = 0.0;
      for (var item in items) {
        final rate = double.tryParse(item['rate'] ?? '0') ?? 0.0;
        final qty = int.tryParse(item['quantity'] ?? '0') ?? 0;
        total += rate * qty;
      }

      subTotal.value = total;
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> approveOrder() async {
    try {
      if (deliveryTime.value.isEmpty || deliveryTimeController.text.isEmpty) {
        Get.snackbar(
          "Error",
          "Please select a delivery date",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }



      final formattedDateTime = _convertToDateTimeFormat(deliveryTime.value);

      final result = await ApproveOrderService.approveOrder(
        orderId: orderId!,
        deliveryDateTime: formattedDateTime,
        extraDeliveryCharge: deliveryCharge.value,
      );

      if (result['status'] == 'success') {
        Get.snackbar("Success", result['message'] ?? "Order approved");
        Get.back(); // Optional: close dialog or page
      } else {
        Get.snackbar("Failed", result['message'] ?? "Could not approve order");
      }
    } catch (e) {
      print("❌ Approve Order Error: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  // Convert dd/MM/yyyy to Y-m-d H:i:s
  String _convertToDateTimeFormat(String input) {
    try {
      final parts = input.split('/');
      final date = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
        15, // Optional: fixed delivery time
        12,
        49,
      );
      return date.toIso8601String().split('T').join(' ').split('.').first;
    } catch (_) {
      return '';
    }
  }

  String get formattedOrderDate {
    try {
      final dateTime = DateTime.parse(orderDate);
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final year = dateTime.year.toString();
      return "$day/$month/$year";
    } catch (_) {
      return '';
    }
  }

}
