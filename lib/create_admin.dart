import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'services/database_service.dart';

// 占い師アカウント作成用の簡易スクリプト
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  developer.log('占い師アカウント作成を開始します...');
  print('占い師アカウント作成を開始します...');
  
  final dbService = DatabaseService();
  try {
    await dbService.connect();
    developer.log('データベースに接続しました');
    print('データベースに接続しました');
    
    // ユーザーテーブルの存在を確認
    await dbService.checkAndCreateTables();
    developer.log('テーブルを確認しました');
    
    final result = await dbService.createOrUpdateFortuneTeller();
    developer.log('結果: ${result['message']}');
    print('結果: ${result['message']}');
    
    // テストユーザーが作成されたことを確認
    final loginTest = await dbService.fortuneTellerLogin('test1', '11111111');
    developer.log('ログインテスト結果: ${loginTest?['success']}');
    if (loginTest?['success'] == true) {
      developer.log('テストユーザーでログイン成功: ${loginTest?['user']}');
    } else {
      developer.log('テストユーザーでログイン失敗: ${loginTest?['message']}');
    }
    
    await dbService.disconnect();
    developer.log('データベース接続を終了しました');
    print('データベース接続を終了しました');
  } catch (e) {
    developer.log('エラーが発生しました: $e', error: e);
    print('エラーが発生しました: $e');
  }
}
