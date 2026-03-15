import '../../domain/entities/beneficiary.dart';

class BeneficiaryModel extends Beneficiary {
  BeneficiaryModel({
    required super.id,
    required super.nickname,
    required super.phoneNumber,
    required super.monthlyUsed,
  });

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      id: json['id'],
      nickname: json['nickname'],
      phoneNumber: json['phoneNumber'],
      monthlyUsed: json['monthlyUsed'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nickname": nickname,
      "phoneNumber": phoneNumber,
      "monthlyUsed": monthlyUsed,
    };
  }
}
