import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../services/database_service.dart';
import '../auth/login_screen.dart';

/// 設定画面
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '1.2.3'; // アプリバージョン
  
  // ログアウト処理
  Future<void> _logout() async {
    // ログアウト確認ダイアログを表示
    final bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ログアウト確認'),
          content: const Text('本当にログアウトしますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('ログアウト', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    
    if (confirmLogout == true) {
      try {
        // SharedPreferencesからユーザー情報を削除
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('userEmail');
        await prefs.remove('userId');
        
        // データベース接続を切断
        try {
          final dbService = DatabaseService();
          await dbService.disconnect();
        } catch (e) {
          print('データベース切断エラー: $e');
          // データベース切断失敗を無視して続行
        }
        
        // ログイン画面に遷移し、バックスタックをクリア
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
        
        // 成功メッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ログアウトしました')),
        );
      } catch (e) {
        print('ログアウトエラー: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ログアウト中にエラーが発生しました')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '設定',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // アカウントセクション
            _buildSectionHeader('アカウント'),
            _buildSettingItem(
              title: 'アカウント',
              onTap: () {
                // アカウント設定への遷移
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('アカウント設定は現在開発中です')),
                );
              },
            ),
            _buildSettingItem(
              title: 'ブロックリスト',
              onTap: () {
                // ブロックリスト画面への遷移
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ブロックリスト機能は現在開発中です')),
                );
              },
              showDivider: true,
            ),
            _buildSettingItem(
              title: 'ログアウト',
              titleColor: Colors.red, // 警告カラー
              onTap: _logout,
              showDivider: true,
            ),
            _buildSettingItem(
              title: '退会・アカウント削除',
              onTap: () {
                // 退会処理画面への遷移
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('退会機能は現在開発中です')),
                );
              },
              showDivider: true,
            ),
            _buildSettingItem(
              title: 'アプリのレビューを書く',
              onTap: () {
                // アプリストアへの遷移
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('レビュー機能は現在開発中です')),
                );
              },
              showDivider: false,
            ),

            const SizedBox(height: 20),

            // サービスセクション
            _buildSectionHeader('サービス'),
            _buildSettingItem(
              title: '料金について',
              onTap: () {
                // 料金情報画面への遷移
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('料金情報は現在開発中です')),
                );
              },
            ),
            _buildSettingItem(
              title: '使い方',
              onTap: () {
                // 使い方ガイド画面への遷移
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('使い方ガイドは現在開発中です')),
                );
              },
              showDivider: true,
            ),
            _buildSettingItem(
              title: '利用規約',
              onTap: () {
                // 利用規約画面への遷移
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('利用規約は現在開発中です')),
                );
              },
              showDivider: true,
            ),
            _buildSettingItem(
              title: 'プライバシーポリシー',
              onTap: () {
                // プライバシーポリシー画面への遷移
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('プライバシーポリシーは現在開発中です')),
                );
              },
              showDivider: true,
            ),
            _buildSettingItem(
              title: '特定商取引法に基づく表示',
              onTap: () {
                // 特定商取引法画面への遷移
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('特定商取引法に基づく表示は現在開発中です')),
                );
              },
              showDivider: false,
            ),

            // バージョン情報
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: const Color(0xFFE0F7FA),
              child: Center(
                child: Text(
                  'バージョン$_appVersion',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// セクションヘッダーを作成
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFF0F0F5),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 設定項目を作成
  Widget _buildSettingItem({
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
    Color? titleColor,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: titleColor,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.black38,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Divider(height: 1, color: Color(0xFFE0E0E0)),
          ),
      ],
    );
  }
}
