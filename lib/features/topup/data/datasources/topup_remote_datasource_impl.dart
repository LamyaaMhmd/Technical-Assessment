import 'dart:math';

import '../../../../core/utils/constants.dart';
import '../models/user_model.dart';
import '../models/beneficiary_model.dart';
import '../models/transaction_model.dart';
import 'topup_remote_datasource.dart';

class TopupRemoteDatasourceImpl implements TopupRemoteDatasource {
  final List<BeneficiaryModel> _beneficiaries = [];

  final List<TransactionModel> _transactions = [];

  final UserModel _user = UserModel(id: "1", balance: 5000, isVerified: true);

  @override
  Future<UserModel> getUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _user;
  }

  @override
  Future<List<BeneficiaryModel>> getBeneficiaries() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _beneficiaries;
  }

  @override
  Future<void> addBeneficiary(String nickname, String phone) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final beneficiary = BeneficiaryModel(
      id: Random().nextInt(10000).toString(),
      nickname: nickname,
      phoneNumber: phone,
      monthlyUsed: 0,
    );

    _beneficiaries.add(beneficiary);
  }

  @override
  Future<void> topup(String beneficiaryId, double amount) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final beneficiary = _beneficiaries.firstWhere((b) => b.id == beneficiaryId);

    final totalAmount = amount + AppConstants.transactionFee;

    if (_user.balance < totalAmount) {
      throw Exception("Insufficient balance");
    }
    _user.balance -= totalAmount;

    beneficiary.monthlyUsed += amount;

    final transaction = TransactionModel(
      id: Random().nextInt(100000).toString(),
      beneficiaryId: beneficiaryId,
      amount: amount,
      date: DateTime.now(),
    );
    _transactions.add(transaction);
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _transactions;
  }
}
