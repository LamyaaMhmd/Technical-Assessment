import '../../../../core/utils/constants.dart';
import '../repositories/topup_repository.dart';

class TopupNumber {
  final TopupRepository repository;

  TopupNumber(this.repository);

  Future<void> call({
    required String beneficiaryId,
    required double amount,
  }) async {
    final user = await repository.getUser();
    final beneficiaries = await repository.getBeneficiaries();
    final transactions = await repository.getTransactions();

    final beneficiary = beneficiaries.firstWhere((b) => b.id == beneficiaryId);

    final totalAmount = amount + AppConstants.transactionFee;

    if (totalAmount > user.balance) {
      throw Exception("Insufficient balance");
    }

    final limit = user.isVerified ? 1000 : 500;

    if (beneficiary.monthlyUsed + amount > limit) {
      throw Exception("Monthly limit exceeded for this beneficiary");
    }

    double totalMonthly = 0;

    for (var t in transactions) {
      totalMonthly += t.amount;
    }

    if (totalMonthly + amount > 3000) {
      throw Exception("Total monthly limit exceeded");
    }

    await repository.topup(beneficiaryId: beneficiaryId, amount: amount);
  }
}
