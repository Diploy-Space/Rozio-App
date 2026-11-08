import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/helper/json_converter.dart';

class AuctionNotificationListModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? newNotification;
  List<AuctionNotificationItem>? notifications;

  AuctionNotificationListModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize       = envelope.totalSize;
    limit           = envelope.limit;
    offset          = envelope.offset;
    newNotification = int.tryParse('${envelope.read('new_notification')}');
    if (envelope.data != null) {
      notifications = <AuctionNotificationItem>[];
      for (final dynamic v in envelope.data!) {
        notifications!.add(AuctionNotificationItem.fromJson(Map<String, dynamic>.from(v)));
      }
    }
  }
}

class AuctionNotificationItem {
  int?    id;
  int?    auctionProductId;
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
  String? auctionProductName;
  String? slug;
  String? auctionProductThumbnailFullUrl;

  String get typeLabel {
    const labels = {
      'auction_won':                          'Auction Won',
      'auction_approved':                     'Auction Approved',
      'auction_denied':                       'Auction Denied',
      'auction_new_participation':            'New Participation',
      'auction_new_bid':                      'New Bid',
      'auction_expired_result':              'Auction Result',
      'auction_item_claimed':                 'Item Claimed',
      'auction_claim_payment_verified_owner': 'Payment Verified',
      'auction_withdrawal_approved':          'Withdrawal Approved',
      'auction_withdrawal_rejected':          'Withdrawal Rejected',
    };
    if (type == null) return 'Auction Notification';
    return labels[type!] ??
        type!
            .replaceAll('_', ' ')
            .split(' ')
            .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
            .join(' ');
  }

  AuctionNotificationItem.fromJson(Map<String, dynamic> json) {
    final Map? auctionProduct      = json['auction_product'] is Map ? json['auction_product'] : null;
    id                             = json['id'];
    auctionProductId               = json['auction_product_id'];
    userId                         = json['user_id'];
    senderId                       = json['sender_id'];
    senderType                     = json['sender_type'];
    receiverId                     = json['receiver_id'];
    receiverType                   = json['receiver_type'];
    type                           = json['type'];
    message                        = json['message'];
    isRead                         = JsonConverter.toBool(json['is_read']);
    createdAt                      = json['created_at'];
    updatedAt                      = json['updated_at'];
    auctionProductName             = json['auction_product_name'] ?? auctionProduct?['name'];
    slug                           = json['slug'] ?? auctionProduct?['slug'];
    auctionProductThumbnailFullUrl = json['auction_product_thumbnail_full_url'] ?? auctionProduct?['thumbnail_full_url'];
  }
}
