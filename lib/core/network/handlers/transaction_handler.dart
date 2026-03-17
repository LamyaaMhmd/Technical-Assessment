import '../mock_database.dart';

class TransactionHandler {
  final MockDatabase _db = MockDatabase.instance;

  Map<String, dynamic> getTransactions() {
    return {'statusCode': 200, 'data': _db.transactions};
  }
}
