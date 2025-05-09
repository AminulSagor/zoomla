import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/custom_text_field_widget.dart';
import 'change_pass_controller.dart';

class ChangePassView extends StatelessWidget {
  ChangePassView({super.key});
  final controller = Get.put(ChangePassController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 262.h,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Transform.translate(
                      offset: Offset(0, -30.h),
                      child: Transform.scale(
                        scale: 1.2,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: Image.asset(
                            'assets/png/header_background_second.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 250.h,
                  width: double.infinity,
                  child: Transform.translate(
                    offset: Offset(0, -30.h),
                    child: Transform.scale(
                      scale: 1.2,
                      child: Image.asset(
                        'assets/png/header_background.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -10.h,
                  left: 0,
                  right: 20,
                  child: Center(
                    child: Image.asset('assets/png/logo.png', height: 250.h),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/signup', arguments: {'isLogin': true});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5AB2FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: const Text("Log In"),
            ),
            SizedBox(height: 16.h),
            Text(
              "New Password",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
              child: Text(
                "Your new password must be at least 8 characters long, including one uppercase letter, number, and symbol.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Obx(
                    () => CustomTextField(
                      hint: "Create A Password",
                      isPassword: true,
                      isHidden: controller.isNewPasswordHidden.value,
                      toggleVisibility: controller.toggleNewPasswordVisibility,
                      controller: controller.newPasswordController,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(
                    () => CustomTextField(
                      hint: "Confirm Password",
                      isPassword: true,
                      isHidden: controller.isConfirmPasswordHidden.value,
                      toggleVisibility:
                          controller.toggleConfirmPasswordVisibility,
                      controller: controller.confirmPasswordController,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),
            Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        controller.isButtonEnabled.value
                            ? controller.resetPassword
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.isButtonEnabled.value
                              ? const Color(0xFF5AB2FF)
                              : Colors.grey.shade300,
                      foregroundColor:
                          controller.isButtonEnabled.value
                              ? Colors.white
                              : Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text("Next", style: TextStyle(fontSize: 16.sp)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
