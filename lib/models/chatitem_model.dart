import 'package:fit_medicine_02/controllers/static/server_info.dart';

class ChatitemModel {
  final int id, senderId, recieverId;
  final DateTime time;
  final DateTime? editTime;
  final String type;
  final String? message;
  ChatitemModel({
    required this.id,
    required this.senderId,
    required this.recieverId,
    required this.time,
    this.editTime,
    required this.type,
    this.message,
  });

  factory ChatitemModel.fromjsonText({data}) {
    return ChatitemModel(
        id: data['id'],
        senderId: data['sender_id'],
        recieverId: data['receiver_id'],
        time: DateTime.parse(data['time'].toString().substring(0, 19)),
        type: data['type'],
        message: data['message']);
  }

  factory ChatitemModel.fromjsonImage({data}) {
    return ChatitemModel(
        id: data['id'],
        senderId: data['sender_id'],
        recieverId: data['receiver_id'],
        time: DateTime.parse(data['time'].toString().substring(0, 19)),
        type: data['type'],
        message: "http://$serverIp${data['message']}");
  }

  factory ChatitemModel.fromjsonAudio({data}) {
    return ChatitemModel(
        id: data['id'],
        senderId: data['sender_id'],
        recieverId: data['receiver_id'],
        time: DateTime.parse(data['time'].toString().substring(0, 19)),
        type: data['type'],
        message: "message");
  }
}
