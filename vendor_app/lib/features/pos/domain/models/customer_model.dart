import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';

class CustomerModel {
  List<Customers>? customers;

  CustomerModel({this.customers});

  CustomerModel.fromJson(Map<String, dynamic> raw) {
    // v6 envelope: the list is `content.data`.
    final Map<String, dynamic> json = raw['content'] is Map ? Map<String, dynamic>.from(raw['content']) : raw;
    if (json['data'] is List) {
      customers = (json['data'] as List).map((v) => Customers.fromJson(Map<String, dynamic>.from(v))).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customers != null) {
      data['customers'] = customers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customers {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  ImageFullUrl? imageFullUrl;
  String? email;
  double? walletBalance;

  Customers(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.imageFullUrl,
        this.email,
        this.walletBalance
      });

  Customers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'] ?? '';
    lName = json['l_name'] ?? '';
    phone = json['phone'];
    // v6 sends `image_full_url` as a bare URL string, not the usual {key, path, status} object.
    imageFullUrl = ImageFullUrl.fromDynamic(json['image_full_url']);
    email = json['email'];
    if(json['wallet_balance'] != null) {
      walletBalance = double.tryParse(json['wallet_balance'].toString());
    } else {
      walletBalance = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    if (imageFullUrl != null) {
      data['image_full_url'] = imageFullUrl!.toJson();
    }
    data['email'] = email;
    return data;
  }
}
