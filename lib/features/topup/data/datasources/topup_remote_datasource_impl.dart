import '../../../../core/network/api_client.dart';
import '../models/beneficiary_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import 'topup_remote_datasource.dart';

class TopupRemoteDatasourceImpl implements TopupRemoteDatasource {
  final ApiClient apiClient;

  TopupRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<UserModel> getUser() async {
    final json = await apiClient.get('/user');
    return UserModel.fromJson(json as Map<String, dynamic>);
  }

  @override
  Future<List<BeneficiaryModel>> getBeneficiaries() async {
    final json = await apiClient.get('/beneficiaries');
    return (json as List)
        .map((e) => BeneficiaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addBeneficiary(String nickname, String phone) async {
    await apiClient.post('/beneficiaries', {
      'nickname': nickname,
      'phoneNumber': phone,
    });
  }

  @override
  Future<void> topup(String beneficiaryId, double amount) async {
    await apiClient.post('/topup', {
      'beneficiaryId': beneficiaryId,
      'amount': amount,
    });
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final json = await apiClient.get('/transactions');
    return (json as List)
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
