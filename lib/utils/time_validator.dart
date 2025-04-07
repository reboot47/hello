class TimeValidator {
  static bool isValidTimeFormat(String input) {
    // HH:mm形式かチェック
    RegExp timeFormat = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    return timeFormat.hasMatch(input);
  }

  static String? formatTimeString(String input) {
    // 数字以外を削除
    String numbers = input.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbers.length > 4) {
      numbers = numbers.substring(0, 4);
    }
    
    if (numbers.length >= 2) {
      // 時間部分のバリデーション（00-23）
      int hours = int.parse(numbers.substring(0, 2));
      if (hours > 23) {
        numbers = '23' + numbers.substring(2);
      }
    }
    
    if (numbers.length >= 4) {
      // 分部分のバリデーション（00-59）
      int minutes = int.parse(numbers.substring(2, 4));
      if (minutes > 59) {
        numbers = numbers.substring(0, 2) + '59';
      }
    }
    
    // コロンを自動で挿入
    if (numbers.length >= 2) {
      numbers = numbers.substring(0, 2) + ':' + numbers.substring(2);
    }
    
    return numbers;
  }
}
