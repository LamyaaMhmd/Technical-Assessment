import 'package:flutter/material.dart';

import '../../../../core/utils/app_constants.dart';
import '../bloc/topup_bloc.dart';
import '../bloc/topup_event.dart';

class TopupOptions extends StatelessWidget {
  final String beneficiaryId;
  final TopupBloc bloc;
  const TopupOptions({
    super.key,
    required this.beneficiaryId,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: AppConstants.topupOptions.length,
      itemBuilder: (context, index) {
        final amount = AppConstants.topupOptions[index];

        return ElevatedButton(
          onPressed: () {
            bloc.add(
              TopupEventRequested(beneficiaryId: beneficiaryId, amount: amount),
            );

            Navigator.pop(context);
          },
          child: Text("AED $amount"),
        );
      },
    );
  }
}
