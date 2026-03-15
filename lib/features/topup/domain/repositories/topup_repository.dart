import '../entities/user.dart';
import '../entities/beneficiary.dart';
import '../entities/transaction.dart';

abstract class TopupRepository {
  Future<User> getUser();

  Future<List<Beneficiary>> getBeneficiaries();

  Future<void> addBeneficiary(String nickname, String phone);

  Future<void> topup({required String beneficiaryId, required double amount});

  Future<List<Transaction>> getTransactions();
}
