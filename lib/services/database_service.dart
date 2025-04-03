import 'package:postgres/postgres.dart';
import 'dart:async';
import '../utils/password_util.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  late final PostgreSQLConnection _connection;
  bool _isConnected = false;
  
  // 接続状態確認用のゲッター
  bool get isConnected => _isConnected;
  
  // テスト目的からの接続情報へのアクセス用
  PostgreSQLConnection get connection => _connection;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal() {
    // Neonクラウドデータベースに接続
    _connection = PostgreSQLConnection(
      'ep-twilight-forest-a1uddfjm-pooler.ap-southeast-1.aws.neon.tech',
      5432,
      'uranai',
      username: 'uranai_owner',
      password: 'npg_2Ht0cUKFVwGa',
      useSSL: true,
      allowClearTextPassword: true,
    );
    print('DatabaseService initialized with Neon cloud database');
  }

  Future<void> connect() async {
    if (!_isConnected) {
      try {
        print('Attempting to connect to database...');
        await _connection.open();
        _isConnected = true;
        print('Database connected successfully');
        
        // テーブルの存在確認
        await _ensureUsersTableExists();
      } catch (e) {
        print('Failed to connect to database: $e');
        print('Connection details: ${_connection.host}, ${_connection.port}, ${_connection.databaseName}');
        _isConnected = false;
        rethrow;
      }
    } else {
      print('Database already connected');
    }
  }

  Future<void> disconnect() async {
    if (_isConnected) {
      await _connection.close();
      _isConnected = false;
      print('Database disconnected');
    }
  }

  Future<Map<String, dynamic>?> registerUser(String email, String password) async {
    try {
      // データベース接続が確立されていることを確認
      if (!_isConnected) {
        await connect();
      }
      
      // ユーザーが既に存在するか確認
      final existingUsers = await _connection.query(
        'SELECT * FROM users WHERE email = @email',
        substitutionValues: {'email': email},
      );
      
      if (existingUsers.isNotEmpty) {
        return {'success': false, 'message': 'このメールアドレスは既に登録されています。'};
      }
      
      // users テーブルが存在するか確認し、必要なら作成
      await _ensureUsersTableExists();
      
      // パスワードをハッシュ化
      final hashedPassword = PasswordUtil.hashPassword(password);
      
      // ユーザー登録
      final result = await _connection.query(
        'INSERT INTO users (email, password, created_at) VALUES (@email, @password, @createdAt) RETURNING id, email',
        substitutionValues: {
          'email': email,
          'password': hashedPassword,
          'createdAt': DateTime.now().toUtc().toIso8601String(),
        },
      );
      
      if (result.isNotEmpty) {
        final user = {
          'id': result.first[0],
          'email': result.first[1],
        };
        return {'success': true, 'user': user};
      } else {
        return {'success': false, 'message': 'ユーザー登録に失敗しました。'};
      }
    } catch (e) {
      print('Error registering user: $e');
      if (e.toString().contains('duplicate key value violates unique constraint')) {
        return {'success': false, 'message': 'このメールアドレスは既に登録されています。'};
      }
      return {'success': false, 'message': 'エラーが発生しました: $e'};
    }
  }
  
  Future<void> _ensureUsersTableExists() async {
    try {
      print('Checking if users table exists...');
      // users テーブルが存在するか確認
      final tableExists = await _connection.query(
        "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'users')"
      );
      
      print('Table exists check result: ${tableExists.first[0]}');
      
      if (tableExists.first[0] == false) {
        print('Creating users table...');
        // テーブルが存在しない場合は作成
        await _connection.execute('''
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
        print('Created users table successfully');
      } else {
        print('Users table already exists');
      }
    } catch (e) {
      print('Error ensuring users table exists: $e');
      rethrow;
    }
  }
  
  // ユーザーログイン機能
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      if (!_isConnected) {
        await connect();
      }
      
      final result = await _connection.query(
        'SELECT id, email, password FROM users WHERE email = @email',
        substitutionValues: {'email': email},
      );
      
      if (result.isEmpty) {
        return {'success': false, 'message': 'メールアドレスまたはパスワードが正しくありません。'};
      }
      
      final storedHash = result.first[2] as String;
      final isPasswordValid = PasswordUtil.verifyPassword(password, storedHash);
      
      if (isPasswordValid) {
        // ログイン成功時にlast_loginを更新
        await _connection.execute(
          'UPDATE users SET last_login = @lastLogin WHERE id = @id',
          substitutionValues: {
            'id': result.first[0],
            'lastLogin': DateTime.now().toUtc().toIso8601String(),
          },
        );
        
        final user = {
          'id': result.first[0],
          'email': result.first[1],
        };
        
        return {'success': true, 'user': user};
      } else {
        return {'success': false, 'message': 'メールアドレスまたはパスワードが正しくありません。'};
      }
    } catch (e) {
      print('Error logging in user: $e');
      return {'success': false, 'message': 'ログイン中にエラーが発生しました: $e'};
    }
  }
}
