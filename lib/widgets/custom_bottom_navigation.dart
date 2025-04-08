import 'package:flutter/material.dart';

/// アプリ全体で使用されるカスタムボトムナビゲーション
class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isFortunetellerMode;

  const CustomBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.isFortunetellerMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // メインのカラー（画像のとおり）
    const Color activeColor = Color(0xFF3bcfd4); // ターコイズ
    const Color inactiveColor = Color(0xFF9E9E9E); // グレー

    return Container(
      height: 56, // 画像に合わせて高さ調整
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 画像と同じアイコンに変更
          _buildNavItem(
            icon: Icons.home_outlined,
            filledIcon: Icons.home,
            label: 'ホーム',
            index: 0,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildNavItem(
            icon: Icons.chat_bubble_outline,
            filledIcon: Icons.chat_bubble,
            label: 'チャット',
            index: 1,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildNavItem(
            icon: Icons.watch_later_outlined,
            filledIcon: Icons.watch_later,
            label: '待機する',
            index: 2,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildNavItem(
            icon: Icons.school_outlined,
            filledIcon: Icons.school,
            label: '教えて先生',
            index: 3,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildNavItem(
            icon: Icons.person_outline,
            filledIcon: Icons.person,
            label: 'マイページ',
            index: 4,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData filledIcon,
    required String label,
    required int index,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final bool isActive = index == currentIndex;
    final color = isActive ? activeColor : inactiveColor;
    final displayIcon = isActive ? filledIcon : icon;

    return InkWell(
      onTap: () => onTap(index),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 6), // 上部に少しスペースを追加
            Icon(
              displayIcon,
              color: color,
              size: 22, // 画像のアイコンサイズに合わせて調整
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11, // 画像のフォントサイズに合わせて調整
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
