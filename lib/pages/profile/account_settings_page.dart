import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/providers/profile_provider.dart';

import 'package:siresep/pages/profile/change_email_page.dart';
import 'package:siresep/pages/profile/change_name_page.dart';
import 'package:siresep/pages/profile/change_password_page.dart';
import 'package:siresep/pages/profile/change_profile_photo_page.dart';

class AccountSettingsPage
    extends StatelessWidget {
  const AccountSettingsPage({
    super.key,
  });

  Future<void>
  _openChangeNamePage(
      BuildContext context,
      String currentName,
      ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ChangeNamePage(
          initialName:
          currentName,
        ),
      ),
    );
  }

  Future<void>
  _openChangeEmailPage(
      BuildContext context,
      String currentEmail,
      ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ChangeEmailPage(
          initialEmail:
          currentEmail,
        ),
      ),
    );
  }

  Future<void>
  _openChangePasswordPage(
      BuildContext context,
      ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
        const ChangePasswordPage(),
      ),
    );
  }

  Future<void>
  _openChangePhotoPage(
      BuildContext context,
      String currentPhoto,
      ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
            ChangeProfilePhotoPage(
              initialImageUrl:
              currentPhoto,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<
        ProfileProvider
    >();

    final user = provider.user;

    if (provider.isLoading ||
        user == null) {
      return const Scaffold(
        body: Center(
          child:
          CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
      AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
        Colors.transparent,
        surfaceTintColor:
        Colors.transparent,
        leading: IconButton(
          onPressed:
              () =>
              Navigator.pop(
                context,
              ),
          icon: const Icon(
            Icons
                .arrow_back_ios_new,
            color:
            AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Account Settings',
          style: AppTextStyles.h2,
        ),
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(
          AppSizes.paddingL,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment
              .start,
          children: [
            _AccountProfileCard(
              name: user.name,
              email: user.email,
              imageUrl:
              user.photoUrl,
            ),

            const SizedBox(
              height:
              AppSizes.spaceXL,
            ),

            const Text(
              'Manage Account',
              style:
              AppTextStyles.h2,
            ),

            const SizedBox(
              height:
              AppSizes.spaceL,
            ),

            _AccountSettingTile(
              icon:
              Icons.badge_outlined,
              iconColor:
              AppColors.primary,
              title:
              'Change Name',
              subtitle:
              'Update your display name',
              onTap:
                  () =>
                  _openChangeNamePage(
                    context,
                    user.name,
                  ),
            ),

            const SizedBox(
              height:
              AppSizes.spaceM,
            ),

            _AccountSettingTile(
              icon: Icons
                  .photo_camera_outlined,
              iconColor:
              Colors.purple,
              title:
              'Change Profile Photo',
              subtitle:
              'Upload or replace your profile picture',
              onTap:
                  () =>
                  _openChangePhotoPage(
                    context,
                    user.photoUrl,
                  ),
            ),

            const SizedBox(
              height:
              AppSizes.spaceM,
            ),

            _AccountSettingTile(
              icon:
              Icons.email_outlined,
              iconColor:
              Colors.orange,
              title:
              'Change Email',
              subtitle:
              'Update the email linked to your account',
              onTap:
                  () =>
                  _openChangeEmailPage(
                    context,
                    user.email,
                  ),
            ),

            const SizedBox(
              height:
              AppSizes.spaceM,
            ),

            _AccountSettingTile(
              icon:
              Icons.lock_outline,
              iconColor:
              Colors.red,
              title:
              'Change Password',
              subtitle:
              'Keep your account secure',
              onTap:
                  () =>
                  _openChangePasswordPage(
                    context,
                  ),
            ),

            const SizedBox(
              height:
              AppSizes.spaceXL,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountProfileCard
    extends StatelessWidget {
  final String name;

  final String email;

  final String? imageUrl;

  const _AccountProfileCard({
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  bool get _hasImage {
    return imageUrl != null &&
        imageUrl!.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(
        AppSizes.paddingL,
      ),
      decoration:
      BoxDecoration(
        color: AppColors.card,
        borderRadius:
        BorderRadius.circular(
          AppSizes.radiusXL,
        ),
        boxShadow: const [
          BoxShadow(
            color:
            AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 104,
            width: 104,
            padding:
            const EdgeInsets.all(
              AppSizes.paddingXS,
            ),
            decoration:
            BoxDecoration(
              shape:
              BoxShape.circle,
              border: Border.all(
                color:
                AppColors.primary,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              backgroundColor:
              AppColors.background,
              backgroundImage:
              _hasImage
                  ? NetworkImage(
                imageUrl!,
              )
                  : null,
              child:
              !_hasImage
                  ? const Icon(
                Icons.person,
                size:
                AppSizes
                    .iconL,
                color: AppColors
                    .textSecondary,
              )
                  : null,
            ),
          ),

          const SizedBox(
            height:
            AppSizes.spaceL,
          ),

          Text(
            name,
            style:
            AppTextStyles.h1,
            textAlign:
            TextAlign.center,
          ),

          const SizedBox(
            height:
            AppSizes.spaceS,
          ),

          Text(
            email,
            style:
            AppTextStyles
                .bodySecondary,
            textAlign:
            TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AccountSettingTile
    extends StatelessWidget {
  final IconData icon;

  final Color iconColor;

  final String title;

  final String subtitle;

  final VoidCallback onTap;

  const _AccountSettingTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius:
      BorderRadius.circular(
        AppSizes.radiusL,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(
          AppSizes.radiusL,
        ),
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(
            AppSizes.paddingL,
          ),
          decoration:
          BoxDecoration(
            borderRadius:
            BorderRadius.circular(
              AppSizes.radiusL,
            ),
            boxShadow: const [
              BoxShadow(
                color:
                AppColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration:
                BoxDecoration(
                  color: iconColor
                      .withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    AppSizes
                        .radiusM,
                  ),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size:
                  AppSizes.iconM,
                ),
              ),

              const SizedBox(
                width:
                AppSizes.spaceM,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      title,
                      style:
                      AppTextStyles
                          .h2,
                    ),

                    const SizedBox(
                      height:
                      AppSizes
                          .spaceXS,
                    ),

                    Text(
                      subtitle,
                      style:
                      AppTextStyles
                          .bodySecondary,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width:
                AppSizes.spaceS,
              ),

              const Icon(
                Icons.chevron_right,
                color: AppColors
                    .textSecondary,
                size:
                AppSizes.iconM,
              ),
            ],
          ),
        ),
      ),
    );
  }
}