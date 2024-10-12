import 'package:flutter_test/flutter_test.dart';

String _preprocessInput(String input) {
  String result = '';

  for (int i = 0; i < input.length; i++) {
    String char = input[i];

    // Jika karakter adalah angka, tambahkan ke hasil
    if (RegExp(r'[0-9]').hasMatch(char)) {
      result += char;
    }
    // Jika karakter adalah operator dan hasil sudah mengandung operator, validasi
    else if (RegExp(r'[+\-*/]').hasMatch(result)) {
      if (result.isNotEmpty &&
          RegExp(r'[+\-*/]').hasMatch(result[result.length - 1])) {
        return "invalid";
      }
      return result;
    }
    // Jika karakter adalah operator dan valid, tambahkan ke hasil
    else if (RegExp(r'[+\-*/]').hasMatch(char)) {
      result += char;
    }
  }

  return result;
}

void main() {
  group('preprocessInput', () {
    test('should return "1+2" for input "1+2"', () {
      expect(_preprocessInput("1+2"), equals("1+2"));
    });

    test('should return "32*123" for input "asas32*123"', () {
      expect(_preprocessInput("asas32*123"), equals("32*123"));
    });

    test('should return "1/333" for input "1/333+#2"', () {
      expect(_preprocessInput("1/333+#2"), equals("1/333"));
    });

    test('should return "invalid" for input "1/-333+#2"', () {
      expect(_preprocessInput("1/-333+#2"), equals("invalid"));
    });

    test('should return "-209" for complex input', () {
      String complexInput =
          'Penjumlahan -209+4=8+6=10 +3 =9+7=12+5 =|11+3=j10 +2 =9+3=|13 +3 =7+7=|9-4 =|8-6=1…';
      expect(_preprocessInput(complexInput), equals("-209"));
    });
  });
}
