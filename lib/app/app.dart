import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siresep/providers/auth_provider.dart';
import 'package:siresep/app/routes.dart';
import 'package:siresep/app/theme.dart';

class SiResepApp extends StatelessWidget {
  const SiResepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp(
          title: 'SiResep',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routes: AppRoutes.routes,
          home: authProvider.isLoggedIn
              ? AppRoutes.routes[AppRoutes.main]!(context)
              : AppRoutes.routes[AppRoutes.login]!(context),
        );
      },
    );
  }
}
