import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';

class PaymentSelectionScreen extends StatefulWidget {
  final int points;
  
  const PaymentSelectionScreen({
    Key? key,
    required this.points,
  }) : super(key: key);

  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    // ステータスバーの色を設定
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '決済選択',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.purple),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // ポイント表示部分
          _buildPointsSection(),
          
          // メインコンテンツ
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // バナー広告
                  _buildPromotionBanner(),
                  
                  // 料金について
                  _buildPricingInfo(),
                  
                  // 初回限定オファー
                  _buildFirstTimeOffer(),
                  
                  // 決済方法リスト
                  _buildPaymentMethod(
                    icon: Icons.credit_card,
                    iconColor: Colors.purple.shade300,
                    title: 'クレジットカード決済',
                    subtitle: '167%お得！一番人気の決済！',
                    onTap: () {
                      // クレジットカード決済処理
                      print('クレジットカード決済が選択されました');
                    }
                  ),
                  
                  _buildPaymentMethod(
                    icon: Icons.monetization_on,
                    iconColor: Colors.orange.shade400,
                    title: 'Amazon Pay決済',
                    subtitle: '167%お得！カードがない方へ',
                    imageAsset: 'assets/images/amazon_pay.png',
                    onTap: () {
                      // Amazon Pay決済処理
                      print('Amazon Pay決済が選択されました');
                    }
                  ),
                  
                  _buildPaymentMethod(
                    icon: Icons.account_balance,
                    iconColor: Colors.blue.shade300,
                    title: '銀行振込み',
                    subtitle: '最大200%お得！最もお得な決済',
                    onTap: () {
                      // 銀行振込み処理
                      print('銀行振込みが選択されました');
                    }
                  ),
                  
                  _buildPaymentMethod(
                    icon: Icons.smartphone,
                    iconColor: Colors.grey.shade500,
                    title: 'アプリ課金決済',
                    subtitle: '通常の決済方法',
                    onTap: () {
                      // アプリ課金決済処理
                      print('アプリ課金決済が選択されました');
                    }
                  ),
                  
                  _buildPaymentMethod(
                    icon: Icons.fiber_new,
                    iconColor: Colors.red.shade400,
                    title: 'コンビニ払い決済',
                    subtitle: '手軽で便利な決済方法',
                    onTap: () {
                      // コンビニ払い決済処理
                      print('コンビニ払い決済が選択されました');
                    }
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // ポイント表示部分
  Widget _buildPointsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.circle,
            size: 28,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '所持ポイント ',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: '${widget.points}pts',
                  style: TextStyle(
                    color: Colors.purple.shade300,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // バナー広告
  Widget _buildPromotionBanner() {
    return Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.yellow.shade200,
          width: 2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.yellow.shade100,
            Colors.yellow.shade200,
          ],
        ),
      ),
      child: Stack(
        children: [
          // 上部のピンクバー
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.pink.shade300,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: const Center(
                child: Text(
                  'クレジットカード決済なら167%お得！',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          
          // メインコンテンツ
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '1,100円分',
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'ご購入すると...',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '920',
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -10),
                      child: const Text(
                        'pts獲得',
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 注釈
          Positioned(
            bottom: 5,
            right: 10,
            child: Text(
              '※アプリ課金決済なら550pts相当',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 料金についての情報
  Widget _buildPricingInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '料金について',
            style: TextStyle(
              color: Colors.purple.shade300,
              fontSize: 14,
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 16,
            color: Colors.purple.shade300,
          ),
        ],
      ),
    );
  }
  
  // 初回限定オファー
  Widget _buildFirstTimeOffer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          // 左側のアイコン
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(9),
                bottomLeft: Radius.circular(9),
              ),
            ),
            child: const Icon(
              Icons.credit_card,
              color: Colors.white,
              size: 20,
            ),
          ),
          
          // 中央の説明
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '初回限定！50%OFF！',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '通常の半額で920ptsGET！',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 右側の金額
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.shade400,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(9),
                bottomRight: Radius.circular(9),
              ),
            ),
            child: const Text(
              '¥550',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 決済方法オプション
  Widget _buildPaymentMethod({
    required IconData icon,
    required Color iconColor,
    String? imageAsset,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          // 左側のアイコン
          Container(
            padding: const EdgeInsets.all(8),
            child: imageAsset != null
                ? Image.asset(
                    imageAsset,
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                    ),
                  )
                : Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
          ),
          
          // 中央の説明
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 右側のボタン
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4FD0C6),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text(
              '購入する',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
