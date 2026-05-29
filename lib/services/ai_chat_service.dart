import 'package:siresep/models/chat_message_model.dart';

import 'package:siresep/services/ai_recipe_service.dart';

class AiChatService {
  final AiRecipeService
  _aiRecipeService =
  AiRecipeService();

  Future<List<ChatMessageModel>>
  loadInitialMessages() async {
    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    return [
      ChatMessageModel(
        id: 'welcome_message',
        userId: 'system',
        chatSessionId:
        'default_session',
        isUser: false,
        message:
        'Halo! Saya AI Recipe Assistant SiResep. Sebutkan bahan makanan yang kamu punya, nanti saya bantu rekomendasikan resep yang bisa kamu masak.',
        createdAt:
        DateTime.now(),
      ),
    ];
  }

  Future<ChatMessageModel>
  generateAiResponse({
    required String userId,
    required String sessionId,
    required String prompt,
  }) async {
    final aiResponse =
    await _aiRecipeService
        .generateRecipeRecommendation(
      prompt,
    );

    return ChatMessageModel(
      id:
      DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      userId: userId,
      chatSessionId:
      sessionId,
      isUser: false,
      message: aiResponse,
      createdAt:
      DateTime.now(),
    );
  }

  Future<void> saveMessage(
      ChatMessageModel message,
      ) async {
    await Future.delayed(
      const Duration(milliseconds: 150),
    );

    // TODO:
    // Save chat message to Firestore
  }

  Future<void> clearChatHistory(
      String sessionId,
      ) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    // TODO:
    // Delete session messages from Firestore
  }
}