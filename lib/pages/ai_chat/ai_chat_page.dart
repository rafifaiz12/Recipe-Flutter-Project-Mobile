import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/pages/ai_chat/widgets/chat_bubble.dart';
import 'package:siresep/pages/ai_chat/widgets/ingredient_suggestion_chip.dart';

import 'package:siresep/providers/ai_chat_provider.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() =>
      _AiChatPageState();
}

class _AiChatPageState
    extends State<AiChatPage> {
  final ScrollController
  _scrollController =
  ScrollController();

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) {
      return;
    }

    Future.microtask(() async {
      await context
          .read<AiChatProvider>()
          .initializeChat();

      _scrollToBottom();
    });

    _isInitialized = true;
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(
      const Duration(
        milliseconds: 100,
      ),
          () {
        if (!_scrollController
            .hasClients) {
          return;
        }

        _scrollController.animateTo(
          _scrollController
              .position
              .maxScrollExtent,
          duration:
          const Duration(
            milliseconds: 300,
          ),
          curve: Curves.easeOut,
        );
      },
    );
  }

  Future<void> _sendMessage()
  async {
    final provider =
    context.read<
        AiChatProvider
    >();

    await provider.sendMessage();

    if (!mounted) {
      return;
    }

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<
        AiChatProvider
    >();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.messages.isNotEmpty) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor:
      AppColors.background,
      appBar: AppBar(
        title: const Text(
          'AI Recipe Assistant',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
            ),
            onPressed: () async {
              await provider.clearChat();
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : Column(
        children: [
          Container(
            width:
            double.infinity,
            margin:
            const EdgeInsets.fromLTRB(
              AppSizes.paddingL,
              AppSizes.paddingM,
              AppSizes.paddingL,
              AppSizes.paddingS,
            ),
            padding:
            const EdgeInsets.all(
              AppSizes.paddingM,
            ),
            decoration:
            BoxDecoration(
              color: AppColors
                  .primary
                  .withValues(
                alpha: 0.10,
              ),
              borderRadius:
              BorderRadius.circular(
                AppSizes
                    .radiusL,
              ),
              border:
              Border.all(
                color: AppColors
                    .primary
                    .withValues(
                  alpha: 0.20,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration:
                  const BoxDecoration(
                    color:
                    AppColors
                        .primary,
                    shape:
                    BoxShape
                        .circle,
                  ),
                  child:
                  const Icon(
                    Icons
                        .auto_awesome,
                    color:
                    Colors
                        .white,
                    size: 22,
                  ),
                ),

                const SizedBox(
                  width:
                  AppSizes
                      .spaceM,
                ),

                Expanded(
                  child: Text(
                    'Add the available ingredients, example: eggs, rice, onions, chilies.',
                    style:
                    AppTextStyles
                        .bodySecondary
                        .copyWith(
                      color:
                      AppColors
                          .textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 42,
            child:
            ListView.separated(
              padding:
              const EdgeInsets.symmetric(
                horizontal:
                AppSizes
                    .paddingL,
              ),
              scrollDirection:
              Axis.horizontal,
              itemCount:
              provider
                  .ingredientSuggestions
                  .length,
              separatorBuilder:
                  (_, __) =>
              const SizedBox(
                width:
                AppSizes
                    .spaceS,
              ),
              itemBuilder:
                  (
                  context,
                  index,
                  ) {
                final ingredient =
                provider
                    .ingredientSuggestions[
                index];

                return IngredientSuggestionChip(
                  label:
                  ingredient,
                  onTap: provider.isTyping
                      ? null
                      : () {
                    provider.addIngredientToInput(
                      ingredient,
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(
            height:
            AppSizes
                .spaceS,
          ),

          Expanded(
            child:
            ListView.builder(
              controller:
              _scrollController,
              padding:
              const EdgeInsets.all(
                AppSizes
                    .paddingL,
              ),
              itemCount:
              provider
                  .messages
                  .length +
                  (provider
                      .isTyping
                      ? 1
                      : 0),
              itemBuilder:
                  (
                  context,
                  index,
                  ) {
                if (provider
                    .isTyping &&
                    index ==
                        provider
                            .messages
                            .length) {
                  return const _TypingBubble();
                }

                final message =
                provider
                    .messages[
                index];

                return ChatBubble(
                  message:
                  message,
                );
              },
            ),
          ),

          Container(
            padding:
            const EdgeInsets.fromLTRB(
              AppSizes.paddingL,
              AppSizes.paddingM,
              AppSizes.paddingL,
              AppSizes.paddingL,
            ),
            decoration:
            const BoxDecoration(
              color:
              Colors.white,
              border: Border(
                top: BorderSide(
                  color:
                  AppColors
                      .border,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child:
                  TextField(
                    controller:
                    provider
                        .messageController,
                    minLines: 1,
                    maxLines: 4,
                    enabled:
                    !provider
                        .isTyping,
                    decoration:
                    InputDecoration(
                      hintText:
                      'Tell the ingredients ypu have...',
                      hintStyle:
                      AppTextStyles
                          .bodySecondary,
                      fillColor:
                      AppColors
                          .inputBg,
                      filled:
                      true,
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal:
                        AppSizes.paddingM,
                        vertical:
                        AppSizes.paddingM,
                      ),
                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          AppSizes.radiusXL,
                        ),
                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                    onSubmitted:
                        (_) =>
                        _sendMessage(),
                  ),
                ),

                const SizedBox(
                  width:
                  AppSizes
                      .spaceS,
                ),

                GestureDetector(
                  onTap:
                  provider
                      .isTyping
                      ? null
                      : _sendMessage,
                  child:
                  Container(
                    height: 52,
                    width: 52,
                    decoration:
                    BoxDecoration(
                      color:
                      provider
                          .isTyping
                          ? AppColors
                          .textSecondary
                          : AppColors
                          .primary,
                      shape:
                      BoxShape
                          .circle,
                    ),
                    child:
                    const Icon(
                      Icons
                          .send_rounded,
                      color:
                      Colors
                          .white,
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

class _TypingBubble
    extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(
      BuildContext context,
      ) {
    return Align(
      alignment:
      Alignment.centerLeft,
      child: Container(
        margin:
        const EdgeInsets.only(
          bottom:
          AppSizes.spaceM,
        ),
        padding:
        const EdgeInsets.symmetric(
          horizontal:
          AppSizes.paddingM,
          vertical:
          AppSizes.paddingM,
        ),
        decoration:
        BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(
            AppSizes.radiusL,
          ),
          boxShadow: const [
            BoxShadow(
              color:
              AppColors.shadow,
              blurRadius: 8,
              offset:
              Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          'AI Assistant is typing...',
          style: AppTextStyles
              .bodySecondary,
        ),
      ),
    );
  }
}