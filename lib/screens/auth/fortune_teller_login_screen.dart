import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';

/// 占い師向けログイン画面
class FortuneTellerLoginScreen extends StatefulWidget {
  const FortuneTellerLoginScreen({Key? key}) : super(key: key);

  @override
  State<FortuneTellerLoginScreen> createState() => _FortuneTellerLoginScreenState();
}

class _FortuneTellerLoginScreenState extends State<FortuneTellerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('占い師ポータル', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              // ヘルプ情報を表示
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('占い師サポートについてはお問い合わせください'),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1a237e), // ダークブルー（60%）
              const Color(0xFF121858), // さらに暗いブルー
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ロゴとヘッダー
                _buildHeader()
                    .animate()
                    .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                    .slideY(begin: -0.2, end: 0, duration: 600.ms),
                
                const SizedBox(height: 32),
                
                // ログインフォーム
                _buildLoginForm()
                    .animate()
                    .fadeIn(
                      duration: 800.ms,
                      delay: 300.ms,
                      curve: Curves.easeOut,
                    ),
                    
                const SizedBox(height: 32),
                
                // 登録案内
                _buildRegistrationInfo()
                    .animate()
                    .fadeIn(
                      duration: 800.ms,
                      delay: 600.ms,
                      curve: Curves.easeOut,
                    ),
              ],
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
        // 占星術をイメージしたロゴ
        Container(
          width: 120,
          height: 120,
          margin: const EdgeInsets.only(top: 20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 外側の円形装飾（幻想的な星や月の軌道を表現）
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                ),
              ),
              
              // 内側の円
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.95),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primaryColor,
                          const Color(0xFF6AECF2),
                        ],
                      ).createShader(bounds);
                    },
                    child: const Icon(
                      Icons.auto_awesome, // 星のアイコン
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              // 装飾的な円
              Positioned(
                top: 10,
                right: 15,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF8BBD0).withOpacity(0.7), // ライトピンク
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // 占い師向けタイトル
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.8),
              ],
            ).createShader(bounds);
          },
          child: const Text(
            '占い師ポータル',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // 説明文
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            '特別な占い師セッションにアクセス',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w300,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// ログインフォーム
  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // フォームコンテナ
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // メールアドレス入力
                const Text(
                  'メールアドレス',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'fortune@teller.com',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    prefixIcon: Icon(Icons.mail_outline, color: AppTheme.primaryColor),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                  ),
                  validator: Validators.validateEmail,
                ),
                
                const SizedBox(height: 24),
                
                // パスワード入力
                const Text(
                  'パスワード',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'パスワードを入力',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    prefixIcon: Icon(Icons.lock_outline, color: AppTheme.primaryColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                  ),
                  validator: Validators.validatePassword,
                ),
              ],
            ),
          ),
          // オプションコンテナ
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            child: Row(
              children: [
                // カスタムチェックボックス
                InkWell(
                  onTap: () {
                    setState(() {
                      _rememberMe = !_rememberMe;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _rememberMe ? AppTheme.primaryColor : Colors.transparent,
                          border: Border.all(
                            color: _rememberMe ? AppTheme.primaryColor : Colors.white.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: _rememberMe
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'ログイン情報を記憶',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // パスワードリセット
                TextButton(
                  onPressed: () {
                    // パスワードリセット機能
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('パスワードリセットメールを送信しました'),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'パスワードを忘れた場合',
                    style: TextStyle(
                      color: AppTheme.primaryColor.withOpacity(0.9),
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationThickness: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // ログインボタン
          Container(
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                  spreadRadius: -5,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor, // ターコイズ
                  const Color(0xFF30B5BA), // より濃いターコイズ
                ],
              ),
            ),
            child: ElevatedButton(
              onPressed: _attemptLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stars, size: 20),
                  const SizedBox(width: 10),
                  const Text(
                    '占い師ポータルにログイン',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 一般ユーザーログインに戻る
          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios, size: 14, color: Colors.white.withOpacity(0.8)),
              label: Text('一般ユーザーログインに戻る', 
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 占い師登録案内セクション
  Widget _buildRegistrationInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 30),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.07),
            Colors.white.withOpacity(0.02),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 装飾的なヘッダー
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -10,
                top: -10,
                child: Icon(
                  Icons.auto_awesome,
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  size: 30,
                ),
              ),
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryColor,
                          Colors.white,
                        ],
                      ).createShader(bounds);
                    },
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '占い師になるには',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 説明文
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppTheme.primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '専門家による審査プロセスあり',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppTheme.primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '実績や専門分野の証明が必要',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppTheme.primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '特別な占いセッションへの参加権',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 申請ボタン
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  // 占い師申請フォームへ
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('占い師申請フォームは準備中です'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.spa,
                  size: 18,
                ),
                label: const Text('占い師申請プロセスを開始'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ログイン処理
  void _attemptLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // ローディングアニメーション表示
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('占い師ポータルに接続中...',
                  style: TextStyle(
                    color: AppTheme.secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text('占いの力を呼び起こしています',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // 模擬ログイン処理（デモ表示用）
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // ローディングダイアログを閉じる
        
        // ログイン成功表示
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: AppTheme.primaryColor,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text('ログイン成功',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1a237e),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('占い師ポータルへようこそ。特別なセッションにアクセスできます。',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // 実際のアプリではここでホーム画面に遷移する
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('ポータルへ移動',
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
          ),
        );
      });
    }
  }
}
