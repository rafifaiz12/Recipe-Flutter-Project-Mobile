import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/core/widgets/custom_text_field.dart';

import 'package:siresep/providers/profile_provider.dart';

class ChangeEmailPage
    extends StatefulWidget {
  final String initialEmail;

  const ChangeEmailPage({
    super.key,
    required this.initialEmail,
  });

  @override
  State<ChangeEmailPage>
  createState() =>
      _ChangeEmailPageState();
}

class _ChangeEmailPageState
    extends State<
        ChangeEmailPage
    > {
  late final TextEditingController
  _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        TextEditingController(
          text: widget.initialEmail,
        );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Future<void> _onSave()
  async {
    final value =
    _controller.text.trim();

    if (value.isEmpty ||
        !value.contains('@') ||
        !value.contains('.')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Email tidak valid',
          ),
        ),
      );

      return;
    }

    final provider =
    context.read<
        ProfileProvider
    >();

    final success =
    await provider
        .changeEmail(
      value,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal mengubah email',
          ),
        ),
      );

      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<
        ProfileProvider
    >();

    return Scaffold(
      backgroundColor:
      AppColors.background,
      appBar: AppBar(
        leading: TextButton(
          onPressed:
          provider.isUpdating
              ? null
              : () =>
              Navigator.pop(
                context,
              ),
          child: Text(
            'Cancel',
            style:
            AppTextStyles
                .bodySecondary,
          ),
        ),
        title: Text(
          'Change Email',
          style:
          AppTextStyles.h2,
        ),
        actions: [
          TextButton(
            onPressed:
            provider.isUpdating
                ? null
                : _onSave,
            child:
            provider.isUpdating
                ? const SizedBox(
              height: 18,
              width: 18,
              child:
              CircularProgressIndicator(
                strokeWidth:
                2,
              ),
            )
                : Text(
              'Done',
              style:
              AppTextStyles
                  .smallBold
                  .copyWith(
                color:
                AppColors
                    .primary,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding:
        const EdgeInsets.all(
          AppSizes.paddingM,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment
              .start,
          children: [
            Text(
              'Email',
              style:
              AppTextStyles
                  .caption,
            ),

            const SizedBox(
              height:
              AppSizes.spaceS,
            ),

            CustomTextField(
              controller:
              _controller,
              hintText:
              'Masukkan email',
              keyboardType:
              TextInputType
                  .emailAddress,
            ),
          ],
        ),
      ),
    );
  }
}