


class NotificationBody {
  int? orderId;
  int? orderDetailsId;
  int? refundId;
  int? auctionId;
  int? productId;
  int? campaignId;
  int? reviewId;
  String? type;
  String? messageKey;
  String? businessModule;


  NotificationBody({
    this.orderId,
    this.orderDetailsId,
    this.refundId,
    this.auctionId,
    this.productId,
    this.campaignId,
    this.reviewId,
    this.type,
    this.messageKey,
    this.businessModule,
  });

  bool get isWholesale => businessModule == 'wholesale' || type == 'campaign';

  NotificationBody.fromJson(Map<String, dynamic> json) {
    if(json['order_id'] != null && json['order_id'] != ''){
      orderId = int.tryParse(json['order_id'].toString());
    }
    if(json['order_details_id'] != null && json['order_details_id'] != ''){
      orderDetailsId = int.tryParse(json['order_details_id'].toString());
    }
    type = json['type'];
    messageKey = json['message_key'];
    if(json['refund_id'] != null && json['refund_id'] != ''){
      refundId = int.tryParse(json['refund_id'].toString());
    }
    if(json['auction_id'] != null && json['auction_id'] != ''){
      auctionId = int.tryParse(json['auction_id'].toString());
    }
    if(json['product_id'] != null && json['product_id'] != ''){
      productId = int.tryParse(json['product_id'].toString());
    }
    if(json['campaign_id'] != null && json['campaign_id'] != ''){
      campaignId = int.tryParse(json['campaign_id'].toString());
    }
    if(json['review_id'] != null && json['review_id'] != ''){
      reviewId = int.tryParse(json['review_id'].toString());
    }
    businessModule = json['business_module']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_details_id'] = orderDetailsId;
    data['refund_id'] = refundId;
    data['auction_id'] = auctionId;
    data['product_id'] = productId;
    data['campaign_id'] = campaignId;
    data['review_id'] = reviewId;
    data['type'] = type;
    data['message_key'] = messageKey;
    data['business_module'] = businessModule;
    return data;
  }


}
