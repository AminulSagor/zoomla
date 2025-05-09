import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../widgets/otp_dialog_widgets.dart';

class ForgetPassController extends GetxController {
  final phoneController = TextEditingController();
  var isButtonEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(() {
      isButtonEnabled.value = phoneController.text.trim().isNotEmpty;
    });
  }

  Future<void> sendOtpAndShowDialog(BuildContext context) async {
    final phone = phoneController.text.trim();

    try {
      final res = await AuthService.sendOtp(phone: phone, method: 'reset');

      if (res['status'] == 'success') {
        showDialog(
          context: context,
          builder: (_) => OtpVerificationDialog(
            phoneNumber: phone,
            onVerify: (otp) {
              Navigator.of(context).pop(); // close dialog
              Get.toNamed('/change-pass', arguments: {
                'phone': phone,
                'otp': otp,
              }); // navigate with phone + otp
            },
            onResend: () async {
              await AuthService.sendOtp(phone: phone, method: 'reset');
            },
          ),
        );
      } else {
        Get.snackbar("Error", res['message'] ?? "OTP sending failed",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }


  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
