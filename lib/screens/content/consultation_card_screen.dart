import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

class ConsultationCardScreen extends StatefulWidget {
  const ConsultationCardScreen({Key? key}) : super(key: key);

  @override
  State<ConsultationCardScreen> createState() => _ConsultationCardScreenState();
}

class _ConsultationCardScreenState extends State<ConsultationCardScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  // 自分の情報
  final _selfNameController = TextEditingController();
  String _selfGender = '男性'; // デフォルト値
  final _selfBirthdateController = TextEditingController();
  final _selfBirthplaceController = TextEditingController();
  final _selfBirthtimeController = TextEditingController();
  final _selfConcernsController = TextEditingController();
  
  // 相手の情報（カルテ1）
  final _partner1NameController = TextEditingController();
  String _partner1Gender = '';
  final _partner1BirthdateController = TextEditingController();
  final _partner1BirthplaceController = TextEditingController();
  final _partner1BirthtimeController = TextEditingController();
  final _partner1RelationshipController = TextEditingController();
  
  // 相手の情報（カルテ2）
  final _partner2NameController = TextEditingController();
  String _partner2Gender = '';
  final _partner2BirthdateController = TextEditingController();
  final _partner2BirthplaceController = TextEditingController();
  final _partner2BirthtimeController = TextEditingController();
  final _partner2RelationshipController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadConsultationCard();
  }
  
  @override
  void dispose() {
    // TextEditingController を破棄
    _selfNameController.dispose();
    _selfBirthdateController.dispose();
    _selfBirthplaceController.dispose();
    _selfBirthtimeController.dispose();
    _selfConcernsController.dispose();
    
    _partner1NameController.dispose();
    _partner1BirthdateController.dispose();
    _partner1BirthplaceController.dispose();
    _partner1BirthtimeController.dispose();
    _partner1RelationshipController.dispose();
    
    _partner2NameController.dispose();
    _partner2BirthdateController.dispose();
    _partner2BirthplaceController.dispose();
    _partner2BirthtimeController.dispose();
    _partner2RelationshipController.dispose();
    
    super.dispose();
  }
  
  // 相談カルテの情報を読み込む
  Future<void> _loadConsultationCard() async {
    setState(() => _isLoading = true);
    
    try {
      // ユーザーのメールアドレスを取得
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('userEmail');
      
      if (userEmail == null || userEmail.isEmpty) {
        // デバッグ用にダミーメールアドレスを設定
        await prefs.setString('userEmail', 'user@example.com');
        print('ユーザー情報が見つからないため、ダミーメールアドレスを設定しました');
        // 実際の実装ではログイン画面に戻すことも考えられます
      }
      
      // データベースから相談カルテ情報を取得
      final dbService = DatabaseService();
      await dbService.connect();
      
      // nullableな値を非nullableに変換（null/空の場合はダミーメールを使用）
      final String email = userEmail?.isNotEmpty == true ? userEmail! : 'user@example.com';
      final result = await dbService.getConsultationCard(email);
      await dbService.disconnect();
      
      if (result['success'] && result['exists']) {
        final cardData = result['card'];
        
        // 自分の情報をセット
        setState(() {
          _selfNameController.text = cardData['self_name'] ?? '';
          _selfGender = cardData['self_gender'] ?? '男性';
          _selfBirthdateController.text = cardData['self_birthdate'] ?? '';
          _selfBirthplaceController.text = cardData['self_birthplace'] ?? '';
          _selfBirthtimeController.text = cardData['self_birthtime'] ?? '';
          _selfConcernsController.text = cardData['self_concerns'] ?? '';
          
          // 相手の情報（カルテ1）
          _partner1NameController.text = cardData['partner1_name'] ?? '';
          _partner1Gender = cardData['partner1_gender'] ?? '';
          _partner1BirthdateController.text = cardData['partner1_birthdate'] ?? '';
          _partner1BirthplaceController.text = cardData['partner1_birthplace'] ?? '';
          _partner1BirthtimeController.text = cardData['partner1_birthtime'] ?? '';
          _partner1RelationshipController.text = cardData['partner1_relationship'] ?? '';
          
          // 相手の情報（カルテ2）
          _partner2NameController.text = cardData['partner2_name'] ?? '';
          _partner2Gender = cardData['partner2_gender'] ?? '';
          _partner2BirthdateController.text = cardData['partner2_birthdate'] ?? '';
          _partner2BirthplaceController.text = cardData['partner2_birthplace'] ?? '';
          _partner2BirthtimeController.text = cardData['partner2_birthtime'] ?? '';
          _partner2RelationshipController.text = cardData['partner2_relationship'] ?? '';
        });
      } else {
        // データが存在しない場合は空のままにする
        // 性別のデフォルト値だけ設定
        setState(() {
          _selfGender = '男性'; // デフォルトの性別のみ設定
        });
        print('相談カルテデータが存在しません。新規作成されます。');
      }
    } catch (e) {
      print('相談カルテ読み込みエラー: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  // 生年月日選択用のメソッド
  Future<String?> _selectDate(BuildContext context, String currentValue) async {
    // 現在の値からDateTimeを生成、なければ現在の日付を使用
    DateTime initialDate;
    try {
      if (currentValue.isNotEmpty) {
        // 'yyyy/MM/dd' 形式をパース
        final parts = currentValue.split('/');
        if (parts.length == 3) {
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final day = int.parse(parts[2]);
          initialDate = DateTime(year, month, day);
        } else {
          initialDate = DateTime.now();
        }
      } else {
        initialDate = DateTime.now();
      }
    } catch (e) {
      initialDate = DateTime.now();
    }
    
    // 日付選択ダイアログを表示
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFBE84FB), // カレンダーのヘッダー色
              onPrimary: Colors.white, // ヘッダーのテキスト色
              onSurface: Colors.black, // カレンダーの数字色
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDate != null) {
      // 'yyyy/MM/dd' 形式にフォーマット
      return '${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}';
    }
    
    return null;
  }
  
  // 出生地選択用のメソッド
  Future<String?> _selectBirthplace(BuildContext context, String currentValue) async {
    final List<String> prefectures = [
      '北海道', '青森', '岩手', '宮城', '秋田', '山形', '福島', '茨城', '栃木', '群馬', '埼玉', '千葉', '東京', '神奈川',
      '新潟', '富山', '石川', '福井', '山梨', '長野', '岐阜', '静岡', '愛知', '三重', '滋賀', '京都', '大阪', '兵庫',
      '奈良', '和歌山', '鳥取', '島根', '岡山', '広島', '山口', '徳島', '香川', '愛媛', '高知', '福岡', '佐賀', '長崎', '熊本',
      '大分', '宮崎', '鹿児島', '沖縄',
    ];
    
    // ダイアログで都道府県を選択
    String? selectedPrefecture = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('出生地を選択'),
          backgroundColor: Colors.white,
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: prefectures.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(prefectures[index]),
                  onTap: () {
                    Navigator.of(context).pop(prefectures[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );
    
    return selectedPrefecture;
  }
  
  // 出生時間選択用のメソッド
  Future<String?> _selectBirthtime(BuildContext context, String currentValue) async {
    // 現在の値からTimeOfDayを生成、なければ現在の時間を使用
    TimeOfDay initialTime;
    try {
      if (currentValue.isNotEmpty) {
        // 'HH:mm' 形式をパース
        final parts = currentValue.split(':');
        if (parts.length == 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          initialTime = TimeOfDay(hour: hour, minute: minute);
        } else {
          initialTime = TimeOfDay.now();
        }
      } else {
        initialTime = TimeOfDay.now();
      }
    } catch (e) {
      initialTime = TimeOfDay.now();
    }
    
    // 時間選択ダイアログを表示
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFBE84FB), // ヘッダー色
              onPrimary: Colors.white, // ヘッダーのテキスト色
              onSurface: Colors.black, // 数字色
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedTime != null) {
      // 'HH:mm' 形式にフォーマット
      return '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
    }
    
    return null;
  }

  // 相談カルテを保存する
  Future<void> _saveConsultationCard() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      // ユーザーのメールアドレスを取得
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('userEmail');
      
      if (userEmail == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ユーザー情報が見つかりません。再ログインしてください。')),
        );
        return;
      }
      
      // カルテデータを作成
      final cardData = {
        'self_name': _selfNameController.text,
        'self_gender': _selfGender,
        'self_birthdate': _selfBirthdateController.text,
        'self_birthplace': _selfBirthplaceController.text,
        'self_birthtime': _selfBirthtimeController.text,
        'self_concerns': _selfConcernsController.text,
        
        'partner1_name': _partner1NameController.text,
        'partner1_gender': _partner1Gender,
        'partner1_birthdate': _partner1BirthdateController.text,
        'partner1_birthplace': _partner1BirthplaceController.text,
        'partner1_birthtime': _partner1BirthtimeController.text,
        'partner1_relationship': _partner1RelationshipController.text,
        
        'partner2_name': _partner2NameController.text,
        'partner2_gender': _partner2Gender,
        'partner2_birthdate': _partner2BirthdateController.text,
        'partner2_birthplace': _partner2BirthplaceController.text,
        'partner2_birthtime': _partner2BirthtimeController.text,
        'partner2_relationship': _partner2RelationshipController.text,
      };
      
      // データベースに保存
      final dbService = DatabaseService();
      await dbService.connect();
      
      // nullableな値を非nullableに変換
      final email = userEmail!; // nullチェックは上で既に行っているので、!演算子で安全
      final result = await dbService.saveConsultationCard(cardData, email);
      await dbService.disconnect();
      
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        Navigator.of(context).pop(); // 保存後に前の画面に戻る
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      print('相談カルテ保存エラー: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  // カルテ2のフィールドをリセットする
  void _resetPartner1Fields() {
    setState(() {
      _partner1NameController.clear();
      _partner1Gender = '';
      _partner1BirthdateController.clear();
      _partner1BirthplaceController.clear();
      _partner1BirthtimeController.clear();
      _partner1RelationshipController.clear();
    });
  }
  
  // カルテ2のフィールドをリセットする
  void _resetPartner2Fields() {
    setState(() {
      _partner2NameController.clear();
      _partner2Gender = '';
      _partner2BirthdateController.clear();
      _partner2BirthplaceController.clear();
      _partner2BirthtimeController.clear();
      _partner2RelationshipController.clear();
    });
  }

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFF0F0F6), // 画像通りの薄い紫色背景
          foregroundColor: Colors.black,
          automaticallyImplyLeading: false,
          leadingWidth: 100,
          leading: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFBE84FB), // 画像通りの紫色
              padding: EdgeInsets.zero,
            ),
            child: const Text(
              'キャンセル',
              style: TextStyle(fontSize: 16),
            ),
          ),
          centerTitle: true,
          title: const Text(
            '相談カルテ',
            style: TextStyle(
              fontSize: 17, 
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _saveConsultationCard,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFBE84FB), // 画像通りの紫色
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                '保存', 
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // セクションヘッダー: 自分の情報
                  _buildSectionHeader('自分の情報'),
                  
                  // 自分の情報フォーム
                  _buildProfileField('本名', _selfNameController),
                  _buildGenderField('性別', _selfGender, (value) => setState(() => _selfGender = value)),
                  _buildDateSelectorField('生年月日', _selfBirthdateController),
                  _buildBirthplaceSelectorField('出生地', _selfBirthplaceController),
                  _buildBirthtimeSelectorField('出生時間', _selfBirthtimeController),
                  _buildProfileField('今の悩み', _selfConcernsController, maxLines: 2),
                  
                  // セクションヘッダー: 相手の情報(カルテ1)
                  _buildSectionHeaderWithReset('相手の情報(カルテ1)', _resetPartner1Fields),
                  
                  // 相手の情報フォーム(カルテ1)
                  _buildProfileField('本名', _partner1NameController, isRequired: false),
                  _buildGenderField('性別', _partner1Gender, (value) => setState(() => _partner1Gender = value), isRequired: false),
                  _buildDateSelectorField('生年月日', _partner1BirthdateController, isRequired: false),
                  _buildBirthplaceSelectorField('出生地', _partner1BirthplaceController, isRequired: false),
                  _buildBirthtimeSelectorField('出生時間', _partner1BirthtimeController, isRequired: false),
                  _buildProfileField('関係', _partner1RelationshipController, isRequired: false),
                  
                  // セクションヘッダー: 相手の情報(カルテ2)
                  _buildSectionHeaderWithReset('相手の情報(カルテ2)', _resetPartner2Fields),
                  
                  // 相手の情報フォーム(カルテ2)
                  _buildProfileField('本名', _partner2NameController, isRequired: false),
                  _buildGenderField('性別', _partner2Gender, (value) => setState(() => _partner2Gender = value), isRequired: false),
                  _buildDateSelectorField('生年月日', _partner2BirthdateController, isRequired: false),
                  _buildBirthplaceSelectorField('出生地', _partner2BirthplaceController, isRequired: false),
                  _buildBirthtimeSelectorField('出生時間', _partner2BirthtimeController, isRequired: false),
                  _buildProfileField('関係', _partner2RelationshipController, isRequired: false),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
    );
  }
  
  // セクションヘッダーウィジェット
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFF0F0F6), // 画像と同じ薄い紫色の背景
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
      ),
    );
  }
  
  // リセットボタン付きセクションヘッダー
  Widget _buildSectionHeaderWithReset(String title, VoidCallback onReset) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: title.contains('カルテ1') 
        ? const Color(0xFFEDF0F7) // 画像通りの薄い青色の背景 (カルテ1)
        : const Color(0xFFE6F7F7), // 画像通りの薄い水色の背景 (カルテ2)
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          TextButton(
            onPressed: onReset,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              foregroundColor: const Color(0xFF5C9BEB), // 画像通りの青色
            ),
            child: const Text(
              'リセット', 
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
  
  // プロフィールフィールドウィジェット
  Widget _buildProfileField(
    String label, 
    TextEditingController controller, {
    String? hintText,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300), // 画像通りのグレー色の区切り線
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // 画像通りに余白を調整
      child: Row(
        crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          // ラベル部分
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          // 値の部分
          Expanded(
            child: TextFormField(
              controller: controller,
              validator: isRequired ? (value) => value!.isEmpty ? '必須項目です' : null : null,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                hintText: '--',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                isDense: true,
                contentPadding: const EdgeInsets.only(left: 16),
                errorStyle: const TextStyle(height: 0, color: Colors.transparent), // エラーメッセージを非表示
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              maxLines: maxLines,
              textAlign: TextAlign.right, // 右寄せにする
            ),
          ),
        ],
      ),
    );
  }
  
  // 性別選択フィールド
  Widget _buildGenderField(
    String label, 
    String currentValue, 
    Function(String) onChanged, {
    bool isRequired = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300), // 画像通りのグレー色の区切り線
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // 画像通りに余白を調整
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ラベル部分
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          // 値の部分
          Expanded(
            child: GestureDetector(
              onTap: () {
                // プルダウンメニューを表示するためのダイアログ
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    backgroundColor: Colors.white,
                    title: const Text('性別を選択'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          onChanged('男性');
                          Navigator.pop(context);
                        },
                        child: Text('男性', 
                          style: TextStyle(
                            fontWeight: currentValue == '男性' ? FontWeight.bold : FontWeight.normal,
                          )
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          onChanged('女性');
                          Navigator.pop(context);
                        },
                        child: Text('女性',
                          style: TextStyle(
                            fontWeight: currentValue == '女性' ? FontWeight.bold : FontWeight.normal,
                          )
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          onChanged('その他');
                          Navigator.pop(context);
                        },
                        child: Text('その他',
                          style: TextStyle(
                            fontWeight: currentValue == 'その他' ? FontWeight.bold : FontWeight.normal,
                          )
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    currentValue.isEmpty ? '--' : currentValue,
                    style: TextStyle(
                      fontSize: 16,
                      color: currentValue.isEmpty ? Colors.grey.shade400 : Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 生年月日選択フィールド
  Widget _buildDateSelectorField(
    String label, 
    TextEditingController controller, {
    bool isRequired = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                // 日付選択ダイアログを表示
                final selectedDate = await _selectDate(context, controller.text);
                if (selectedDate != null) {
                  setState(() {
                    controller.text = selectedDate;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    controller.text.isEmpty ? '--' : controller.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: controller.text.isEmpty ? Colors.grey.shade400 : Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 出生地選択フィールド
  Widget _buildBirthplaceSelectorField(
    String label, 
    TextEditingController controller, {
    bool isRequired = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                // 都道府県選択ダイアログを表示
                final selectedPlace = await _selectBirthplace(context, controller.text);
                if (selectedPlace != null) {
                  setState(() {
                    controller.text = selectedPlace;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    controller.text.isEmpty ? '--' : controller.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: controller.text.isEmpty ? Colors.grey.shade400 : Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 出生時間選択フィールド
  Widget _buildBirthtimeSelectorField(
    String label, 
    TextEditingController controller, {
    bool isRequired = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                // 時間選択ダイアログを表示
                final selectedTime = await _selectBirthtime(context, controller.text);
                if (selectedTime != null) {
                  setState(() {
                    controller.text = selectedTime;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    controller.text.isEmpty ? '--' : controller.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: controller.text.isEmpty ? Colors.grey.shade400 : Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
