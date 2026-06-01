import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siresep/app/routes.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_strings.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/core/utils/validators.dart';
import 'package:siresep/core/widgets/custom_text_field.dart';
import 'package:siresep/core/widgets/primary_button.dart';
import 'package:siresep/providers/auth_provider.dart';
import 'package:siresep/providers/profile_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await context.read<ProfileProvider>().loadProfile();

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, AppRoutes.main);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login gagal: ${authProvider.errorMessage ?? e}'),
        ),
      );
    }
  }

  void _goToRegisterPage() {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.card,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 380,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=1200&auto=format&fit=crop',
                      fit: BoxFit.cover,
                    ),
                    Container(color: Colors.black.withValues(alpha: 0.10)),
                    Center(
                      child: Text(
                        AppStrings.appName,
                        style: AppTextStyles.h1.copyWith(
                          color: Colors.white,
                          fontSize: 54,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.paddingXL,
                  AppSizes.paddingXL,
                  AppSizes.paddingXL,
                  AppSizes.paddingL,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: AppStrings.email,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: AppSizes.spaceM),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: AppStrings.password,
                        obscureText: _obscurePassword,
                        validator: Validators.validatePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceL),
                      PrimaryButton(
                        text: authProvider.isLoading
                            ? 'LOADING...'
                            : AppStrings.login.toUpperCase(),
                        onPressed: authProvider.isLoading ? null : _login,
                        backgroundColor: AppColors.secondary,
                      ),
                      const SizedBox(height: AppSizes.spaceM),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style: AppTextStyles.bodySecondary,
                          ),
                          GestureDetector(
                            onTap: _goToRegisterPage,
                            child: Text(
                              'Sign up',
                              style: AppTextStyles.bodySecondary.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
