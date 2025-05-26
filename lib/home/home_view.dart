import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../components/bottom_navbar.dart';
import '../widgets/email_donut_chart.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/png/header_home.png',
                    width: 1.sw,
                    height: 230.h, // Increase this value to make it bigger
                    fit: BoxFit.cover,
                  ),

                  Positioned(
                    top: 1.h,
                    child: Image.asset(
                      'assets/png/logo.png',
                      width: 300.w,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ActionCard(icon: Icons.list_alt, label: 'Pending',onTap: () => Get.toNamed('/pending-product')),
                    _ActionCard(
                      icon: Icons.add,
                      label: 'Create Post',
                      onTap: () => Get.toNamed('/product-upload'),
                    ),
                    _ActionCard(icon: Icons.check_circle, label: 'Approve',onTap: () => Get.toNamed('/approved-product')),
                  ],
                ),

              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Email And Transaction",
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 24.sp,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),

              //SizedBox(height: 12.h),

              EmailDonutChart(),

              //SizedBox(height: 20.h),
              _DashboardStats(),
              SizedBox(height: 80.h), // Space for bottom navbar
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: controller.selectedIndex.value,
          onItemTapped: controller.onTabTapped,
        ),
      );
    });
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // <-- add this

  const _ActionCard({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // <-- use it here
      borderRadius: BorderRadius.circular(8.r),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white,
        child: Container(
          width: 100.w,
          height: 60.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20.sp, color: Colors.black87),
                Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _DashboardStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      {'label': 'Total Sale', 'value': '\$5645'},
      {'label': 'Visitor', 'value': '5645'},
      {'label': 'New Orders', 'value': '\$5645'},
      {'label': 'Customers', 'value': '5645'},
      {'label': 'Review', 'value': '645'},
      {'label': 'Cancel', 'value': '0'},
    ];

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Wrap(
        spacing: 16.w,
        runSpacing: 16.h,
        alignment: WrapAlignment.center,
        children: items.map((item) {
          return Material(
            elevation: 8, // Increased elevation for deeper shadow
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: 170.w,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  Text(
                    item['label']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item['value']!,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

