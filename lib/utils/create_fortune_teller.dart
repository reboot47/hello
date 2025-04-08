import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../utils/password_util.dart';

// 占い師アカウント作成ユーティリティ
class FortuneTellerCreator {
  static Future<void> createFortuneTeller(BuildContext context) async {
    try {
      // データベース接続
      final dbService = DatabaseService();
      
      // 占い師アカウントが既に存在するか確認
      await dbService.connect();
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
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('占い師アカウントを更新しました')),
        );
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
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('占い師アカウントを作成しました')),
        );
      }
    } catch (e) {
      print('占い師アカウント作成エラー: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }
}
