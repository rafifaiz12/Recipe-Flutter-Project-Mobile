import 'package:flutter/material.dart';
import 'package:siresep/app/routes.dart';
import 'package:siresep/app/theme.dart';

class SiResepApp extends StatelessWidget {
  const SiResepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiResep',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}