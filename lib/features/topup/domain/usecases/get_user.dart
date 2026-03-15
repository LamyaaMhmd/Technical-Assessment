import '../entities/user.dart';
import '../repositories/topup_repository.dart';

class GetUser {
  final TopupRepository repository;

  GetUser(this.repository);

  Future<User> call() async {
    return await repository.getUser();
  }
}
