import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../storage/token_storage.dart';
import '../order_list/order_list_view.dart';
import '../home/home_view.dart';
import '../product_upload/product_upload_view.dart';


class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
  });

  Future<void> _handleNavigation(int index) async {
    final token = await TokenStorage.getToken();

    // Orders and Profile require login
    if ((index == 2 || index == 3) && (token == null || token.isEmpty)) {
      _showLoginRequiredDialog();
      return;
    }

    switch (index) {
      case 0:
        Get.offAll(() => HomeView());
        break;
      case 1:
        Get.offAll(() => ProductUploadView());
        break;
      case 2:
        Get.offAll(() => OrderListView());
        break;
      case 3:
        //Get.offAll(() => ProfileView());
        break;
    }
  }

  void _showLoginRequiredDialog() {
    Get.defaultDialog(
      title: "Login Required",
      content: const Text("You must log in to access this feature."),
      textConfirm: "Login",
      textCancel: "Cancel",
      onConfirm: () {
        Get.back(); // Close dialog
        Get.toNamed('/signup', arguments: {'isLogin': true});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF5AB2FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(icon: Icons.home, label: 'Home', index: 0),
          _navItem(icon: Icons.add, label: 'Post', index: 1),
          _navItem(icon: Icons.shopping_cart, label: 'Orders', index: 2),
          _navItem(
            iconWidget: const CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage('assets/png/logo.png'),
            ),
            label: 'Profile',
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _navItem({IconData? icon, Widget? iconWidget, required String label, required int index}) {
    final isSelected = index == selectedIndex;
    final color = isSelected ? Colors.white : Colors.white60;

    return GestureDetector(
      onTap: () => _handleNavigation(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget ?? Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 2),
              height: 3,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}
