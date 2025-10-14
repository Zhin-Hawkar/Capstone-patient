
// import 'package:capstone/Pages/AiChat/Model/message_response.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// @riverpod
// class MessageResponseNotifier
//     extends StateNotifier<AsyncValue<List<MessageResponseEntity>>> {
//   MessageResponseNotifier() : super(const AsyncValue.loading()) {
//     getAiResponse();
//   }

//   Future<void> getAiResponse() async {
//     try {
//       state = const AsyncValue.loading();
//       final response = await HttpUtil().get("api/ai/getAiLog");
//       final result = response["result"];
//       final List<dynamic> data = result["response"];
//       final stringResponse = result["string_result"];

//       final aiLogResponse = data
//           .map((e) => MessageResponseEntity.fromJson(e, stringResponse))
//           .toList();
//       state = AsyncValue.data(aiLogResponse);
//     } catch (e, stackTrace) {
//       state = AsyncValue.error(e, stackTrace);
//     }
//   }

//   Future<void> refresh() async {
//     await getAiResponse();
//   }
// }

// final messageResponseNotifier =
//     StateNotifierProvider<
//       MessageResponseNotifier,
//       AsyncValue<List<MessageResponseEntity>>
//     >((ref) => MessageResponseNotifier());
