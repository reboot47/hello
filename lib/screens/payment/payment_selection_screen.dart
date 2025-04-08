import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentSelectionScreen extends StatefulWidget {
  final int points;
  
  const PaymentSelectionScreen({Key? key, required this.points}) : super(key: key);

  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  int _selectedPlan = 1; // デフォルトで1000ポイントプランを選択
  
  final List<Map<String, dynamic>> _plans = [
    {
      'id': 0,
      'title': 'お試しプラン',
      'points': 500,
      'price': 550,
      'description': '初めての方におすすめ！',
      'color': const Color(0xFFE57373), // 赤系
    },
    {
      'id': 1,
      'title': 'スタンダードプラン',
      'points': 1000,
      'price': 1100,
      'description': '人気No.1！お得なポイント付き',
      'color': const Color(0xFF3bcfd4), // ターコイズ（アプリテーマカラー）
      'isRecommended': true,
    },
    {
      'id': 2,
      'title': 'プレミアムプラン',
      'points': 3000,
      'price': 3300,
      'description': '長期利用の方はこちら！',
      'color': const Color(0xFF9575CD), // 紫系
    },
    {
      'id': 3,
      'title': 'ロイヤルプラン',
      'points': 5000,
      'price': 5500,
      'description': '最もお得！VIP特典付き',
      'color': const Color(0xFF7986CB), // 紫青系
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'ポイント購入',
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
      body: Column(
        children: [
          // 現在のポイント表示
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '現在のポイント: ${widget.points}pt',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'ポイントは占い相談やプレミアム特典に使えます。',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // プラン選択部分
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final plan = _plans[index];
                final bool isSelected = _selectedPlan == plan['id'];
                final bool isRecommended = plan['isRecommended'] ?? false;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? plan['color'] : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPlan = plan['id'];
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          plan['title'],
                                          style: TextStyle(
                                            color: plan['color'],
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (isRecommended) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFF9C4),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'おすすめ',
                                              style: TextStyle(
                                                color: Color(0xFFE65100),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      plan['description'],
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Radio<int>(
                                value: plan['id'],
                                groupValue: _selectedPlan,
                                activeColor: plan['color'],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPlan = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${plan['points']}ポイント',
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '¥${plan['price']}',
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 購入ボタン
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3bcfd4), // ターコイズ（アプリテーマカラー）
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  _performPayment();
                },
                child: const Text(
                  'ポイントを購入する',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 決済処理（サンプル実装）
  void _performPayment() async {
    // 選択されたプランの情報を取得
    final selectedPlan = _plans.firstWhere((plan) => plan['id'] == _selectedPlan);
    
    // ローディング表示
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('決済処理中...'),
          ],
        ),
      ),
    );
    
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
      
      // ポイント追加処理
      final pointsToAdd = selectedPlan['points'];
      final result = await dbService.updateUserPoints(userEmail, pointsToAdd, 'purchase');
      await dbService.disconnect();
      
      // ダイアログを閉じる
      Navigator.pop(context);
      
      if (result['success']) {
        // 購入成功時の処理
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('購入完了'),
            content: Text('${pointsToAdd}ポイントを購入しました！'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true); // trueを返して親画面でポイント更新を行う
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception(result['message'] ?? '決済処理中にエラーが発生しました');
      }
    } catch (e) {
      // エラー発生時の処理
      Navigator.pop(context); // ローディングダイアログを閉じる
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('エラー'),
          content: Text('決済処理中にエラーが発生しました: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
