import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  // ユーザー情報
  String _userEmail = '';
  String _userName = '';
  String _userPhone = '';
  bool _isNewsLetterEnabled = true;
  bool _isMonthlyReportEnabled = true;
  bool _isEventNotificationEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ユーザーデータを取得
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      // SharedPreferencesからユーザーメールを取得
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('userEmail');
      
      if (userEmail == null) {
        throw Exception('ユーザー情報が見つかりません');
      }
      
      // データベースサービスを初期化
      final dbService = DatabaseService();
      await dbService.connect();
      
      // ユーザープロフィールを取得
      final result = await dbService.getUserProfile(userEmail);
      await dbService.disconnect();
      
      if (result['success']) {
        final profile = result['profile'];
        setState(() {
          _userEmail = userEmail;
          _userName = profile['name'] ?? '';
          _userPhone = profile['phone'] ?? '';
          _isNewsLetterEnabled = profile['newsletter_enabled'] ?? true;
          _isMonthlyReportEnabled = profile['monthly_report_enabled'] ?? true;
          _isEventNotificationEnabled = profile['event_notification_enabled'] ?? true;
        });
      } else {
        throw Exception(result['message'] ?? 'ユーザープロフィールの取得に失敗しました');
      }
    } catch (e) {
      print('ユーザーデータ取得エラー: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ユーザー情報の取得に失敗しました: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 設定を保存
  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    try {
      // データベースサービスを初期化
      final dbService = DatabaseService();
      await dbService.connect();
      
      // 更新するデータを準備
      final updateData = {
        'newsletter_enabled': _isNewsLetterEnabled,
        'monthly_report_enabled': _isMonthlyReportEnabled,
        'event_notification_enabled': _isEventNotificationEnabled,
      };
      
      // ユーザープロフィールを更新
      final result = await dbService.updateUserProfile(_userEmail, updateData);
      await dbService.disconnect();
      
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('設定を保存しました')),
        );
      } else {
        throw Exception(result['message'] ?? '設定の保存に失敗しました');
      }
    } catch (e) {
      print('設定保存エラー: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('設定の保存に失敗しました: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'アカウント・メルマガ設定',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // アカウント情報セクション
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                    child: Text(
                      'アカウント情報',
                      style: TextStyle(
                        color: Color(0xFF1a237e), // 濃紺
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoItem('メールアドレス', _userEmail, Icons.email_outlined),
                        const Divider(height: 1),
                        _buildInfoItem('ユーザー名', _userName, Icons.person_outline),
                        const Divider(height: 1),
                        _buildInfoItem('電話番号', _userPhone, Icons.phone_outlined),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF3bcfd4), // ターコイズ
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Color(0xFF3bcfd4)),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('パスワード変更機能は現在開発中です')),
                              );
                            },
                            child: const Text(
                              'パスワードを変更する',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // メルマガ設定セクション
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Text(
                      'メルマガ設定',
                      style: TextStyle(
                        color: Color(0xFF1a237e), // 濃紺
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text(
                            'お得な情報を受け取る',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: const Text(
                            'キャンペーンやイベントの情報をメールでお知らせします',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          value: _isNewsLetterEnabled,
                          activeColor: const Color(0xFF3bcfd4), // ターコイズ
                          onChanged: (value) {
                            setState(() {
                              _isNewsLetterEnabled = value;
                            });
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        SwitchListTile(
                          title: const Text(
                            '月次レポートを受け取る',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: const Text(
                            'あなたの運勢や星座の傾向を月次でお届けします',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          value: _isMonthlyReportEnabled,
                          activeColor: const Color(0xFF3bcfd4), // ターコイズ
                          onChanged: (value) {
                            setState(() {
                              _isMonthlyReportEnabled = value;
                            });
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        SwitchListTile(
                          title: const Text(
                            'イベント通知',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: const Text(
                            '特別イベントやセミナーの案内をお届けします',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          value: _isEventNotificationEnabled,
                          activeColor: const Color(0xFF3bcfd4), // ターコイズ
                          onChanged: (value) {
                            setState(() {
                              _isEventNotificationEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  // 保存ボタン
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3bcfd4), // ターコイズ
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _saveSettings,
                      child: const Text(
                        '設定を保存',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // 情報表示アイテム
  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 22),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? '未設定' : value,
                style: TextStyle(
                  fontSize: 16,
                  color: value.isEmpty ? Colors.grey.shade400 : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
