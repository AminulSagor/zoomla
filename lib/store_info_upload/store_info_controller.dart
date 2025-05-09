import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';
import '../signup/signup_view.dart';

class StoreInfoController extends GetxController {
  final storeNameController = TextEditingController();
  final crNumberController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();

  var selectedStoreType = ''.obs;
  var storeTypes = ['Clothing', 'Electronics', 'Grocery', 'Other'];
  var coverImage = Rxn<File>();
  var profileImage = Rxn<File>();

  var isFormValid = false.obs; // ✅
  var isSubmitting = false.obs;

  final ImagePicker picker = ImagePicker();

  var selectedIdType = ''.obs;
  var idTypes = ['CR', 'Civil ID', 'Passport'];


  @override
  void onInit() {
    super.onInit();
    storeNameController.addListener(validateForm);
    crNumberController.addListener(validateForm);
    addressController.addListener(validateForm);
    descriptionController.addListener(validateForm);
    ever(selectedStoreType, (_) => validateForm());
  }

  void validateForm() {
    isFormValid.value =
        storeNameController.text.isNotEmpty &&
            selectedIdType.value.isNotEmpty &&
            addressController.text.isNotEmpty &&
            descriptionController.text.isNotEmpty &&
            selectedStoreType.value.isNotEmpty;
  }

  Future<void> pickCoverImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      coverImage.value = File(picked.path);
    }
  }

  Future<void> pickProfileImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage.value = File(picked.path);
    }
  }

  Future<void> submitSellerRegistration(String name, String phone, String password, String otp) async {
    if (coverImage.value == null || profileImage.value == null) {
      Get.snackbar("Error", "Please upload both cover and profile images");
      return;
    }

    try {
      isSubmitting.value = true;

      final result = await AuthService().registerSeller(
        name: name,
        phone: phone,
        password: password,
        storeName: storeNameController.text.trim(),
        storeType: selectedStoreType.value,
        regNum: crNumberController.text.trim(),
        regType: selectedIdType.value.toLowerCase(), // ensure lowercase as in example
        storeAddress: addressController.text.trim(),
        description: descriptionController.text.trim(),
        profileImage: profileImage.value!,
        coverImage: coverImage.value!,
        otp: otp,
      );

      if (result['status'] == 'success') {
        Get.snackbar("Success", result['message']);
        Get.offAll(() => SignUpView(), arguments: {'isLogin': true});
      } else {
        Get.snackbar("Failed", result['message']);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    storeNameController.dispose();
    crNumberController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
