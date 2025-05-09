import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../widgets/otp_dialog_widgets.dart';
import 'forget_pass_controller.dart';
import '../widgets/custom_text_field_widget.dart';

class ForgetPassView extends StatelessWidget {
  ForgetPassView({super.key});
  final controller = Get.put(ForgetPassController());


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
                    child: Image.asset(
                      'assets/png/logo.png',
                      height: 250.h,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5AB2FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 10.h),
              ),
              child: Text("Log In", style: TextStyle(fontSize: 16.sp)),
            ),

            SizedBox(height: 24.h),
            Text("Forget Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Text(
                "To reset your password, enter your mobile number, verify with an otp, and create a new password.",
                style: TextStyle(fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomTextField(
                    hint: "Enter your mobile number",
                    keyboardType: TextInputType.phone,
                    controller: controller.phoneController,
                  ),
                  SizedBox(height: 6.h),
                  GestureDetector(
                    onTap: () {}, // add help handler
                    child: Text(
                      "Need Helps?",
                      style: TextStyle(color: Colors.blue, fontSize: 13.sp),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),
            Obx(() => Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),

              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    onPressed: controller.isButtonEnabled.value
                        ? () => controller.sendOtpAndShowDialog(context)
                        : null,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.disabled)) {
                          return Colors.grey.shade300;
                        }
                        return const Color(0xFF5AB2FF);
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: const Text("Next"),
                ),
              ),
            ))

          ],
        ),
      ),
    );
  }
}
