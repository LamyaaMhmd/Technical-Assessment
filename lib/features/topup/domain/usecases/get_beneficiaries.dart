import '../entities/beneficiary.dart';
import '../repositories/topup_repository.dart';

class GetBeneficiaries {
  final TopupRepository repository;

  GetBeneficiaries(this.repository);

  Future<List<Beneficiary>> call() async {
    return await repository.getBeneficiaries();
  }
}
