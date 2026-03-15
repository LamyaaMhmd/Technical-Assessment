import 'package:flutter/material.dart';

class AddBeneficiaryActions extends StatelessWidget {
  final Function({required BuildContext context}) onSubmit;

  const AddBeneficiaryActions({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => onSubmit(context: context),
        child: const Text("Add"),
      ),
    );
  }
}
