import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

class CommonHeader extends StatelessWidget {
  final int points;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onPointsTap;
  final bool showNotificationBadge;
  final int notificationCount;

  const CommonHeader({
    Key? key, 
    required this.points,
    this.onSettingsTap,
    this.onPointsTap,
    this.showNotificationBadge = false,
    this.notificationCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 左側の通知バッジ付きアイコン
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF9E9E9E),
                    size: 28,
                  ),
                ),
                if (showNotificationBadge)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF87B7B),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        notificationCount > 99 ? '99+' : notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // 中央のポイント表示
            GestureDetector(
              onTap: onPointsTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${points}pts',
                      style: const TextStyle(
                        color: Color(0xFFA67FFF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFA67FFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 右側の設定アイコン
            GestureDetector(
              onTap: onSettingsTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.settings,
                  color: Color(0xFF9E9E9E),
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
