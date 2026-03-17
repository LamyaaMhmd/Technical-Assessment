class MockDatabase {
  static final MockDatabase instance = MockDatabase._internal();
  MockDatabase._internal();

  Map<String, dynamic> user = {
    'id': '1',
    'balance': 5000.0,
    'isVerified': true,
  };

  final List<Map<String, dynamic>> beneficiaries = [];
  final List<Map<String, dynamic>> transactions = [];
}
