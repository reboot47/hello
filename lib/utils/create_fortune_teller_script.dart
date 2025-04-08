import '../services/database_service.dart';
import '../utils/password_util.dart';

// 占い師アカウント作成スクリプト（コンソールから直接実行用）
Future<void> createFortuneTellerAccount() async {
  print('占い師アカウント作成を開始します...');
  
  try {
    // データベース接続
    final dbService = DatabaseService();
    await dbService.connect();
    
    // 占い師アカウントが既に存在するか確認
    final checkResult = await dbService._connection.query(
      'SELECT * FROM users WHERE email = @email',
      substitutionValues: {'email': 'test1'},
    );
    
    if (checkResult.isNotEmpty) {
      // アカウントが既に存在する場合はロールを更新
      await dbService._connection.execute(
        'UPDATE users SET role = @role WHERE email = @email',
        substitutionValues: {
          'email': 'test1',
          'role': 'fortuneteller',
        },
      );
      
      print('既存の占い師アカウントを更新しました');
    } else {
      // アカウントが存在しない場合は新規作成
      final hashedPassword = PasswordUtil.hashPassword('11111111');
      
      await dbService._connection.execute(
        'INSERT INTO users (email, password, role, points, created_at) VALUES (@email, @password, @role, @points, @createdAt)',
        substitutionValues: {
          'email': 'test1',
          'password': hashedPassword,
          'role': 'fortuneteller',
          'points': 5000, // 占い師には多めのポイント
          'createdAt': DateTime.now().toUtc().toIso8601String(),
        },
      );
      
      print('新規占い師アカウントを作成しました');
    }
    
    print('処理が完了しました。test1/11111111 でログインできます。');
    
    // データベース接続を閉じる
    await dbService.disconnect();
  } catch (e) {
    print('占い師アカウント作成エラー: $e');
  }
}

// メイン実行関数
void main() async {
  await createFortuneTellerAccount();
}
