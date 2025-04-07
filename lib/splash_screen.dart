import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // 全画面表示にする
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    // アニメーション設定
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    
    // アニメーション開始
    _controller.forward();
    
    // タイマーを確実に実行するためのmountedチェックを追加
    _navigateToLogin();
  }
  
  // ログイン画面への遷移を別メソッドで実装
  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 3), () {
      // Widgetがまだツリーに存在するか確認
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, 
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              AppTheme.primaryColor,
              const Color(0xFF30B5BA),
            ],
            stops: const [0.4, 1.0],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 47ロゴ
                Container(
                  width: 130,
                  height: 130,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '47',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // REBOOT47 SYSTEMSロゴ
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'REBOOT47',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      
                      const SizedBox(height: 5),
                      
                      const Text(
                        'SYSTEMS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
