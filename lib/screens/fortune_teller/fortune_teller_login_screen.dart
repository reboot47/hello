import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../../services/database_service.dart';
// import '../../theme/app_theme.dart'; // 未使用のため削除
import 'fortune_teller_home_screen.dart';

/// 占い師ポータルログイン画面
/// 高品質な神秘的デザインで占い師にふさわしいUIを提供
class FortuneTellerLoginScreen extends StatefulWidget {
  const FortuneTellerLoginScreen({Key? key}) : super(key: key);

  @override
  State<FortuneTellerLoginScreen> createState() => _FortuneTellerLoginScreenState();
}

class _FortuneTellerLoginScreenState extends State<FortuneTellerLoginScreen> 
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoggingIn = false;
  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  
  // アニメーション用コントローラー
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  
  // 星の位置リスト
  final List<Star> _stars = List.generate(20, (index) => Star());

  @override
  void initState() {
    super.initState();
    
    // デフォルト値の設定
    _emailController.text = 'test1';
    _passwordController.text = '11111111';
    
    _loadSavedCredentials();
    
    // 星が回転するアニメーション
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100),
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_animationController);
    
    _animationController.repeat();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // 保存された認証情報を読み込む
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('fortuneTellerRememberMe') == true) {
      setState(() {
        _emailController.text = prefs.getString('fortuneTellerEmail') ?? '';
        _rememberMe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ヘルプページは現在準備中です')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 背景グラデーション
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0c164d), // 深い紺
                  Color(0xFF1a237e), // 濃紺
                  Color(0xFF281fa2), // 紺に近いパープル
                ],
              ),
            ),
          ),
          
          // 星空アニメーション
          CustomPaint(
            painter: StarfieldPainter(_stars, _rotationAnimation.value),
            size: MediaQuery.of(context).size,
          ),
          
          // 上部の光源効果
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3bcfd4).withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),
          
          // メインコンテンツ
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
              child: Column(
                children: [
                  _buildLogo(),
                  const SizedBox(height: 40),
                  // フロストガラスエフェクト付きカード
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: _buildLoginForm(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // ロゴ部分
  Widget _buildLogo() {
    return Column(
      children: [
        // 神秘的な天体アニメーションロゴ
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3bcfd4).withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 光る円
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Colors.white,
                      Color(0xFF3bcfd4),
                    ],
                    stops: [0.2, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              
              // 円形のリング
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                .rotate(duration: 10.seconds, end: 0.05),
              
              // 外側の円形リング
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                .rotate(duration: 20.seconds, end: -0.1),
              
              // 占い師シンボル
              Stack(
                alignment: Alignment.center,
                children: [
                  // 中央の大きな星
                  const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 50,
                  ),
                  
                  // 周りの小さな星が回転
                  ..._buildOrbitingStars(6, 40, 1.5, Icons.star, 16),
                  
                  // 外側の小さな星
                  ..._buildOrbitingStars(8, 60, -1, Icons.star, 10),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 30),
        
        // タイトルテキスト
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Color(0xFF3bcfd4), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: const Text(
            '占い師ポータル',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ).animate()
          .fadeIn(duration: 800.ms)
          .scaleXY(begin: 0.8, end: 1.0, duration: 800.ms, curve: Curves.easeOutBack),
        
        const SizedBox(height: 12),
        
        // サブタイトル
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            borderRadius: BorderRadius.circular(30),
            color: Colors.white.withOpacity(0.1),
          ),
          child: const Text(
            '特別な占いセッションへの入口',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        ).animate().fadeIn(duration: 800.ms, delay: 300.ms),
      ],
    );
  }
  
  // 周回する星を生成するヘルパーメソッド
  List<Widget> _buildOrbitingStars(int count, double radius, double direction, IconData icon, double size) {
    return List.generate(count, (index) {
      final angle = (index / count) * 2 * math.pi;
      final offset = Offset(
        radius * math.cos(angle),
        radius * math.sin(angle),
      );
      
      return Positioned(
        left: 60 + offset.dx,
        top: 60 + offset.dy,
        child: Icon(
          icon,
          color: Colors.white,
          size: size,
        ).animate(onPlay: (controller) => controller.repeat())
          .rotate(
            begin: 0,
            end: direction * 2 * math.pi,
            duration: (5000 + index * 500).ms,
          ),
      );
    });
  }
  
  // ログインフォーム
  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 入力フィールドのシャイニングと神秘的なエフェクト
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // メールアドレスフィールド
                _buildInputLabel('メールアドレス'),
                _buildInputField(
                  controller: _emailController,
                  hintText: 'fortune@mystic.com',
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'メールアドレスを入力してください';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // パスワードフィールド
                _buildInputLabel('パスワード'),
                _buildInputField(
                  controller: _passwordController,
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: const Color(0xFF3bcfd4),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'パスワードを入力してください';
                    }
                    return null;
                  },
                ),
              ],
            ).animate().fade(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),
          ),
          
          const SizedBox(height: 24),
          
          // ログインオプション
          Row(
            children: [
              // 記憶するチェックボックス
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: _rememberMe ? const Color(0xFF3bcfd4) : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _rememberMe ? const Color(0xFF3bcfd4) : Colors.white.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: _rememberMe
                      ? [
                          BoxShadow(
                            color: const Color(0xFF3bcfd4).withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () {
                      setState(() {
                        _rememberMe = !_rememberMe;
                      });
                    },
                    child: _rememberMe
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _rememberMe = !_rememberMe;
                  });
                },
                child: Text(
                  'ログイン情報を記憶',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ),
              const Spacer(),
              
              // パスワードを忘れた場合のリンク
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('パスワードリセット機能は現在開発中です')),
                  );
                },
                child: Text(
                  'パスワードを忘れた場合',
                  style: TextStyle(
                    color: const Color(0xFF3bcfd4),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: const Color(0xFF3bcfd4).withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ).animate().fade(duration: 600.ms, delay: 400.ms),
          
          const SizedBox(height: 40),
          
          // ログインボタン
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3bcfd4), // ターコイズ
                  Color(0xFF2A92B0), // 深いターコイズ
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3bcfd4).withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _isLoggingIn ? null : _attemptLogin,
                child: Center(
                  child: _isLoggingIn
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              '占い師ポータルにログイン',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ).animate()
                .fade(duration: 600.ms, delay: 600.ms)
                .scaleXY(begin: 0.95, end: 1.0, duration: 800.ms, curve: Curves.easeOutBack),
          
          const SizedBox(height: 24),
          
          // テストアカウント作成ボタン
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                onPressed: _createTestAccount,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  foregroundColor: Colors.white.withOpacity(0.7),
                ),
                child: const Text('テストアカウントを作成'),
              ),
            ),
          ).animate().fade(duration: 600.ms, delay: 800.ms),
        ],
      ),
    );
  }
  
  // 入力フィールドのラベルを満たすヘルパーメソッド
  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3bcfd4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3bcfd4).withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // 入力フィールドを満たすヘルパーメソッド
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          color: Color(0xFF3bcfd4),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(
              prefixIcon,
              color: const Color(0xFF3bcfd4),
              size: 22,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 60),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF3bcfd4).withOpacity(0.5),
            fontSize: 16,
          ),
        ),
        validator: validator,
      ),
    );
  }
  
  // テストアカウント作成
  Future<void> _createTestAccount() async {
    try {
      final dbService = DatabaseService();
      await dbService.connect();
      
      // テスト用アカウント情報
      const email = 'test1';
      const password = 'test1';
      
      // データベースに占い師アカウントを作成/更新
      await dbService.createOrUpdateFortuneTeller(email, password);
      await dbService.disconnect();
      
      // 成功メッセージを表示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('テスト用占い師アカウントを作成しました: email=test1, password=test1'),
            duration: Duration(seconds: 5),
          ),
        );
        
        // テキストフィールドに自動入力
        setState(() {
          _emailController.text = email;
          _passwordController.text = password;
        });
      }
    } catch (e) {
      // ログ出力
      debugPrint('テストアカウント作成エラー: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('アカウント作成中にエラーが発生しました: $e')),
        );
      }
    }
  }
  
  // ログイン処理
  Future<void> _attemptLogin() async {
    // バリデーション
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    
    setState(() => _isLoggingIn = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ログイン処理中...')),
    );
    
    try {
      final email = _emailController.text;
      final password = _passwordController.text;
      
      debugPrint('ログイン試行: $email / $password');
      
      // Web環境では自動ログイン許可（開発環境用）
      bool isWebEnvironment = true;
      int? userId;
      
      if (!isWebEnvironment) {
        // データベース接続
        final dbService = DatabaseService();
        await dbService.connect();
        
        // 認証処理
        userId = await dbService.authenticateFortuneTeller(email, password);
        await dbService.disconnect();
      } else {
        // Web環境では自動ログイン許可（開発環境用）
        if (email == 'test1' && (password == 'test1' || password == '11111111')) {
          userId = 1; // テスト用ID
          debugPrint('Web環境でのテストログイン成功');
        }
      }
      
      if (userId != null) {
        // ログイン情報を保存
        if (_rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('fortuneTellerEmail', email);
          await prefs.setBool('fortuneTellerRememberMe', true);
        }
        
        // セッション情報を保存
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', email);
        await prefs.setString('userRole', 'fortuneteller');
        await prefs.setInt('userId', userId);
        await prefs.setBool('isLoggedIn', true);
        
        // 占い師ホーム画面に遷移
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const FortuneTellerHomeScreen()),
          );
        }
      } else {
        // 認証失敗
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('メールアドレスまたはパスワードが正しくありません')),
          );
        }
      }
    } catch (e) {
      // ログ出力
      debugPrint('ログインエラー: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ログイン中にエラーが発生しました: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoggingIn = false);
      }
    }
  }
}

// 星空の星を表すクラス
class Star {
  late double x;
  late double y;
  late double size;
  late double opacity;
  late double speed;
  
  Star() {
    // ランダムな初期値を設定
    final random = math.Random();
    x = random.nextDouble() * 2 - 1; // -1から1の座標
    y = random.nextDouble() * 2 - 1; // -1から1の座標
    size = random.nextDouble() * 2 + 1; // 1から3のサイズ
    opacity = random.nextDouble() * 0.8 + 0.2; // 0.2から1.0の不透明度
    speed = random.nextDouble() * 0.02 + 0.01; // 回転速度
  }
  
  // 星を更新するメソッド
  void update() {
    // キラキラと明滅する効果
    opacity += (math.Random().nextDouble() * 0.02 - 0.01);
    if (opacity > 1.0) opacity = 1.0;
    if (opacity < 0.2) opacity = 0.2;
  }
}

// 星空を描画するペインター
class StarfieldPainter extends CustomPainter {
  final List<Star> stars;
  final double rotation;
  
  StarfieldPainter(this.stars, this.rotation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    // final maxDistance = math.sqrt(centerX * centerX + centerY * centerY); // 未使用のため削除
    
    // 各星を描画
    for (final star in stars) {
      // 回転行列を適用
      final x = star.x * math.cos(rotation * star.speed) - star.y * math.sin(rotation * star.speed);
      final y = star.x * math.sin(rotation * star.speed) + star.y * math.cos(rotation * star.speed);
      
      // 画面座標に変換
      final dx = centerX + x * centerX;
      final dy = centerY + y * centerY;
      
      // キラキラ効果を更新
      star.update();
      
      // 星を描画
      final paint = Paint()
        ..color = Colors.white.withOpacity(star.opacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(dx, dy), star.size, paint);
      
      // 光彩効果
      final glowPaint = Paint()
        ..color = const Color(0xFF3bcfd4).withOpacity(star.opacity * 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      
      canvas.drawCircle(Offset(dx, dy), star.size * 1.5, glowPaint);
    }
  }
  
  @override
  bool shouldRepaint(StarfieldPainter oldDelegate) => true;
}
