import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'circular_menu.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool showCenterButton;

  const BottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.showCenterButton = true,
  }) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade100,
            width: 1.0,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // 背景エフェクト
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.85),
                        Colors.white.withOpacity(0.95),
                      ],
                    ),
                  ),
                ),
              ),
              
              // メインメニュー項目
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      icon: Icons.home_outlined, 
                      activeIcon: Icons.home_rounded,
                      label: "HOME", 
                      isActive: widget.selectedIndex == 0,
                      index: 0,
                      color: const Color(0xFF3bcfd4), // プライマリーカラー(ターコイズ)
                    ),
                    _buildNavItem(
                      icon: Icons.chat_bubble_outline_rounded, 
                      activeIcon: Icons.chat_bubble_rounded,
                      label: "相談履歴",
                      index: 1,
                      isActive: widget.selectedIndex == 1,
                      color: Colors.grey.shade700,
                    ),
                    // 中央ボタン用の空白
                    const SizedBox(width: 80),
                    _buildNavItem(
                      icon: Icons.star_border_rounded, 
                      activeIcon: Icons.star_rounded,
                      label: "ランキング",
                      index: 3,
                      isActive: widget.selectedIndex == 3,
                      color: Colors.grey.shade700,
                    ),
                    _buildNavItem(
                      icon: Icons.person_outline_rounded, 
                      activeIcon: Icons.person_rounded,
                      label: "マイページ",
                      index: 4,
                      isActive: widget.selectedIndex == 4,
                      color: Colors.grey.shade700,
                    ),
                  ],
                ),
              ),
              
              // 中央の特別メニューボタン（画像2のように実装）
              if (widget.showCenterButton)
                Positioned(
                  bottom: 6, // 画像2では完全にボトムナビゲーションの中に置かれている
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 54, // 画像2のサイズに合わせる
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFB388FF), // より明るい紫
                            const Color(0xFF9575CD), // 紫
                            const Color(0xFF7E57C2), // 濃い紫
                          ],
                          stops: const [0.2, 0.5, 0.9],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7E57C2).withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            // 何もしない、CircularMenuがタップを処理
                          },
                          child: const CircularMenu(),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ナビゲーションアイテムの作成
  Widget _buildNavItem({
    required IconData icon, 
    IconData? activeIcon, 
    required String label, 
    required int index,
    bool isActive = false,
    Color color = const Color(0xFF7E7E7E),
    int badgeCount = 0,
    Color badgeColor = Colors.redAccent,
  }) {
    final effectiveIcon = isActive ? activeIcon ?? icon : icon;
    final effectiveColor = isActive ? color : Colors.grey.shade400;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: color.withOpacity(0.1),
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          widget.onItemTapped(index);
        },
        child: Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    effectiveIcon,
                    size: 26,
                    color: effectiveColor,
                  ).animate(
                    onPlay: (controller) => isActive ? controller.repeat(reverse: true) : controller.stop(),
                  ).scaleXY(
                    begin: 1.0,
                    end: 1.1,
                    duration: 2000.ms,
                    curve: Curves.easeInOut,
                  ).then(delay: 200.ms),
                  const SizedBox(height: 5),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      color: effectiveColor,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              
              // バッジ
              if (badgeCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: badgeColor.withOpacity(0.3),
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Center(
                      child: Text(
                        badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ).animate().scale(duration: 200.ms, curve: Curves.easeOutBack),
            ],
          ),
        ),
      ),
    );
  }
}
