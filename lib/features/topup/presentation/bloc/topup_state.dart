import '../../domain/entities/user.dart';
import '../../domain/entities/beneficiary.dart';

abstract class TopupState {}

class TopupInitial extends TopupState {}

class TopupLoading extends TopupState {}

class TopupLoaded extends TopupState {
  final User user;
  final List<Beneficiary> beneficiaries;

  TopupLoaded({required this.user, required this.beneficiaries});
}

class TopupError extends TopupState {
  final String message;

  TopupError(this.message);
}

class BeneficiaryLimitReached extends TopupState {}

class CanAddBeneficiary extends TopupState {}

class TopupSuccess extends TopupState {
  final double balance;
  TopupSuccess({required this.balance});
}
