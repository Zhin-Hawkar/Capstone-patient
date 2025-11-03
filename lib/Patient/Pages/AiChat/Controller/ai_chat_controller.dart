import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Patient/Pages/AiChat/Model/message_request.dart';
import 'package:capstone/Patient/Pages/AiChat/Notifier/ai_chat_notifier.dart';
import 'package:capstone/Patient/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiChatController {
  static Future<AiChatModel?> sendPrompt(String prompt, WidgetRef ref) async {
    final user = ref.watch(signInNotifierProvider);
    try {
      final result = await promptRequest(prompt, user.profile?.email);
      print(result);
      if (result['result']['code'] == 200) {
        final chatMessage = AiChatModel.fromJson(result);
        ref.read(chatProvider.notifier).addMessage(chatMessage);
        return chatMessage;
      } else {
        print('Error: ${result}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  static promptRequest(String prompt, String? email) async {
    var result = await HttpUtil().post(
      "api/talktoai",
      data: {'prompt': prompt, 'email': email ?? null},
    );
    return result;
  }
}
