import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/topup_bloc.dart';
import '../bloc/topup_state.dart';
import 'beneficiary_card.dart';
import 'topup_options_sheet.dart';

class BeneficiariesList extends StatelessWidget {
  const BeneficiariesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<TopupBloc, TopupState>(
        buildWhen: (previous, current) => current is TopupLoaded,

        builder: (context, state) {
          if (state is TopupLoaded) {
            return ListView.builder(
              itemCount: state.beneficiaries.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final beneficiary = state.beneficiaries[index];

                return BeneficiaryCard(
                  beneficiary: beneficiary,
                  onTap: () {
                    TopupOptionsSheet.show(context, beneficiary.id);
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
