enum ChatItype { text, image, voicerecord }

class ChatitemModel {
  final int senderId, recieverId;
  final DateTime time;
  final DateTime? editTime;
  final ChatItype type;
  ChatitemModel(
      {required this.senderId,
      required this.recieverId,
      required this.time,
      this.editTime,
      required this.type});
}
