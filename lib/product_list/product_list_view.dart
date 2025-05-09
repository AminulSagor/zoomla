import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jumla/product_list/product_list_controller.dart';

import '../widgets/offer_dialog_widget.dart';

class ProductListView extends StatelessWidget {
  final controller = Get.put(ProductListController());

  ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            SizedBox(height: 40.h), // Top spacing (status bar)
            Row(
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Icon(Icons.arrow_back, size: 24.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: controller.filterProducts,
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //SizedBox(height: 16.h),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.filteredProducts.length,
                itemBuilder: (_, index) {
                  final product = controller.filteredProducts[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: ProductItemTile(product: product),
                  );
                },
              )),
            )
          ],
        ),
      ),
    );
  }

}

class ProductItemTile extends StatelessWidget {
  final Map<String, String> product;

  const ProductItemTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            product['image']!,
            width: 64.w,
            height: 64.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 10.w),

        /// Middle: Expanded to avoid overflow
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product['title']!,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              GestureDetector(
                onTap: () {
                  // Navigate to details
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Text("View Details",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp)),
                      SizedBox(width: 4.w),
                      Icon(Icons.arrow_right_alt_outlined, size: 18.sp),
                    ],
                  ),
                ),
              ),
              Text("May 29, 2025 At 9:00 AM",
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
            ],
          ),
        ),

        SizedBox(width: 8.w),

        /// Right: Button
        GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (_) => const OfferDialog(),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text("Add Offer", style: TextStyle(fontSize: 12.sp)),
          ),
        ),

      ],
    );
  }
}
