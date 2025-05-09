import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes.dart';
import '../services/auth_service.dart';
import '../storage/token_storage.dart';
import '../store_info_upload/store_info_view.dart';
import '../utils/validators.dart';
import '../widgets/otp_dialog_widgets.dart';


class SignUpController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  var isLoginMode = false.obs;

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;


  var usernameError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();
  var phoneError = RxnString();

  var isUsernameTouched = false.obs;
  var isPasswordTouched = false.obs;
  var isConfirmPasswordTouched = false.obs;
  var isPhoneTouched = false.obs;



  var isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();

    usernameController.addListener(() {
      isUsernameTouched.value = true;
      validateForm();
    });

    passwordController.addListener(() {
      isPasswordTouched.value = true;
      validateForm();
    });

    confirmPasswordController.addListener(() {
      isConfirmPasswordTouched.value = true;
      validateForm();
    });

    phoneController.addListener(() {
      isPhoneTouched.value = true;
      validateForm();
    });
  }


  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void validateForm() {
    if (!isLoginMode.value) {
      if (isUsernameTouched.value) {
        usernameError.value = Validators.validateUsername(usernameController.text);
      }

      if (isConfirmPasswordTouched.value) {
        confirmPasswordError.value = Validators.validateConfirmPassword(
          passwordController.text,
          confirmPasswordController.text,
        );
      }
    }

    if (isPasswordTouched.value) {
      passwordError.value = Validators.validatePassword(passwordController.text);
    }

    if (isPhoneTouched.value) {
      phoneError.value = Validators.validatePhone(phoneController.text);
    }

    // isFormValid should always be checked regardless of touch
    final usernameValid = isLoginMode.value || Validators.validateUsername(usernameController.text) == null;
    final confirmPasswordValid = isLoginMode.value || Validators.validateConfirmPassword(
      passwordController.text,
      confirmPasswordController.text,
    ) == null;
    final passwordValid = Validators.validatePassword(passwordController.text) == null;
    final phoneValid = Validators.validatePhone(phoneController.text) == null;

    isFormValid.value = usernameValid && confirmPasswordValid && passwordValid && phoneValid;
  }


  Future<void> handleNext(BuildContext context) async {
    final phone = phoneController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    try {
      final res = await AuthService.sendOtp(phone: phone, method: 'signup');

      if (res['status'] == 'success') {
        showDialog(
          context: context,
          builder: (_) => OtpVerificationDialog(
            phoneNumber: phone,
            username: username, // ✅ add this
            password: password, // ✅ add this
            onVerify: (otp) {
              Navigator.of(context).pop();
              Get.offAllNamed(AppRoutes.storeInfoUp, arguments: {
                'username': username,
                'phone': phone,
                'password': password,
                'otp': otp,
              });
            },
            onResend: () async {
              await AuthService.sendOtp(phone: phone, method: 'signup');
            },
          ),
        );
      } else {
        Get.snackbar("Error", res['message'] ?? "OTP request failed",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> handleLogin() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    try {
      final res = await AuthService().loginSeller(phone: phone, password: password);

      if (res['status'] == 'success') {
        final token = res['user']['token'];
        await TokenStorage.saveToken(token);

        Get.snackbar("Success", "Login successful");
        // Navigate to home or dashboard
        // Example:
        // Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.snackbar("Login Failed", res['message'] ?? "Unknown error",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }



  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
