import 'package:sixvalley_vendor_app/features/order_details/domain/models/order_details_model.dart';

class WholesaleOrderDetailsModel extends OrderDetailsModel {
  WholesaleOrderLineModel? wholesale;

  WholesaleOrderDetailsModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    wholesale = json['wholesale'] is Map ? WholesaleOrderLineModel.fromJson(Map<String, dynamic>.from(json['wholesale'])) : null;
  }
}

class WholesaleOrderLineModel {
  double? unitPrice;
  double? taxPercent;
  String? variation;
  String? thumbnail;
  double? totalPrice;
  bool? isProductUnavailable;

  WholesaleOrderLineModel({
    this.unitPrice,
    this.taxPercent,
    this.variation,
    this.thumbnail,
    this.totalPrice,
    this.isProductUnavailable,
  });

  WholesaleOrderLineModel.fromJson(Map<String, dynamic> json) {
    unitPrice = double.tryParse('${json['unit_price']}');
    taxPercent = double.tryParse('${json['tax_percent']}');
    variation = json['variation'];
    thumbnail = json['thumbnail'];
    totalPrice = double.tryParse('${json['total_price']}');
    isProductUnavailable = json['is_product_unavailable'] == true;
  }
}
