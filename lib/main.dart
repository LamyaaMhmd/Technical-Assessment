import 'package:flutter/material.dart';

import 'core/network/api_client.dart';
import 'features/topup/data/datasources/topup_remote_datasource_impl.dart';
import 'features/topup/data/repositories/topup_repository_impl.dart';
import 'features/topup/domain/repositories/topup_repository.dart';
import 'features/topup/presentation/pages/home_page.dart';

void main() {
  final apiClient = ApiClient();
  final datasource = TopupRemoteDatasourceImpl(apiClient: apiClient);

  final TopupRepository repository = TopupRepositoryImpl(datasource);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TopupRepository repository;

  const MyApp({required this.repository, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Top Up App',
      home: HomePage(repository: repository),
    );
  }
}
