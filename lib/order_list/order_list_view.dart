import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/bottom_navbar.dart';
import 'order_list_controller.dart';

class OrderListView extends StatelessWidget {
  final controller = Get.put(OrderListController());

  Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green.shade100;
      case 'delivered':
        return Colors.blue.shade100;
      case 'shipped':
        return Colors.teal.shade100;
      case 'on_progress':
        return Colors.amber.shade100;
      case 'pending':
      default:
        return Colors.orange.shade100;
    }
  }


  Color getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'delivered':
        return Colors.blue;
      case 'shipped':
        return Colors.teal;
      case 'on_progress':
        return Colors.orange;
      case 'pending':
      default:
        return Colors.orange;
    }
  }



  void _showStatusUpdateOptions(BuildContext context, String orderId, String currentStatus) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            const Center(
              child: Text(
                "Update Order Status",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),

            // Only show if not already 'shipped'
            if (currentStatus != 'shipped')
              ListTile(
                leading: const Icon(Icons.local_shipping),
                title: const Text('Mark as Shipped'),
                onTap: () {
                  controller.updateOrderStatus(orderId, 'shipped');
                  Get.back();
                },
              ),

            // Only show if not already 'on_progress'
            if (currentStatus != 'on_progress')
              ListTile(
                leading: const Icon(Icons.timelapse),
                title: const Text('Mark as On Progress'),
                onTap: () {
                  controller.updateOrderStatus(orderId, 'on_progress');
                  Get.back();
                },
              ),

            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }



  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'delivered':
        return 'Delivered';
      case 'shipped':
        return 'Shipped';
      case 'on_progress':
        return 'On Progress';
      case 'pending':
      default:
        return 'Pending';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
      ),



      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text("My Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: controller.tabs.map((tab) {
                  final isSelected = controller.selectedTab.value == tab;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(tab),
                      selected: isSelected,
                      onSelected: (_) => controller.selectedTab.value = tab,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  final filteredOrders = controller.orders;


                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (filteredOrders.isEmpty) {
                    return const Center(
                      child: Text(
                        'No orders available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (_, index) {
                      final order = filteredOrders[index];
                      String address = order['address'] ?? '';

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            if (controller.selectedTab.value == 'Pending') {
                              Get.toNamed('/confirm-order', arguments: {
                                'order_id': order['order_id'],
                                'name': order['name'],
                                'phone': order['phone'],
                                'address': order['address'],
                                'created_at': order['created_at'],
                              });
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        order['pro_path'] ?? '',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Image.asset(
                                          'assets/png/customer_home_head.png',
                                          width: 70,
                                          height: 70,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(order['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                          Text(order['phone'] ?? ''),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (controller.selectedTab.value == 'Approved') {
                                          _showStatusUpdateOptions(
                                            context,
                                            order['order_id'],
                                            order['status'] ?? '',
                                          );
                                        }
                                      },

                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: getStatusBackgroundColor(order['status'] ?? ''),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          getStatusText(order['status'] ?? ''),
                                          style: TextStyle(
                                            color: getStatusTextColor(order['status'] ?? ''),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          text: "Home: ",
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                          children: [
                                            TextSpan(
                                              text: address,
                                              style: const TextStyle(fontWeight: FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                    },
                  );
                }),
              ),

            ],
          )),
        ),
      ),
    );
  }
}
