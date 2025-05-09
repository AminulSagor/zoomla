import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jumla/product_upload/product_upload_controller.dart';


class ProductUploadView extends StatelessWidget {
  final controller = Get.put(ProductUploadController());

  ProductUploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Product', style: TextStyle(fontSize: 18.sp)),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            DottedBorder(
              color: Colors.grey,
              strokeWidth: 1.5,
              dashPattern: [6, 4],
              borderType: BorderType.RRect,
              radius: Radius.circular(8.r),
              child: Container(
                height: 160.h,
                width: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, size: 30.sp),
                    SizedBox(height: 4.h),
                    Text("Add Image", style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            buildInput(controller.productNameController, "Product Name"),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedCategory.value,
              decoration: InputDecoration(
                hintText: "Select Category",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              items: controller.categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (val) => controller.updateSubCategories(val),
            )),

            SizedBox(height: 12.h),

            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedSubCategory.value,
              decoration: InputDecoration(
                hintText: "Select Sub-Category",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              items: controller.subCategories.map((String sub) {
                return DropdownMenuItem<String>(
                  value: sub,
                  child: Text(sub),
                );
              }).toList(),
              onChanged: (val) => controller.selectedSubCategory.value = val,
            )),
            SizedBox(height: 12.h),
            buildInput(controller.brandNameController, "Brand Name"),
            buildInput(controller.modelNameController, "Model Name"),
            buildInput(controller.priceController, "Price"),
            buildInput(controller.quantityController, "Quantity"),
            buildInput(controller.offerController, "Offer"),
            buildInput(controller.deliveryChargeController, "Delivery Charge"),
            buildInput(controller.minBulkPurchaseController, "Minimum Purchase for Bulk"),
            buildInput(controller.variantsController, "Product Variants (রঙ/সাইজ)"),
            buildInput(controller.tagsController, "Tags/Keywords"),
            buildInput(controller.stockStatusController, "Stock Status"),

            SizedBox(height: 8.h),
            TextFormField(
              controller: controller.descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Description",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
            ),
            SizedBox(height: 20.h),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle upload logic
                },
                child: Text("Upload", style: TextStyle(fontSize: 16.sp)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInput(TextEditingController ctrl, String hint) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      ),
    );
  }
}
