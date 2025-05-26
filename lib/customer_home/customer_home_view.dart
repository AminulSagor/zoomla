import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/customer_bottom_navigation_widget.dart';
import 'customer_home_controller.dart';

class CustomerHomePage extends StatelessWidget {
  final controller = Get.put(CustomerHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomerBottomNavigation(
        selectedIndex: 0,
        onTap: (index) {
          // Handle tab navigation here
        },
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Good Morning,", style: TextStyle(fontSize: 18)),
                    Text(
                      "Fouzia",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "📍 Sylhet, Bangladesh",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildIconBox(Icons.search),
                    const SizedBox(width: 12),
                    _buildIconBox(Icons.notifications_none),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 150,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/png/customer_home_head.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 6,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Limited Time!",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 45,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Get Special Offer",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        //const SizedBox(height: 4),
                        Transform.translate(
                          offset: const Offset(0, -8), // Negative Y moves it up
                          child: Row(
                            children: const [
                              SizedBox(width: 108),
                              Text(
                                "up to",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "40%",
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        "Get",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 2,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
              children:
                  controller.categories.map((item) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item['image']!,
                            width: 120,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['name']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),

            const SizedBox(height: 24),
            _buildSection("Flash Sale", controller.flashSale),
            const SizedBox(height: 24),
            _buildSection("Featured Products", controller.featuredProducts),
            const SizedBox(height: 24),
            _buildSection("Best Sales", controller.bestSales),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items) {
    bool isFlashSale = title == "Flash Sale";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + (optional) countdown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (isFlashSale)
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                        text: "Closing Time: ",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                    TextSpan(
                      text: "12 : 00 : 00",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            if (!isFlashSale)
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "see all",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            )
          ],
        ),

        const SizedBox(height: 12),

        // FlashSale filters only
        if (isFlashSale)
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _filterChip("All", isSelected: false),
                _filterChip("Popular", isSelected: true),
                _filterChip("Latest", isSelected: false),
                _filterChip("Oldest", isSelected: false),
                _filterChip("Headset", isSelected: false),
              ],
            ),
          ),

        if (isFlashSale) const SizedBox(height: 12),

        // Product cards
        SizedBox(
          height: isFlashSale ? 200 : 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) {
              final item = items[index];
              return Container(
                width: 170,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image + heart icon
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item['image'],
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.favorite_border, size: 16),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Title
                    Text(
                      item['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),

                    const SizedBox(height: 6),

                    // Rating + current price
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        const Text("4.5 Rating", style: TextStyle(fontSize: 12)),
                        const Spacer(),
                        Text(
                          "\$${item['price']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    // **Strikethrough old price** (for both sections)
                    const SizedBox(height: 6),
                    if (isFlashSale)
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "\$100",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // “see all” underlined with arrow for **all** non-Flash sections,
        // or you could show it always if desired
        if (isFlashSale)
          Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "see all",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }


}

Widget _buildIconBox(IconData icon) {
  return Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.07),
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: Center(child: Icon(icon, color: Colors.black)),
  );
}

Widget _filterChip(String label, {required bool isSelected}) {
  return Container(
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? Colors.blue.shade100 : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: isSelected ? Colors.blue : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
}
