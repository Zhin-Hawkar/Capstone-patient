import 'package:capstone/Patient/Pages/AiChat/Model/message_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, List<AiChatModel>>(
  (ref) => ChatNotifier(),
);

class ChatNotifier extends StateNotifier<List<AiChatModel>> {
  ChatNotifier() : super([]);

  void addMessage(AiChatModel message) {
    state = [...state, message];
  }

  void clearChat() {
    state = [];
  }
}
