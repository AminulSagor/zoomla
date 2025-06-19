import 'package:get/get.dart';

class OrderListController extends GetxController {
  final selectedTab = 'Pending'.obs;
  final tabs = ['Pending', 'Approved', 'Delivered'];

  final orders = [
    {
      'name': 'Fouzia Hussain',
      'phone': '+88016744839',
      'address': 'Al-Madani Tower, Level-6, Mirboxtula, Sylhet',
      'status': 'Pending',
      'image': 'assets/png/customer_home_head.png',
    },
    {
      'name': 'Fouzia Hussain',
      'phone': '+88016744839',
      'address': 'Al-Madani Tower, Level-6, Mirboxtula, Sylhet',
      'status': 'Approved',
      'image': 'assets/png/customer_home_head.png',
    },
    {
      'name': 'Fouzia Hussain',
      'phone': '+88016744839',
      'address': 'Al-Madani Tower, Level-6, Mirboxtula, Sylhet',
      'status': 'Delivered',
      'image': 'assets/png/customer_home_head.png',
    },
    {
      'name': 'Fouzia Hussain',
      'phone': '+88016744839',
      'address': 'Al-Madani Tower, Level-6, Mirboxtula, Sylhet',
      'status': 'Approved',
      'image': 'assets/png/customer_home_head.png',
    },
  ];

}
