import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:siresep/models/chat_message_model.dart';
import 'package:siresep/services/ai_chat_service.dart';

class AiChatProvider extends ChangeNotifier {
  final AiChatService _service = AiChatService();

  final TextEditingController messageController =
  TextEditingController();

  final List<String> ingredientSuggestions = [
    'Eggs',
    'Rice',
    'Onions',
    'Chicken',
    'Chilli',
    'Tomato',
    'Bread',
    'Avocado',
  ];

  List<ChatMessageModel> _messages = [];

  bool _isTyping = false;

  bool _isLoading = false;

  List<ChatMessageModel> get messages =>
      _messages;

  bool get isTyping => _isTyping;

  bool get isLoading => _isLoading;

  String get _userId =>
      FirebaseAuth.instance.currentUser?.uid ??
          '';

  String get _sessionId =>
      'default_session';

  Future<void> initializeChat() async {
    if (_messages.isNotEmpty) {
      return;
    }

    _isLoading = true;

    notifyListeners();

    try {
      final history =
      await _service.loadChatHistory(
        userId: _userId,
        sessionId: _sessionId,
      );

      if (history.isNotEmpty) {
        _messages = history;
      } else {
        _messages =
        await _service.loadInitialMessages();
      }
    } catch (e) {
      debugPrint(
        'CHAT INIT ERROR: $e',
      );

      _messages =
      await _service.loadInitialMessages();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  void addIngredientToInput(
      String ingredient,
      ) {
    final currentText =
    messageController.text.trim();

    if (currentText.isEmpty) {
      messageController.text =
          ingredient;
    } else {
      messageController.text =
      '$currentText, $ingredient';
    }

    messageController.selection =
        TextSelection.fromPosition(
          TextPosition(
            offset:
            messageController.text.length,
          ),
        );

    notifyListeners();
  }

  Future<void> sendMessage() async {
    final text =
    messageController.text.trim();

    if (text.isEmpty || _isTyping) {
      return;
    }

    final userMessage =
    ChatMessageModel(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      userId: _userId,
      chatSessionId:
      _sessionId,
      isUser: true,
      message: text,
      createdAt: DateTime.now(),
    );

    _messages.add(userMessage);

    messageController.clear();

    _isTyping = true;

    notifyListeners();

    try {
      await _service.saveMessage(
        userMessage,
      );

      final aiMessage =
      await _service.generateAiResponse(
        userId: _userId,
        sessionId: _sessionId,
        prompt: text,
      );

      _messages.add(aiMessage);

      await _service.saveMessage(
        aiMessage,
      );
    } catch (e) {
      debugPrint(
        'SEND MESSAGE ERROR: $e',
      );
    } finally {
      _isTyping = false;

      notifyListeners();
    }
  }

  Future<void> clearChat() async {
    try {
      await _service.clearChatHistory(
        userId: _userId,
        sessionId: _sessionId,
      );

      _messages =
      await _service.loadInitialMessages();

      notifyListeners();
    } catch (e) {
      debugPrint(
        'CLEAR CHAT ERROR: $e',
      );
    }
  }

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }
}