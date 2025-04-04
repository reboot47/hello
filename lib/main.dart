import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_animate/flutter_animate.dart';
import 'screens/auth/login_screen.dart';
import 'theme/app_theme.dart';
import 'splash_screen.dart';

/// アプリケーションのエントリーポイント
void main() {
  // プラットフォーム固有の初期化
  WidgetsFlutterBinding.ensureInitialized();
  
  // macOSプラットフォームの場合、ウィンドウサイズを設定
  if (!kIsWeb && getPlatform() == PlatformType.macOS) {
    // Note: このコードはmacOSでのみ実行されるため、
    // 実際のインポートはプラットフォーム固有のビルド時にのみ行われます
    // import 'package:window_size/window_size.dart' as window_size;
    // window_size.setWindowTitle('REBOOT47');
    // window_size.setWindowMinSize(const Size(400, 600));
    // window_size.setWindowMaxSize(const Size(800, 1200));
  }
  
  runApp(const MyApp());
}

// プラットフォームタイプを表す列挙型
enum PlatformType { iOS, android, web, macOS, windows, linux, unknown }

// 現在のプラットフォームを検出する関数
PlatformType getPlatform() {
  if (kIsWeb) return PlatformType.web;
  if (Platform.isIOS) return PlatformType.iOS;
  if (Platform.isAndroid) return PlatformType.android;
  if (Platform.isMacOS) return PlatformType.macOS;
  if (Platform.isWindows) return PlatformType.windows;
  if (Platform.isLinux) return PlatformType.linux;
  return PlatformType.unknown;
}

/// アプリのメインウィジェット
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REBOOT47',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.system, // システム設定に従う
      home: const SplashScreen(), // カスタムスプラッシュスクリーンを表示
    );
  }
}
