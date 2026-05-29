import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/providers/profile_provider.dart';

class ChangeProfilePhotoPage extends StatefulWidget {
  final String? initialImageUrl;

  const ChangeProfilePhotoPage({
    super.key,
    this.initialImageUrl,
  });

  @override
  State<ChangeProfilePhotoPage> createState() =>
      _ChangeProfilePhotoPageState();
}

class _ChangeProfilePhotoPageState
    extends State<ChangeProfilePhotoPage> {
  final List<String> _photoOptions = [
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=400&q=80',
  ];

  String? _selectedImageUrl;

  @override
  void initState() {
    super.initState();

    _selectedImageUrl =
        widget.initialImageUrl;
  }

  Future<void> _onSave() async {
    if (_selectedImageUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Pilih foto terlebih dahulu',
          ),
        ),
      );

      return;
    }

    final provider =
    context.read<
        ProfileProvider>();

    final success =
    await provider
        .changeProfilePhotoUrl(
      _selectedImageUrl!,
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
            'Gagal mengubah foto profil',
          ),
        ),
      );

      return;
    }

    Navigator.pop(
      context,
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<
        ProfileProvider>();

    return Scaffold(
      backgroundColor:
      AppColors.background,
      appBar: AppBar(
        leading: TextButton(
          onPressed:
          provider.isUpdating
              ? null
              : () {
            Navigator.pop(
              context,
            );
          },
          child: Text(
            'Cancel',
            style:
            AppTextStyles
                .bodySecondary,
          ),
        ),
        title: Text(
          'Change Photo',
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
          AppSizes.paddingL,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 56,
              backgroundColor:
              AppColors.inputBg,
              backgroundImage:
              _selectedImageUrl !=
                  null
                  ? NetworkImage(
                _selectedImageUrl!,
              )
                  : null,
              child:
              _selectedImageUrl ==
                  null
                  ? const Icon(
                Icons.person,
                size: 52,
                color: AppColors
                    .textSecondary,
              )
                  : null,
            ),
            const SizedBox(
              height:
              AppSizes.spaceL,
            ),
            Text(
              'Choose Profile Photo',
              style:
              AppTextStyles.h2,
            ),
            const SizedBox(
              height:
              AppSizes.spaceS,
            ),
            Text(
              'Pilih foto profil untuk akun Anda.',
              textAlign:
              TextAlign.center,
              style:
              AppTextStyles
                  .bodySecondary,
            ),
            const SizedBox(
              height:
              AppSizes.spaceXL,
            ),
            Expanded(
              child:
              GridView.builder(
                itemCount:
                _photoOptions
                    .length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                  2,
                  crossAxisSpacing:
                  AppSizes
                      .spaceM,
                  mainAxisSpacing:
                  AppSizes
                      .spaceM,
                  childAspectRatio:
                  1,
                ),
                itemBuilder:
                    (
                    context,
                    index,
                    ) {
                  final imageUrl =
                  _photoOptions[
                  index];

                  final isSelected =
                      _selectedImageUrl ==
                          imageUrl;

                  return GestureDetector(
                    onTap: () {
                      setState(
                            () {
                          _selectedImageUrl =
                              imageUrl;
                        },
                      );
                    },
                    child:
                    Container(
                      decoration:
                      BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(
                          AppSizes
                              .radiusL,
                        ),
                        border:
                        Border.all(
                          color:
                          isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width:
                          isSelected
                              ? 2
                              : 1,
                        ),
                        image:
                        DecorationImage(
                          image:
                          NetworkImage(
                            imageUrl,
                          ),
                          fit: BoxFit
                              .cover,
                        ),
                      ),
                      child:
                      isSelected
                          ? Align(
                        alignment:
                        Alignment.topRight,
                        child:
                        Container(
                          margin:
                          const EdgeInsets.all(
                            AppSizes.paddingS,
                          ),
                          padding:
                          const EdgeInsets.all(
                            AppSizes.paddingXS,
                          ),
                          decoration:
                          const BoxDecoration(
                            color:
                            AppColors.primary,
                            shape:
                            BoxShape.circle,
                          ),
                          child:
                          const Icon(
                            Icons.check,
                            color:
                            Colors.white,
                            size:
                            AppSizes.iconS,
                          ),
                        ),
                      )
                          : const SizedBox(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}