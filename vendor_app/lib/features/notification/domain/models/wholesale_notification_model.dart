import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/helper/json_converter.dart';

class WholesaleNotificationListModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? newNotification;
  List<WholesaleNotificationItem>? notifications;

  WholesaleNotificationListModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize       = envelope.totalSize;
    limit           = envelope.limit;
    offset          = envelope.offset;
    newNotification = int.tryParse('${envelope.read('new_notification')}');
    if (envelope.data != null) {
      notifications = <WholesaleNotificationItem>[];
      for (final dynamic v in envelope.data!) {
        notifications!.add(WholesaleNotificationItem.fromJson(Map<String, dynamic>.from(v)));
      }
    }
  }
}

class WholesaleNotificationItem {
  int?    id;
  int?    wholesaleProductId;
  int?    userId;
  int?    senderId;
  String? senderType;
  int?    receiverId;
  String? receiverType;
  String? type;
  String? message;
  bool?   isRead;
  String? createdAt;
  String? updatedAt;
  String? wholesaleProductName;
  String? slug;
  String? wholesaleProductThumbnailFullUrl;

  String get typeLabel {
    if (type == null || type!.isEmpty) return 'Wholesale Notification';
    return type!
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  WholesaleNotificationItem.fromJson(Map<String, dynamic> json) {
    id                               = json['id'];
    wholesaleProductId               = json['wholesale_product_id'] ?? json['product_id'];
    userId                           = json['user_id'];
    senderId                         = json['sender_id'];
    senderType                       = json['sender_type'];
    receiverId                       = json['receiver_id'];
    receiverType                     = json['receiver_type'];
    type                             = json['type'];
    message                          = json['message'];
    isRead                           = JsonConverter.toBool(json['is_read']);
    createdAt                        = json['created_at'];
    updatedAt                        = json['updated_at'];
    wholesaleProductName             = json['wholesale_product_name'] ?? json['product_name'];
    slug                             = json['slug'];
    wholesaleProductThumbnailFullUrl = json['wholesale_product_thumbnail_full_url']
        ?? json['product_thumbnail_full_url']
        ?? json['thumbnail_full_url'];
  }
}
