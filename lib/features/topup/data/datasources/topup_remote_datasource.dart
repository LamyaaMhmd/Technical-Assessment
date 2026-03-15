import '../models/user_model.dart';
import '../models/beneficiary_model.dart';
import '../models/transaction_model.dart';

abstract class TopupRemoteDatasource {
  Future<UserModel> getUser();

  Future<List<BeneficiaryModel>> getBeneficiaries();

  Future<void> addBeneficiary(String nickname, String phone);

  Future<void> topup(String beneficiaryId, double amount);

  Future<List<TransactionModel>> getTransactions();
}
