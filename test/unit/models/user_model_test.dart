import 'package:flutter_test/flutter_test.dart';
import 'package:lamyaatask/features/topup/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    final tJson = {'id': '1', 'balance': 5000.0, 'isVerified': true};

    final tModel = UserModel(id: '1', balance: 5000.0, isVerified: true);

    test('fromJson should return a valid UserModel', () {
      final result = UserModel.fromJson(tJson);

      expect(result.id, tModel.id);
      expect(result.balance, tModel.balance);
      expect(result.isVerified, tModel.isVerified);
    });

    test('toJson should return a valid JSON map', () {
      final result = tModel.toJson();

      expect(result, tJson);
    });

    test('fromJson then toJson should return the original map', () {
      final result = UserModel.fromJson(tJson).toJson();

      expect(result, tJson);
    });

    test('fromJson should parse balance as double', () {
      final json = {'id': '1', 'balance': 1000, 'isVerified': false};
      final result = UserModel.fromJson(json);

      expect(result.balance, isA<double>());
      expect(result.balance, 1000.0);
    });
  });
}
