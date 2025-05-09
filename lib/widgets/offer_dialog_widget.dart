import 'package:flutter/material.dart';

class OfferDialog extends StatefulWidget {
  const OfferDialog({super.key});

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
                onPressed: () {
                  Navigator.pop(context);
                  print("Confirmed %: ${percentController.text}");
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
                onPressed: () {
                  Navigator.pop(context);
                  print("Confirmed Bulk: Q=${quantityController.text}, P=${bulkPriceController.text}");
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
