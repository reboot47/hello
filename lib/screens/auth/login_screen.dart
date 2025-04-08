import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';
import '../../utils/page_transitions.dart';
import '../../services/database_service.dart';
import '../content/home_screen.dart';
import 'simple_register_screen.dart';
import '../fortune_teller/fortune_teller_login_screen.dart';
import 'dart:math';
import '../content/my_page_screen.dart';

/// 一般ユーザー向けログイン画面
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoggingIn = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    // デフォルトログイン情報を設定
    _emailController.text = 'wamwam@me.com';
    _passwordController.text = 'Wamwam0055';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'REBOOT47 SYSTEM',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              const Color(0xFF30B5BA), // 濃いターコイズ
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  children: [
                    // ヘッダー
                    _buildHeader(),
                    
                    const SizedBox(height: 20),
                    
                    // ログインフォーム
                    _buildLoginForm(),
                    
                    const SizedBox(height: 20),
                    
                    // ソーシャルログインオプション
                    _buildSocialOptions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ヘッダー部分
  Widget _buildHeader() {
    return Column(
      children: [
        // ロゴ画像
        Container(
          width: 150,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/images/eboot47_logo.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Image error: $error');
                return Container(
                  color: AppTheme.secondaryColor,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '画像読込エラー',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ).animate()
          .fadeIn(duration: 500.ms)
          .slideY(begin: -0.3, end: 0, duration: 500.ms, curve: Curves.easeOutBack),
        
        const SizedBox(height: 16),
        
        // サブタイトル
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            '占いシステム',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ).animate()
          .fadeIn(duration: 500.ms, delay: 200.ms)
          .slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOut),
      ],
    );
  }

  /// ログインフォーム
  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // メールアドレス
          const Text(
            'メールアドレス',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'example@mail.com',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              prefixIcon: Icon(Icons.email_outlined, color: Colors.white.withOpacity(0.7)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white),
              ),
              isDense: true,
            ),
            validator: Validators.validateEmail,
          ),
          
          const SizedBox(height: 16),
          
          // パスワード
          const Text(
            'パスワード',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '8文字以上の英数字',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              prefixIcon: Icon(Icons.lock_outline, color: Colors.white.withOpacity(0.7)),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withOpacity(0.7),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white),
              ),
              isDense: true,
            ),
            validator: Validators.validatePassword,
          ),
          
          const SizedBox(height: 16),
          
          // パスワードを忘れた場合のリンク
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // パスワードリセット画面への遷移
                print('パスワードリセット');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'パスワード忘れ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // ログインボタン
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoggingIn ? null : _attemptLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryColor,
                disabledBackgroundColor: Colors.white.withOpacity(0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isLoggingIn
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ),
                  )
                : const Text(
                    'ログイン',
                    style: TextStyle(
                      color: Color(0xFF1a237e),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 新規登録案内
          Center(
            child: TextButton(
              onPressed: () {
                // 新規登録画面へ遷移
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleRegisterScreen(),
                  ),
                );
              },
              child: const Text(
                'アカウントをお持ちでない方はこちら',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 占い師向けリンク
          Center(
            child: TextButton(
              onPressed: () {
                // 占い師ポータルに遷移
                Navigator.of(context).pushNamed('/fortune_teller_login');
              },
              child: const Text(
                '占い師の方はこちら',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms, delay: 300.ms)
      .moveY(begin: 20, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }

  /// ソーシャルログインオプション
  Widget _buildSocialOptions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.white.withOpacity(0.5))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'または',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.white.withOpacity(0.5))),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Googleでログイン
        Container(
          width: double.infinity,
          height: 45,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextButton.icon(
            onPressed: () {
              print('Googleログイン');
            },
            icon: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Image.asset(
                'assets/images/google_logo.png',
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.g_mobiledata,
                  color: Colors.red,
                  size: 24,
                ),
              ),
            ),
            label: const Text(
              'Googleでログイン',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ).animate()
          .fadeIn(duration: 500.ms, delay: 400.ms)
          .moveX(begin: 10, end: 0, duration: 400.ms),
        
        // Appleでログイン
        Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextButton.icon(
            onPressed: () {
              print('Appleログイン');
            },
            icon: const Padding(
              padding: EdgeInsets.only(right: 6),
              child: Icon(
                Icons.apple,
                color: Colors.white,
                size: 22,
              ),
            ),
            label: const Text(
              'Appleでログイン',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ).animate()
          .fadeIn(duration: 500.ms, delay: 500.ms)
          .moveX(begin: 10, end: 0, duration: 400.ms),
      ],
    );
  }

  /// ソーシャルログインボタン
  Widget _buildSocialButton({
    required String? icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
    required IconData fallbackIcon,
    required Color fallbackIconColor,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Image.asset(
                icon,
                width: 22,
                height: 22,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(fallbackIcon, size: 22, color: fallbackIconColor);
                },
              )
            : Icon(fallbackIcon, size: 22, color: fallbackIconColor),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: textColor,
        ),
      ),
    );
  }

  /// ログイン処理
  Future<void> _attemptLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoggingIn = true;
      });
      
      try {
        // データベースサービスのインスタンスを取得
        final dbService = DatabaseService();
        
        // ローディング表示
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                      strokeWidth: 3,
                    ).animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 1200.ms, color: const Color(0xFFF8BBD0).withOpacity(0.5)),
                  ),
                  const SizedBox(height: 20),
                  Text('ログイン中...',
                    style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate()
                   .fadeIn(duration: 300.ms)
                   .then(delay: 200.ms)
                   .fadeOut(duration: 300.ms)
                   .then(delay: 200.ms)
                   .fadeIn(duration: 300.ms),
                ],
              ),
            ),
          ),
        );
        
        // データベースに接続
        await dbService.connect();
        
        // ログイン処理
        final result = await dbService.loginUser(
          _emailController.text.trim(),
          _passwordController.text,
        );
        
        // ローディングダイアログを閉じる
        if (mounted) Navigator.of(context).pop();
        
        if (result?['success'] == true) {
          // ログイン成功
          final userData = result?['user'];
          
          if (mounted) {
            // ダッシュボードに遷移
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(userData: userData),
              ),
            );
          }
        } else {
          // ログイン失敗
          final errorMessage = result?['message'] ?? 'ログインに失敗しました。';
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        }
      } catch (e) {
        // エラー処理
        print('Error during login: $e');
        
        // ローディングダイアログが表示中なら閉じる
        if (mounted) Navigator.of(context).pop();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('エラーが発生しました: $e'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } finally {
        // データベース接続を終了
        try {
          final dbService = DatabaseService();
          await dbService.disconnect();
        } catch (e) {
          print('Error disconnecting database: $e');
        }
        
        if (mounted) {
          setState(() {
            _isLoggingIn = false;
          });
        }
      }
    }
  }
}
