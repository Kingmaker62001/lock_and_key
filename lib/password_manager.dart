import 'dart:math';

class PasswordManager {
  final Random _random = Random();
  static const _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const _digits = '0123456789';
  static const _special = r'!@#$%^&*()-_=+{}[]|;:<>,.?/~';

  String validatePassword(String pw) {
    final hasUpper = pw.contains(RegExp(r'[A-Z]'));
    final hasLower = pw.contains(RegExp(r'[a-z]'));
    final hasDigit = pw.contains(RegExp(r'\d'));
    final hasSpecial = pw.contains(RegExp(r'[!@#\$%^&*()_\-+=\[\]{};:,.<>?/\\|~]'));
    final isLong = pw.length >= 12;

    if (hasUpper && hasLower && hasDigit && hasSpecial && isLong) {
      return 'Strong';
    } else if (hasLower && hasDigit && pw.length >= 8) {
      return 'Intermediate';
    } else {
      return 'Weak';
    }
  }

  String generatePassword(String level) {
    switch (level) {
      case 'strong':
        return _generateStrong(16);
      case 'intermediate':
        return _generateRandom(12, _lowercase + _uppercase + _digits);
      case 'low':
        return _generateRandom(8, _lowercase);
      default:
        throw ArgumentError('Invalid level: $level');
    }
  }

  String _generateStrong(int length) {
    final req = [
      _uppercase[_random.nextInt(_uppercase.length)],
      _lowercase[_random.nextInt(_lowercase.length)],
      _digits[_random.nextInt(_digits.length)],
      _special[_random.nextInt(_special.length)],
    ];
    final pool = _lowercase + _uppercase + _digits + _special;
    final rest = List.generate(length - req.length, (_) => pool[_random.nextInt(pool.length)]);
    final pw = []..addAll(req)..addAll(rest)..shuffle(_random);
    return pw.join();
  }

  String _generateRandom(int length, String pool) =>
      List.generate(length, (_) => pool[_random.nextInt(pool.length)]).join();
}
