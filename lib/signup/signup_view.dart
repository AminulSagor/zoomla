import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jumla/signup/signup_controller.dart';

import '../forget_pass/forget_pass_view.dart';
import '../store_info_upload/store_info_view.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/otp_dialog_widgets.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});

  final controller = Get.put(SignUpController());


  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    if (args != null && args['isLogin'] == true) {
      controller.isLoginMode.value = true;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stack two background images
            Stack(
              children: [
                // Base background
                SizedBox(
                  height: 262.h,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Transform.translate(
                      offset: Offset(0, -30.h), // 🔼 move up by 30 pixels
                      child: Transform.scale(
                        scale: 1.2, // scale the image up
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


                // Front overlay wave
                SizedBox(
                  height: 250.h,
                  width: double.infinity,
                  child: Transform.translate(
                    offset: Offset(0, -30.h),
                    // 🔼 move image up by 30 logical pixels
                    child: Transform.scale(
                      scale: 1.2, // Zoom 20%
                      child: Image.asset(
                        'assets/png/header_background.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),


                // Logo on top
                Positioned(
                  bottom: -10.h,
                  left: 0,
                  right: 20,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/png/logo.png',
                        height: 250.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Toggle buttons
            Obx(() =>
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.isLoginMode.value = true;
                          controller
                              .validateForm(); // revalidate based on login fields
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isLoginMode.value ? Colors
                              .blue : Colors.white,
                          foregroundColor: controller.isLoginMode.value ? Colors
                              .white : Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        child: Text(
                            "Log In", style: TextStyle(fontSize: 16.sp)),
                      ),
                      SizedBox(width: 16.w),
                      OutlinedButton(
                        onPressed: () {
                          controller.isLoginMode.value = false;
                          controller
                              .validateForm(); // revalidate based on sign up fields
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: controller.isLoginMode.value ? Colors
                              .white : Colors.blue,
                          foregroundColor: controller.isLoginMode.value ? Colors
                              .blue : Colors.white,
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r)),
                        ),
                        child: Text(
                            "Sign Up", style: TextStyle(fontSize: 16.sp)),
                      ),
                    ],
                  ),
                )),


            SizedBox(height: 12.h),
            Text(
              "\"Manage your store, track sales, grow profits.\"",
              style: TextStyle(color: Colors.blue, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              "seller center",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
            ),
            SizedBox(height: 24.h),

            Obx(() =>
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.isLoginMode.value) ...[
                        CustomTextField(
                          hint: "Enter your mobile number",
                          keyboardType: TextInputType.phone,
                          controller: controller.phoneController,
                          errorText: controller.isPhoneTouched.value
                              ? controller.phoneError.value
                              : null,
                        ),
                        SizedBox(height: 12.h),
                      ],

                      if (!controller.isLoginMode.value) ...[
                        CustomTextField(
                          hint: "Enter your username",
                          controller: controller.usernameController,
                          errorText: controller.isUsernameTouched.value
                              ? controller.usernameError.value
                              : null,
                        ),
                        SizedBox(height: 12.h),
                      ],

                      CustomTextField(
                        hint: "Password",
                        isPassword: true,
                        controller: controller.passwordController,
                        isHidden: controller.isPasswordHidden.value,
                        toggleVisibility: controller.togglePasswordVisibility,
                        errorText: controller.isPasswordTouched.value
                            ? controller.passwordError.value
                            : null,
                      ),
                      SizedBox(height: 12.h),

                      if (!controller.isLoginMode.value) ...[
                        CustomTextField(
                          hint: "Confirm Password",
                          isPassword: true,
                          controller: controller.confirmPasswordController,
                          isHidden: controller.isConfirmPasswordHidden.value,
                          toggleVisibility: controller
                              .toggleConfirmPasswordVisibility,
                          errorText: controller.isConfirmPasswordTouched.value
                              ? controller.confirmPasswordError.value
                              : null,
                        ),
                        SizedBox(height: 12.h),
                      ],

                      if (!controller.isLoginMode.value)
                        CustomTextField(
                          hint: "Enter your mobile number",
                          keyboardType: TextInputType.phone,
                          controller: controller.phoneController,
                          errorText: controller.isPhoneTouched.value
                              ? controller.phoneError.value
                              : null,
                        ),

                      if (controller.isLoginMode.value)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => Get.to(() => ForgetPassView()),
                              child: Text(
                                "Forget Password?",
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 14.sp),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )),


            SizedBox(height: 24.h),
            Obx(() =>
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isFormValid.value
                          ? () {
                        if (controller.isLoginMode.value) {
                          controller.handleLogin();
                        } else {
                          controller.handleNext(context); // signup
                        }
                      }
                          : null,


                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5AB2FF),
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        "Next",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ),
                )),


          ],
        ),
      ),
    );
  }
}
