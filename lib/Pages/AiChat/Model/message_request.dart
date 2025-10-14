class MessageRequestEntity {
   String? message;

  MessageRequestEntity({this.message});
  
  
  MessageRequestEntity copyWith({String? message}) {
    return MessageRequestEntity(message: this.message ?? message);
  }

  Map<String, dynamic> toJson() => {"prompt": message};
}
