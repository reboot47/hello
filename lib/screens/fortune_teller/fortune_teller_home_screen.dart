import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../services/database_service.dart';
import '../../widgets/custom_bottom_navigation.dart';
import 'fortune_teller_mypage_screen.dart';

/// 占い師専用ホーム画面
class FortuneTellerHomeScreen extends StatefulWidget {
  const FortuneTellerHomeScreen({Key? key}) : super(key: key);

  @override
  State<FortuneTellerHomeScreen> createState() => _FortuneTellerHomeScreenState();
}

class _FortuneTellerHomeScreenState extends State<FortuneTellerHomeScreen> {
  String _fortuneTellerName = '占い師';
  int _consultationRequests = 0;
  bool _isLoading = true;
  int _currentIndex = 0; // 現在のタブはホーム画面
  
  // フッターナビゲーションのタブ切り替え処理
  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    
    setState(() {
      _currentIndex = index;
    });
    
    // タブに応じた画面遷移
    switch (index) {
      case 0:
        // すでにホーム画面
        break;
      case 1:
        // チャット画面に遷移
        _showNotImplementedMessage('チャット機能');
        break;
      case 2:
        // 待機する画面に遷移
        _showNotImplementedMessage('待機する機能');
        break;
      case 3:
        // 教えて先生画面に遷移
        _showNotImplementedMessage('教えて先生機能');
        break;
      case 4:
        // マイページに遷移
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const FortuneTellerMyPageScreen()),
        );
        break;
    }
  }
  
  // 未実装機能のメッセージを表示
  void _showNotImplementedMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$featureは開発中です')),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFortuneTellerData();
  }

  Future<void> _loadFortuneTellerData() async {
    setState(() => _isLoading = true);
    
    try {
      // SharedPreferencesからユーザー情報を取得
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('userEmail') ?? '';
      
      if (userEmail.isNotEmpty) {
        // 占い師情報を取得（ここでは仮のデータを使用）
        setState(() {
          _fortuneTellerName = userEmail;
          _consultationRequests = 5; // 仮のデータ
        });
      }
    } catch (e) {
      print('占い師データ読み込みエラー: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F6),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        isFortunetellerMode: true,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '占い師ページ',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreenPlaceholder(),
                ),
              );
            },
            icon: const Icon(Icons.settings, color: Colors.black54),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFortuneTellerHeader(),
                  const SizedBox(height: 16),
                  _buildConsultationRequestsCard(),
                  const SizedBox(height: 16),
                  _buildMenuSection(),
                ],
              ),
            ),
    );
  }

  // 占い師情報ヘッダー
  Widget _buildFortuneTellerHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF3bcfd4),
            child: Text(
              _fortuneTellerName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 24, 
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fortuneTellerName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '占い師',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 相談リクエストカード
  Widget _buildConsultationRequestsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '新着相談リクエスト',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$_consultationRequests件',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3bcfd4),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('この機能は開発中です')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3bcfd4),
                  foregroundColor: Colors.white,
                ),
                child: const Text('確認する'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // メニューセクション
  Widget _buildMenuSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.message,
            title: '相談一覧',
            subtitle: '現在対応中の相談を確認',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('この機能は開発中です')),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.history,
            title: '相談履歴',
            subtitle: '過去の相談一覧',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('この機能は開発中です')),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.payment,
            title: '収入管理',
            subtitle: '売上の確認と振込申請',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('この機能は開発中です')),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.star,
            title: '評価・レビュー',
            subtitle: 'ユーザーからの評価を確認',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('この機能は開発中です')),
              );
            },
          ),
        ],
      ),
    );
  }

  // メニュー項目
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF3bcfd4)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

/// 占い師用設定画面
class SettingsScreenPlaceholder extends StatefulWidget {
  const SettingsScreenPlaceholder({Key? key}) : super(key: key);

  @override
  State<SettingsScreenPlaceholder> createState() => _SettingsScreenPlaceholderState();
}

class _SettingsScreenPlaceholderState extends State<SettingsScreenPlaceholder> {
  String _userEmail = '';
  int _userPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _userEmail = prefs.getString('userEmail') ?? '未設定';
        _userPoints = prefs.getInt('userPoints') ?? 0;
      });
    } catch (e) {
      print('ユーザーデータ読み込みエラー: $e');
    }
  }

  Future<void> _logout() async {
    // ログアウト確認ダイアログを表示
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ログアウトの確認'),
        content: const Text('本当にログアウトしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'ログアウト',
              style: TextStyle(color: Color(0xFF1a237e)), // 濃紺色
            ),
          ),
        ],
      ),
    );

    if (confirmLogout == true) {
      try {
        // SharedPreferencesからユーザーデータを削除
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('userEmail');
        await prefs.remove('userRole');
        await prefs.remove('userId');
        await prefs.remove('userPoints');
        await prefs.remove('isLoggedIn');

        // データベース接続を閉じる
        final dbService = DatabaseService();
        await dbService.disconnect();

        if (mounted) {
          // ログイン画面に遷移
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      } catch (e) {
        print('ログアウトエラー: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ログアウト中にエラーが発生しました')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        children: [
          // アカウント情報セクション
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'アカウント情報',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: Color(0xFF3bcfd4)),
                  title: const Text('メールアドレス'),
                  subtitle: Text(_userEmail),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.star, color: Color(0xFFf8bbd0)), // 薬ピンク色
                  title: const Text('ポイント'),
                  subtitle: Text('$_userPoints ポイント'),
                ),
              ],
            ),
          ),

          // アプリ設定セクション
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 24, bottom: 8),
            child: Text(
              'アプリ設定',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications, color: Color(0xFF3bcfd4)),
                  title: const Text('通知設定'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // 通知設定画面への遷移処理
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('通知設定は開発中です')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock, color: Color(0xFF3bcfd4)),
                  title: const Text('プライバシー設定'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // プライバシー設定画面への遷移処理
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('プライバシー設定は開発中です')),
                    );
                  },
                ),
              ],
            ),
          ),

          // ログアウトセクション
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1a237e), // 濃紺色
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('ログアウト'),
            ),
          ),
        ],
      ),
    );
  }
}
