import 'package:flutter/material.dart';

import 'features/topup/data/datasources/topup_remote_datasource_impl.dart';
import 'features/topup/data/repositories/topup_repository_impl.dart';

import 'features/topup/presentation/pages/home_page.dart';

void main() {
  final datasource = TopupRemoteDatasourceImpl();
  final repository = TopupRepositoryImpl(datasource);

  runApp(MyApp(repository));
}

class MyApp extends StatelessWidget {
  final TopupRepositoryImpl repository;

  const MyApp(this.repository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Top Up App',
      home: HomePage(repository: repository),
    );
  }
}
