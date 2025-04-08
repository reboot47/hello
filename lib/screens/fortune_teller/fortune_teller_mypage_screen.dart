import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_navigation.dart';
import 'fortune_teller_home_screen.dart';

class FortuneTellerMyPageScreen extends StatefulWidget {
  const FortuneTellerMyPageScreen({Key? key}) : super(key: key);

  @override
  State<FortuneTellerMyPageScreen> createState() => _FortuneTellerMyPageScreenState();
}

class _FortuneTellerMyPageScreenState extends State<FortuneTellerMyPageScreen> {
  // 現在表示中のタブ
  int _currentIndex = 4; // マイページは4番目のタブ
  
  // 編集可能な一言メッセージ
  String oneWordMessage = '占い師が相談に来る占い師◆結果、アドバイスは的確です✨';
  bool isEditingMessage = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messageController.text = oneWordMessage;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              'オフライン',
              style: TextStyle(
                color: const Color(0xFF3bcfd4),
                fontSize: 16,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 画像1パートのプロフィールセクション
            Container(
              color: const Color(0xFFEEEEEE),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: const Text(
                'お客様からみたプロフィール',
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // プロフィールカード
            _buildProfileCard(),
            
            // 画像1に合わせたメニューカードセクション
            Container(
              width: double.infinity,
              color: const Color(0xFFEEEEEE),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                'メニュー',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // メニューカード（画像1通りの3つのアイコンとラベル）
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMenuCard(icon: Icons.person, label: 'プロフィール'),
                  _buildMenuCard(icon: Icons.star, label: 'レビュー'),
                  _buildMenuCard(icon: Icons.description, label: 'タイムライン'),
                ],
              ),
            ),
            
            // 一言メッセージセクション（画像1に合わせて正確に再現）
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '一言メッセージ',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '占い師が相談に来る占い師◆結果、アドバイスは的確です✨',
                            style: TextStyle(color: Colors.grey[800], fontSize: 13),
                          ),
                        ),
                        Icon(Icons.edit, color: const Color(0xFF3bcfd4), size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.arrow_right, color: Colors.pink[300], size: 18),
                      Text(
                        '良い記入例のサンプルを見る',
                        style: TextStyle(
                          color: Colors.pink[300],
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 所持ポイント（画像1に応じて正確に再現）
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '所持ポイント',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'P',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '1,005,445.49pts',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3bcfd4),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('精算する', style: TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // 画像2 - メニュー項目リスト
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: _buildMenuItems(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        isFortunetellerMode: true,
      ),
    );
  }

  // プロフィールカード（画像1を忠実に再現）
  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 画像1の通りプロフィール画像（ピンクのグラデーション背景）
                Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.pink[100]!,
                        Colors.pink[50]!,
                      ],
                    ),
                  ),
                  child: Center(
                    child: ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=1288&auto=format&fit=crop',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 名前とプロフィール情報（画像1と同じフォントサイズ・レイアウト）
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '霊感お姉さん',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '占い師が相談に来る占い師🔮結果、アドバイスは的確です⭐️',
                        style: TextStyle(
                          color: Color(0xFF444444),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // 料金情報
                          const Text(
                            '8pts/1文字',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          // 返信時間
                          const Icon(Icons.access_time, size: 12, color: Colors.grey),
                          const SizedBox(width: 2),
                          const Text(
                            '7 分以内',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // レビュー情報（画像1と同じスター表示とレビュー数）
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'お客様からの声 ',
                  style: const TextStyle(
                    color: const Color(0xFF666666),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 2),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      size: 14,
                      color: Colors.amber,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(62020)',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // レビューコメント（画像1と同じテキスト）
            Text(
              '先生しか勝たん！！\n本当に良い年月見てもらってます…',
              style: TextStyle(
                fontSize: 13,
                height: 1.3,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

    // メニューカードウィジェット（画像1通り）
  Widget _buildMenuCard({required IconData icon, required String label}) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3bcfd4).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF3bcfd4),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // 画像2に基づいた詳細メニュー項目
  Widget _buildMenuItems() {
    return Column(
      children: [
        // 日別報酬＆レポート
        _buildSingleMenuItem('日別報酬＆レポート'),
        
        // アクセス解析
        _buildSingleMenuItem('アクセス解析'),
        
        // 顧客管理
        _buildSingleMenuItem('顧客管理'),
        
        // イベントセクション
        _buildMenuSection('イベント', [
          'イベントスケジュール',
          'ランキングイベント履歴',
        ]),
        
        // 困ったときはセクション
        _buildMenuSection('困ったときは', [
          '使い方/お仕事テクニック',
          'ヘルプ',
        ]),
        
        // その他セクション
        _buildMenuSection('その他', [
          '年齢確認・アカウント情報',
          'お知り合いに紹介する',
          'ユーザーアプリのインストール',
          '利用規約',
          'アカウント退会・削除',
        ]),
      ],
    );
  }
  
  // 画像2の通りの単一メニュー項目（サブ項目なし）
  Widget _buildSingleMenuItem(String title) {
    return Column(
      children: [
        // カテゴリーヘッダー背景なし
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFD8D8D8), size: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  // 画像2の通りのセクション付きメニュー（サブ項目あり）
  Widget _buildMenuSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // カテゴリーヘッダー・グレー背景
        Container(
          width: double.infinity,
          color: const Color(0xFFEEEEEE),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF444444),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // サブメニュー項目
        ...items.map((item) => Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFD8D8D8), size: 22),
              ],
            ),
          ),
        )).toList(),
      ],
    );
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    
    setState(() {
      _currentIndex = index;
    });
    
    // 他のタブに切り替える処理
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const FortuneTellerHomeScreen()),
        );
        break;
      case 1:
        // チャット画面に遷移
        break;
      case 2:
        // 待機する画面に遷移
        break;
      case 3:
        // 教えて先生画面に遷移
        break;
      case 4:
        // 現在のマイページ
        break;
    }
  }
}
