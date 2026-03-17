import 'dart:math';
import 'package:dio/dio.dart';

import 'handlers/user_handler.dart';
import 'handlers/beneficiary_handler.dart';
import 'handlers/transaction_handler.dart';
import 'handlers/topup_handler.dart';

class MockInterceptor extends Interceptor {
  final _userHandler = UserHandler();
  final _beneficiaryHandler = BeneficiaryHandler();
  final _transactionHandler = TransactionHandler();
  final _topupHandler = TopupHandler();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future.delayed(Duration(milliseconds: 200 + Random().nextInt(400)));

    try {
      final response = _route(options);
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: response['statusCode'] as int,
          data: response['data'],
        ),
      );
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          message: e.toString(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: options,
            statusCode: 400,
            data: {'error': e.toString()},
          ),
        ),
      );
    }
  }

  Map<String, dynamic> _route(RequestOptions options) {
    final path = options.path;
    final method = options.method.toUpperCase();

    if (method == 'GET' && path == '/user') {
      return _userHandler.getUser();
    }
    if (method == 'GET' && path == '/beneficiaries') {
      return _beneficiaryHandler.getBeneficiaries();
    }
    if (method == 'POST' && path == '/beneficiaries') {
      return _beneficiaryHandler.addBeneficiary(options);
    }
    if (method == 'GET' && path == '/transactions') {
      return _transactionHandler.getTransactions();
    }
    if (method == 'POST' && path == '/topup') {
      return _topupHandler.topup(options);
    }

    throw Exception('Endpoint not found: $method $path');
  }
}
