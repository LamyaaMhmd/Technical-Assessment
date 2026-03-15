abstract class TopupEvent {}

class LoadInitialData extends TopupEvent {}

class AddBeneficiaryEvent extends TopupEvent {
  final String nickname;
  final String phone;

  AddBeneficiaryEvent({required this.nickname, required this.phone});
}

class TopupEventRequested extends TopupEvent {
  final String beneficiaryId;
  final double amount;

  TopupEventRequested({required this.beneficiaryId, required this.amount});
}

class AddBeneficiaryPressed extends TopupEvent {}
