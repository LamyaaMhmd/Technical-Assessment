import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/topup_bloc.dart';
import '../../bloc/topup_state.dart';
import 'balance_header.dart';

class BalanceHeaderWidget extends StatelessWidget {
  const BalanceHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopupBloc, TopupState>(
      buildWhen: (previous, current) =>
          current is TopupSuccess || current is TopupLoaded,
      builder: (context, state) {
        if (state is TopupSuccess) {
          return BalanceHeader(balance: state.balance);
        }
        if (state is TopupLoaded) {
          return BalanceHeader(balance: state.user.balance);
        }
        return const SizedBox();
      },
    );
  }
}
