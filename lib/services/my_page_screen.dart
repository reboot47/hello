import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/common_header.dart';
import '../widgets/circular_menu.dart';
import '../screens/content/home_screen.dart';
import '../screens/content/consultation_card_screen.dart';
// 決済画面は現在実装されていないため、インポートを削除
// 設定画面は現在実装されていないため、インポートを削除

class MyPageScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  
  const MyPageScreen({Key? key, this.userData}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  int _selectedIndex = 4; // 画像通りにマイページを選択状態に
  
  // 相談カルテの情報
  String _selfName = '--';
  String _selfBirthdate = '--';
  String _selfConcerns = '--';
  String _partnerName = '--';
  String _partnerBirthdate = '--';
  String _partnerRelationship = '--';
  
  // ユーザーポイント
  int _userPoints = 1000; // 実際のポイントに合わせる
  
  bool _isLoading = false;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    // HOME画面への遷移
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen(userData: {'id': '123', 'email': 'user@example.com'})),
      );
      return;
    }

    // その他のタブも必要に応じて遷移できるように実装
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadConsultationCardData();
    _loadUserPoints();
  }
  
  // 相談カルテデータをデータベースから読み込む
  Future<void> _loadConsultationCardData() async {
    setState(() => _isLoading = true);
    
    try {
      // ユーザーのメールアドレスを取得
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('userEmail');
      
      if (userEmail == null) {
        print('ユーザー情報が見つかりません');
        setState(() => _isLoading = false);
        return;
      }
      
      // データベースからカルテデータを取得
      final dbService = DatabaseService();
      await dbService.connect();
      
      final result = await dbService.getConsultationCard(userEmail);
      await dbService.disconnect();
      
      if (result['success'] && result['exists']) {
        final cardData = result['card'];
        
        setState(() {
          _selfName = cardData['self_name'] ?? '--';
          _selfBirthdate = cardData['self_birthdate'] ?? '--';
          _selfConcerns = cardData['self_concerns'] ?? '--';
          
          // 相手のデータはカルテ1を表示
          _partnerName = cardData['partner1_name'] ?? '--';
          _partnerBirthdate = cardData['partner1_birthdate'] ?? '--';
          _partnerRelationship = cardData['partner1_relationship'] ?? '--';
          
          // 表示文字数を制限
          if (_selfConcerns.length > 20) {
            _selfConcerns = _selfConcerns.substring(0, 17) + '...';
          }
        });
      }
    } catch (e) {
      print('相談カルテデータ読み込みエラー: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F6), // 画像のグレーがかった薄い赤紫色の背景
      extendBody: true, // フローティングボタンのために必要
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CommonHeader(
          points: _userPoints,
          showNotificationBadge: false,
          onPointsTap: () {
            // ポイントタップ時のアクション（決済選択画面は現在実装されていない）
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('決済機能は現在開発中です'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          onSettingsTap: () {
            // 設定アイコンタップ時のアクション（設定画面は現在実装されていない）
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('設定機能は現在開発中です'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildConsultationCard(),
            _buildBanner(),
            _buildMenuItems(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const CircularMenu(key: ValueKey('floatingCircularMenu')), // キーを追加して一意的にする
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        showCenterButton: false, // 中央ボタンを表示しないようにする
      ),
    );
  }

  // 相談カルテセクション
  Widget _buildConsultationCard() {
    return GestureDetector(
      onTap: () {
        // 相談カルテ画面に遷移
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ConsultationCardScreen()),
        ).then((_) {
          // 相談カルテ画面から戻ってきたときにデータを再読み込み
          _loadConsultationCardData();
        });
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10), // 画像に合わせて角丸を少し小さく
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 5,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            // ヘッダー
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '相談カルテ',
                    style: TextStyle(
                      color: Colors.purple.shade300, // 画像通りの薄い紫色
                      fontSize: 16, // 画像に合わせて少し小さく
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.edit_outlined,
                    color: Colors.blue.shade300, // 画像の青色
                    size: 20, // 画像に合わせて小さく
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            
            // 自分の情報
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow('自分の名前', _selfName),
                  const SizedBox(height: 12),
                  _buildInfoRow('生年月日', _selfBirthdate),
                  const SizedBox(height: 12),
                  _buildInfoRow('今の悩み', _selfConcerns),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // 相手の情報
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow('相手の名前', _partnerName),
                  const SizedBox(height: 12),
                  _buildInfoRow('生年月日', _partnerBirthdate),
                  const SizedBox(height: 12),
                  _buildInfoRow('関係', _partnerRelationship),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 情報行のウィジェット
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
  
  // バナー広告 - 画像に忠実に再現
  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 80, // 画像に合わせて高さ調整
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFF9C4), // より薄い黄色
            const Color(0xFFFFF176), // 黄色
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(10), // 画像通りの角丸
      ),
      child: Stack(
        children: [
          // テキスト部分
          Positioned(
            left: 16,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE91E63), // 画像の濃いピンク
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '毎月1回だけ！',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10, // 画像に合わせて小さく
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ステニー定期便なら',
                      style: TextStyle(
                        color: Color(0xFF673AB7),
                        fontSize: 12, // 画像に合わせて小さく
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'お得な',
                      style: TextStyle(
                        color: Color(0xFFE91E63), // 画像に合わせた色
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'ポイント',
                      style: TextStyle(
                        color: Color(0xFF673AB7),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Text(
                      '30日間',
                      style: TextStyle(
                        color: Color(0xFFE91E63), // 画像の濃いピンク
                        fontSize: 28, // 画像に合わせてサイズ調整
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ログインボーナス',
                      style: TextStyle(
                        color: Color(0xFFE91E63), // 画像の濃いピンク
                        fontSize: 24, // 画像に合わせてサイズ調整
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // メニュー項目
  Widget _buildMenuItems() {
    return Container(
      margin: const EdgeInsets.all(16),
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
        children: [
          _buildMenuItem(
            icon: Icons.card_giftcard,
            iconColor: const Color(0xFFEC407A), // 画像の色に合わせる
            title: '紹介で500pts GET!!',
            showBadge: false,
            showAlert: false,
          ),
          _buildMenuItem(
            icon: Icons.assignment,
            iconColor: const Color(0xFF2196F3),
            title: 'ミッションでポイントGET!!',
            showBadge: true,
            badgeColor: const Color(0xFF673AB7),
            showAlert: false,
          ),
          _buildMenuItem(
            icon: Icons.person_outline,
            iconColor: const Color(0xFF009688),
            title: 'アカウント・メルマガ設定',
            showBadge: false,
            showAlert: true,
            onTap: () {
              // アカウント設定画面は現在実装されていない
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('アカウント設定機能は現在開発中です'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.notifications_none,
            iconColor: const Color(0xFF2196F3),
            title: '通知設定',
            showBadge: false,
            showAlert: false,
            onTap: () {
              // 通知設定画面は現在実装されていない
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('通知設定機能は現在開発中です'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.confirmation_number_outlined,
            iconColor: const Color(0xFF4CAF50),
            title: 'キャンペーンコード入力',
            showBadge: false,
            showAlert: false,
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            iconColor: const Color(0xFF9E9E9E),
            title: 'ヘルプ・お問い合わせ',
            showBadge: false,
            showAlert: false,
            isLast: true,
            onTap: () {
              // ヘルプ・お問い合わせ画面への遷移を実装できます
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ヘルプ・お問い合わせ機能は開発中です')),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor, 
    required String title,
    bool showBadge = false, 
    Color badgeColor = Colors.red,
    bool showAlert = false,
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 32, // 画像に合わせて小さく
                  height: 32, // 画像に合わせて小さく
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon, 
                    color: iconColor,
                    size: 18, // 画像に合わせて小さく
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (showBadge)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.priority_high,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  )
                else if (showAlert)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.priority_high,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            indent: 68,
          ),
      ],
    );
  }
  
  // ユーザーポイントをデータベースから取得する
  Future<void> _loadUserPoints() async {
    try {
      // ユーザーのメールアドレスを取得
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('userEmail');
      
      if (userEmail == null) {
        print('ユーザー情報が見つかりません');
        return;
      }
      
      // データベースからポイントを取得
      final dbService = DatabaseService();
      await dbService.connect();
      
      // ユーザープロフィールからポイントを取得
      final result = await dbService.getUserProfile(userEmail);
      await dbService.disconnect();
      
      print('getUserProfile result: $result'); // デバッグ時にはこの行を有効化して結果を確認
      
      if (result['success']) {
        final profileData = result['profile'];
        // データベースから実際のポイントを取得して表示
        final points = profileData['points'];
        print('Fetched points from database: $points'); // デバッグ用
        
        setState(() {
          if (points != null) {
            _userPoints = points;
          } else {
            _userPoints = 1000; // ポイントがデータベースにない場合はデフォルトで1000ポイント
          }
        });
      }
    } catch (e) {
      print('ユーザーポイント読み込みエラー: $e');
      // エラー時はデフォルトの1000ポイントを使用
      setState(() {
        _userPoints = 1000;
      });
    }
  }
}
