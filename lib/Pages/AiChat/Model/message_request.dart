class AiChatModel {
  final String prompt;
  final String response;
  final String createdAt;

  AiChatModel({
    required this.prompt,
    required this.response,
    required this.createdAt,
  });

  factory AiChatModel.fromJson(Map<String, dynamic> json) {
    final log = json['result']['log'];
    return AiChatModel(
      prompt: log['prompt'],
      response: log['response'],
      createdAt: log['created_at'],
    );
  }
}
