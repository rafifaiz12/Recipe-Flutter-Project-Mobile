import 'package:siresep/core/utils/model_parsers.dart';

class ChatMessageModel {
  final String id;

  final String userId;

  final String chatSessionId;

  final bool isUser;

  final String message;

  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.userId,
    required this.chatSessionId,
    required this.isUser,
    required this.message,
    required this.createdAt,
  });

  factory ChatMessageModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return ChatMessageModel(
      id:
      map['id']
          ?.toString() ??
          '',

      userId:
      map['userId']
          ?.toString() ??
          '',

      chatSessionId:
      map['chatSessionId']
          ?.toString() ??
          '',

      isUser:
      map['isUser'] == true,

      message:
      map['message']
          ?.toString() ??
          '',

      createdAt:
      ModelParsers.parseDateTime(
        map['createdAt'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'chatSessionId':
      chatSessionId,
      'isUser': isUser,
      'message': message,
      'createdAt': createdAt,
    };
  }

  ChatMessageModel copyWith({
    String? id,
    String? userId,
    String? chatSessionId,
    bool? isUser,
    String? message,
    DateTime? createdAt,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,

      userId:
      userId ?? this.userId,

      chatSessionId:
      chatSessionId ??
          this.chatSessionId,

      isUser:
      isUser ?? this.isUser,

      message:
      message ?? this.message,

      createdAt:
      createdAt ??
          this.createdAt,
    );
  }
}