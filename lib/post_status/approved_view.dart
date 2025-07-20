import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/offer_dialog_widget.dart';
import 'approved_product_controller.dart';

class ApprovedProductsView extends StatelessWidget {
  final controller = Get.put(ApprovedProductController());

  ApprovedProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: const BackButton(),
        title: Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                const Icon(Icons.search, size: 20),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    onChanged: controller.filterProducts,
                    decoration: const InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = controller.filteredProducts;

        if (products.isEmpty) {
          return const Center(child: Text("No approved products found"));
        }

        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: products.length,
          separatorBuilder: (_, __) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final product = products[index];
            final imageUrl = product["product_image"];


            return GestureDetector(
              onTap: () {
                final productId = product["id"].toString();
                Get.toNamed('/product-details/$productId');
              },
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: imageUrl != null
                          ? Image.network(
                        imageUrl,
                        width: 64.w,
                        height: 64.h,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholderImage(),
                      )
                          : _placeholderImage(),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            product["product_name"] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                'View Details',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(Icons.arrow_right_alt, size: 18.w),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _formatDate(product["created_at"]),
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => OfferDialog(productId: int.parse(product["id"])),
                          );
                        },
                        child: Text(
                          "Add Offer",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 64.w,
      height: 64.h,
      color: Colors.grey[200],
      child: Icon(Icons.image, size: 32.w, color: Colors.grey),
    );
  }

  String _formatDate(String rawDate) {
    try {
      final dt = DateTime.parse(rawDate);
      final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
      final suffix = dt.hour >= 12 ? "pm" : "am";
      return "${_monthName(dt.month)} ${dt.day}, ${dt.year}  At ${hour}:${dt.minute.toString().padLeft(2, '0')} $suffix";
    } catch (_) {
      return rawDate;
    }
  }

  String _monthName(int month) {
    const names = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return names[month];
  }
}
