import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:siresep/models/chat_message_model.dart';

import 'package:siresep/services/ai_recipe_service.dart';

class AiChatService {
  final AiRecipeService _aiRecipeService =
  AiRecipeService();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<List<ChatMessageModel>>
  loadInitialMessages() async {
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
      id: DateTime.now()
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
    await _firestore
        .collection('users')
        .doc(message.userId)
        .collection(
      'chat_sessions',
    )
        .doc(
      message.chatSessionId,
    )
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());
  }

  Future<List<ChatMessageModel>>
  loadChatHistory({
    required String userId,
    required String sessionId,
  }) async {
    final snapshot =
    await _firestore
        .collection('users')
        .doc(userId)
        .collection(
      'chat_sessions',
    )
        .doc(sessionId)
        .collection('messages')
        .orderBy(
      'createdAt',
      descending: false,
    )
        .get();

    return snapshot.docs
        .map(
          (doc) =>
          ChatMessageModel
              .fromMap(
            doc.data(),
          ),
    )
        .toList();
  }

  Future<void> clearChatHistory({
    required String userId,
    required String sessionId,
  }) async {
    final snapshot =
    await _firestore
        .collection('users')
        .doc(userId)
        .collection(
      'chat_sessions',
    )
        .doc(sessionId)
        .collection('messages')
        .get();

    final batch =
    _firestore.batch();

    for (final doc
    in snapshot.docs) {
      batch.delete(
        doc.reference,
      );
    }

    await batch.commit();
  }
}