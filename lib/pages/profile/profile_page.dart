import 'package:flutter/material.dart';
import 'package:siresep/app/routes.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_strings.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const String _defaultName = 'User';
  static const String _defaultEmail = 'user@gmail.com';

  // Nanti tinggal diganti dari Firebase/Auth
  static const String? _profileImageUrl = null;

  void _goBackToHome(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void _goToAccountSettings(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.accountSettings);
  }

  void _handleLogout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _ProfileHeader(
                name: _defaultName,
                email: _defaultEmail,
                imageUrl: _profileImageUrl,
                onBackTap: () => _goBackToHome(context),
              ),
              Transform.translate(
                offset: const Offset(0, -AppSizes.spaceXL),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingL,
                  ),
                  child: Column(
                    children: [
                      const _StatsCard(),
                      const SizedBox(height: AppSizes.spaceL),
                      _ProfileMenuTile(
                        icon: Icons.person_outline,
                        title: 'Account Settings',
                        subtitle:
                        'Manage your profile, email, and password',
                        onTap: () => _goToAccountSettings(context),
                      ),
                      const SizedBox(height: AppSizes.spaceM),
                      _LogoutButton(
                        onTap: () => _handleLogout(context),
                      ),
                      const SizedBox(height: AppSizes.spaceL),
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

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;
  final VoidCallback onBackTap;

  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingL,
        AppSizes.paddingM,
        AppSizes.paddingL,
        AppSizes.paddingXL + 60,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.radiusXL),
          bottomRight: Radius.circular(AppSizes.radiusXL),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onBackTap,
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: AppSizes.iconM,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceM),
          _ProfileAvatar(imageUrl: imageUrl),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            name,
            style: AppTextStyles.h1.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            email,
            style: AppTextStyles.body.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? imageUrl;

  const _ProfileAvatar({
    required this.imageUrl,
  });

  bool get _hasImage {
    return imageUrl != null && imageUrl!.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      width: 104,
      padding: const EdgeInsets.all(AppSizes.paddingXS),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: _hasImage ? NetworkImage(imageUrl!) : null,
        child: !_hasImage
            ? const Icon(
          Icons.person,
          size: AppSizes.iconL,
          color: AppColors.textSecondary,
        )
            : null,
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

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
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Your Stats',
            style: AppTextStyles.h2,
          ),
          SizedBox(height: AppSizes.spaceM),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.favorite_border,
                  iconColor: AppColors.error,
                  value: '0',
                  label: 'Saved Recipes',
                ),
              ),
              SizedBox(width: AppSizes.spaceM),
              Expanded(
                child: _StatItem(
                  icon: Icons.calendar_today_outlined,
                  iconColor: Colors.blue,
                  value: '0',
                  label: 'Planned Meals',
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceM),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.shopping_cart_outlined,
                  iconColor: AppColors.success,
                  value: '0',
                  label: 'Shopping Items',
                ),
              ),
              SizedBox(width: AppSizes.spaceM),
              Expanded(
                child: _StatItem(
                  icon: Icons.star_border,
                  iconColor: AppColors.warning,
                  value: '0',
                  label: 'Reviews',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingL,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: AppSizes.iconM,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            value,
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            label,
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
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
                child: const Icon(
                  Icons.person_outline,
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
                      style: AppTextStyles.h2,
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
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingL,
            vertical: AppSizes.paddingL,
          ),
          decoration: BoxDecoration(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout,
                color: AppColors.error,
                size: AppSizes.iconM,
              ),
              const SizedBox(width: AppSizes.spaceS),
              Text(
                AppStrings.logout,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}