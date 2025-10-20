import 'package:capstone/Backend/Model/user.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Pages/AiChat/Controller/ai_chat_controller.dart';
import 'package:capstone/Pages/AiChat/Model/message_request.dart';
import 'package:capstone/Pages/AiChat/Notifier/ai_chat_notifier.dart';
import 'package:capstone/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/Pages/UserProfile/View/user_profile.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:capstone/Reusables/TextFields/ai_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class AiChat extends ConsumerStatefulWidget {
  const AiChat({super.key});

  @override
  ConsumerState<AiChat> createState() => _AiChatState();
}

class _AiChatState extends ConsumerState<AiChat> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isSending = true);

    await AiChatController.sendPrompt(_controller.text.trim(), ref);

    _controller.clear();
    setState(() => _isSending = false);

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildMessageBubble(AiChatModel msg, bool isUser, Profile user) {
    return isUser
        ? Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.DARK_GREEN : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isUser
                            ? const Radius.circular(12)
                            : Radius.zero,
                        bottomRight: isUser
                            ? Radius.zero
                            : const Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUser ? msg.prompt : msg.response,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: UserProfile(),
                      ),
                    );
                  },
                  icon: user.image == null || user.image == "null"
                      ? Icon(Icons.person)
                      : ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(35),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.network(
                              "${user.image}",
                              width: 40,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Transform.scale(
                    scale: 1.7,
                    child: Lottie.asset("assets/json/E V E.json"),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.DARK_GREEN : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isUser
                            ? const Radius.circular(12)
                            : Radius.zero,
                        bottomRight: isUser
                            ? Radius.zero
                            : const Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUser ? msg.prompt : msg.response,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(signInNotifierProvider);
    final messages = ref.watch(chatProvider);
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: CustomAppBar(title: "AiChat"),
      body: Stack(
        children: [
          messages.isNotEmpty
              ? Container()
              : Container(
                  margin: EdgeInsets.only(top: 20.h),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(),
                        child: BlurText(
                          text:
                              "Hello ${profileState.profile!.firstName}, How Can I Help You Today?",
                          mode: AnimationMode.repeatNoReverse,
                          duration: Duration(milliseconds: 1300),
                          type: AnimationType.word,
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: false,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length * 2,
                  itemBuilder: (context, index) {
                    int msgIndex = index ~/ 2;
                    bool isUser = index % 2 == 0;
                    final msg = messages[msgIndex];
                    return _buildMessageBubble(
                      isUser ? msg : msg,
                      isUser,
                      profileState.profile!,
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  bottom: 35,
                  left: 20,
                  right: 20,
                  top: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AiTextField(
                        textFieldController: _controller,
                        hintText: "Enter your message...",
                      ),
                    ),
                    SizedBox(width: 10),
                    _isSending
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              _sendMessage();
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
