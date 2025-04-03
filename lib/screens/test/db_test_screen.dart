import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

class DbTestScreen extends StatefulWidget {
  const DbTestScreen({Key? key}) : super(key: key);

  @override
  State<DbTestScreen> createState() => _DbTestScreenState();
}

class _DbTestScreenState extends State<DbTestScreen> {
  final DatabaseService _dbService = DatabaseService();
  bool _isConnecting = false;
  String _connectionStatus = 'まだ接続していません';
  String _tableStatus = 'テーブル状態: 未確認';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('データベース接続テスト'),
        backgroundColor: const Color(0xFF3bcfd4),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.storage_rounded,
                      size: 48,
                      color: const Color(0xFF3bcfd4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Neonデータベース接続テスト',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1a237e),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '接続状態:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _connectionStatus,
                            style: TextStyle(
                              color: _connectionStatus.contains('成功')
                                  ? Colors.green
                                  : _connectionStatus.contains('エラー')
                                      ? Colors.red
                                      : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'テーブル状態:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _tableStatus,
                            style: TextStyle(
                              color: _tableStatus.contains('作成済み')
                                  ? Colors.green
                                  : _tableStatus.contains('エラー')
                                      ? Colors.red
                                      : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isConnecting
                          ? null
                          : () async {
                              setState(() {
                                _isConnecting = true;
                                _connectionStatus = '接続中...';
                                _tableStatus = 'テーブル状態: 確認中...';
                              });

                              try {
                                // データベースに接続
                                await _dbService.connect();

                                // テーブル作成を強制的に確認
                                await _checkAndCreateTable();

                                setState(() {
                                  _connectionStatus = '接続成功しました！';
                                  _tableStatus = 'テーブル状態: 確認済み/作成済み';
                                  _isConnecting = false;
                                });
                              } catch (e) {
                                setState(() {
                                  _connectionStatus = 'エラー: $e';
                                  _tableStatus = 'テーブル状態: エラー';
                                  _isConnecting = false;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3bcfd4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isConnecting
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'データベースに接続',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1a237e),
                ),
                child: const Text('戻る'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkAndCreateTable() async {
    try {
      // データベースに接続
      if (!_dbService.isConnected) {
        await _dbService.connect();
      }

      // テーブルが存在するか確認
      final result = await _dbService.connection.query(
        "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'users')",
      );

      bool tableExists = result.first[0] as bool;

      if (!tableExists) {
        // テーブルを作成
        await _dbService.connection.execute('''
          CREATE TABLE users (
            id SERIAL PRIMARY KEY,
            email VARCHAR(255) UNIQUE NOT NULL,
            password VARCHAR(255) NOT NULL,
            created_at TIMESTAMP NOT NULL,
            updated_at TIMESTAMP,
            profile_image TEXT,
            display_name VARCHAR(100),
            last_login TIMESTAMP
          )
        ''');
        setState(() {
          _tableStatus = 'テーブル状態: 新規作成しました';
        });
      } else {
        setState(() {
          _tableStatus = 'テーブル状態: 既に存在します';
        });
      }
    } catch (e) {
      setState(() {
        _tableStatus = 'テーブル確認エラー: $e';
      });
      rethrow;
    }
  }
}
