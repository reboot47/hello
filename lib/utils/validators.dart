/// 入力フォームの検証ロジックを提供するユーティリティクラス
class Validators {
  /// メールアドレスの検証
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'メールアドレスを入力してください';
    }

    // 基本的なメール形式の検証
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return '有効なメールアドレスを入力してください';
    }

    return null;
  }

  /// パスワードの検証
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'パスワードを入力してください';
    }

    if (value.length < 8) {
      return 'パスワードは8文字以上必要です';
    }

    // 少なくとも1つの英数字と記号
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d\W_]+$').hasMatch(value)) {
      return 'パスワードは英字と数字を含める必要があります';
    }

    return null;
  }

  /// 確認用パスワードの検証
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return '確認用パスワードを入力してください';
    }

    if (value != password) {
      return 'パスワードが一致しません';
    }

    return null;
  }
}
