import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'confirm_order_controller.dart';

class ConfirmOrderView extends StatelessWidget {
  final controller = Get.put(ConfirmOrderController());


  void showDeliveryChargeDialog(BuildContext context) {
    final chargeController = TextEditingController(text: controller.deliveryCharge.value.toString());

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFFF0F8FF), // light blue like in your image
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.close),
              ),
              const Text("Write the delivery charge", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              TextField(
                controller: chargeController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.deliveryCharge.value = double.tryParse(chargeController.text) ?? 0.0;

                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5AB2FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text("Update"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  void showApprovalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFFF0F8FF), // Light blue
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.close),
              ),
              const SizedBox(height: 12),
              const Text(
                "If you want to sell your product then press approve,\notherwise click cancel. It will automatically be canceled.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Perform approve logic here
                      Get.back(); // close the dialog
                      Get.snackbar("Order", "Product Approved", snackPosition: SnackPosition.BOTTOM);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5AB2FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text("Approve"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirmation Order", style: TextStyle(color: Colors.black)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("12/05/2024", style: TextStyle(color: Colors.black)),
              ],
            ),

            // User Info
            Column(
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/png/world_map.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.h),
                          Text("Fouzia Hussain", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("+88016744839"),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                SizedBox(height: 8.h),
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: const TextSpan(
                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                    children: [
                      TextSpan(text: 'Home: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'Al-Madani Tower, Level-6, Mirboxtula, Sylhet'),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),
            const Divider(),

            // Product List
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.products.length,
                itemBuilder: (_, i) {
                  final product = controller.products[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            product['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(product['brand']),
                              Text('\$${product['price']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 60,
                          child: Text('Qty: ${product['qty']}'),
                        ),
                      ],
                    ),
                  );
                },
              )),
            ),

            // Bottom Summary Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFB5BABF), // light grey-blue background
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Center(
                    child: Text(
                      'Sub Total : \$${controller.subTotal.value}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  )),
                  const SizedBox(height: 12),

                  // Delivery Label
                  Row(
                    children: const [
                      Flexible(child: Text('Delivery', style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(width: 8),
                      Icon(Icons.local_shipping),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Delivery Time Input
                  Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(text: controller.deliveryTime.value),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );

                              if (pickedDate != null) {
                                final formatted = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                controller.deliveryTime.value = formatted;
                              }
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Delivery date',
                              icon: Icon(Icons.edit),
                            ),
                          ),

                        ),
                        GestureDetector(
                          onTap: () => showDeliveryChargeDialog(context),
                          child: Text(
                            'charge : \$${controller.deliveryCharge.value}',
                            style: const TextStyle(fontWeight: FontWeight.w500, decoration: TextDecoration.underline),
                          ),
                        ),

                      ],
                    ),
                  )),

                  const SizedBox(height: 16),

                  // Total + Update Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Expanded(
                        child: Text(
                          'Total : \$${controller.total}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5AB2FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        onPressed: () => showApprovalDialog(context),
                        child: const Text('Update', style: TextStyle(fontSize: 16)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
