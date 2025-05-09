import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jumla/widgets/tooltip_card_with_arrow_widget.dart';

class EmailDonutChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      width: 180.w,
      child: Stack(
        children: [
          // Donut Chart
          PieChart(
            PieChartData(
              sectionsSpace: 4.w,
              centerSpaceRadius: 60.r,
              startDegreeOffset: -90,
              sections: [
                PieChartSectionData(color: Colors.blueAccent, value: 70, title: '', radius: 15.r),
                PieChartSectionData(color: Colors.lightBlue, value: 20, title: '', radius: 15.r),
                PieChartSectionData(color: Colors.cyan, value: 10, title: '', radius: 15.r),
              ],
            ),
          ),

          // Tooltip-style card positioned at bottom-right
          Positioned(
            right: 13.w,
            top: 50.h,
            child: TooltipCardWithArrow(label: "Read", value: "70%"),
          ),
        ],
      )

    );
  }
}
