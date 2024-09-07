import 'package:fit_medicine_02/controllers/static/server_info.dart';
import 'package:fit_medicine_02/models/user_model.dart';

class Group {
  final int id;
  final String name;
  final List<UserModel>? groupMembers;
  final String? image;
  Group(
      {required this.id,
      required this.name,
      this.groupMembers = const [],
      this.image});
  factory Group.local({required Group data}) {
    return Group(id: data.id, name: data.name, image: data.image);
  }
  factory Group.fromjson({data}) {
    return Group(
        id: data['id'],
        name: data['name'],
        groupMembers: data['group_members'],
        image: data['image'] == null || data['image'] == "null"
            ? null
            : "http://$serverIp${data['image']}");
  }
}
