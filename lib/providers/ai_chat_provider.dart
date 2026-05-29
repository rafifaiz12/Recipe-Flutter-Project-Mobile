import 'package:flutter/material.dart';

import 'package:siresep/models/chat_message_model.dart';

import 'package:siresep/services/ai_chat_service.dart';

class AiChatProvider
    extends ChangeNotifier {
  final AiChatService
  _service =
  AiChatService();

  final TextEditingController
  messageController =
  TextEditingController();

  final List<String>
  ingredientSuggestions = [
    'Telur',
    'Nasi',
    'Ayam',
    'Tahu',
    'Tempe',
    'Bawang',
    'Cabai',
    'Tomat',
  ];

  List<ChatMessageModel>
  _messages = [];

  bool _isTyping = false;

  bool _isLoading = false;

  final String _userId =
      'temporary_user';

  final String _sessionId =
      'default_session';

  List<ChatMessageModel>
  get messages => _messages;

  bool get isTyping => _isTyping;

  bool get isLoading => _isLoading;

  Future<void> initializeChat()
  async {
    if (_messages.isNotEmpty) {
      return;
    }

    _isLoading = true;

    notifyListeners();

    try {
      _messages =
      await _service
          .loadInitialMessages();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  void addIngredientToInput(
      String ingredient,
      ) {
    final currentText =
    messageController.text
        .trim();

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
            messageController
                .text
                .length,
          ),
        );

    notifyListeners();
  }

  Future<void> sendMessage()
  async {
    final text =
    messageController.text
        .trim();

    if (text.isEmpty ||
        _isTyping) {
      return;
    }

    final userMessage =
    ChatMessageModel(
      id:
      DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      userId: _userId,
      chatSessionId:
      _sessionId,
      isUser: true,
      message: text,
      createdAt:
      DateTime.now(),
    );

    _messages.add(userMessage);

    messageController.clear();

    _isTyping = true;

    notifyListeners();

    await _service.saveMessage(
      userMessage,
    );

    try {
      final aiMessage =
      await _service
          .generateAiResponse(
        userId: _userId,
        sessionId:
        _sessionId,
        prompt: text,
      );

      _messages.add(aiMessage);

      await _service.saveMessage(
        aiMessage,
      );
    } finally {
      _isTyping = false;

      notifyListeners();
    }
  }

  Future<void> clearChat()
  async {
    _messages = [];

    notifyListeners();

    await _service
        .clearChatHistory(
      _sessionId,
    );

    await initializeChat();
  }

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }
}