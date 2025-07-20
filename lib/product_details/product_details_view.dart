import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'product_details_controller.dart';
import 'package:flutter/services.dart';


class ProductDetailsView extends StatelessWidget {
  ProductDetailsView({Key? key}) : super(key: key);


  void _showUpdateDialog(BuildContext context, ProductDetailsController controller) {
    final priceController = TextEditingController(text: controller.price.value);
    final stockValue = double.tryParse(controller.stock.value)?.toInt().toString() ?? '0';
    final stockController = TextEditingController(text: stockValue);


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock'),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // ✅ only allows whole numbers (0-9)
                ],
              ),

            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final price = priceController.text.trim();
                final stock = stockController.text.trim();

                if (price.isEmpty || stock.isEmpty) {
                  Get.snackbar("Error", "Price and Stock are required");
                  return;
                }

                controller.updateProduct(price: price, stock: stock);
              },
              child: const Text('Update'),
            ),

          ],
        );
      },
    );
  }


  Color _getColorFromName(String name) {
    switch (name.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'black':
        return Colors.black;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'yellow':
        return Colors.yellow;
      default:
        return Colors.grey; // fallback color
    }
  }

  @override
  Widget build(BuildContext context) {
    final String productId = Get.parameters['id'] ?? '';
    final controller = Get.find<ProductDetailsController>(tag: productId);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showUpdateDialog(context, controller),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Update",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),


      body: SafeArea(
        child: ListView(
          children: [
            // Top image + icons + thumbnails
            Stack(
              children: [
                // Main product image
                Obx(() {
                  final images = controller.images;
                  final index = controller.selectedImageIndex.value;

                  if (images.isEmpty || index >= images.length) {
                    return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return Center(
                    child: Image.network(
                      images[index],
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                    ),
                  );
                }),

                // Back button
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),

                // Favorite icon
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    // child: IconButton(
                    //   icon: const Icon(Icons.favorite_border),
                    //   onPressed: () {},
                    // ),
                  ),
                ),

                // Thumbnails with 4+ indicator
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Obx(() {
                    final thumbnails = controller.images;
                    final visibleThumbnails =
                        thumbnails.length > 4
                            ? thumbnails.take(3).toList()
                            : thumbnails;
                    final extraCount = thumbnails.length - 3;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          visibleThumbnails.asMap().entries.map((entry) {
                            int index = entry.key;
                            String image = entry.value;

                            bool isExtra =
                                thumbnails.length > 4 &&
                                index == 2; // last visible
                            bool isSelected =
                                controller.selectedImageIndex.value == index;

                            return GestureDetector(
                              onTap: () {
                                if (!isExtra) {
                                  controller.selectedImageIndex.value = index;
                                }
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? Colors.blue
                                                : Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child:
                                        image.startsWith('http')
                                            ? Image.network(
                                              image,
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.asset(
                                              image,
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                  if (isExtra)
                                    Positioned.fill(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          "+$extraCount",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Obx(
                    () => Text(
                      controller.productName.value,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            "item: ${controller.model.value}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(() {
                        final hasDiscount =
                            controller.discount.value.isNotEmpty &&
                            controller.discount.value != '0';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "\$${controller.discountPrice.value}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            if (hasDiscount)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "\$${controller.price.value}",
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "${controller.discount.value}%",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        );
                      }),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Obx(() {
                            final hasDiscount =
                                controller.discount.value.isNotEmpty;

                            final content =
                                Row(
                                      children: [

                                        Obx(() {
                                          final reviews = controller.reviews;

                                          if (reviews.isEmpty) {
                                            return const Text(
                                              "No rating yet",
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                            );
                                          }


                                          // Calculate average rating
                                          double totalRating = 0;
                                          for (var r in reviews) {
                                            totalRating += double.tryParse(r['rating']?.toString() ?? '0') ?? 0;
                                          }
                                          final avgRating = totalRating / reviews.length;

                                          return Row(
                                            children: [
                                              ...List.generate(5, (index) {
                                                final rounded = avgRating.round();
                                                return  Icon(
                                                  index < rounded ? Icons.star : Icons.star_border,
                                                  size: 18,
                                                  color: Colors.amber,
                                                );
                                              }),
                                              const SizedBox(width: 6),
                                              Text(
                                                "${avgRating.toStringAsFixed(1)} Rating",
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),




                                            ],
                                          );
                                        }),

                                      ],
                                    );

                            return Transform.translate(
                              offset:
                                  hasDiscount
                                      ? const Offset(0, -12)
                                      : Offset.zero,
                              child: content,
                            );
                          }),

                          Spacer(),

                          const Icon(Icons.store, size: 18, color: Colors.blue),
                          const SizedBox(width: 4),
                          Obx(
                            () => Text(
                              controller.storeName.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Obx(() {
                        final variants = controller.variants;
                        if (variants.isEmpty) {
                          return const SizedBox(); // or Text('No variants')
                        }

                        final variantText = variants.map((v) => v['variant']).join(', '); // M, L

                        return Text(
                          'Size: $variantText',
                          style: const TextStyle( fontWeight: FontWeight.w500),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Color section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Color",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Row(
                              children:
                                  controller.colors.map((colorItem) {
                                    final colorName = colorItem['color'] ?? '';
                                    final colorId = colorItem['id'] ?? '';
                                    final colorValue = _getColorFromName(
                                      colorName,
                                    );
                                    return _colorOption(colorId, colorValue);
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                      // Right: Availability and Quantity
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Obx(() {
                            final isOutOfStock = double.tryParse(controller.stock.value) == 0.0;

                            final isTapped =
                                controller.isOutOfStockTapped.value;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isTapped && isOutOfStock
                                        ? Colors.red.withOpacity(0.1)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text("Availability: ${double.tryParse(controller.stock.value)?.toInt() ?? 0} pcs",

                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                            );
                          }),



                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Obx(
                    () => ReadMoreText(
                      controller.description.value,
                      trimLines: 4,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' see more',
                      trimExpandedText: ' see less',
                      style: const TextStyle(color: Colors.black),
                      moreStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      lessStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    "Review",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    final reviews = controller.reviews;

                    if (reviews.isEmpty) return const Text("No reviews yet.");

                    return Column(
                      children:
                          reviews.map((review) {
                            final reviewerName =
                                review['reviewer_name'] ?? 'Anonymous';
                            final reviewerProfile =
                                review['reviewer_profile'] ?? '';
                            final reviewedImage =
                                review['reviewed_image'] ?? '';
                            final reviewText = review['review'] ?? '';
                            final rating = review['rating'] ?? '0';
                            final date =
                                '11/12/2024'; // Replace with real date if available

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Reviewer Info Row
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          reviewerProfile,
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) =>
                                                  const Icon(Icons.person),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              reviewerName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  size: 16,
                                                  color: Colors.amber,
                                                ),
                                                const SizedBox(width: 4),
                                                Text("$rating Rating"),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Text(date, style: const TextStyle(color: Colors.grey)),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.close, size: 18),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Review Text and Image Row
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text
                                      Expanded(
                                        child: ReadMoreText(
                                          reviewText,
                                          trimLines: 3,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: '...see more',
                                          trimExpandedText: ' see less',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          moreStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          lessStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Image
                                      if (reviewedImage.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            reviewedImage,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (_, __, ___) => const Icon(
                                                  Icons.broken_image,
                                                ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    );
                  }),

                  const SizedBox(height: 100),
                ],
              ),
            ), // space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _colorOption(String id, Color color) {
    final String productId = Get.parameters['id'] ?? '';
    final controller = Get.find<ProductDetailsController>(tag: productId);
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectedColor.value = id,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  controller.selectedColor.value == id
                      ? Colors.black
                      : Colors.grey,
            ),
          ),
          child: CircleAvatar(backgroundColor: color, radius: 8),
        ),
      ),
    );
  }
}
