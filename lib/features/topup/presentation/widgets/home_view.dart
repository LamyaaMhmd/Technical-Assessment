import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/shared_snackbar.dart';
import '../bloc/topup_bloc.dart';
import '../bloc/topup_state.dart';
import 'add_beneficiary_button.dart';
import 'add_beneficiary_dialog/add_beneficiary_dialog.dart';
import 'balance_header/balance_header_widget.dart';
import 'beneficiaries_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Top Up")),
      body: SafeArea(
        child: BlocListener<TopupBloc, TopupState>(
          listenWhen: (previous, current) =>
              current is TopupError ||
              current is BeneficiaryLimitReached ||
              current is CanAddBeneficiary ||
              current is TopupSuccess,
          listener: (context, state) {
            if (state is TopupError) {
              SharedSnackBar.showError(context, state.message);
            } else if (state is BeneficiaryLimitReached) {
              SharedSnackBar.showError(
                context,
                "You cannot add more than 5 beneficiaries.",
              );
            } else if (state is CanAddBeneficiary) {
              AddBeneficiaryDialog.show(context);
            } else if (state is TopupSuccess) {
              SharedSnackBar.showSuccess(
                context,
                'Balance updated successfully',
              );
            }
          },
          child: Column(
            children: [
              BalanceHeaderWidget(),
              BeneficiariesList(),
              const AddBeneficiaryButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
