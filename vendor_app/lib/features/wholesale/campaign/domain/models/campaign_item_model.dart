import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';

class CampaignItemModel {
  final int id;
  final String name;
  final String? image;
  final int quantity;
  final double? discount;

  CampaignItemModel({
    required this.id,
    required this.name,
    this.image,
    this.quantity = 1,
    this.discount,
  });

  factory CampaignItemModel.fromJson(Map<String, dynamic> json) {
    return CampaignItemModel(
      id: json['id'] ?? json['product_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['thumbnail_full_url'] != null
          ? ImageFullUrl.fromDynamic(json['thumbnail_full_url']).path : json['image'],
      quantity: json['quantity'] ?? 1,
      discount: json['discount'] != null ? double.tryParse('${json['discount']}') : null,
    );
  }
}
