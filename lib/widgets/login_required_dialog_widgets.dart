import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoginRequiredDialog() {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      title: Row(
        children: const [
          Icon(Icons.lock_outline, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            "Authentication Required",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: const Text(
        "You need to log in or sign up to access this feature.",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
      actionsPadding: const EdgeInsets.only(right: 12, bottom: 8),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // close dialog
            Get.toNamed('/signup', arguments: {'isLogin': true});
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
          child: const Text(
            "Log In",
            style: TextStyle(fontSize: 15),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back(); // close dialog
            Get.toNamed('/signup', arguments: {'isLogin': false});
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ],
    ),
    barrierDismissible: true,
  );
}
