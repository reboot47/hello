import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    
    print('スプラッシュスクリーンが初期化されました');
    developer.log('スプラッシュスクリーンが初期化されました');
    
    // 画面遷移ロジックをセットアップ
    _setupNavigation();
  }
  
  void _setupNavigation() {
    // 1. すぐに次のフレームで実行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Post frame callback が実行されました');
      _scheduleNavigation();
    });
    
    // 2. バックアップタイマー (3秒後に確実に実行)
    _timer = Timer(const Duration(seconds: 3), () {
      print('タイマー完了: ログイン画面へ遷移');
      _navigateToLogin();
    });
  }

  void _scheduleNavigation() {
    // 初回のビルド完了後にナビゲーション
    Future.delayed(const Duration(milliseconds: 500), () {
      print('初回遅延後: ログイン画面へ遷移試行');
      _navigateToLogin();
    });
  }

  void _navigateToLogin() {
    if (!mounted || _navigated) {
      print('遷移キャンセル: mounted=$mounted, navigated=$_navigated');
      return;
    }
    _navigated = true;
    
    String platform = kIsWeb ? 'Web' : Platform.operatingSystem;
    print('プラットフォーム: $platform でログイン画面に遷移します');
    
    try {
      // メインスレッドで遷移を保証
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          print('ナビゲーション実行中...');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false
          );
        }
      });
    } catch (e) {
      print('ナビゲーションエラー: $e');
      // 代替手段を試みる
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    print('スプラッシュスクリーンが破棄されました');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 画面タップでも遷移できるようにする
      onTap: _navigateToLogin,
      child: Scaffold(
        backgroundColor: const Color(0xFF3bcfd4), // ターコイズ色の背景
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // アプリ名またはロゴを表示
              const Text(
                'REBOOT47',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // ローディングインジケータを表示
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 20),
              // タップして進むヒントを表示
              const Text(
                'タップして進む',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
