import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/pages/profile/change_email_page.dart';
import 'package:siresep/pages/profile/change_name_page.dart';
import 'package:siresep/pages/profile/change_password_page.dart';
import 'package:siresep/pages/profile/change_profile_photo_page.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  String _name = 'User';
  String _email = 'user@gmail.com';
  String? _profileImageUrl;

  Future<void> _openChangeNamePage() async {
    final String? newName = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNamePage(
          initialName: _name,
        ),
      ),
    );

    if (newName == null || newName.trim().isEmpty) {
      return;
    }

    setState(() {
      _name = newName.trim();
    });
  }

  Future<void> _openChangeEmailPage() async {
    final String? newEmail = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeEmailPage(
          initialEmail: _email,
        ),
      ),
    );

    if (newEmail == null || newEmail.trim().isEmpty) {
      return;
    }

    setState(() {
      _email = newEmail.trim();
    });
  }

  Future<void> _openChangePasswordPage() async {
    final bool? isUpdated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ChangePasswordPage(),
      ),
    );

    if (isUpdated == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password berhasil diperbarui'),
        ),
      );
    }
  }

  Future<void> _openChangePhotoPage() async {
    final String? newPhotoUrl = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeProfilePhotoPage(
          initialImageUrl: _profileImageUrl,
        ),
      ),
    );

    if (newPhotoUrl == null) {
      return;
    }

    setState(() {
      _profileImageUrl = newPhotoUrl;
    });
  }

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
              name: _name,
              email: _email,
              imageUrl: _profileImageUrl,
            ),
            const SizedBox(height: AppSizes.spaceL),
            const Text(
              'Manage Account',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: AppSizes.spaceM),
            _AccountSettingTile(
              icon: Icons.badge_outlined,
              title: 'Change Name',
              subtitle: 'Update your display name',
              onTap: _openChangeNamePage,
            ),
            const SizedBox(height: AppSizes.spaceM),
            _AccountSettingTile(
              icon: Icons.photo_camera_outlined,
              title: 'Change Profile Photo',
              subtitle: 'Upload or replace your profile picture',
              onTap: _openChangePhotoPage,
            ),
            const SizedBox(height: AppSizes.spaceM),
            _AccountSettingTile(
              icon: Icons.email_outlined,
              title: 'Change Email',
              subtitle: 'Update the email linked to your account',
              onTap: _openChangeEmailPage,
            ),
            const SizedBox(height: AppSizes.spaceM),
            _AccountSettingTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Keep your account secure',
              onTap: _openChangePasswordPage,
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
  final VoidCallback onTap;

  const _AccountSettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      child: Container(
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
      ),
    );
  }
}