import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';

class CircularMenu extends StatefulWidget {
  const CircularMenu({Key? key}) : super(key: key);

  @override
  State<CircularMenu> createState() => _CircularMenuState();
}

class _CircularMenuState extends State<CircularMenu> with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _toggle() {
    print('メニューボタンがクリックされました！ 現在の状態: ${_isOpen ? "開いている" : "閉じている"}');
    setState(() {
      _isOpen = !_isOpen;
      print('状態を切り替え: ${_isOpen ? "開く" : "閉じる"}');
      
      // iOSアプリライクな滑らかなアニメーションのために最適化
      if (_isOpen) {
        Future.delayed(const Duration(milliseconds: 50), () {
          _animationController.forward();
        });
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 放射状メニューのオーバーレイ（開いているときのみ表示）
          if (_isOpen) _buildExpandedMenu(),
          
          // 中央の丸いボタン - 添付画像の通りに実装
          InkWell(
            onTap: _toggle,
            customBorder: const CircleBorder(),
            child: Container(
              width: 66, 
              height: 66,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFC5A3FF), // より明るい紫
                    const Color(0xFFA67FFF), // 明るい紫
                    const Color(0xFF8659DB), // 濃い紫
                  ],
                  stops: const [0.2, 0.5, 0.9],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7E57C2).withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 放射状メニューの実装 - 添付画像に忠実な再現
  Widget _buildExpandedMenu() {
    print('放射状メニューを構築中...');
    // メニュー項目の定義（添付画像の通り）
    final List<MenuItemData> menuItems = [
      // タイムライン（左上）
      MenuItemData(
        icon: Icons.view_list_outlined,
        label: 'タイムライン',
        color: Colors.blue.shade300,
        onTap: () {
          print('タイムラインがタップされました');
          _toggle();
        },
      ),
      // 公式ブログ（右上）
      MenuItemData(
        icon: Icons.article_outlined,
        label: '公式ブログ',
        color: Colors.blue.shade300,
        onTap: () {
          print('公式ブログがタップされました');
          _toggle();
        },
      ),
      // ポイント購入（中央）
      MenuItemData(
        icon: Icons.monetization_on_outlined,
        label: 'ポイント購入',
        color: Colors.pink.shade300,
        onTap: () {
          print('ポイント購入がタップされました');
          _toggle();
        },
      ),
      // 教えて先生（左下）
      MenuItemData(
        icon: Icons.school_outlined,
        label: '教えて先生',
        color: Colors.cyan.shade300,
        onTap: () {
          print('教えて先生がタップされました');
          _toggle();
        },
      ),
      // 占い師一覧（右下）
      MenuItemData(
        icon: Icons.search_outlined,
        label: '占い師一覧',
        color: Colors.purple.shade300,
        onTap: () {
          print('占い師一覧がタップされました');
          _toggle();
        },
      ),
    ];
    
    // 画面サイズを取得
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerX = screenWidth / 2;
    final centerY = screenHeight / 2;
    
    // メニューを表示するオーバーレイ（全画面）
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggle, // 背景タップでメニューを閉じる
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                // 各メニューボタンを放射状に配置
                ...List.generate(menuItems.length, (index) {
                  // メニューの配置を計算
                  // 添付画像の配置を実現するため、特定の角度を設定
                  double startAngle = -math.pi / 2; // 上から開始
                  List<double> angles;
                  List<double> distances;
                  
                  // 添付画像の配置に合わせて優先的に角度と距離を調整
                  if (menuItems.length == 5) {
                    // 左上、右上、中央下、左下、右下の配置
                    angles = [
                      startAngle - math.pi / 4,      // 左上（-135度）
                      startAngle + math.pi / 4,      // 右上（-45度）
                      startAngle + math.pi / 2,      // 中央下（0度）
                      startAngle + math.pi * 3 / 4,  // 左下（45度）
                      startAngle + math.pi * 5 / 4,  // 右下（135度）
                    ];
                    distances = [
                      200.0, // 左上
                      200.0, // 右上
                      230.0, // 中央下（少し遠く）
                      200.0, // 左下
                      200.0, // 右下
                    ];
                  } else {
                    // 決められた距離で均等に配置
                    final double angleStep = 2 * math.pi / menuItems.length;
                    angles = List.generate(
                      menuItems.length, 
                      (i) => startAngle + i * angleStep
                    );
                    distances = List.generate(menuItems.length, (_) => 200.0);
                  }
                  
                  // 位置を計算
                  final double x = math.cos(angles[index]) * distances[index];
                  final double y = math.sin(angles[index]) * distances[index];
                  
                  return Positioned(
                    left: centerX + x - 35, // ボタンの大きさの半分をオフセット
                    top: centerY + y - 35,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        // アニメーション効果を実装
                        final double delay = index * 0.1;
                        double scale = 0.0;
                        if (_animationController.value > delay) {
                          scale = Curves.elasticOut.transform(
                            (_animationController.value - delay) / (1 - delay)
                          );
                        }
                        
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: _buildMenuButton(menuItems[index]),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // メニューボタンのスタイル（添付画像の円形ボタン）
  Widget _buildMenuButton(MenuItemData itemData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 円形ボタン
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: Colors.purple.shade100,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: itemData.onTap,
              customBorder: const CircleBorder(),
              child: Center(
                child: Icon(
                  itemData.icon,
                  color: itemData.color,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // ラベル
        Text(
          itemData.label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// メニュー項目のデータクラス
class MenuItemData {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  
  MenuItemData({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
