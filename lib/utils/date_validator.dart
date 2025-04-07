class DateValidator {
  static bool isValidDateFormat(String input) {
    // YYYY/MM/DD形式かチェック
    RegExp dateFormat = RegExp(r'^\d{4}/\d{2}/\d{2}$');
    if (!dateFormat.hasMatch(input)) return false;

    // 日付を分解
    List<String> parts = input.split('/');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    // 年の範囲チェック (1900年から現在まで)
    if (year < 1900 || year > DateTime.now().year) return false;

    // 月のチェック
    if (month < 1 || month > 12) return false;

    // 日のチェック
    int daysInMonth = DateTime(year, month + 1, 0).day;
    if (day < 1 || day > daysInMonth) return false;

    return true;
  }

  static String? formatDateString(String input) {
    // スラッシュを自動で挿入
    String numbers = input.replaceAll(RegExp(r'[^\d]'), '');
    if (numbers.length >= 4) {
      numbers = numbers.substring(0, 4) + '/' + numbers.substring(4);
    }
    if (numbers.length >= 7) {
      numbers = numbers.substring(0, 7) + '/' + numbers.substring(7);
    }
    if (numbers.length > 10) {
      numbers = numbers.substring(0, 10);
    }
    return numbers;
  }
}
