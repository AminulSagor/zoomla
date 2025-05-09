import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final int maxLines;
  final bool? isHidden; // controls password visibility
  final VoidCallback? toggleVisibility;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.hint,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.maxLines = 1,
    this.isHidden,
    this.toggleVisibility,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final showPassword = isPassword && (isHidden ?? true);

    return Padding(
      padding: EdgeInsets.only(bottom: errorText != null ? 4.h : 12.h),
      child: TextField(
        controller: controller,
        obscureText: showPassword,
        keyboardType: keyboardType,
        maxLines: isPassword ? 1 : maxLines,
        decoration: InputDecoration(
          hintText: hint,
          errorText: errorText,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              showPassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: toggleVisibility,
          )
              : null,
        ),
      ),
    );
  }
}
