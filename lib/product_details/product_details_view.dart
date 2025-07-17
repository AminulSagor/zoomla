import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'product_details_controller.dart';

class ProductDetailsView extends StatelessWidget {
  final controller = Get.put(ProductDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
        child: ElevatedButton.icon(
          onPressed: () {
            // Handle update action
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Colors.lightBlueAccent,
          ),

          label: Text(
            "Update",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
                Obx(
                  () => Center(
                    child: Image.asset(
                      controller.images[controller.selectedImageIndex.value],
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

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
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                  ),
                ),

                // Thumbnails with 4+ indicator
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Obx(() {
                    final thumbnails = controller.images;
                    final visibleThumbnails = thumbnails.take(4).toList();

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          visibleThumbnails.asMap().entries.map((entry) {
                            int index = entry.key;
                            String image = entry.value;
                            bool isLast = index == visibleThumbnails.length - 1;

                            return GestureDetector(
                              onTap:
                                  () =>
                                      controller.selectedImageIndex.value =
                                          index,
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
                                            controller
                                                        .selectedImageIndex
                                                        .value ==
                                                    index
                                                ? Colors.blue
                                                : Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(
                                      image,
                                      width: 48,
                                      height: 48,
                                    ),
                                  ),
                                  if (isLast)
                                    Positioned.fill(
                                      child: Center(
                                        child: Text(
                                          "4+",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            shadows: [
                                              Shadow(
                                                color: Colors.white.withOpacity(
                                                  0.8,
                                                ),
                                                blurRadius: 6,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
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
                  const Text(
                    "Foldable Bluetooth Over Ear Headphone With Wireless Noise Cancelling.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT SIDE: Column with Item ID, stars, and review
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Item: 564jd3",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.amber,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.amber,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.amber,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.amber,
                                  ),
                                  Icon(
                                    Icons.star_half,
                                    size: 18,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "4.5 Rating",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Write a review",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 10.w),
                          Transform.translate(
                            offset: const Offset(
                              5,
                              4,
                            ), // X: 0 (no horizontal shift), Y: -4 (upward)
                            child: Text(
                              "\$100",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          Row(
                            children: [
                              _colorOption("blue", Colors.blue),
                              _colorOption("purple", Colors.purple),
                              _colorOption("black", Colors.deepPurple.shade900),
                            ],
                          ),
                        ],
                      ),
                      // Right: Availability and Quantity
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Availability: In Stock",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                "Quantity: ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Obx(
                                () => DropdownButton<int>(
                                  value: controller.quantity.value,
                                  onChanged:
                                      (value) =>
                                          controller.quantity.value = value!,
                                  items: List.generate(
                                    5,
                                    (i) => DropdownMenuItem(
                                      value: i + 1,
                                      child: Text(
                                        "${i + 1}",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    "Lorem ipsum is simply dummy text of the printing and typesetting industry. "
                    "Lorem ipsum has been the industry's standard dummy text ever since the 1500s...",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Suggested Products",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  Obx(
                    () => SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.suggestedProducts.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final item = controller.suggestedProducts[i];
                          final String name = item['name'] as String;
                          final String image = item['image'] as String;
                          final int price = item['price'] as int;

                          return Container(
                            width: 170,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        image,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Icon(Icons.close, size: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(

                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text("4.5 Rating"),
                                    const Spacer(),
                                    Text(
                                      "\$$price",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Review",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/png/headphone.png',
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Fouzia Hussain",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.star, size: 14, color: Colors.amber),
                                      SizedBox(width: 4),
                                      Text("4.5 Rating"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Text("11/12/2024", style: TextStyle(color: Colors.grey)),
                            const SizedBox(width: 8),
                            const Icon(Icons.close, size: 18),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text.rich(
                          TextSpan(
                            text:
                            "Lorem ipsum is simply dummy text of the printing and typesetting industry. "
                                "Lorem ipsum has been the industry's standard dummy text ever since the, but also the leap into electronic typesetting, remaining essentially unchanged....",
                            children: [
                              TextSpan(
                                text: "see more",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ), // space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _colorOption(String name, Color color) {
    final controller = Get.find<ProductDetailsController>();
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectedColor.value = name,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  controller.selectedColor.value == name
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



