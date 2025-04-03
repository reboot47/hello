import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  // プラットフォーム固有の初期化（必要に応じて）
  WidgetsFlutterBinding.ensureInitialized();
  
  // macOSプラットフォームの場合、ウィンドウサイズを設定
  if (!kIsWeb && getPlatform() == PlatformType.macOS) {
    // Note: このコードはmacOSでのみ実行されるため、
    // 実際のインポートはプラットフォーム固有のビルド時にのみ行われます
    // import 'package:window_size/window_size.dart' as window_size;
    // window_size.setWindowTitle('Hello World');
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // アプリで使用する色の定義
  static const Color mainColor = Color(0xFF3bcfd4); // ターコイズ（メインカラー）
  static const Color darkColor = Color(0xFF1a237e); // 濃紺（ダークモードや補助色）
  static const Color accentColor = Color(0xFFf8bbd0); // 薄ピンク（アクセントカラー）

  @override
  Widget build(BuildContext context) {
    final platform = getPlatform();
    
    // プラットフォームに適したフォントの選択
    String primaryFont;
    String japaneseFont;
    
    switch (platform) {
      case PlatformType.iOS:
        primaryFont = 'SF Pro';
        japaneseFont = 'Hiragino Sans';
        break;
      case PlatformType.macOS:
        primaryFont = 'SF Pro';
        japaneseFont = 'Hiragino Sans';
        break;
      case PlatformType.android:
        primaryFont = 'Roboto';
        japaneseFont = 'Noto Sans JP';
        break;
      case PlatformType.windows:
        primaryFont = 'Segoe UI';
        japaneseFont = 'Yu Gothic UI';
        break;
      default: // Webやその他のプラットフォーム
        primaryFont = 'Roboto';
        japaneseFont = 'Noto Sans JP';
        break;
    }
    
    return MaterialApp(
      title: 'Hello World App',
      debugShowCheckedModeBanner: false, // デバッグバナーを非表示
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: mainColor,
          secondary: accentColor,
          background: Colors.white,
        ),
        useMaterial3: true, // Material 3を使用
        fontFamily: primaryFont,
        // デスクトップ向けに調整
        visualDensity: platform == PlatformType.iOS || platform == PlatformType.android
            ? VisualDensity.standard
            : VisualDensity.comfortable,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: mainColor,
          secondary: accentColor,
          background: darkColor,
        ),
        useMaterial3: true,
        fontFamily: primaryFont,
        visualDensity: platform == PlatformType.iOS || platform == PlatformType.android
            ? VisualDensity.standard
            : VisualDensity.comfortable,
      ),
      themeMode: ThemeMode.system, // システム設定に従う
      home: MyHomePage(japaneseFont: japaneseFont),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String japaneseFont;
  
  const MyHomePage({super.key, required this.japaneseFont});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;
  late PlatformType _currentPlatform;

  @override
  void initState() {
    super.initState();
    // 現在のプラットフォームを取得
    _currentPlatform = getPlatform();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    // デスクトップ向けのアニメーション最適化
    if (_isDesktopPlatform()) {
      // デスクトップ向けにアニメーションをより滑らかに
      Animate.restartOnHotReload = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // デスクトッププラットフォームかどうかチェック
  bool _isDesktopPlatform() {
    return _currentPlatform == PlatformType.macOS || 
           _currentPlatform == PlatformType.windows || 
           _currentPlatform == PlatformType.linux;
  }
  
  // アニメーションの最適化
  Duration _getAnimationDuration() {
    // デスクトップ向けには短めのアニメーション、モバイル向けには通常のアニメーション
    return _isDesktopPlatform()
        ? 300.ms
        : 500.ms;
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onTap: _toggleExpand,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MyApp.mainColor.withOpacity(0.8),
                MyApp.accentColor.withOpacity(0.3),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ロゴ部分（iOSアプリライクなアニメーション）
                  Hero(
                    tag: 'logo',
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'LB',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 42,
                            color: MyApp.mainColor,
                          ),
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, curve: Curves.easeOutQuad)
                  .slide(begin: const Offset(0, -0.5), curve: Curves.easeOutQuad)
                  .then(delay: 200.ms)
                  .animate(target: _isExpanded ? 1 : 0)
                  .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 400.ms)
                  .then(delay: 200.ms)
                  .scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1), duration: 400.ms),
                  
                  const SizedBox(height: 40),
                  
                  // Hello World テキスト（iOSアプリライクなアニメーション）
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: 1,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      'Hello World',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: MyApp.darkColor,
                        letterSpacing: 1.2,
                        fontFamily: 'SF Pro',
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 800.ms, curve: Curves.easeOutQuad)
                  .slideY(begin: 0.3, curve: Curves.easeOutQuad),
                  
                  const SizedBox(height: 20),
                  
                  // 日本語表示（スイッチャブルアニメーション）
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: _isExpanded
                      ? Column(
                          key: const ValueKey('expanded'),
                          children: [
                            Text(
                              'こんにちは、世界',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                letterSpacing: 1.0,
                                fontFamily: widget.japaneseFont,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 2,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'タップしてサイズを変更',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontFamily: widget.japaneseFont,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'こんにちは、世界',
                          key: const ValueKey('normal'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 1.0,
                            fontFamily: widget.japaneseFont,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 2,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                  )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 800.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
