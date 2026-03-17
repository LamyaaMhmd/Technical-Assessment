import 'package:flutter_test/flutter_test.dart';
import 'package:lamyaatask/features/topup/data/models/beneficiary_model.dart';

void main() {
  group('BeneficiaryModel', () {
    final tJson = {
      'id': '101',
      'nickname': 'Mom',
      'phoneNumber': '0501234567',
      'monthlyUsed': 200.0,
    };

    final tModel = BeneficiaryModel(
      id: '101',
      nickname: 'Mom',
      phoneNumber: '0501234567',
      monthlyUsed: 200.0,
    );

    test('fromJson should return a valid BeneficiaryModel', () {
      final result = BeneficiaryModel.fromJson(tJson);

      expect(result.id, tModel.id);
      expect(result.nickname, tModel.nickname);
      expect(result.phoneNumber, tModel.phoneNumber);
      expect(result.monthlyUsed, tModel.monthlyUsed);
    });

    test('toJson should return a valid JSON map', () {
      final result = tModel.toJson();

      expect(result, tJson);
    });

    test('fromJson then toJson should return the original map', () {
      final result = BeneficiaryModel.fromJson(tJson).toJson();

      expect(result, tJson);
    });

    test('fromJson should parse monthlyUsed as double', () {
      final json = {
        'id': '1',
        'nickname': 'Dad',
        'phoneNumber': '0507654321',
        'monthlyUsed': 0,
      };
      final result = BeneficiaryModel.fromJson(json);

      expect(result.monthlyUsed, isA<double>());
      expect(result.monthlyUsed, 0.0);
    });
  });
}
