import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_screen.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({Key? key}) : super(key: key);

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  bool _isLoading = false;
  String _appVersion = '1.2.3';
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  // 設定を読み込む
  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _appVersion = prefs.getString('app_version') ?? '1.2.3';
      });
    } catch (e) {
      print('設定読み込みエラー: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  // ユーザー設定を保存する
  Future<void> _saveUserPreference(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('設定を保存しました')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }
  
  // ログアウト処理
  Future<void> _logout() async {
    // 確認ダイアログを表示
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ログアウトしますか？'),
        content: const Text('ログアウトすると、再度ログインが必要になります。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('ログアウト'),
          ),
        ],
      ),
    ) ?? false;
    
    if (!confirmed) return;
    
    setState(() => _isLoading = true);
    try {
      // SharedPreferencesからユーザー情報を削除
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userEmail');
      await prefs.remove('userPassword');
      
      // ログイン画面に戻る
      if (!mounted) return;
      
      // 直接ログイン画面に遷移する（名前付きルートではなく、MaterialPageRouteを使用）
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      
      // スナックバーで通知
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ログアウトしました')),
      );
    } catch (e) {
      print('ログアウトエラー: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ログアウト中にエラーが発生しました: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1ECF8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFC080FC)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '設定',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
        actions: [
          // 右上にログアウトボタンを追加
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFC080FC)),
            onPressed: _logout,
            tooltip: 'ログアウト',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            // アカウントセクション
            _buildSectionHeader('アカウント'),
            _buildNavigationOption(
              context,
              'ブロックリスト',
              () {
                // ブロックリスト画面へのナビゲーション
              }
            ),
            _buildNavigationOption(
              context,
              '退会・アカウント削除',
              () {
                // 退会・アカウント削除画面へのナビゲーション
              }
            ),
            _buildNavigationOption(
              context,
              'アプリのレビューを書く',
              () {
                // アプリのレビュー画面へのナビゲーション
              }
            ),
            
            // サービスセクション
            _buildSectionHeader('サービス'),
            _buildNavigationOption(
              context,
              '料金について',
              () {
                // 料金ページへのナビゲーション
              }
            ),
            _buildNavigationOption(
              context,
              '使い方',
              () {
                // 使い方ページへのナビゲーション
              }
            ),
            _buildNavigationOption(
              context,
              '利用規約',
              () {
                // 利用規約ページへのナビゲーション
              }
            ),
            _buildNavigationOption(
              context,
              'プライバシーポリシー',
              () {
                // プライバシーポリシーページへのナビゲーション
              }
            ),
            _buildNavigationOption(
              context,
              '特定商取引法に基づく表示',
              () {
                // 特定商取引法ページへのナビゲーション
              }
            ),
            
            // バージョン情報
            _buildVersionInfo(),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFECECF8),
      width: double.infinity,
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF757575),
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildNavigationOption(BuildContext context, String title, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFEEEEEE),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: Text(
        'バージョン$_appVersion',
        style: const TextStyle(
          color: Color(0xFF757575),
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
