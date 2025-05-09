import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../services/auth_service.dart';

class ChangePassController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isButtonEnabled = false.obs;
  var isLoading = false.obs;

  late String phone;
  late String otp;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    phone = args['phone'];
    otp = args['otp'];

    newPasswordController.addListener(_validate);
    confirmPasswordController.addListener(_validate);
  }

  void _validate() {
    isButtonEnabled.value =
        newPasswordController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty &&
            newPasswordController.text == confirmPasswordController.text;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> resetPassword() async {
    isLoading.value = true;

    try {
      final result = await AuthService.resetPassword(
        phone: phone,
        password: newPasswordController.text,
        otp: otp,
      );

      if (result['status'] == 'success') {
        Get.snackbar("Success", result['message'] ?? "Password changed successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed('/login');
      } else {
        Get.snackbar("Error", result['message'] ?? "Failed to reset password",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
