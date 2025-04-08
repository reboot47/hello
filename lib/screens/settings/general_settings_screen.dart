import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({Key? key}) : super(key: key);

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  // 一般設定
  bool _isDarkModeEnabled = false;
  String _selectedLanguage = '日本語';
  String _selectedTheme = 'デフォルト';
  bool _isAutoplayEnabled = true;
  bool _isLoading = true;
  
  // テーマオプション
  final List<String> _themeOptions = ['デフォルト', 'ライト', 'ダーク'];
  
  // 言語オプション
  final List<String> _languageOptions = ['日本語', '英語'];

  @override
  void initState() {
    super.initState();
    _loadGeneralSettings();
  }

  // 設定を取得
  Future<void> _loadGeneralSettings() async {
    setState(() => _isLoading = true);
    try {
      // SharedPreferencesからユーザー設定を取得
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
          _isDarkModeEnabled = profile['dark_mode_enabled'] ?? false;
          _selectedLanguage = profile['language'] ?? '日本語';
          _selectedTheme = profile['theme'] ?? 'デフォルト';
          _isAutoplayEnabled = profile['autoplay_enabled'] ?? true;
        });
      } else {
        throw Exception(result['message'] ?? '設定の取得に失敗しました');
      }
    } catch (e) {
      print('設定取得エラー: $e');
      // ローカルの設定を使用
      setState(() {
        _isDarkModeEnabled = false;
        _selectedLanguage = '日本語';
        _selectedTheme = 'デフォルト';
        _isAutoplayEnabled = true;
      });
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
        'dark_mode_enabled': _isDarkModeEnabled,
        'language': _selectedLanguage,
        'theme': _selectedTheme,
        'autoplay_enabled': _isAutoplayEnabled,
      };
      
      // ユーザープロフィールを更新
      final result = await dbService.updateUserProfile(userEmail, updateData);
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
          '一般設定',
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
                  // 表示設定セクション
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                    child: Text(
                      '表示設定',
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
                            'ダークモード',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: const Text(
                            'アプリ全体の表示を暗いテーマに切り替えます',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          value: _isDarkModeEnabled,
                          activeColor: const Color(0xFF3bcfd4), // ターコイズ
                          onChanged: (value) {
                            setState(() {
                              _isDarkModeEnabled = value;
                            });
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          title: const Text(
                            'テーマ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            _selectedTheme,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          onTap: () {
                            _showThemeSelector();
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  // 言語設定セクション
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Text(
                      '言語設定',
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
                    child: ListTile(
                      title: const Text(
                        '言語',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        _selectedLanguage,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        _showLanguageSelector();
                      },
                    ),
                  ),
                  
                  // メディア設定セクション
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Text(
                      'メディア設定',
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
                    child: SwitchListTile(
                      title: const Text(
                        '動画自動再生',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: const Text(
                        'ホーム画面などで動画を自動再生します',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      value: _isAutoplayEnabled,
                      activeColor: const Color(0xFF3bcfd4), // ターコイズ
                      onChanged: (value) {
                        setState(() {
                          _isAutoplayEnabled = value;
                        });
                      },
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
  
  // テーマ選択ダイアログ
  void _showThemeSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('テーマを選択'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _themeOptions.map((theme) => 
            RadioListTile<String>(
              title: Text(theme),
              value: theme,
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.of(context).pop();
              },
            ),
          ).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
        ],
      ),
    );
  }
  
  // 言語選択ダイアログ
  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('言語を選択'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languageOptions.map((language) => 
            RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.of(context).pop();
              },
            ),
          ).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
        ],
      ),
    );
  }
}
