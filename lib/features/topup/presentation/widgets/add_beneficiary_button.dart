import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/topup_bloc.dart';
import '../bloc/topup_event.dart';
import '../bloc/topup_state.dart';

class AddBeneficiaryButton extends StatelessWidget {
  const AddBeneficiaryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<TopupBloc, TopupState>(
        builder: (context, state) {
          return ElevatedButton(
            onPressed: () {
              context.read<TopupBloc>().add(AddBeneficiaryPressed());
            },
            child: state is TopupLoading
                ? const CircularProgressIndicator(padding: EdgeInsets.all(10))
                : const Text("Add Beneficiary"),
          );
        },
      ),
    );
  }
}
