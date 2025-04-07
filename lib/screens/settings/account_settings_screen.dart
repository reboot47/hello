import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/database_service.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _newsletterEnabled = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }
  
  // SharedPreferencesから設定を読み込む
  Future<void> _loadUserSettings() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 実際に使用したメールアドレスを取得
      String savedEmail = prefs.getString('userEmail') ?? '';
      
      // 場合によってはデフォルト値を使用
      if (savedEmail.isEmpty) {
        // デフォルトでwamwam@me.comを使用（ログイン画面のデフォルト値）
        savedEmail = 'wamwam@me.com';
        // 保存しておく
        await prefs.setString('userEmail', savedEmail);
      }
      
      setState(() {
        _emailController.text = savedEmail;
        _newsletterEnabled = prefs.getBool('newsletterEnabled') ?? true;
      });
      
      print('メールアドレスを読み込みました: ${_emailController.text}');
    } catch (e) {
      print('設定の読み込みエラー: $e');
      
      // エラー発生時はデフォルト値を設定
      setState(() {
        _emailController.text = 'wamwam@me.com';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  // データを保存する
  Future<void> _saveUserSettings() async {
    if (!_formKey.currentState!.validate()) return;
    
    // パスワード入力がある場合の追加検証
    if (_passwordController.text.isNotEmpty) {
      // 8文字以上の英数字かチェック
      if (_passwordController.text.length < 8 || !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(_passwordController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('パスワードは8文字以上の英数字で入力してください')),
        );
        return;
      }
      
      // パスワード一致チェック
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('パスワードが一致しません')),
        );
        return;
      }
    }
    
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // メールアドレスの保存
      final email = _emailController.text;
      await prefs.setString('userEmail', email);
      print('メールアドレスを保存しました: $email');
      
      // パスワードの保存処理
      if (_passwordController.text.isNotEmpty) {
        final newPassword = _passwordController.text;
        
        // SharedPreferencesにパスワードを保存
        final success = await prefs.setString('userPassword', newPassword);
        
        if (!success) {
          print('パスワードの保存に失敗しました');
          throw Exception('パスワードの保存に失敗しました');
        }
        
        print('ローカルにパスワードを保存しました: $newPassword');
        
        // データベースにもパスワードを更新
        try {
          // データベースサービスを取得
          final dbService = DatabaseService();
          await dbService.connect();
          
          // データベース内のパスワードを更新
          final result = await dbService.updatePassword(email, newPassword);
          
          await dbService.disconnect();
          
          if (result['success']) {
            print('データベース内のパスワードを正常に更新しました');
          } else {
            print('データベース内のパスワード更新エラー: ${result['message']}');
            throw Exception('データベース内のパスワード更新エラー: ${result['message']}');
          }
        } catch (dbError) {
          print('データベースエラー: $dbError');
          throw Exception('データベース内のパスワード更新に失敗しました: $dbError');
        }
      }
      
      // ニュースレター設定の保存
      await prefs.setBool('newsletterEnabled', _newsletterEnabled);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('設定を保存しました')),
      );
      
      Navigator.of(context).pop();
    } catch (e) {
      print('設定保存エラー: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1ECF8),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleSpacing: 0,
        leadingWidth: 100,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'キャンセル',
            style: TextStyle(
              color: Color(0xFFC080FC),
              fontSize: 15,
            ),
          ),
        ),
        title: const Text(
          'パスワード変更',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          Container(
            width: 100,
            alignment: Alignment.center,
            child: TextButton(
              onPressed: _isLoading ? null : _saveUserSettings,
              child: Text(
                '完了',
                style: TextStyle(
                  color: _isLoading ? Colors.grey : const Color(0xFFC080FC),
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // メールアドレス入力フィールド
                  _buildInputSection('メールアドレス', _emailController, false, validator: (value) {
                    if (value?.isEmpty ?? true) return null; // 空欄は許可
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                      return '有効なメールアドレスを入力してください';
                    }
                    return null;
                  }),
                  
                  // パスワード入力フィールド
                  _buildInputSection('パスワード', _passwordController, true, validator: (value) {
                    if (value?.isEmpty ?? true) return null; // 空欄は許可（未変更の場合）
                    if (value!.length < 8) return '8文字以上入力してください';
                    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) return '英数字のみ使用できます';
                    return null;
                  }),
                  
                  // パスワード確認フィールド
                  _buildInputSection('パスワード確認', _confirmPasswordController, true, validator: (value) {
                    if (_passwordController.text.isEmpty) return null; // パスワードが空ならチェックしない
                    if (value != _passwordController.text) return 'パスワードが一致しません';
                    return null;
                  }),
                  
                  // 説明テキスト
                  _buildInfoText(),
                  
                  // メルマガ設定
                  _buildNewsletterToggle(),
                  
                  // メルマガ説明テキスト
                  _buildNewsletterInfoText(),
                  
                  // ログアウトボタン
                  const SizedBox(height: 40),
                  _buildLogoutButton(),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildInputSection(String label, TextEditingController controller, bool isPassword, {String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            validator: validator,
            enabled: label != 'メールアドレス', // メールアドレスフィールドは編集不可
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            style: TextStyle(
              fontSize: 16,
              color: label == 'メールアドレス' ? Colors.black54 : Colors.black87, // メールアドレスは薄い色に
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE0E0E0)),
      ],
    );
  }

  Widget _buildInfoText() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFE9EFFD),
      child: const Text(
        'パスワードを変更する場合は、新しいパスワードを入力してください。\n登録済みのメールアドレスは変更できません。\nパスワードを変更しない場合は、パスワード欄を空白のままで完了ボタンを押してください。\nパスワードは8文字以上の英数字で設定してください。',
        style: TextStyle(
          color: Color(0xFF505050),
          fontSize: 12,
          height: 1.5, // 行間を調整して画像に近づける
        ),
      ),
    );
  }

  Widget _buildNewsletterToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'メルマガ設定',
            style: TextStyle(
              color: Color(0xFF303030),
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
          Switch(
            value: _newsletterEnabled,
            onChanged: (value) {
              setState(() {
                _newsletterEnabled = value;
              });
            },
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF3bcfd4),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildNewsletterInfoText() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFE8FBF9),
      child: const Text(
        'メールアドレスを設定するだけで、無料ポイントがもらえるキャンペーンや、お気に入りの先生のイベント情報などを受け取ることができます。\n設定はいつでもオフにすることができますので、お得な情報を逃さないためにもまずはオンにしてみましょう。',
        style: TextStyle(
          color: Color(0xFF505050),
          fontSize: 12,
          height: 1.5, // 行間を調整して画像に近づける
        ),
      ),
    );
  }

  // ログアウトボタン
  Widget _buildLogoutButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _logout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('ログアウト', style: TextStyle(fontSize: 16)),
      ),
    );
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
      
      // アニメーション付きで遷移
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      
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
}
