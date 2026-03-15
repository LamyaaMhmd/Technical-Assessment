import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.balance,
    required super.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      balance: json['balance'].toDouble(),
      isVerified: json['isVerified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "balance": balance, "isVerified": isVerified};
  }
}
