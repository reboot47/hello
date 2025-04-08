import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/circular_menu.dart';
import '../../widgets/common_header.dart';
import 'my_page_screen.dart';
import '../settings/settings_screen.dart';

// 画面インデックス管理用の列挙型
enum AppScreen { home, history, menu, ranking, profile }

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HomeScreen({Key? key, required this.userData}) : super(key: key);
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 現在の選択インデックス
  int _selectedIndex = 0;
  
  // ナビゲーションアイテムタップ時の処理
  void _onItemTapped(int index) {
    // 中央のメニューボタン(index=2)は除く
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
      
      // 画面遷移の実装
      if (index == 4) {
        // マイページ画面へ遷移
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyPageScreen(userData: widget.userData),
          ),
        );
      } else {
        // 他のタブはここに実装
        print('インデックス $index がタップされました');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 共通ヘッダー（画像2枚目の通り）
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: CommonHeader(
          points: 13,
          showNotificationBadge: true,
          notificationCount: 13,
          onPointsTap: () {
            // ポイント画面への遷移など
            print('ポイントがタップされました');
          },
          onSettingsTap: () {
            // 設定画面へ遷移
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
      ),
      // 完全にフロートする中央メニューボタン (添付画像の通りに実装)
      extendBody: true, // 画面の内容がナビゲーションバーの下に展開されるようにする
      floatingActionButton: const CircularMenu(), // CircularMenuウィジェットを使用してクリック時に放射状メニューを表示
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        showCenterButton: false, // 中央ボタンは非表示にしてfloatingActionButtonを使用
      ),
      body: Stack(
        children: [
          // 背景デザイン要素
          Positioned(
            top: -50,
            left: -20,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -50,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Color(0xFFf8bbd0).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // メインコンテンツ
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _getScreenContent(),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: color,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF1a237e),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 現在の画面に応じたタイトルを取得
  String _getScreenTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'ホーム';
      case 1:
        return '相談履歴';
      case 3:
        return 'ランキング';
      case 4:
        return 'マイページ';
      default:
        return 'ホーム';
    }
  }
  
  // 現在選択されている画面のコンテンツを取得
  Widget _getScreenContent() {
    switch (_selectedIndex) {
      case 0:
        // ホーム画面
        return _buildHomeContent();
      case 1:
        // 相談履歴画面
        return _buildHistoryContent();
      case 3:
        // ランキング画面
        return _buildRankingContent();
      case 4:
        // マイページ画面
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }
  
  // ホーム画面のコンテンツ
  Widget _buildHomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildUserGreeting(),
        const SizedBox(height: 20),
        _buildServiceCards(),
      ],
    );
  }
  
  // ユーザー向けの挨拶カード
  Widget _buildUserGreeting() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            const Color(0xFF30B5BA),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ようこそ！',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${widget.userData['id']} - ${widget.userData['email']}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '登録完了ありがとうございます。\nコンテンツを自由にお楽しみください。',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms, delay: 100.ms)
      .moveY(begin: 10, end: 0, duration: 350.ms, curve: Curves.easeOutQuad);
  }
  
  // サービスカードセクション
  Widget _buildServiceCards() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'おすすめサービス',
            style: TextStyle(
              color: Color(0xFF1a237e),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // サービスリスト
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildServiceCard(
                  icon: Icons.star,
                  title: '占いサービス',
                  description: '運勢をチェック',
                  color: const Color(0xFF1a237e),
                ),
                _buildServiceCard(
                  icon: Icons.chat_bubble,
                  title: 'チャット',
                  description: '占い師と相談',
                  color: AppTheme.primaryColor,
                ),
                _buildServiceCard(
                  icon: Icons.calendar_today,
                  title: '今日の運勢',
                  description: 'デイリー占い',
                  color: const Color(0xFFf8bbd0),
                ),
                _buildServiceCard(
                  icon: Icons.favorite,
                  title: '相性診断',
                  description: '相性を確認',
                  color: Colors.redAccent,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
        ],
      ),
    );
  }
  
  // 相談履歴画面のコンテンツ
  Widget _buildHistoryContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            '相談履歴がありません',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('占いを始める'),
          ),
        ],
      ),
    );
  }
  
  // ランキング画面のコンテンツ
  Widget _buildRankingContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            size: 80,
            color: Colors.amber.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'ランキング画面',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '準備中...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
  
  // マイページ画面のコンテンツ
  Widget _buildProfileContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ユーザー情報カード
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                    child: Text(
                      widget.userData['email'].toString().substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ユーザーID: ${widget.userData['id']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.userData['email'] ?? 'メールアドレスなし',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _buildSettingItem(
                icon: Icons.account_circle,
                title: 'プロフィール設定',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.notifications,
                title: '通知設定',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.credit_card,
                title: 'お支払い情報',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.lock,
                title: 'パスワード変更',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.help_outline,
                title: 'ヘルプ・お問い合わせ',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.exit_to_app,
                title: 'ログアウト',
                onTap: () {
                  Navigator.of(context).pop();
                },
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // マイページの設定アイテム
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
