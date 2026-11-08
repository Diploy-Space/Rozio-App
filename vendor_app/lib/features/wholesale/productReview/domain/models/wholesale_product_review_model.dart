class WholesaleProductReviewModel {
  final int? id;
  final int? productId;
  final String? productName;
  final String? productThumbnail;
  final String? productType;
  final int? customerId;
  final String? customerName;
  final String? customerImage;
  final int? orderId;
  final String? comment;
  final double? rating;
  int status;
  final String? createdAt;
  final List<String>? attachments;
  WholesaleReviewReply? reply;

  WholesaleProductReviewModel({
    this.id,
    this.productId,
    this.productName,
    this.productThumbnail,
    this.productType,
    this.customerId,
    this.customerName,
    this.customerImage,
    this.orderId,
    this.comment,
    this.rating,
    this.status = 1,
    this.createdAt,
    this.attachments,
    this.reply,
  });

  factory WholesaleProductReviewModel.fromJson(Map<String, dynamic> json) {
    final Map? product = json['product'] is Map ? json['product'] : null;
    final Map? customer = json['customer'] is Map ? json['customer'] : null;
    final dynamic attachments = json['attachment_full_url'];

    return WholesaleProductReviewModel(
      id: json['id'],
      productId: json['product_id'],
      productName: product?['name'],
      productThumbnail: product?['thumbnail_full_url'] is Map ? product!['thumbnail_full_url']['path'] : null,
      productType: product?['product_type'],
      customerId: json['customer_id'],
      customerName: customer != null ? '${customer['f_name'] ?? ''} ${customer['l_name'] ?? ''}'.trim() : null,
      customerImage: customer?['image_full_url'] is Map ? customer!['image_full_url']['path'] : null,
      orderId: json['order_id'],
      comment: json['comment'],
      rating: double.tryParse('${json['rating']}'),
      status: int.tryParse('${json['status']}') ?? (json['status'] == true ? 1 : 0),
      createdAt: json['created_at'],
      attachments: attachments is List ? attachments.whereType<Map>().map((image) => image['path']).whereType<String>().toList() : null,
      reply: json['reply'] is Map ? WholesaleReviewReply.fromJson(Map<String, dynamic>.from(json['reply'])) : null,
    );
  }
}

class WholesaleReviewReply {
  final String? replyText;
  final String? addedBy;
  final String? createdAt;

  WholesaleReviewReply({this.replyText, this.addedBy, this.createdAt});

  factory WholesaleReviewReply.fromJson(Map<String, dynamic> json) {
    return WholesaleReviewReply(
      replyText: json['reply_text'],
      addedBy: json['added_by'],
      createdAt: json['created_at'],
    );
  }
}
