import 'package:flutter/material.dart';

import '../../../../../core/utils/constants.dart' show AppConstants;

class AddBeneficiaryFields extends StatelessWidget {
  final TextEditingController nicknameController, phoneController;
  final Function({required BuildContext context}) onSubmit;
  const AddBeneficiaryFields({
    super.key,
    required this.nicknameController,
    required this.phoneController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: nicknameController,
          decoration: const InputDecoration(labelText: "Nickname"),
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value?.isEmpty == true) {
              return "Please enter a nickname";
            } else if ((value?.length ?? 0) >= AppConstants.nicknameMaxLength) {
              return "Nickname cannot exceed ${AppConstants.nicknameMaxLength} characters";
            }
            return null;
          },
        ),
        TextFormField(
          controller: phoneController,
          decoration: const InputDecoration(labelText: "Phone Number"),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value?.isEmpty == true) {
              return "Please enter a phone number";
            }
            return null;
          },
          onFieldSubmitted: (value) {
            onSubmit(context: context);
          },
        ),
      ],
    );
  }
}
