import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  static const String _defaultName = 'User';
  static const String _defaultEmail = 'user@gmail.com';
  static const String? _profileImageUrl = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Account Settings'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AccountProfileCard(
              name: _defaultName,
              email: _defaultEmail,
              imageUrl: _profileImageUrl,
            ),
            const SizedBox(height: AppSizes.spaceL),
            const Text(
              'Manage Account',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: AppSizes.spaceM),
            const _AccountSettingTile(
              icon: Icons.badge_outlined,
              title: 'Change Name',
              subtitle: 'Update your display name',
            ),
            const SizedBox(height: AppSizes.spaceM),
            const _AccountSettingTile(
              icon: Icons.photo_camera_outlined,
              title: 'Change Profile Photo',
              subtitle: 'Upload or replace your profile picture',
            ),
            const SizedBox(height: AppSizes.spaceM),
            const _AccountSettingTile(
              icon: Icons.email_outlined,
              title: 'Change Email',
              subtitle: 'Update the email linked to your account',
            ),
            const SizedBox(height: AppSizes.spaceM),
            const _AccountSettingTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Keep your account secure',
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;

  const _AccountProfileCard({
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  bool get _hasImage {
    return imageUrl != null && imageUrl!.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.inputBg,
            backgroundImage: _hasImage ? NetworkImage(imageUrl!) : null,
            child: !_hasImage
                ? const Icon(
              Icons.person,
              color: AppColors.textSecondary,
              size: AppSizes.iconL,
            )
                : null,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            name,
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            email,
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AccountSettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AccountSettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppSizes.iconM,
            ),
          ),
          const SizedBox(width: AppSizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceXS),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: AppSizes.iconM,
          ),
        ],
      ),
    );
  }
}