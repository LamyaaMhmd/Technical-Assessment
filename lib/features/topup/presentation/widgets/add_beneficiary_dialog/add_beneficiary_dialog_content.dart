import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/topup_bloc.dart';
import '../../bloc/topup_event.dart';
import 'add_beneficiary_fields.dart';
import 'add_beneficiary_actions.dart';

class AddBeneficiaryDialogContent extends StatelessWidget {
  AddBeneficiaryDialogContent({super.key});

  final nicknameController = TextEditingController();
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void onSubmit({required BuildContext context}) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.read<TopupBloc>().add(
      AddBeneficiaryEvent(
        nickname: nicknameController.text,
        phone: phoneController.text,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Beneficiary"),
      content: Form(
        key: _formKey,

        child: AddBeneficiaryFields(
          nicknameController: nicknameController,
          phoneController: phoneController,
          onSubmit: onSubmit,
        ),
      ),
      actions: [AddBeneficiaryActions(onSubmit: onSubmit)],
    );
  }
}
