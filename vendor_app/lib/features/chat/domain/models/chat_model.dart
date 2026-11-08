import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';

class ChatModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<Chat>? chat;

  ChatModel({this.totalSize, this.limit, this.offset, this.chat});

  ChatModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['chat']);
    totalSize = envelope.totalSize;
    limit = envelope.limit?.toString();
    offset = envelope.offset?.toString();
    chat = envelope.data?.map((v) => Chat.fromJson(v)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (chat != null) {
      data['chat'] = chat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chat {
  int? id;
  int? userId;
  int? deliveryManId;
  String? message;
  bool? sentByCustomer;
  bool? sentByDeliveryMan;
  bool? seenBySeller;
  String? createdAt;
  String? updatedAt;
  DeliveryMan? deliveryMan;
  Customer? customer;
  List<ImageFullUrl>? attachmentFullUrl;
  int? unseenMessageCount;
  Counterparty? counterparty;

  Chat(
      {this.id,
        this.userId,
        this.deliveryManId,
        this.message,
        this.sentByCustomer,
        this.sentByDeliveryMan,
        this.seenBySeller,
        this.createdAt,
        this.updatedAt,
        this.deliveryMan,
        this.customer,
        this.attachmentFullUrl,
        this.unseenMessageCount,
        this.counterparty,
      });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    if(json['delivery_man_id'] != null){
      deliveryManId = int.parse(json['delivery_man_id'].toString());
    }
    message = json['last_message'];
    sentByCustomer = json['sent_by_customer'];
    sentByDeliveryMan = json['sent_by_delivery_man'];
    seenBySeller = json['seen_by_seller'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryMan = json['delivery_man'] != null ? DeliveryMan.fromJson(json['delivery_man']) : null;
    customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    if (json['attachment_full_url'] is List) {
      attachmentFullUrl = (json['attachment_full_url'] as List).map((v) => ImageFullUrl.fromJson(v)).toList();
    }
    unseenMessageCount = json['unseen_message_count'];
    counterparty = json['counterparty'] != null ? Counterparty.fromJson(json['counterparty']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['delivery_man_id'] = deliveryManId;
    data['message'] = message;
    data['sent_by_customer'] = sentByCustomer;
    data['sent_by_delivery_man'] = sentByDeliveryMan;
    data['seen_by_seller'] = seenBySeller;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (deliveryMan != null) {
      data['delivery_man'] = deliveryMan!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }


    data['unseen_message_count'] = unseenMessageCount;

    return data;
  }
}

class Counterparty {
  String? type;
  int? id;
  String? name;
  ImageFullUrl? imageFullUrl;

  Counterparty({this.type, this.id, this.name, this.imageFullUrl});

  Counterparty.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = int.tryParse('${json['id']}');
    name = json['name'];
    imageFullUrl = json['image_full_url'] != null ? ImageFullUrl.fromJson(json['image_full_url']) : null;
  }
}

class DeliveryMan {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? image;
  ImageFullUrl? imageFullUrl;

  DeliveryMan({this.id, this.fName, this.lName, this.phone, this.email, this.image, this.imageFullUrl});

  DeliveryMan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    imageFullUrl = json['image_full_url'] != null ? ImageFullUrl.fromJson(json['image_full_url']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['image'] = image;
    return data;
  }
}

class Customer {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? image;
  ImageFullUrl? imageFullUrl;
  String? email;


  Customer({this.id, this.fName, this.lName, this.phone, this.image, this.imageFullUrl, this.email});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    image = json['image'];
    imageFullUrl = json['image_full_url'] != null ? ImageFullUrl.fromJson(json['image_full_url']) : null;
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['image'] = image;
    data['email'] = email;
    return data;
  }
}
