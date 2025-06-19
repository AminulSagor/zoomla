import 'package:get/get.dart';
import 'package:jumla/forget_pass/change_pass_view.dart';
import 'package:jumla/forget_pass/forget_pass_view.dart';
import 'package:jumla/home/home_view.dart';
import 'package:jumla/post_status/approved_view.dart';
import 'package:jumla/post_status/pending_products_view.dart';
import 'package:jumla/product_details/product_details_view.dart';
import 'package:jumla/product_list/product_list_view.dart';
import 'package:jumla/product_upload/product_upload_view.dart';
import 'package:jumla/signup/signup_view.dart';
import 'package:jumla/store_info_upload/store_info_view.dart';

import 'confirm_order/confirm_order_view.dart';
import 'order_list/order_list_view.dart';

class AppRoutes {
  static const String signUp = '/signup';
  static const String storeInfoUp = '/store-info-up';
  static const String forgetPass = '/forget-pass';
  static const String changePass = '/change-pass';
  static const String homePage = '/home-page';
  static const String productUpload = '/product-upload';
  // static const String productList = '/product-list';
  static const String approvedProduct = '/approved-product';
  static const String pendingProduct = '/pending-product';
  static const String orderList = '/order-list';
  static const String confirmOrder = '/confirm-order';
  static const String productDetails = '/product-details';

  static final routes = [
    GetPage(name: signUp, page: () =>  SignUpView()),
    GetPage(name: storeInfoUp, page: () =>  StoreInfoView()),
    GetPage(name: forgetPass, page: () =>  ForgetPassView()),
    GetPage(name: changePass, page: () =>  ChangePassView()),
    GetPage(name: homePage, page: () => HomeView()),
    GetPage(name: productUpload, page: () => ProductUploadView()),
    // GetPage(name: productList, page: () => ProductListView()),
    GetPage(name: approvedProduct, page: () => ApprovedProductsView()),
    GetPage(name: pendingProduct, page: () => PendingProductsView()),
    GetPage(name: orderList, page: () => OrderListView()),
    GetPage(name: confirmOrder, page: () => ConfirmOrderView()),

    GetPage(name: productDetails, page: () => ProductDetailsView()),
  ];
}
