import 'package:flutter_test/flutter_test.dart';
import 'package:lamyaatask/features/topup/data/models/transaction_model.dart';

void main() {
  group('TransactionModel', () {
    final tDate = DateTime(2024, 3, 15);

    final tJson = {
      'id': '999',
      'beneficiaryId': '101',
      'amount': 50.0,
      'date': tDate.toIso8601String(),
    };

    final tModel = TransactionModel(
      id: '999',
      beneficiaryId: '101',
      amount: 50.0,
      date: tDate,
    );

    test('fromJson should return a valid TransactionModel', () {
      final result = TransactionModel.fromJson(tJson);

      expect(result.id, tModel.id);
      expect(result.beneficiaryId, tModel.beneficiaryId);
      expect(result.amount, tModel.amount);
      expect(result.date, tModel.date);
    });

    test('toJson should return a valid JSON map', () {
      final result = tModel.toJson();

      expect(result, tJson);
    });

    test('fromJson then toJson should return the original map', () {
      final result = TransactionModel.fromJson(tJson).toJson();

      expect(result, tJson);
    });

    test('fromJson should parse amount as double', () {
      final json = {
        'id': '1',
        'beneficiaryId': '101',
        'amount': 100,
        'date': tDate.toIso8601String(),
      };
      final result = TransactionModel.fromJson(json);

      expect(result.amount, isA<double>());
      expect(result.amount, 100.0);
    });

    test('fromJson should parse date as DateTime', () {
      final result = TransactionModel.fromJson(tJson);

      expect(result.date, isA<DateTime>());
    });
  });
}
