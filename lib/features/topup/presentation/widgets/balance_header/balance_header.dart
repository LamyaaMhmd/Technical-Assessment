import 'package:flutter/material.dart';

class BalanceHeader extends StatelessWidget {
  final double balance;

  const BalanceHeader({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        "Balance: AED $balance",
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
