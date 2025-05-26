import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jumla/product_upload/product_upload_controller.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class ProductUploadView extends StatelessWidget {
  final controller = Get.put(ProductUploadController());

  ProductUploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('Upload Product', style: TextStyle(fontSize: 18.sp)),
              leading: BackButton(),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Obx(() {
                    final images = controller.pickedImages;

                    if (images.isEmpty) {
                      return GestureDetector(
                        onTap: controller.pickImage,
                        child: DottedBorder(
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
                                Text(
                                  "Add Image",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (images.length == 1) {
                      return Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.file(
                                images[0],
                                height: 160.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          if (images.length < 10)
                            GestureDetector(
                              onTap: controller.pickImage,
                              child: Container(
                                height: 160.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(child: Icon(Icons.add)),
                              ),
                            ),
                        ],
                      );
                    } else {
                      return Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          ...images.map(
                            (img) => ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.file(
                                img,
                                height: 80.h,
                                width: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (images.length < 10)
                            GestureDetector(
                              onTap: controller.pickImage,
                              child: Container(
                                height: 80.h,
                                width: 80.h,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(child: Icon(Icons.add)),
                              ),
                            ),
                        ],
                      );
                    }
                  }),

                  SizedBox(height: 16.h),

                  buildInput(controller.productNameController, "Product Name"),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedCategory.value,
                      decoration: InputDecoration(
                        hintText: "Select Category",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      items:
                          controller.categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                      onChanged: (val) {
                        controller.updateSubCategories(val);
                        controller.selectedSubCategory.value = null;
                      },

                    ),
                  ),

                  SizedBox(height: 12.h),

                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.subCategories.any((sub) => sub['id'] == controller.selectedSubCategory.value)
                          ? controller.selectedSubCategory.value
                          : null,
                      decoration: InputDecoration(
                        hintText: "Select Sub-Category",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      items: controller.subCategories.map<DropdownMenuItem<String>>((sub) {
                        return DropdownMenuItem<String>(
                          value: sub['id'], // send ID
                          child: Text(sub['name'] ?? ''),
                        );
                      }).toList(),
                      onChanged: (val) {
                        controller.selectedSubCategory.value = val;
                        print('✅ Selected Sub-category ID: $val');
                      },
                    ),

                  ),
                  SizedBox(height: 12.h),
                  buildInput(controller.brandNameController, "Brand Name"),
                  buildInput(controller.modelNameController, "Model Name"),
                  buildInput(controller.priceController, "Price"),
                  buildInput(
                    controller.deliveryChargeController,
                    "Delivery Charge",
                  ),
                  Obx(
                    () => Column(
                      children: List.generate(
                        controller.variantControllers.length,
                        (index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: TextFormField(
                              controller: controller.variantControllers[index],
                              decoration: InputDecoration(
                                hintText:
                                    "Enter variant number ${index + 1} (optional)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onChanged:
                                  (_) =>
                                      controller.addVariantFieldIfNeeded(index),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  MultiSelectDialogField<String>(
                    items:
                        controller.colorOptions
                            .map((color) => MultiSelectItem(color, color))
                            .toList(),
                    title: Text("Select Colors"),
                    selectedColor: Colors.green,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    buttonText: Text("Select Color(s)"),
                    initialValue: controller.selectedColors,
                    onConfirm: (values) {
                      controller.selectedColors.value = values;
                    },
                  ),

                  SizedBox(height: 12.h),
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 4.h,
                          children:
                              controller.tags.map((tag) {
                                return Chip(
                                  label: Text(tag),
                                  onDeleted: () => controller.tags.remove(tag),
                                );
                              }).toList(),
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: controller.tagInputController,
                          decoration: InputDecoration(
                            hintText: "Enter tag and press Enter",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            final trimmed = value.trim();
                            if (trimmed.isNotEmpty &&
                                controller.totalTagLength + trimmed.length <=
                                    500) {
                              controller.tags.add(trimmed);
                              controller.tagInputController.clear();
                            }
                          },
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Used: ${controller.totalTagLength}/500 characters",
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  buildInput(controller.stockStatusController, "Stock Status"),

                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: controller.descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final success = await controller.uploadProduct();
                        if (success) {
                          Get.snackbar(
                            'Success',
                            'Product uploaded successfully',
                          );
                        } else {
                          Get.snackbar('Error', 'Failed to upload product');
                        }
                      },
                      child: Text("Upload", style: TextStyle(fontSize: 16.sp)),
                    ),
                  ),

                ],
              ),
            ),
          ),
          if (controller.isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
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
