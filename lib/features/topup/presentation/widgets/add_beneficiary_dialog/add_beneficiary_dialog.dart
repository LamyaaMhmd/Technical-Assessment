import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/topup_bloc.dart';
import 'add_beneficiary_dialog_content.dart';

class AddBeneficiaryDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<TopupBloc>(),
          child: AddBeneficiaryDialogContent(),
        );
      },
    );
  }
}
