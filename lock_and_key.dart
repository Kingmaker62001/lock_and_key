import 'dart:math';
import 'dart:io';

/// A class to manage password operations like validation and generation.
class PasswordManager {
  final Random _random = Random();

  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _digits = '0123456789';
  static const String _specialChars = '!@#\$%^&*()-_=+{}[]|;:<>,.?/~';

  /// Validates the strength of a password.
  String validatePassword(String password) {
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasLower = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#\$%^&*()_\-+=\[\]{};:,.<>?/|\\]'));
    bool isLong = password.length >= 12;

    if (hasUpper && hasLower && hasDigit && hasSpecial && isLong) {
      return 'Strong';
    } else if (hasLower && hasDigit && password.length >= 8) {
      return 'Intermediate';
    } else {
      return 'Weak';
    }
  }

  /// Generates a password of specified strength: strong, intermediate, or low.
  String generatePassword(String level) {
    int length;
    String charPool;

    switch (level.toLowerCase()) {
      case 'strong':
        length = 16;
        charPool = _lowercase + _uppercase + _digits + _specialChars;
        break;
      case 'intermediate':
        length = 12;
        charPool = _lowercase + _uppercase + _digits;
        break;
      case 'low':
        length = 8;
        charPool = _lowercase;
        break;
      default:
        throw ArgumentError('Invalid level. Choose strong, intermediate, or low.');
    }

    return _generateRandomPassword(length, charPool);
  }

  String _generateRandomPassword(int length, String charPool) {
    return List.generate(length, (_) => charPool[_random.nextInt(charPool.length)]).join();
  }
}

/// Prints CLI usage instructions.
void printUsage() {
  print('''
 Lock and Key - Dart Password CLI

Usage:
  dart run lock_and_key.dart validate <password>
  dart run lock_and_key.dart generate <strong|intermediate|low>

Examples:
  dart run lock_and_key.dart validate MyP@ss1234
  dart run lock_and_key.dart generate strong
''');
}

/// Entry point for the CLI.
void main(List<String> args) {
  final pm = PasswordManager();

  if (args.isEmpty || args.length < 2) {
    print(' Error: Invalid arguments.\n');
    printUsage();
    exit(1);
  }

  final command = args[0].toLowerCase();
  final value = args[1];

  try {
    if (command == 'validate') {
      final result = pm.validatePassword(value);
      print(' Password Strength: $result');
    } else if (command == 'generate') {
      final password = pm.generatePassword(value);
      print(' Generated Password [$value]: $password');
    } else {
      print(' Error: Unknown command "$command".\n');
      printUsage();
      exit(1);
    }
  } catch (e) {
    print(' Exception: ${e.toString()}');
    exit(1);
  }
}
