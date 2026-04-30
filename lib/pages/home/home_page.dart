import 'package:flutter/material.dart';
import 'package:siresep/app/routes.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/core/utils/dummy_data.dart';
import 'package:siresep/core/widgets/section_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _filteredRecipes = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _filteredRecipes = [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final query = value.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredRecipes = [];
        _showSuggestions = false;
      });
      return;
    }

    final results = DummyData.recipes.where((recipe) {
      final title = recipe['title'].toString().toLowerCase();
      return title.contains(query);
    }).toList();

    setState(() {
      _filteredRecipes = results;
      _showSuggestions = true;
    });
  }

  void _goToRecipeDetail(String recipeId) {
    _searchController.clear();

    setState(() {
      _showSuggestions = false;
      _filteredRecipes = [];
    });

    Navigator.pushNamed(
      context,
      AppRoutes.recipeDetail,
      arguments: recipeId,
    );
  }

  void _goToProfile() {
    Navigator.pushNamed(context, AppRoutes.profile);
  }

  void _goToAiChat() {
    Navigator.pushNamed(context, AppRoutes.aiChat);
  }

  @override
  Widget build(BuildContext context) {
    final trendingRecipes = DummyData.trendingRecipes;
    final recommendedRecipes = DummyData.recipes;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              _showSuggestions = false;
            });
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discover',
                            style: AppTextStyles.h1.copyWith(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: AppSizes.spaceS),
                          Text(
                            'Hi, What do you want to cook today?',
                            style: AppTextStyles.bodySecondary.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _goToProfile,
                      child: Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceL),

                // Search bar + suggestion dropdown
                Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      onTap: () {
                        if (_searchController.text.trim().isNotEmpty &&
                            _filteredRecipes.isNotEmpty) {
                          setState(() {
                            _showSuggestions = true;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Search recipes...',
                        hintStyle: AppTextStyles.bodySecondary.copyWith(
                          fontSize: 16,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(AppSizes.radiusXL),
                          borderSide: const BorderSide(
                            color: AppColors.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(AppSizes.radiusXL),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingM,
                          vertical: 18,
                        ),
                      ),
                    ),
                    if (_showSuggestions && _filteredRecipes.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: AppSizes.spaceS),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(AppSizes.radiusM),
                          border: Border.all(color: AppColors.border),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredRecipes.length > 5
                              ? 5
                              : _filteredRecipes.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            color: AppColors.border,
                          ),
                          itemBuilder: (context, index) {
                            final recipe = _filteredRecipes[index];

                            return ListTile(
                              title: Text(
                                recipe['title'],
                                style: AppTextStyles.body,
                              ),
                              subtitle: Text(
                                '${recipe['cookTimeMinutes']} min • ${recipe['difficulty']}',
                                style: AppTextStyles.caption,
                              ),
                              onTap: () => _goToRecipeDetail(recipe['id']),
                            );
                          },
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: AppSizes.spaceL),
                _AiRecipeAssistantCard(
                  onTap: _goToAiChat,
                ),

                const SizedBox(height: AppSizes.spaceXL),
                const SectionTitle(title: 'Trending Recipes'),
                const SizedBox(height: AppSizes.spaceM),

                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingRecipes.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSizes.spaceM),
                    itemBuilder: (context, index) {
                      final recipe = trendingRecipes[index];

                      return SizedBox(
                        width: 300,
                        child: _HorizontalRecipeCard(
                          title: recipe['title'],
                          imageUrl: recipe['imageUrl'],
                          time: recipe['cookTimeMinutes'].toString(),
                          difficulty: recipe['difficulty'],
                          rating: recipe['ratingAverage'].toString(),
                          onTap: () => _goToRecipeDetail(recipe['id']),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppSizes.spaceXL),
                const SectionTitle(title: 'Recommended For You'),
                const SizedBox(height: AppSizes.spaceM),

                Column(
                  children: recommendedRecipes.map((recipe) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.spaceM),
                      child: _VerticalRecipeCard(
                        title: recipe['title'],
                        imageUrl: recipe['imageUrl'],
                        time: recipe['cookTimeMinutes'].toString(),
                        difficulty: recipe['difficulty'],
                        rating: recipe['ratingAverage'].toString(),
                        onTap: () => _goToRecipeDetail(recipe['id']),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AiRecipeAssistantCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AiRecipeAssistantCard({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.paddingL),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
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
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ask AI Recipe',
                    style: AppTextStyles.h2.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceXS),
                  Text(
                    'Masukkan bahan yang tersedia dan dapatkan rekomendasi resep.',
                    style: AppTextStyles.bodySecondary.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalRecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String time;
  final String difficulty;
  final String rating;
  final VoidCallback onTap;

  const _HorizontalRecipeCard({
    required this.title,
    required this.imageUrl,
    required this.time,
    required this.difficulty,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusXL),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.65),
              ],
            ),
          ),
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$time min • $difficulty • ⭐ $rating',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppSizes.spaceS),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h2.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerticalRecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String time;
  final String difficulty;
  final String rating;
  final VoidCallback onTap;

  const _VerticalRecipeCard({
    required this.title,
    required this.imageUrl,
    required this.time,
    required this.difficulty,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusXL),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.65),
              ],
            ),
          ),
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$time min • $difficulty • ⭐ $rating',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppSizes.spaceS),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h2.copyWith(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}