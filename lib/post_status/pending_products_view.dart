import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'pending_product_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingProductsView extends StatelessWidget {
  final controller = Get.put(PendingProductController());

  PendingProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pendingProducts.isEmpty) {
          return const Center(child: Text("No pending products found"));
        }

        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.pendingProducts.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final product = controller.pendingProducts[index];
            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: product["product_image"] != null
                        ? Builder(
                      builder: (context) {
                        final imageUrl = product["product_image"];
                        return Image.network(
                          imageUrl,
                          width: 64.w,
                          height: 64.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 64.w,
                                height: 64.h,
                                color: Colors.grey[200],
                                child: Icon(Icons.image_not_supported,
                                    size: 32.w),
                              ),
                        );
                      },
                    )
                        : Container(
                      width: 64.w,
                      height: 64.h,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, size: 32.w),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product["product_name"] ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          formatDate(product["created_at"]),
                          style: TextStyle(
                              fontSize: 13.sp, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      "Pending",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  String formatDate(String rawDate) {
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
