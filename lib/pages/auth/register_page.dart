import 'package:flutter/material.dart';
import 'package:siresep/app/routes.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_strings.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/core/utils/validators.dart';
import 'package:siresep/core/widgets/custom_text_field.dart';
import 'package:siresep/core/widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToMainPage() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    }
  }

  void _goToLoginPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                      'https://images.unsplash.com/photo-1490645935967-10de6ba17061?q=80&w=1200&auto=format&fit=crop',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black.withValues(alpha: 0.10),
                    ),
                    Center(
                      child: Text(
                        AppStrings.appName,
                        style: AppTextStyles.h1.copyWith(
                          color: Colors.white,
                          fontSize: 54,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          shadows: const [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
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
                        controller: _nameController,
                        hintText: AppStrings.fullName,
                        validator: (value) =>
                            Validators.validateRequired(value, 'Nama'),
                      ),
                      const SizedBox(height: AppSizes.spaceM),
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
                        text: AppStrings.register.toUpperCase(),
                        onPressed: _goToMainPage,
                        backgroundColor: AppColors.secondary,
                      ),
                      const SizedBox(height: AppSizes.spaceM),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: AppTextStyles.bodySecondary,
                          ),
                          GestureDetector(
                            onTap: _goToLoginPage,
                            child: Text(
                              'Login',
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