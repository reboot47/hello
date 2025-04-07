import 'package:postgres/postgres.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../utils/password_util.dart';
import 'web_database_service.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  late PostgreSQLConnection? _connection;
  bool _isConnected = false;
  
  // Web用のサービス
  static WebDatabaseService? _webService;
  
  // 接続状態確認用のゲッター
  bool get isConnected => _isConnected;
  
  // テスト目的からの接続情報へのアクセス用
  PostgreSQLConnection? get connection => _connection;

  factory DatabaseService() {
    return _instance;
  }

  // 新しい接続インスタンスを作成するメソッド
  PostgreSQLConnection _createNewConnection() {
    return PostgreSQLConnection(
      'ep-twilight-forest-a1uddfjm-pooler.ap-southeast-1.aws.neon.tech',
      5432,
      'uranai',
      username: 'uranai_owner',
      password: 'npg_2Ht0cUKFVwGa',
      useSSL: true,
      allowClearTextPassword: true,
    );
  }

  DatabaseService._internal() {
    if (!kIsWeb) {
      // モバイル環境では通常のPostgreSQLConnectionを使用
      _connection = _createNewConnection();
      print('DatabaseService initialized with Neon cloud database for mobile');
    } else {
      // Web環境では接続をnullに設定し、WebDatabaseServiceを使用
      _connection = null;
      _webService = WebDatabaseService();
      print('DatabaseService initialized for web environment');
    }
  }

  Future<void> connect() async {
    if (!_isConnected) {
      if (!kIsWeb) {
        // モバイル環境での接続処理
        try {
          print('Attempting to connect to database (mobile)...');
          
          // 接続が閉じられていた場合は新しい接続を作成
          if (_connection!.isClosed) {
            print('Connection was closed, creating a new connection instance');
            _connection = _createNewConnection();
          }
          
          await _connection!.open();
          _isConnected = true;
          print('Database connected successfully (mobile)');
          
          // テーブルの存在確認
          await _ensureUsersTableExists();
        } catch (e) {
          print('Failed to connect to database: $e');
          if (_connection != null) {
            print('Connection details: ${_connection!.host}, ${_connection!.port}, ${_connection!.databaseName}');
          }
          _isConnected = false;
          
          // エラーが「closed connection」に関するものであれば、新しい接続を試みる
          if (e.toString().contains('closed connection') || 
              e.toString().contains('reopen a closed connection')) {
            print('Trying with a fresh connection instance...');
            _connection = _createNewConnection();
            // ここでは再接続を試みないが、次回のconnect()呼び出しで新しいインスタンスが使用される
          }
          
          rethrow;
        }
      } else {
        // Web環境では接続成功とみなす
        print('Web environment detected, using WebDatabaseService');
        _isConnected = true;
      }
    } else {
      print('Database already connected');
    }
  }

  Future<void> disconnect() async {
    // Keep connection open for better performance
    // Only disconnect when app is shutting down or in low memory situations
    print('Database connection kept alive for better performance');
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
      
      // 初期ポイント1000PTを付与してユーザー登録
      final result = await _connection.query(
        'INSERT INTO users (email, password, points, created_at) VALUES (@email, @password, @points, @createdAt) RETURNING id, email, points',
        substitutionValues: {
          'email': email,
          'password': hashedPassword,
          'points': 1000, // 新規登録時に1000ポイント付与
          'createdAt': DateTime.now().toUtc().toIso8601String(),
        },
      );
      
      if (result.isNotEmpty) {
        final user = {
          'id': result.first[0],
          'email': result.first[1],
          'points': result.first[2],
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
            points INTEGER DEFAULT 0,
            created_at TIMESTAMP NOT NULL,
            updated_at TIMESTAMP,
            profile_image TEXT,
            display_name VARCHAR(100),
            last_login TIMESTAMP
          )
        ''');
        print('Created users table successfully');
      } else {
        // テーブルは存在するが、pointsカラムが存在するか確認
        final pointsColumnExists = await _connection.query(
          "SELECT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'points')"
        );
        
        if (pointsColumnExists.first[0] == false) {
          print('Adding points column to users table...');
          await _connection.execute('ALTER TABLE users ADD COLUMN points INTEGER DEFAULT 0');
          print('Added points column successfully');
        }
        
        print('Users table already exists');
      }
      
      // 関連テーブルもチェックしておく
      await _ensureConsultationCardTableExists();
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
      
      if (!kIsWeb) {
        // モバイル環境でのログイン処理
        final result = await _connection!.query(
          'SELECT id, email, password, points FROM users WHERE email = @email',
          substitutionValues: {'email': email},
        );
        
        if (result.isEmpty) {
          return {'success': false, 'message': 'メールアドレスまたはパスワードが正しくありません。'};
        }
        
        final storedHash = result.first[2] as String;
        final isPasswordValid = PasswordUtil.verifyPassword(password, storedHash);
        
        if (isPasswordValid) {
          // ログイン成功時にlast_loginを更新
          await _connection!.execute(
            'UPDATE users SET last_login = @lastLogin WHERE id = @id',
            substitutionValues: {
              'id': result.first[0],
              'lastLogin': DateTime.now().toUtc().toIso8601String(),
            },
          );
          
          final user = {
            'id': result.first[0],
            'email': result.first[1],
            'points': result.first[3] ?? 0,
          };
          
          // ユーザーメールアドレスをSharedPreferencesに保存
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userEmail', email);
          
          return {'success': true, 'user': user};
        } else {
          return {'success': false, 'message': 'メールアドレスまたはパスワードが正しくありません。'};
        }
      } else {
        // Web環境でのログイン処理
        print('Using web login service');
        return await _webService!.loginUser(email, password);
      }
    } catch (e) {
      print('Error logging in user: $e');
      
      // Web環境でエラーが発生した場合、デモユーザーでのログインを試みる
      if (kIsWeb && email == 'demo@example.com' && password == 'password123') {
        print('Falling back to demo user login for web');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', email);
        
        return {
          'success': true,
          'message': 'デモユーザーとしてログインしました。',
          'user': {
            'id': 'demo-user',
            'email': email,
            'points': 100,
          }
        };
      }
      
      return {'success': false, 'message': 'ログイン中にエラーが発生しました: $e'};
    }
  }
  
  // パスワード更新機能
  Future<Map<String, dynamic>> updatePassword(String email, String newPassword) async {
    try {
      if (!_isConnected) {
        await connect();
      }
      
      // ユーザーの存在確認
      final userExists = await _connection.query(
        'SELECT id FROM users WHERE email = @email',
        substitutionValues: {'email': email},
      );
      
      if (userExists.isEmpty) {
        return {'success': false, 'message': 'ユーザーが見つかりません。'};
      }
      
      // パスワードをハッシュ化
      final hashedPassword = PasswordUtil.hashPassword(newPassword);
      
      // パスワードを更新
      await _connection.execute(
        'UPDATE users SET password = @password, updated_at = @updatedAt WHERE email = @email',
        substitutionValues: {
          'email': email,
          'password': hashedPassword,
          'updatedAt': DateTime.now().toUtc().toIso8601String(),
        },
      );
      
      return {'success': true, 'message': 'パスワードが正常に更新されました。'};
    } catch (e) {
      print('Error updating password: $e');
      return {'success': false, 'message': 'パスワード更新中にエラーが発生しました: $e'};
    }
  }
  
  // 相談カルテテーブルの作成を確認
  Future<void> _ensureConsultationCardTableExists() async {
    try {
      print('Checking if consultation_cards table exists...');
      // consultation_cards テーブルが存在するか確認
      final tableExists = await _connection.query(
        "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'consultation_cards')"
      );
      
      print('Table exists check result: ${tableExists.first[0]}');
      
      if (tableExists.first[0] == false) {
        print('Creating consultation_cards table...');
        // テーブルが存在しない場合は作成
        await _connection.execute('''
          CREATE TABLE consultation_cards (
            id SERIAL PRIMARY KEY,
            user_id INTEGER NOT NULL,
            self_name VARCHAR(100),
            self_gender VARCHAR(50),
            self_birthdate VARCHAR(50),
            self_birthplace VARCHAR(100),
            self_birthtime VARCHAR(50),
            self_concerns TEXT,
            partner1_name VARCHAR(100),
            partner1_gender VARCHAR(50),
            partner1_birthdate VARCHAR(50),
            partner1_birthplace VARCHAR(100),
            partner1_birthtime VARCHAR(50),
            partner1_relationship VARCHAR(100),
            partner2_name VARCHAR(100),
            partner2_gender VARCHAR(50),
            partner2_birthdate VARCHAR(50),
            partner2_birthplace VARCHAR(100),
            partner2_birthtime VARCHAR(50),
            partner2_relationship VARCHAR(100),
            created_at TIMESTAMP NOT NULL,
            updated_at TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');
        print('Created consultation_cards table successfully');
      } else {
        print('Consultation_cards table already exists');
      }
    } catch (e) {
      print('Error ensuring consultation_cards table exists: $e');
      rethrow;
    }
  }
  
  // 相談カルテを保存する機能
  Future<Map<String, dynamic>> saveConsultationCard(Map<String, dynamic> cardData, String userEmail) async {
    try {
      if (!_isConnected) {
        await connect();
      }
      
      if (!kIsWeb) {
        // モバイル環境での処理
        // 相談カルテテーブルが存在するか確認し、必要なら作成
        await _ensureConsultationCardTableExists();
        
        // ユーザーIDを取得
        final userResult = await _connection!.query(
          'SELECT id FROM users WHERE email = @email',
          substitutionValues: {'email': userEmail},
        );
        
        if (userResult.isEmpty) {
          return {'success': false, 'message': 'ユーザーが見つかりません。'};
        }
        
        final userId = userResult.first[0];
        
        // 既存の相談カルテがあるか確認
        final existingCard = await _connection!.query(
          'SELECT id FROM consultation_cards WHERE user_id = @userId',
          substitutionValues: {'userId': userId},
        );
        
        final timestamp = DateTime.now().toUtc().toIso8601String();
        Map<String, dynamic> result;
        
        if (existingCard.isEmpty) {
          // 新規作成
          final insertResult = await _connection!.query('''
            INSERT INTO consultation_cards (
              user_id, self_name, self_gender, self_birthdate, self_birthplace, self_birthtime, self_concerns,
              partner1_name, partner1_gender, partner1_birthdate, partner1_birthplace, partner1_birthtime, partner1_relationship,
              partner2_name, partner2_gender, partner2_birthdate, partner2_birthplace, partner2_birthtime, partner2_relationship,
              created_at, updated_at
            ) VALUES (
              @userId, @selfName, @selfGender, @selfBirthdate, @selfBirthplace, @selfBirthtime, @selfConcerns,
              @partner1Name, @partner1Gender, @partner1Birthdate, @partner1Birthplace, @partner1Birthtime, @partner1Relationship,
              @partner2Name, @partner2Gender, @partner2Birthdate, @partner2Birthplace, @partner2Birthtime, @partner2Relationship,
              @createdAt, @updatedAt
            ) RETURNING id
          ''', substitutionValues: {
            'userId': userId,
            'selfName': cardData['self_name'] ?? '',
            'selfGender': cardData['self_gender'] ?? '',
            'selfBirthdate': cardData['self_birthdate'] ?? '',
            'selfBirthplace': cardData['self_birthplace'] ?? '',
            'selfBirthtime': cardData['self_birthtime'] ?? '',
            'selfConcerns': cardData['self_concerns'] ?? '',
            'partner1Name': cardData['partner1_name'] ?? '',
            'partner1Gender': cardData['partner1_gender'] ?? '',
            'partner1Birthdate': cardData['partner1_birthdate'] ?? '',
            'partner1Birthplace': cardData['partner1_birthplace'] ?? '',
            'partner1Birthtime': cardData['partner1_birthtime'] ?? '',
            'partner1Relationship': cardData['partner1_relationship'] ?? '',
            'partner2Name': cardData['partner2_name'] ?? '',
            'partner2Gender': cardData['partner2_gender'] ?? '',
            'partner2Birthdate': cardData['partner2_birthdate'] ?? '',
            'partner2Birthplace': cardData['partner2_birthplace'] ?? '',
            'partner2Birthtime': cardData['partner2_birthtime'] ?? '',
            'partner2Relationship': cardData['partner2_relationship'] ?? '',
            'createdAt': timestamp,
            'updatedAt': timestamp,
          });
          
          result = {
            'success': true, 
            'message': '相談カルテを作成しました。',
            'id': insertResult.first[0]
          };
        } else {
          // 既存のカルテを更新
          final cardId = existingCard.first[0];
          await _connection!.execute('''
            UPDATE consultation_cards SET
              self_name = @selfName,
              self_gender = @selfGender,
              self_birthdate = @selfBirthdate,
              self_birthplace = @selfBirthplace,
              self_birthtime = @selfBirthtime,
              self_concerns = @selfConcerns,
              partner1_name = @partner1Name,
              partner1_gender = @partner1Gender,
              partner1_birthdate = @partner1Birthdate,
              partner1_birthplace = @partner1Birthplace,
              partner1_birthtime = @partner1Birthtime,
              partner1_relationship = @partner1Relationship,
              partner2_name = @partner2Name,
              partner2_gender = @partner2Gender,
              partner2_birthdate = @partner2Birthdate,
              partner2_birthplace = @partner2Birthplace,
              partner2_birthtime = @partner2Birthtime,
              partner2_relationship = @partner2Relationship,
              updated_at = @updatedAt
            WHERE id = @cardId
          ''', substitutionValues: {
            'cardId': cardId,
            'selfName': cardData['self_name'] ?? '',
            'selfGender': cardData['self_gender'] ?? '',
            'selfBirthdate': cardData['self_birthdate'] ?? '',
            'selfBirthplace': cardData['self_birthplace'] ?? '',
            'selfBirthtime': cardData['self_birthtime'] ?? '',
            'selfConcerns': cardData['self_concerns'] ?? '',
            'partner1Name': cardData['partner1_name'] ?? '',
            'partner1Gender': cardData['partner1_gender'] ?? '',
            'partner1Birthdate': cardData['partner1_birthdate'] ?? '',
            'partner1Birthplace': cardData['partner1_birthplace'] ?? '',
            'partner1Birthtime': cardData['partner1_birthtime'] ?? '',
            'partner1Relationship': cardData['partner1_relationship'] ?? '',
            'partner2Name': cardData['partner2_name'] ?? '',
            'partner2Gender': cardData['partner2_gender'] ?? '',
            'partner2Birthdate': cardData['partner2_birthdate'] ?? '',
            'partner2Birthplace': cardData['partner2_birthplace'] ?? '',
            'partner2Birthtime': cardData['partner2_birthtime'] ?? '',
            'partner2Relationship': cardData['partner2_relationship'] ?? '',
            'updatedAt': timestamp,
          });
          
          result = {
            'success': true, 
            'message': '相談カルテを更新しました。',
            'id': cardId
          };
        }
        
        return result;
      } else {
        // Web環境での処理
        print('Using web service for consultation card saving');
        return await _webService!.saveConsultationCard(cardData, userEmail);
      }
    } catch (e) {
      print('Error saving consultation card: $e');
      return {'success': false, 'message': '相談カルテの保存中にエラーが発生しました: $e'};
    }
  }
  
  // 相談カルテを取得する機能
  Future<Map<String, dynamic>> getConsultationCard(String userEmail) async {
    try {
      if (!_isConnected) {
        await connect();
      }
      
      if (!kIsWeb) {
        // モバイル環境での処理
        // ユーザーIDを取得
        final userResult = await _connection!.query(
          'SELECT id FROM users WHERE email = @email',
          substitutionValues: {'email': userEmail},
        );
        
        if (userResult.isEmpty) {
          return {'success': false, 'message': 'ユーザーが見つかりません。'};
        }
        
        final userId = userResult.first[0];
        
        // 相談カルテを取得
        final cardResult = await _connection!.query('''
          SELECT * FROM consultation_cards WHERE user_id = @userId
        ''', substitutionValues: {'userId': userId});
        
        if (cardResult.isEmpty) {
          return {
            'success': true,
            'message': '相談カルテが見つかりません。',
            'exists': false,
            'card': {}
          };
        }
        
        // データをマップに変換
        final row = cardResult.first;
        final columnDescriptions = cardResult.columnDescriptions;
        
        Map<String, dynamic> cardData = {};
        for (int i = 0; i < columnDescriptions.length; i++) {
          cardData[columnDescriptions[i].columnName] = row[i];
        }
        
        return {
          'success': true,
          'message': '相談カルテを取得しました。',
          'exists': true,
          'card': cardData
        };
      } else {
        // Web環境での処理
        print('Using web service for consultation card retrieval');
        return await _webService!.getConsultationCard(userEmail);
      }
    } catch (e) {
      print('Error fetching consultation card: $e');
      return {'success': false, 'message': '相談カルテの取得中にエラーが発生しました: $e'};
    }
  }
  
  // ユーザープロフィール情報を取得する
  Future<Map<String, dynamic>> getUserProfile(String email) async {
    try {
      if (!_isConnected) {
        await connect();
      }

      final result = await _connection.query(
        'SELECT id, email, profile_image, display_name, points FROM users WHERE email = @email',
        substitutionValues: {'email': email},
      );

      if (result.isEmpty) {
        return {'success': false, 'message': 'ユーザーが見つかりません。'};
      }

      final profileData = {
        'id': result.first[0],
        'email': result.first[1],
        'profile_image': result.first[2],
        'display_name': result.first[3],
        'points': result.first[4] ?? 0,
      };

      return {'success': true, 'profile': profileData};
    } catch (e) {
      print('Error getting user profile: $e');
      return {'success': false, 'message': 'プロフィール取得中にエラーが発生しました: $e'};
    }
  }
  
  // ユーザーのポイントを取得する
  Future<Map<String, dynamic>> getUserPoints(String email) async {
    try {
      if (!_isConnected) {
        await connect();
      }

      final result = await _connection.query(
        'SELECT points FROM users WHERE email = @email',
        substitutionValues: {'email': email},
      );

      if (result.isEmpty) {
        return {'success': false, 'message': 'ユーザーが見つかりません。'};
      }

      return {
        'success': true, 
        'points': result.first[0] ?? 0,
      };
    } catch (e) {
      print('Error getting user points: $e');
      return {'success': false, 'message': 'ポイント取得中にエラーが発生しました: $e'};
    }
  }

  // ユーザーのポイントを更新する
  Future<Map<String, dynamic>> updateUserPoints(String email, int points) async {
    try {
      if (!_isConnected) {
        await connect();
      }

      await _connection.execute(
        'UPDATE users SET points = @points WHERE email = @email',
        substitutionValues: {
          'email': email,
          'points': points,
        },
      );

      return {'success': true, 'points': points};
    } catch (e) {
      print('Error updating user points: $e');
      return {'success': false, 'message': 'ポイント更新中にエラーが発生しました: $e'};
    }
  }
}
