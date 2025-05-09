import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'store_info_controller.dart';
import '../widgets/custom_text_field_widget.dart'; // ✅ import reused text field

class StoreInfoView extends StatelessWidget {
  StoreInfoView({super.key});
  final controller = Get.put(StoreInfoController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;

    final String username = args['username'];
    final String phone = args['phone'];
    final String password = args['password'];
    final String otp = args['otp'];

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            OutlinedButton(
              onPressed: () {

              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text("Sign Up", style: TextStyle(fontSize: 16.sp)),
            ),

            SizedBox(height: 16.h),
            // ✅ Cover + Profile image stacked
            Stack(
              clipBehavior: Clip.none,
              children: [
                // 📷 Cover Photo Upload
                GestureDetector(
                  onTap: controller.pickCoverImage,
                  child: Obx(() {
                    final image = controller.coverImage.value;

                    // ✅ If image is selected, show plain container with image only
                    if (image != null) {
                      return Container(
                        height: 120.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          image: DecorationImage(
                            image: FileImage(image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }

                    // 🔲 If no image, show dotted border
                    return DottedBorder(
                      dashPattern: [6, 4],
                      borderType: BorderType.RRect,
                      radius: Radius.circular(12.r),
                      color: Colors.grey,
                      strokeWidth: 1.2,
                      child: Container(
                        height: 120.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: Colors.grey[100],
                        ),
                        child: const SizedBox.shrink(),
                      ),
                    );
                  }),
                ),


                // 🧑 Profile Photo (floating)
                Positioned(
                  bottom: -60.h, // Pull up to overlap
                  left: 16.w,    // Push to left
                  child: Obx(() {
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: controller.pickProfileImage,
                          child: CircleAvatar(
                            radius: 50.r,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: controller.profileImage.value != null
                                ? FileImage(controller.profileImage.value!)
                                : null,
                            child: controller.profileImage.value == null
                                ? const Icon(Icons.person, size: 40)
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: controller.pickProfileImage,
                            child: Image.asset(
                              'assets/png/camera_plus_icon.png',
                              height: 28.w,
                              width: 28.w,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),




            SizedBox(height: 90.h),
            CustomTextField(
              hint: "Enter your store name",
              controller: controller.storeNameController,
            ),
            SizedBox(height: 2.h),
            Obx(() {
              final selected = controller.selectedIdType.value;

              if (selected.isEmpty) {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select ID Type",
                  ),
                  value: null,
                  items: controller.idTypes
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      controller.selectedIdType.value = val;
                      controller.validateForm();
                    }
                  },
                );
              } else {
                return TextField(
                  controller: controller.crNumberController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter your $selected",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_drop_down),
                      onPressed: () {
                        controller.selectedIdType.value = ''; // reset to dropdown
                        controller.crNumberController.clear(); // optional
                        controller.validateForm();
                      },
                    ),
                  ),
                );
              }
            }),

            SizedBox(height: 12.h),
            Obx(() {
              return DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "What type of store it is",
                ),
                value: controller.selectedStoreType.value.isEmpty
                    ? null
                    : controller.selectedStoreType.value,
                items: controller.storeTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) controller.selectedStoreType.value = val;
                },
              );
            }),
            SizedBox(height: 12.h),
            CustomTextField(
              hint: "Store address",
              controller: controller.addressController,
            ),
            SizedBox(height: 2.h),
            CustomTextField(
              hint: "Describe about your store",
              controller: controller.descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: 5, // 👈 Make it visually taller
            ),

            SizedBox(height: 24.h),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: controller.isFormValid.value
                    ? () {
                  controller.submitSellerRegistration(
                    username,
                    phone,
                    password,
                    otp,
                  );
                }
                    : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey.shade300;
                      }
                      return const Color(0xFF5AB2FF); // Enabled color
                    },
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.white;
                    },
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                child: const Text("Next"),
              ),
            )),


          ],
        ),
      ),
    );
  }
}
