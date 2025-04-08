import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // 通知設定
  bool _isPushEnabled = true;
  bool _isMessageNotificationEnabled = true;
  bool _isCommentNotificationEnabled = true;
  bool _isLikeNotificationEnabled = true;
  bool _isFortuneNotificationEnabled = true;
  bool _isPointsNotificationEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  // 通知設定を取得
  Future<void> _loadNotificationSettings() async {
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
          _isPushEnabled = profile['push_enabled'] ?? true;
          _isMessageNotificationEnabled = profile['message_notification_enabled'] ?? true;
          _isCommentNotificationEnabled = profile['comment_notification_enabled'] ?? true;
          _isLikeNotificationEnabled = profile['like_notification_enabled'] ?? true;
          _isFortuneNotificationEnabled = profile['fortune_notification_enabled'] ?? true;
          _isPointsNotificationEnabled = profile['points_notification_enabled'] ?? true;
        });
      } else {
        throw Exception(result['message'] ?? '通知設定の取得に失敗しました');
      }
    } catch (e) {
      print('通知設定取得エラー: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('通知設定の取得に失敗しました: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 設定を保存
  Future<void> _saveSettings() async {
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
      
      // 更新するデータを準備
      final updateData = {
        'push_enabled': _isPushEnabled,
        'message_notification_enabled': _isMessageNotificationEnabled,
        'comment_notification_enabled': _isCommentNotificationEnabled,
        'like_notification_enabled': _isLikeNotificationEnabled,
        'fortune_notification_enabled': _isFortuneNotificationEnabled,
        'points_notification_enabled': _isPointsNotificationEnabled,
      };
      
      // ユーザープロフィールを更新
      final result = await dbService.updateUserProfile(userEmail, updateData);
      await dbService.disconnect();
      
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('通知設定を保存しました')),
        );
      } else {
        throw Exception(result['message'] ?? '通知設定の保存に失敗しました');
      }
    } catch (e) {
      print('通知設定保存エラー: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('通知設定の保存に失敗しました: $e')),
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
          '通知設定',
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
                  // プッシュ通知設定
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                    child: Text(
                      'プッシュ通知',
                      style: TextStyle(
                        color: Color(0xFF1a237e), // 濃紺
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
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
                    child: SwitchListTile(
                      title: const Text(
                        'プッシュ通知を受け取る',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: const Text(
                        'すべての通知を有効または無効にします',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      value: _isPushEnabled,
                      activeColor: const Color(0xFF3bcfd4), // ターコイズ
                      onChanged: (value) {
                        setState(() {
                          _isPushEnabled = value;
                        });
                      },
                    ),
                  ),
                  
                  // 通知カテゴリ設定
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Text(
                      '通知カテゴリ',
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
                            'メッセージ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: const Text(
                            '新しいメッセージが届いたときに通知します',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          value: _isMessageNotificationEnabled && _isPushEnabled,
                          activeColor: const Color(0xFF3bcfd4), // ターコイズ
                          onChanged: _isPushEnabled ? (value) {
                            setState(() {
                              _isMessageNotificationEnabled = value;
                            });
                          } : null,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        SwitchListTile(
                          title: const Text(
                            'コメント',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: const Text(
                            'あなたの投稿にコメントがついたときに通知します',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          value: _isCommentNotificationEnabled && _isPushEnabled,
                          activeColor: const Color(0xFF3bcfd4), // ターコイズ
                          onChanged: _isPushEnabled ? (value) {
                            setState(() {
                              _isCommentNotificationEnabled = value;
                            });
                          } : null,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        SwitchListTile(
                          title: const Text(
                            'いいね',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: const Text(
                            'あなたの投稿にいいねがついたときに通知します',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          value: _isLikeNotificationEnabled && _isPushEnabled,
                          activeColor: const Color(0xFF3bcfd4), // ターコイズ
                          onChanged: _isPushEnabled ? (value) {
                            setState(() {
                              _isLikeNotificationEnabled = value;
                            });
                          } : null,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        SwitchListTile(
                          title: const Text(
                            '運勢情報',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: const Text(
                            '日々の運勢情報やアドバイスを通知します',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          value: _isFortuneNotificationEnabled && _isPushEnabled,
                          activeColor: const Color(0xFF3bcfd4), // ターコイズ
                          onChanged: _isPushEnabled ? (value) {
                            setState(() {
                              _isFortuneNotificationEnabled = value;
                            });
                          } : null,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        SwitchListTile(
                          title: const Text(
                            'ポイント情報',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: const Text(
                            'ポイントの取得・利用があったときに通知します',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          value: _isPointsNotificationEnabled && _isPushEnabled,
                          activeColor: const Color(0xFF3bcfd4), // ターコイズ
                          onChanged: _isPushEnabled ? (value) {
                            setState(() {
                              _isPointsNotificationEnabled = value;
                            });
                          } : null,
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
}
