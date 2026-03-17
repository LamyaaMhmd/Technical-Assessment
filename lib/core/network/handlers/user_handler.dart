import '../mock_database.dart';

class UserHandler {
  final MockDatabase _db = MockDatabase.instance;

  Map<String, dynamic> getUser() {
    return {'statusCode': 200, 'data': _db.user};
  }
}
