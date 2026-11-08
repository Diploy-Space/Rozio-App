import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';

class WholesaleCouponModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<WholesaleCoupon>? coupons;

  WholesaleCouponModel({this.totalSize, this.limit, this.offset, this.coupons});

  WholesaleCouponModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    coupons = envelope.data?.whereType<Map>().map((coupon) => WholesaleCoupon.fromJson(Map<String, dynamic>.from(coupon))).toList();
  }
}

class WholesaleCoupon {
  int? id;
  String? title;
  String? code;
  String? couponType;
  int? customerId;
  int? limit;
  String? discountType;
  double? discount;
  double? maxDiscount;
  double? minPurchase;
  String? startDate;
  String? expireDate;
  int? status;
  bool? isEditable;
  int? orderCount;
  String? createdAt;

  WholesaleCoupon({
    this.id,
    this.title,
    this.code,
    this.couponType,
    this.customerId,
    this.limit,
    this.discountType,
    this.discount,
    this.maxDiscount,
    this.minPurchase,
    this.startDate,
    this.expireDate,
    this.status,
    this.isEditable,
    this.orderCount,
    this.createdAt,
  });

  WholesaleCoupon.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    title = json['title'];
    code = json['code'];
    couponType = json['coupon_type'];
    customerId = int.tryParse(json['customer_id'].toString());
    limit = double.tryParse(json['limit'].toString())?.toInt();
    discountType = json['discount_type'];
    discount = double.tryParse(json['discount'].toString());
    maxDiscount = double.tryParse(json['max_discount'].toString());
    minPurchase = double.tryParse(json['min_purchase'].toString());
    startDate = json['start_date'];
    expireDate = json['expire_date'];
    status = _parseStatus(json['status']);
    isEditable = json['is_editable'] == true;
    orderCount = int.tryParse(json['order_count'].toString());
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toPayload({required bool targeting, required bool discountEnabled}) {
    return {
      'coupon_type': couponType,
      'title': title,
      'code': code,
      'min_purchase': minPurchase,
      'start_date': startDate,
      'expire_date': expireDate,
      if (targeting) ...{
        'customer_id': customerId ?? 0,
        'limit': limit,
      },
      if (discountEnabled) ...{
        'discount_type': discountType,
        'discount': discount,
        if (discountType == 'percentage') 'max_discount': maxDiscount,
      },
    };
  }

  static int _parseStatus(dynamic value) {
    if (value is bool) return value ? 1 : 0;
    return int.tryParse(value.toString()) ?? 0;
  }
}
