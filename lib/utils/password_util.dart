import 'dart:convert';
import 'package:crypto/crypto.dart';

/// パスワードの暗号化と検証を行うユーティリティクラス
class PasswordUtil {
  /// パスワードをハッシュ化する
  /// 実際のアプリケーションではもっと強力な暗号化（bcryptなど）を使用すべき
  static String hashPassword(String password) {
    final bytes = utf8.encode(password + 'uranai_salt_key'); // 簡易的なソルト
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// パスワードを検証する
  static bool verifyPassword(String password, String hashedPassword) {
    final hashedInput = hashPassword(password);
    return hashedInput == hashedPassword;
  }
}
