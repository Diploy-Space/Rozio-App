import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/features/chat/domain/models/chat_model.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class MessageModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Message>? message;

  MessageModel({this.totalSize, this.limit, this.offset, this.message});

  MessageModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['message']);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    message = envelope.data?.map((v) => Message.fromJson(v)).toList();
  }
}

class Message {
  int? id;
  int? userId;
  int? deliveryManId;
  String? message;
  bool? sentByCustomer;
  bool? sentByDeliveryMan;
  bool? sentBySeller;
  bool? seenBySeller;
  String? createdAt;
  String? updatedAt;
  Customer? customer;
  DeliveryMan? deliveryMan;
  List<Attachment>? attachment;

  Message(
      {this.id,
        this.userId,
        this.deliveryManId,
        this.message,
        this.sentByCustomer,
        this.sentByDeliveryMan,
        this.sentBySeller,
        this.seenBySeller,
        this.createdAt,
        this.updatedAt,
        this.customer,
      this.deliveryMan,
        this.attachment
      });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    if(json['delivery_man_id'] != null){
      deliveryManId = int.parse(json['delivery_man_id'].toString());
    }

    message = json['message'];
    sentByCustomer = json['sent_by_customer'];
    sentByDeliveryMan = json['sent_by_delivery_man']??false;
    sentBySeller = json['sent_by_seller'];
    seenBySeller = json['seen_by_seller'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    deliveryMan = json['delivery_man'] != null ? DeliveryMan.fromJson(json['delivery_man']) : null;
    if (json['attachment_full_url'] != null) {
      attachment = <Attachment>[];
      json['attachment_full_url'].forEach((v) {
        if(v is Map){
          attachment!.add(Attachment.fromJson(Map<String, dynamic>.from(v)));
        }
      });
    }
  }
}


class Attachment {
  String? type;
  String? key;
  String? path;
  String? size;

  Attachment({this.type, this.key, this.path, this.size});

  Attachment.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    path = json['path'];
    size = json['size']?.toString();
    type = json['type'] ?? _typeFromExtension(key ?? path ?? '');
  }

  static String _typeFromExtension(String name) {
    final String extension = name.split('.').last.toLowerCase();
    final bool isMedia = AppConstants.imageExtensions.contains(extension) || AppConstants.videoExtensions.contains(extension);
    return isMedia ? 'media' : 'file';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['key'] = key;
    data['path'] = path;
    data['size'] = size;
    return data;
  }
}
