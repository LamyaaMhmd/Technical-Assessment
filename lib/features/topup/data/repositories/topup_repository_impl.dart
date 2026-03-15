import '../../domain/entities/user.dart';
import '../../domain/entities/beneficiary.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/topup_repository.dart';

import '../datasources/topup_remote_datasource.dart';

class TopupRepositoryImpl implements TopupRepository {
  final TopupRemoteDatasource remoteDatasource;

  TopupRepositoryImpl(this.remoteDatasource);

  @override
  Future<User> getUser() async {
    return await remoteDatasource.getUser();
  }

  @override
  Future<List<Beneficiary>> getBeneficiaries() async {
    return await remoteDatasource.getBeneficiaries();
  }

  @override
  Future<void> addBeneficiary(String nickname, String phone) async {
    await remoteDatasource.addBeneficiary(nickname, phone);
  }

  @override
  Future<void> topup({
    required String beneficiaryId,
    required double amount,
  }) async {
    await remoteDatasource.topup(beneficiaryId, amount);
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    return await remoteDatasource.getTransactions();
  }
}
