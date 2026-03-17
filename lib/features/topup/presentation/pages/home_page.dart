import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/topup_repository.dart';
import '../../domain/usecases/add_beneficiary.dart';
import '../../domain/usecases/get_beneficiaries.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/topup_number.dart';
import '../bloc/topup_bloc.dart';
import '../bloc/topup_event.dart';
import '../widgets/home_view.dart';

class HomePage extends StatelessWidget {
  final TopupRepository repository;

  const HomePage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TopupBloc(
        getUser: GetUser(repository),
        getBeneficiaries: GetBeneficiaries(repository),
        addBeneficiary: AddBeneficiary(repository),
        topupNumber: TopupNumber(repository),
      )..add(LoadInitialData()),
      child: const HomeView(),
    );
  }
}
