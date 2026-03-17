import 'dart:math';
import 'package:dio/dio.dart';
import '../mock_database.dart';
import '../../../features/topup/data/models/beneficiary_model.dart';

class BeneficiaryHandler {
  final MockDatabase _db = MockDatabase.instance;

  Map<String, dynamic> getBeneficiaries() {
    return {'statusCode': 200, 'data': _db.beneficiaries};
  }

  Map<String, dynamic> addBeneficiary(RequestOptions options) {
    final body = options.data as Map<String, dynamic>;

    if (_db.beneficiaries.length >= 5) {
      throw Exception('Maximum of 5 beneficiaries allowed');
    }

    final newBeneficiary = BeneficiaryModel(
      id: Random().nextInt(100000).toString(),
      nickname: body['nickname'] as String,
      phoneNumber: body['phoneNumber'] as String,
      monthlyUsed: 0.0,
    ).toJson();

    _db.beneficiaries.add(newBeneficiary);
    return {'statusCode': 201, 'data': newBeneficiary};
  }
}
