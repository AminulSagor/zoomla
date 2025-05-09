import 'package:get/get.dart';
import 'package:jumla/forget_pass/change_pass_view.dart';
import 'package:jumla/forget_pass/forget_pass_view.dart';
import 'package:jumla/home/home_view.dart';
import 'package:jumla/product_list/product_list_view.dart';
import 'package:jumla/product_upload/product_upload_view.dart';
import 'package:jumla/signup/signup_view.dart';
import 'package:jumla/store_info_upload/store_info_view.dart';

class AppRoutes {
  static const String signUp = '/signup';
  static const String storeInfoUp = '/store-info-up';
  static const String forgetPass = '/forget-pass';
  static const String changePass = '/change-pass';
  static const String homePage = '/home-page';
  static const String productUpload = '/product-upload';
  static const String productList = '/product-list';

  static final routes = [
    GetPage(name: signUp, page: () =>  SignUpView()),
    GetPage(name: storeInfoUp, page: () =>  StoreInfoView()),
    GetPage(name: forgetPass, page: () =>  ForgetPassView()),
    GetPage(name: changePass, page: () =>  ChangePassView()),
    GetPage(name: homePage, page: () => HomeView()),
    GetPage(name: productUpload, page: () => ProductUploadView()),
    GetPage(name: productList, page: () => ProductListView()),
  ];
}
