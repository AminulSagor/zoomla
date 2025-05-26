import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../offer/offer_service.dart';
import '../storage/token_storage.dart';

class OfferDialog extends StatefulWidget {

  final int productId;
  const OfferDialog({super.key, required this.productId});


  @override
  State<OfferDialog> createState() => _OfferDialogState();
}

class _OfferDialogState extends State<OfferDialog> {
  int step = 0;
  String offerType = '';
  final percentController = TextEditingController();
  final quantityController = TextEditingController();
  final bulkPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF1F8FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (step > 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => setState(() => step--),
                  )
                else
                  const SizedBox(width: 48),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (step == 0) ...[
              const Text("What type of offer would you like to include?",
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      offerType = 'percentage';
                      setState(() => step = 1);
                    },
                    child: const Text("Percentage Discount"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      offerType = 'bulk';
                      setState(() => step = 1);
                    },
                    child: const Text("Bulk Discount"),
                  ),
                ],
              )
            ] else if (offerType == 'percentage') ...[
              const Text("What Is The Discount Percentage?"),
              const SizedBox(height: 16),
              TextField(
                controller: percentController,
                decoration: InputDecoration(
                  hintText: "Fill The Percentage",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),

                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final token = await TokenStorage.getToken(); // import your token utility
                  final response = await OfferService.addOffer(
                    token: token!,
                    productId: widget.productId,
                    discount: int.parse(percentController.text),
                    minimumPurchase: 1,
                  );
                  Navigator.pop(context);
                  Get.snackbar("Status", response['message'] ?? 'Offer submitted');
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Confirm"),
              ),

            ] else ...[
              const Text("What Is The Bulk Discount?"),
              const SizedBox(height: 16),
              Row(
                children: [
                  Flexible(
                    flex: 2, // More space
                    child: TextField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        hintText: "Minimum Quantity",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 1, // Less space
                    child: TextField(
                      controller: bulkPriceController,
                      decoration: InputDecoration(
                        hintText: "Price",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final token = await TokenStorage.getToken();
                  final response = await OfferService.addOffer(
                    token: token!,
                    productId: widget.productId,
                    discount: int.parse(bulkPriceController.text),
                    minimumPurchase: int.parse(quantityController.text),
                  );
                  Navigator.pop(context);
                  Get.snackbar("Status", response['message'] ?? 'Offer submitted');
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // button color
                  foregroundColor: Colors.white, // text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Confirm"),
              ),

            ],
          ],
        ),
      ),
    );
  }
}
