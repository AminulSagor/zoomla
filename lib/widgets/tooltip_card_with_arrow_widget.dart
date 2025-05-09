import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TooltipCardWithArrow extends StatelessWidget {
  final String label;
  final String value;

  const TooltipCardWithArrow({
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: 110.w, // ✅ increased card width
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                Text(value, style: TextStyle(fontSize: 14.sp)),
              ],
            ),
          ),
        ),

        // Triangle pointer
        Transform.translate(
          offset: Offset(-8.w, 0), // ✅ tweak for better alignment if needed
          child: ClipPath(
            clipper: BottomTriangleClipper(),
            child: Container(
              height: 10.h,
              width: 20.w,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class BottomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width - 6.w, 10.h);
    path.lineTo(size.width - 12.w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
