import 'package:get/get.dart';

import 'oder_list_service.dart';


class OrderListController extends GetxController {
  final selectedTab = 'Pending'.obs;
  final tabs = ['Pending', 'Approved', 'Delivered'];
  final orders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders(); // fetch default: pending
    ever(selectedTab, (_) => fetchOrders()); // fetch on tab switch
  }

  void fetchOrders() async {
    isLoading.value = true;
    try {
      final fetchedOrders = await OrderService.getOrdersByStatus(selectedTab.value.toLowerCase());
      orders.assignAll(fetchedOrders);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final result = await OrderService.updateOrderStatus(orderId, newStatus);

      if (result['status'] == 'success') {
        Get.snackbar('Success', result['message'] ?? 'Order updated');
        fetchOrders(); // Refresh the list
      } else {
        Get.snackbar('Failed', result['message'] ?? 'Failed to update status');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
