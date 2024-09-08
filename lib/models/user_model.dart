import '../controllers/static/server_info.dart';

enum UserType { veter, breeder }

abstract class UserModel {
  final int id;
  final String username;
  UserModel({
    required this.id,
    required this.username,
  });
}

class VeterModel extends UserModel {
  final UserType userType;
  final String? certificateImage,
      experienceCertificateImage,
      address,
      specialization,
      photo,
      email;
  VeterModel({
    this.userType = UserType.veter,
    required super.id,
    required super.username,
    this.certificateImage,
    this.experienceCertificateImage,
    this.address,
    this.specialization,
    this.photo,
    this.email,
  });

  factory VeterModel.local({required VeterModel data}) {
    return VeterModel(
        id: data.id,
        username: data.username,
        certificateImage: data.certificateImage,
        experienceCertificateImage: data.experienceCertificateImage,
        address: data.address,
        specialization: data.specialization,
        photo: data.photo,
        email: data.email);
  }

  factory VeterModel.fromjson({data}) {
    return VeterModel(
      id: data['id'],
      username: data['name'],
      certificateImage: data['certificate_image'] == null ||
              data['certificate_image'] == "null"
          ? null
          : "http://$serverIp${data['certificate_image']}",
      experienceCertificateImage:
          data['experience_certificate_image'] == null ||
                  data['experience_certificate_image'] == "null"
              ? null
              : "http://$serverIp${data['experience_certificate_image']}",
      address: data['address'],
      specialization: data['Specialization'] == null ||
              data['Specialization'] == "null" ||
              data['Specialization'] == ""
          ? ""
          : data['Specialization'],
      photo: data['photo'] == null || data['photo'] == "null"
          ? null
          : "http://$serverIp${data['photo']}",
      email: data['email'],
    );
  }
}

class BreederModel extends UserModel {
  final UserType userType;
  final String? mobile, region;
  final int? categoyId;
  BreederModel(
      {this.userType = UserType.breeder,
      required super.id,
      required super.username,
      this.mobile,
      this.region,
      this.categoyId});
  factory BreederModel.local({required BreederModel data}) {
    return BreederModel(
        id: data.id,
        username: data.username,
        mobile: data.mobile,
        region: data.region,
        categoyId: data.categoyId);
  }
  factory BreederModel.fromjson({data}) {
    return BreederModel(
        id: data['id'],
        username: data['name'],
        mobile: data['mobile'],
        region: data['region'],
        categoyId: data['category_id']);
  }
}
