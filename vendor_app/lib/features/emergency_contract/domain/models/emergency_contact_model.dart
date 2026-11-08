import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/helper/json_converter.dart';

class EmergencyContactModel {
  List<ContactList>? contactList;

  EmergencyContactModel({this.contactList});

  EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    contactList = ApiListEnvelope.fromJson(json, legacyKeys: ['contact_list']).data?.map((v) => ContactList.fromJson(v)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contactList != null) {
      data['contact_list'] = contactList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContactList {
  int? id;
  int? userId;
  String? name;
  String? countryCode;
  String? phone;
  int? status;
  String? createdAt;
  String? updatedAt;

  ContactList(
      {this.id,
        this.userId,
        this.name,
        this.countryCode,
        this.phone,
        this.status,
        this.createdAt,
        this.updatedAt});

  String get fullPhone => '${countryCode ?? ''}${phone ?? ''}';

  ContactList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    countryCode = json['country_code'];
    phone = json['phone'];
    status = (JsonConverter.toBool(json['status']) ?? false) ? 1 : 0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['phone'] = phone;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
