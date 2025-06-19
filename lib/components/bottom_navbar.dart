import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF5AB2FF),
        borderRadius: BorderRadius.circular(8), // 👈 less curved
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
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget ?? Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
