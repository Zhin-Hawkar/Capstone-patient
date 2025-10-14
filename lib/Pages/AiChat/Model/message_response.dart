// import 'package:aiwarehousemanagementsystem/pages/tables/item/model/item.dart';

// class MessageResponseEntity {
//   String? user;
//   String? message;
//   List<Item>? response;

//   MessageResponseEntity({
//     this.user,
//     this.message,
//     this.response,
//     this.singleResponse,
//   });

//   factory MessageResponseEntity.fromJson(Map<String, dynamic> response, String stringResponse) {
//     final raw = response["ai_response"];
    
//     if (raw is List && raw[0].length > 1) {
//       if (raw.isNotEmpty && raw.first is Map<String, dynamic>) {
//         return MessageResponseEntity(
//           user: (response["user_id"] as num).toString(),
//           message: response["prompt"],
//           response: raw.map((e) => Item.fromJson(e)).toList(),
//         );
//       }

//       return MessageResponseEntity(
//         user: (response["user_id"] as num).toString(),
//         message: "${response["prompt"]}\n\nAnswer: ${raw.join(", ")}",
//         response: [],
//       );
//     }

//     return MessageResponseEntity(
//       user: (response["user_id"] as num? ?? 0).toString(),
//       message: "${response["prompt"]}\n\nAnswer: $raw",
//       response: [],
//       singleResponse: stringResponse,
//     );
//   }

//   MessageResponseEntity copyWith({
//     String? user,
//     String? message,
//     List<Item>? response,
//   }) {
//     return MessageResponseEntity(
//       user: user ?? this.user,
//       message: message ?? this.message,
//       response: response ?? this.response,
//     );
//   }
// }
