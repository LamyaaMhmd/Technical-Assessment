import '../../../../core/utils/app_constants.dart';
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
      throw Exception('Insufficient balance');
    }

    final limit = user.isVerified ? 1000.0 : 500.0;
    if (beneficiary.monthlyUsed + amount > limit) {
      throw Exception('Monthly limit exceeded for this beneficiary');
    }

    final now = DateTime.now();
    final monthlyTransactions = transactions.where(
      (t) => t.date.year == now.year && t.date.month == now.month,
    );

    final totalMonthly = monthlyTransactions.fold(
      0.0,
      (sum, t) => sum + t.amount,
    );

    if (totalMonthly + amount > AppConstants.totalMonthlyLimit) {
      throw Exception('Total monthly limit of AED 3,000 exceeded');
    }

    await repository.topup(beneficiaryId: beneficiaryId, amount: amount);
  }
}
