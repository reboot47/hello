import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // 設定値
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _siteNotificationsEnabled = true;
  bool _timelinePostsEnabled = true;
  bool _quickEnableAll = true;
  bool _isLoading = false;
  
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
        _soundEnabled = prefs.getBool('sound_enabled') ?? true;
        _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
        _siteNotificationsEnabled = prefs.getBool('site_notifications_enabled') ?? true;
        _timelinePostsEnabled = prefs.getBool('timeline_posts_enabled') ?? true;
        _quickEnableAll = prefs.getBool('quick_enable_all') ?? true;
      });
    } catch (e) {
      print('設定読み込みエラー: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  // 設定を一括保存する
  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sound_enabled', _soundEnabled);
      await prefs.setBool('vibration_enabled', _vibrationEnabled);
      await prefs.setBool('site_notifications_enabled', _siteNotificationsEnabled);
      await prefs.setBool('timeline_posts_enabled', _timelinePostsEnabled);
      await prefs.setBool('quick_enable_all', _quickEnableAll);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('設定を保存しました')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  // 個別の設定項目を保存する
  Future<void> _saveSettingItem(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is bool) {
        await prefs.setBool(key, value);
      }
      print('保存しました: $key = $value');
    } catch (e) {
      print('設定保存エラー: $e');
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
          onPressed: () {
            // 個別に保存済みなので、完了メッセージだけ表示
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('設定を保存しました')),
            );
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          '通知設定',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            // サウンド設定セクション
            _buildSectionHeader('サウンド設定'),
            _buildToggleOption('サウンド', _soundEnabled, (value) async {
              setState(() {
                _soundEnabled = value;
              });
              await _saveSettingItem('sound_enabled', value);
            }),
            _buildToggleOption('バイブレーション', _vibrationEnabled, (value) async {
              setState(() {
                _vibrationEnabled = value;
              });
              await _saveSettingItem('vibration_enabled', value);
            }),
            
            // 通知設定セクション
            _buildSectionHeader('通知設定'),
            _buildToggleOption('サイトからのお知らせ', _siteNotificationsEnabled, (value) async {
              setState(() {
                _siteNotificationsEnabled = value;
              });
              await _saveSettingItem('site_notifications_enabled', value);
            }),
            _buildToggleOption('タイムライン投稿（お気に入りのみ）', _timelinePostsEnabled, (value) async {
              setState(() {
                _timelinePostsEnabled = value;
              });
              await _saveSettingItem('timeline_posts_enabled', value);
            }),
            
            // メッセージ受信設定
            _buildNavigationOption('メッセージ受信', 'すべて'),
            
            // オンライン通知セクション
            _buildSectionHeader('オンライン通知'),
            _buildToggleOption('お気に入りを一括でONにする', _quickEnableAll, (value) async {
              setState(() {
                _quickEnableAll = value;
              });
              await _saveSettingItem('quick_enable_all', value);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFECECF8),
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

  Widget _buildToggleOption(String title, bool value, Function(bool) onChanged) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF303030),
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFF3bcfd4),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildNavigationOption(String title, String subtitle) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
