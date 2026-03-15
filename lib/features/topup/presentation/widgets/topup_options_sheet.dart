import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/topup_bloc.dart';
import 'topup_options.dart';

class TopupOptionsSheet {
  static void show(BuildContext context, String beneficiaryId) {
    showModalBottomSheet(
      context: context,
      builder: (_) => TopupOptions(
        beneficiaryId: beneficiaryId,
        bloc: context.read<TopupBloc>(),
      ),
    );
  }
}
