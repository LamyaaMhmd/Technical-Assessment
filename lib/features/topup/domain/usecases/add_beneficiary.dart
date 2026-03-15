import '../repositories/topup_repository.dart';

class AddBeneficiary {
  final TopupRepository repository;

  AddBeneficiary(this.repository);

  Future<void> call({required String nickname, required String phone}) async {
    await repository.addBeneficiary(nickname, phone);
  }
}
