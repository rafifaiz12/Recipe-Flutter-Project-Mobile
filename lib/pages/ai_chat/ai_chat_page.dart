import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/pages/ai_chat/widgets/chat_bubble.dart';
import 'package:siresep/pages/ai_chat/widgets/ingredient_suggestion_chip.dart';
import 'package:siresep/services/ai_recipe_service.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiRecipeService _aiRecipeService = AiRecipeService();

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'message':
      'Halo! Saya AI Recipe Assistant SiResep. Sebutkan bahan makanan yang kamu punya, nanti saya bantu rekomendasikan resep yang bisa kamu masak.',
    },
  ];

  final List<String> _ingredientSuggestions = [
    'Telur',
    'Nasi',
    'Ayam',
    'Tahu',
    'Tempe',
    'Bawang',
    'Cabai',
    'Tomat',
  ];

  bool _isTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addIngredientToInput(String ingredient) {
    final currentText = _messageController.text.trim();

    if (currentText.isEmpty) {
      _messageController.text = ingredient;
    } else {
      _messageController.text = '$currentText, $ingredient';
    }

    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();

    if (text.isEmpty || _isTyping) {
      return;
    }

    setState(() {
      _messages.add({
        'isUser': true,
        'message': text,
      });
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    final aiResponse =
    await _aiRecipeService.generateRecipeRecommendation(text);

    if (!mounted) return;

    setState(() {
      _messages.add({
        'isUser': false,
        'message': aiResponse,
      });
      _isTyping = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Recipe Assistant'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(
              AppSizes.paddingL,
              AppSizes.paddingM,
              AppSizes.paddingL,
              AppSizes.paddingS,
            ),
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSizes.spaceM),
                Expanded(
                  child: Text(
                    'Masukkan bahan makanan yang tersedia, misalnya: telur, nasi, bawang, cabai.',
                    style: AppTextStyles.bodySecondary.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: _ingredientSuggestions.length,
              separatorBuilder: (_, __) =>
              const SizedBox(width: AppSizes.spaceS),
              itemBuilder: (context, index) {
                final ingredient = _ingredientSuggestions[index];

                return IngredientSuggestionChip(
                  label: ingredient,
                  onTap: () => _addIngredientToInput(ingredient),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSizes.paddingL),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return const _TypingBubble();
                }

                final message = _messages[index];

                return ChatBubble(
                  message: message['message'] as String,
                  isUser: message['isUser'] as bool,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingL,
              AppSizes.paddingM,
              AppSizes.paddingL,
              AppSizes.paddingL,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    minLines: 1,
                    maxLines: 4,
                    enabled: !_isTyping,
                    decoration: InputDecoration(
                      hintText: 'Tulis bahan yang kamu punya...',
                      hintStyle: AppTextStyles.bodySecondary,
                      fillColor: AppColors.inputBg,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM,
                        vertical: AppSizes.paddingM,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: AppSizes.spaceS),
                GestureDetector(
                  onTap: _isTyping ? null : _sendMessage,
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: _isTyping
                          ? AppColors.textSecondary
                          : AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingM,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          'AI sedang mengetik...',
          style: AppTextStyles.bodySecondary,
        ),
      ),
    );
  }
}