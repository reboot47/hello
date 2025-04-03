import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

class CircularMenu extends StatefulWidget {
  const CircularMenu({Key? key}) : super(key: key);

  @override
  State<CircularMenu> createState() => _CircularMenuState();
}

class _CircularMenuState extends State<CircularMenu> with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _animationController;
  OverlayEntry? _overlayEntry;
  
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
    _hideMenu();
    _animationController.dispose();
    super.dispose();
  }
  
  void _toggle() {
    // クリック時の触覚フィードバック
    HapticFeedback.lightImpact();
    
    setState(() {
      _isOpen = !_isOpen;
      
      if (_isOpen) {
        // メニューを開く
        _showMenu();
        Future.delayed(const Duration(milliseconds: 50), () {
          _animationController.forward();
        });
      } else {
        // メニューを閉じる
        _animationController.reverse().then((_) {
          _hideMenu();
        });
      }
    });
  }
  
  // メニューを表示する（オーバーレイを使って最上位レイヤーに表示）
  void _showMenu() {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return _buildExpandedMenu();
      },
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }
  
  // メニューを非表示にする
  void _hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    // 画像2のように中央ボタンを水晶玉アイコンに
    return Container(
      width: 70, 
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFB388FF), // 明るい紫
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggle,
          customBorder: const CircleBorder(),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(
                  turns: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                );
              },
              child: _isOpen 
                ? const Icon(
                    Icons.close,
                    key: ValueKey('close'),
                    color: Colors.white,
                    size: 28,
                  )
                : const Icon(
                    Icons.visibility, // 水晶玉に近いアイコン
                    key: ValueKey('crystal_ball'),
                    color: Colors.white,
                    size: 28,
                  ),
            ),
          ),
        ),
      ),
    );
  }
  
  // 放射状メニューの実装 - 添付画像3に忠実に再現
  Widget _buildExpandedMenu() {
    // メニュー項目の定義（添付画像3の通り）
    final List<MenuItemData> menuItems = [
      // タイムライン（左上）
      MenuItemData(
        icon: Icons.format_list_bulleted,
        label: 'タイムライン',
        color: Colors.blue.shade400,
        onTap: () {
          _toggle();
        },
      ),
      // 公式ブログ（右上）
      MenuItemData(
        icon: Icons.article,
        label: '公式ブログ',
        color: Colors.blue.shade400,
        onTap: () {
          _toggle();
        },
      ),
      // ポイント購入（中央）
      MenuItemData(
        icon: Icons.monetization_on,
        label: 'ポイント購入',
        color: Colors.pink.shade400,
        onTap: () {
          _toggle();
        },
      ),
      // 教えて先生（左下）
      MenuItemData(
        icon: Icons.school,
        label: '教えて先生',
        color: Colors.teal.shade300,
        onTap: () {
          _toggle();
        },
      ),
      // 占い師一覧（右下）
      MenuItemData(
        icon: Icons.search,
        label: '占い師一覧',
        color: Colors.purple.shade400,
        onTap: () {
          _toggle();
        },
      ),
    ];
    
    // 画面全体を覆うオーバーレイ（最上位レイヤー）- 画像3のように
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // 背景をタップでメニューを閉じる
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggle,
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
          
          // 各メニューアイテム
          Positioned.fill(
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(menuItems.length, (index) {
                // 添付画像3の配置に合わせた角度と距離の調整
                double startAngle = -math.pi / 2; // 上から開始
                List<double> angles = [
                  startAngle - math.pi / 4,      // 左上（-135度）
                  startAngle + math.pi / 4,      // 右上（-45度）
                  startAngle + math.pi / 2,      // 中央下（0度）
                  startAngle + math.pi * 3 / 4,  // 左下（45度）
                  startAngle + math.pi * 5 / 4,  // 右下（135度）
                ];
                List<double> distances = [
                  200.0, // 左上
                  200.0, // 右上
                  230.0, // 中央下（少し遠く）
                  200.0, // 左下
                  200.0, // 右下
                ];
                
                // 位置を計算
                final screenSize = MediaQuery.of(context).size;
                final centerX = screenSize.width / 2;
                final centerY = screenSize.height / 2;
                final double x = math.cos(angles[index]) * distances[index];
                final double y = math.sin(angles[index]) * distances[index];
                
                return Positioned(
                  left: centerX + x - 35, // ボタンの半分をオフセット
                  top: centerY + y - 35,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      // アニメーション効果
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
            ),
          ),
        ],
      ),
    );
  }
  
  // メニューボタンのスタイル（添付画像3の円形ボタン）
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
                color: Colors.black.withOpacity(0.5),
                blurRadius: 3,
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
