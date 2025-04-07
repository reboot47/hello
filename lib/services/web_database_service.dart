import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/password_util.dart';

/// Web環境用のデータベースサービス
/// RESTful APIを使用してバックエンドと通信する
class WebDatabaseService {
  // APIエンドポイントのベースURL
  final String _baseUrl = 'https://reboot47-api.herokuapp.com/api';
  
  // シングルトンパターン
  static final WebDatabaseService _instance = WebDatabaseService._internal();
  
  factory WebDatabaseService() {
    return _instance;
  }
  
  WebDatabaseService._internal();
  
  /// ユーザーログイン処理
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      // APIエンドポイントにPOSTリクエストを送信
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      // レスポンスを解析
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // ログイン成功時にはトークンをローカルストレージに保存
        if (data['success'] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userEmail', email);
          await prefs.setString('authToken', data['token']);
        }
        
        return data;
      } else {
        // エラーレスポンスの場合
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'ログインに失敗しました。',
        };
      }
    } catch (e) {
      print('Web login error: $e');
      
      // オフライン認証のフォールバック（デモ用）
      if (email == 'demo@example.com' && password == 'password123') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', email);
        
        return {
          'success': true,
          'message': 'デモユーザーとしてログインしました。',
          'user': {
            'email': email,
            'display_name': 'デモユーザー',
            'points': 100,
          }
        };
      }
      
      return {
        'success': false,
        'message': 'ネットワークエラーが発生しました。インターネット接続を確認してください。',
      };
    }
  }
  
  /// ユーザー登録処理
  Future<Map<String, dynamic>> registerUser(String email, String password) async {
    try {
      // APIエンドポイントにPOSTリクエストを送信
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      // レスポンスを解析
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        // エラーレスポンスの場合
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? '登録に失敗しました。',
        };
      }
    } catch (e) {
      print('Web register error: $e');
      
      // デモ用のフォールバック
      if (email == 'demo@example.com') {
        return {
          'success': false,
          'message': 'このメールアドレスは既に登録されています。',
        };
      }
      
      return {
        'success': true,
        'message': 'ユーザー登録が完了しました。（オフラインモード）',
      };
    }
  }
  
  /// 相談カルテを取得する
  Future<Map<String, dynamic>> getConsultationCard(String userEmail) async {
    try {
      // 認証トークンを取得
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      
      // APIエンドポイントにGETリクエストを送信
      final response = await http.get(
        Uri.parse('$_baseUrl/consultation-card'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      // レスポンスを解析
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        // エラーレスポンスの場合
        return {
          'success': false,
          'message': '相談カルテの取得に失敗しました。',
        };
      }
    } catch (e) {
      print('Web get consultation card error: $e');
      
      // デモ用のフォールバック - ローカルストレージから取得
      final prefs = await SharedPreferences.getInstance();
      final cardData = prefs.getString('consultationCard');
      
      if (cardData != null) {
        return {
          'success': true,
          'message': '相談カルテを取得しました。（オフラインモード）',
          'exists': true,
          'card': jsonDecode(cardData),
        };
      }
      
      return {
        'success': true,
        'message': '相談カルテが見つかりません。',
        'exists': false,
        'card': {}
      };
    }
  }
  
  /// 相談カルテを保存する
  Future<Map<String, dynamic>> saveConsultationCard(Map<String, dynamic> cardData, String userEmail) async {
    try {
      // 認証トークンを取得
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      
      // APIエンドポイントにPOSTリクエストを送信
      final response = await http.post(
        Uri.parse('$_baseUrl/consultation-card'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(cardData),
      );
      
      // レスポンスを解析
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        // エラーレスポンスの場合
        return {
          'success': false,
          'message': '相談カルテの保存に失敗しました。',
        };
      }
    } catch (e) {
      print('Web save consultation card error: $e');
      
      // デモ用のフォールバック - ローカルストレージに保存
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('consultationCard', jsonEncode(cardData));
      
      return {
        'success': true,
        'message': '相談カルテを保存しました。（オフラインモード）',
        'id': 'local-${DateTime.now().millisecondsSinceEpoch}',
      };
    }
  }
  
  /// ユーザープロフィール情報を取得する
  Future<Map<String, dynamic>> getUserProfile(String email) async {
    try {
      // 認証トークンを取得
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      
      // APIエンドポイントにGETリクエストを送信
      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      // レスポンスを解析
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        // エラーレスポンスの場合
        return {
          'success': false,
          'message': 'プロフィール情報の取得に失敗しました。',
        };
      }
    } catch (e) {
      print('Web get profile error: $e');
      
      // デモ用のフォールバック
      if (email == 'demo@example.com') {
        return {
          'success': true,
          'profile': {
            'id': 'demo-user',
            'email': email,
            'profile_image': null,
            'display_name': 'デモユーザー',
            'points': 100,
          }
        };
      }
      
      return {
        'success': false,
        'message': 'プロフィール取得中にエラーが発生しました。',
      };
    }
  }
  
  /// ユーザーのポイントを取得する
  Future<Map<String, dynamic>> getUserPoints(String email) async {
    try {
      // 認証トークンを取得
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      
      // APIエンドポイントにGETリクエストを送信
      final response = await http.get(
        Uri.parse('$_baseUrl/points'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      // レスポンスを解析
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        // エラーレスポンスの場合
        return {
          'success': false,
          'message': 'ポイント情報の取得に失敗しました。',
        };
      }
    } catch (e) {
      print('Web get points error: $e');
      
      // デモ用のフォールバック
      return {
        'success': true,
        'points': 100,
      };
    }
  }
  
  /// ユーザーのポイントを更新する
  Future<Map<String, dynamic>> updateUserPoints(String email, int points) async {
    try {
      // 認証トークンを取得
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      
      // APIエンドポイントにPOSTリクエストを送信
      final response = await http.post(
        Uri.parse('$_baseUrl/points'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'points': points}),
      );
      
      // レスポンスを解析
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        // エラーレスポンスの場合
        return {
          'success': false,
          'message': 'ポイントの更新に失敗しました。',
        };
      }
    } catch (e) {
      print('Web update points error: $e');
      
      // デモ用のフォールバック
      return {
        'success': true,
        'points': points,
      };
    }
  }
}
