import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_constants.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/get_beneficiaries.dart';
import '../../domain/usecases/add_beneficiary.dart';
import '../../domain/usecases/topup_number.dart';

import 'topup_event.dart';
import 'topup_state.dart';

class TopupBloc extends Bloc<TopupEvent, TopupState> {
  final GetUser getUser;
  final GetBeneficiaries getBeneficiaries;
  final AddBeneficiary addBeneficiary;
  final TopupNumber topupNumber;

  TopupBloc({
    required this.getUser,
    required this.getBeneficiaries,
    required this.addBeneficiary,
    required this.topupNumber,
  }) : super(TopupInitial()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<AddBeneficiaryEvent>(_onAddBeneficiary);
    on<TopupEventRequested>(_onTopup);
    on<AddBeneficiaryPressed>(_onAddBeneficiaryPressed);
  }

  Future<void> _onLoadInitialData(
    LoadInitialData event,
    Emitter<TopupState> emit,
  ) async {
    try {
      emit(TopupLoading());
      final user = await getUser();
      final beneficiaries = await getBeneficiaries();
      emit(TopupLoaded(user: user, beneficiaries: beneficiaries));
    } catch (e) {
      emit(TopupError(e.toString()));
    }
  }

  Future<void> _onAddBeneficiary(
    AddBeneficiaryEvent event,
    Emitter<TopupState> emit,
  ) async {
    try {
      emit(TopupLoading());
      await addBeneficiary(nickname: event.nickname, phone: event.phone);
      final user = await getUser();
      final beneficiaries = await getBeneficiaries();
      emit(TopupLoaded(user: user, beneficiaries: beneficiaries));
    } catch (e) {
      emit(TopupError(e.toString()));
    }
  }

  Future<void> _onTopup(
    TopupEventRequested event,
    Emitter<TopupState> emit,
  ) async {
    try {
      emit(TopupLoading());
      await topupNumber(
        beneficiaryId: event.beneficiaryId,
        amount: event.amount,
      );
      final user = await getUser();
      emit(TopupSuccess(balance: user.balance));
    } catch (e) {
      emit(TopupError(e.toString()));
    }
  }

  Future<void> _onAddBeneficiaryPressed(
    AddBeneficiaryPressed event,
    Emitter<TopupState> emit,
  ) async {
    final currentState = state;
    if (currentState is TopupLoaded &&
        currentState.beneficiaries.length >= AppConstants.maxBeneficiaries) {
      emit(BeneficiaryLimitReached());
      return;
    }
    emit(CanAddBeneficiary());
  }
}
