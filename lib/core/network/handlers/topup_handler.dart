import 'dart:math';
import 'package:dio/dio.dart';
import '../mock_database.dart';
import '../../../features/topup/data/models/user_model.dart';
import '../../../features/topup/data/models/beneficiary_model.dart';
import '../../../features/topup/data/models/transaction_model.dart';

class TopupHandler {
  final MockDatabase _db = MockDatabase.instance;

  Map<String, dynamic> topup(RequestOptions options) {
    final body = options.data as Map<String, dynamic>;
    final benefId = body['beneficiaryId'] as String;
    final amount = (body['amount'] as num).toDouble();
    const fee = 3.0;
    final total = amount + fee;

    final user = UserModel.fromJson(_db.user);
    if (user.balance < total) throw Exception('Insufficient balance');

    final index = _db.beneficiaries.indexWhere((b) => b['id'] == benefId);
    if (index == -1) throw Exception('Beneficiary not found');

    final beneficiary = BeneficiaryModel.fromJson(_db.beneficiaries[index]);
    _db.beneficiaries[index] = BeneficiaryModel(
      id: beneficiary.id,
      nickname: beneficiary.nickname,
      phoneNumber: beneficiary.phoneNumber,
      monthlyUsed: beneficiary.monthlyUsed + amount,
    ).toJson();

    _db.user = UserModel(
      id: user.id,
      balance: user.balance - total,
      isVerified: user.isVerified,
    ).toJson();

    final transaction = TransactionModel(
      id: Random().nextInt(1000000).toString(),
      beneficiaryId: benefId,
      amount: amount,
      date: DateTime.now(),
    ).toJson();

    _db.transactions.add(transaction);
    return {'statusCode': 200, 'data': transaction};
  }
}
