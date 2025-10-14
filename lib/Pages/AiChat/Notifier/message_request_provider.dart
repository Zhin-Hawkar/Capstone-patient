import 'package:capstone/Pages/AiChat/Model/message_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


@riverpod
class MessageRequestNotifier extends StateNotifier<MessageRequestEntity> {
  MessageRequestNotifier() : super(MessageRequestEntity());

  void setMessage(String message) {
    state = state.copyWith(message: message);
  }

  void clearMessageState() {
    state.message = null;
  }
}

var messageRequestNotifier =
    StateNotifierProvider<MessageRequestNotifier, MessageRequestEntity>(
      (ref) => MessageRequestNotifier(),
    );
