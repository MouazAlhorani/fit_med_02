import 'package:fit_medicine_02/controllers/static/server_info.dart';

enum ServiceType { medicine, feed, diseaseTreatment }

class ServiceModel {
  final int id;
  final String name;
  final String? image, category, type, usage, composition;
  final ServiceType serviceType;
  final double? price;
  final DateTime? expirationDate;

  int count;
  ServiceModel(
      {required this.serviceType,
      required this.id,
      required this.name,
      required this.image,
      this.category,
      this.type,
      this.usage,
      this.composition,
      this.price,
      this.expirationDate,
      this.count = 1});
}

class MedicineModel extends ServiceModel {
  MedicineModel(
      {required super.id,
      required super.name,
      super.image,
      super.category,
      super.type,
      super.usage,
      super.composition,
      super.price,
      super.expirationDate,
      required super.count,
      super.serviceType = ServiceType.medicine});
  factory MedicineModel.local({required MedicineModel data}) {
    return MedicineModel(
        id: data.id,
        name: data.name,
        image: data.image,
        category: data.category,
        type: data.type,
        usage: data.usage,
        composition: data.composition,
        price: data.price,
        expirationDate: data.expirationDate,
        count: data.count);
  }
  factory MedicineModel.fromjson({data}) {
    return MedicineModel(
        id: data['id'],
        name: data['name'],
        image: data['image'] == null ||
                data['image'] == "null" ||
                data['image'] == ""
            ? null
            : "http://$serverIp${data['image']}",
        expirationDate: data['expiration_date'],
        category: data['category'],
        type: data['type_of_medicine'],
        price: data['price'] == null || data['price'] == "null"
            ? null
            : double.tryParse(data['price']),
        usage: data['usage'] ?? data['Description'],
        composition: data['Composition'],
        count: data['count'] ?? 1);
  }
}

class FeedModel extends ServiceModel {
  FeedModel(
      {required super.id,
      required super.name,
      super.image,
      super.category,
      super.usage,
      super.composition,
      super.price,
      super.expirationDate,
      required super.count,
      super.serviceType = ServiceType.feed});
  factory FeedModel.local({required FeedModel data}) {
    return FeedModel(
        id: data.id,
        name: data.name,
        image: data.image,
        category: data.category,
        usage: data.usage,
        composition: data.composition,
        price: data.price,
        expirationDate: data.expirationDate,
        count: data.count);
  }
  factory FeedModel.fromjson({data}) {
    return FeedModel(
        id: data['id'],
        name: data['name'],
        image: data['image'] == null ||
                data['image'] == "null" ||
                data['image'] == ""
            ? null
            : "http://$serverIp${data['image']}",
        expirationDate: data['expiration_date'],
        category: data['category'],
        price: data['price'] == null || data['price'] == "null"
            ? null
            : double.tryParse(data['price']),
        usage: data['usage'] ?? data['Description'],
        composition: data['Composition'],
        count: data['count'] ?? 1);
  }
}

class DiseaseTreatMentModel extends ServiceModel {
  final String? details, causes, symptoms, prevention, type, treatment;
  final MedicineModel? medicin;
  DiseaseTreatMentModel(
      {required super.id,
      required super.name,
      super.image,
      this.causes,
      this.symptoms,
      this.prevention,
      this.type,
      this.treatment,
      this.details,
      this.medicin})
      : super(serviceType: ServiceType.diseaseTreatment);

  factory DiseaseTreatMentModel.local({required DiseaseTreatMentModel data}) {
    return DiseaseTreatMentModel(
        id: data.id,
        name: data.name,
        image: data.image,
        causes: data.causes,
        symptoms: data.symptoms,
        prevention: data.prevention,
        type: data.type,
        treatment: data.treatment,
        details: data.details,
        medicin: data.medicin);
  }
  factory DiseaseTreatMentModel.fromjson({data}) {
    return DiseaseTreatMentModel(
        id: data['id'],
        name: data['name'],
        image: data['image'] == null || data['image'] == "null"
            ? null
            : "http://$serverIp${data['image']}",
        causes: data['causes'],
        symptoms: data['symptoms'],
        prevention: data['prevention'],
        type: data['type'],
        treatment: data['treatment'],
        details: data['details'],
        medicin: MedicineModel.fromjson(data: data['medicines']));
  }
}
