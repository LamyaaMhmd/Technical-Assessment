import 'package:flutter/material.dart';
import '../../domain/entities/beneficiary.dart';

class BeneficiaryCard extends StatelessWidget {
  final Beneficiary beneficiary;
  final VoidCallback onTap;

  const BeneficiaryCard({
    super.key,
    required this.beneficiary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(beneficiary.nickname),
        subtitle: Text(beneficiary.phoneNumber),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
