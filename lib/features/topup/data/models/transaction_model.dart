import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required super.id,
    required super.beneficiaryId,
    required super.amount,
    required super.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      beneficiaryId: json['beneficiaryId'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "beneficiaryId": beneficiaryId,
      "amount": amount,
      "date": date.toIso8601String(),
    };
  }
}
