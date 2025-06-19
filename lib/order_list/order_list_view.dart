import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/bottom_navbar.dart';
import 'order_list_controller.dart';

class OrderListView extends StatelessWidget {
  final controller = Get.put(OrderListController());

  Color getStatusBackgroundColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green.shade100;
      case 'Delivered':
        return Colors.blue.shade100;
      case 'Pending':
      default:
        return Colors.orange.shade100;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Delivered':
        return Colors.blue;
      case 'Pending':
      default:
        return Colors.orange;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'Approved':
        return 'Success';
      case 'Delivered':
        return 'Delivered';
      case 'Pending':
      default:
        return 'Pending';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
        onItemTapped: (index) {
          // handle tab switch
        },
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
                child: ListView.builder(
                  itemCount: controller.orders.length,
                  itemBuilder: (_, index) {
                    final order = controller.orders[index];

                    // Skip orders not matching selected tab
                    if (order['status'] != controller.selectedTab.value) {
                      return const SizedBox.shrink();
                    }

                    // Address formatting (optional)
                    String address = order['address'] ?? '';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  order['image']!,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(order['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(order['phone']!),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: getStatusBackgroundColor(order['status']!),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      getStatusText(order['status']!),
                                      style: TextStyle(
                                        color: getStatusTextColor(order['status']!),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: "Home: ",
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: order['address'] ?? '',
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
                    );
                  },


                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
