import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../routes.dart';
import '../services/auth_service.dart';

class OtpVerificationDialog extends StatefulWidget {
  final String phoneNumber;
  final String? username;
  final String? password;
  final void Function(String otp) onVerify;
  final VoidCallback onResend;

  const OtpVerificationDialog({
    super.key,
    required this.phoneNumber,
    this.username,
    this.password,
    required this.onVerify,
    required this.onResend,
  });

  @override
  State<OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
  final List<TextEditingController> _controllers =
  List.generate(5, (_) => TextEditingController());
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  String get _enteredOtp => _controllers.map((c) => c.text).join().trim();

  void _verifyOtp() async {
    if (_enteredOtp.length != 5 || _isVerifying) return;

    setState(() => _isVerifying = true);

    try {
      final result = await AuthService().verifyOtp(
        phone: widget.phoneNumber,
        otp: _enteredOtp,
      );


      if (result['status'] == 'success') {

          widget.onVerify(_enteredOtp);


      } else {
        _showError(result['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      print("ki sommossa $e");
      _showError('Something went wrong. Please try again.');
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _resendOtp() {
    widget.onResend();
    _startCountdown();
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("OTP Verification Code",
                style:
                TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Text(
              "A 5 digits OTP has been \nsent to your mobile ${widget.phoneNumber}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                return SizedBox(
                  width: 45.w,
                  height: 45.h,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(8.r),
                    dashPattern: [10, 3],
                    color: Colors.grey,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                       // color: index == 0 ? const Color(0xFF5AB2FF) : null,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: TextField(
                        controller: _controllers[index],
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        autofocus: index == 0,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          //color: index == 0 ? Colors.white : Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (val) {
                          if (val.isNotEmpty && index < 4) {
                            FocusScope.of(context).nextFocus();
                          }
                          if (_enteredOtp.length == 5) {
                            _verifyOtp();
                          }
                        },
                      ),
                    ),
                  ),
                );
              }),
            ),
            if (_isVerifying) ...[
              SizedBox(height: 16.h),
              const CircularProgressIndicator(),
            ],
            SizedBox(height: 16.h),
            RichText(
              text: TextSpan(
                text: "Didn’t Receive OTP? ",
                style: TextStyle(color: Colors.black, fontSize: 14.sp),
                children: [
                  TextSpan(
                    text: "RESEND OTP",
                    style: TextStyle(
                      color: _canResend ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: _canResend
                        ? (TapGestureRecognizer()..onTap = _resendOtp)
                        : null,
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "You Can Resend Code In $_secondsRemaining S",
              style: TextStyle(fontSize: 13.sp),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () {
                // Add help logic here
              },
              child: Text(
                "Need Help?",
                style: TextStyle(color: Colors.blue, fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
