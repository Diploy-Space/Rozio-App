import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';

class CampaignEligibleProductModel {
  final int? id;
  final String? name;
  final String? code;
  final ImageFullUrl? thumbnailFullUrl;
  final double? unitPrice;
  final int? minimumOrderQty;
  final double? discount;
  final bool isEnrolled;
  final bool isSelectable;

  CampaignEligibleProductModel({
    this.id,
    this.name,
    this.code,
    this.thumbnailFullUrl,
    this.unitPrice,
    this.minimumOrderQty,
    this.discount,
    this.isEnrolled = false,
    this.isSelectable = true,
  });

  String? get thumbnail => thumbnailFullUrl?.path;

  factory CampaignEligibleProductModel.fromJson(Map<String, dynamic> json) {
    return CampaignEligibleProductModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      thumbnailFullUrl:
          json['thumbnail_full_url'] != null ? ImageFullUrl.fromDynamic(json['thumbnail_full_url']) : null,
      unitPrice: json['unit_price'] != null ? double.tryParse('${json['unit_price']}') : null,
      minimumOrderQty: json['minimum_order_qty'],
      discount: json['discount'] != null ? double.tryParse('${json['discount']}') : null,
      isEnrolled: json['is_enrolled'] ?? false,
      isSelectable: json['is_selectable'] ?? true,
    );
  }
}

class CampaignEligibleProductListModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<CampaignEligibleProductModel>? products;

  CampaignEligibleProductListModel({this.totalSize, this.limit, this.offset, this.products});

  CampaignEligibleProductListModel.fromJson(Map<String, dynamic> raw) {
    final Map<String, dynamic> json = raw['content'] is Map ? Map<String, dynamic>.from(raw['content']) : raw;
    final Map<String, dynamic>? pagination =
        json['pagination'] is Map ? Map<String, dynamic>.from(json['pagination']) : null;

    totalSize = int.tryParse('${pagination?['total']}');
    limit = int.tryParse('${pagination?['per_page']}');
    offset = int.tryParse('${pagination?['current_page']}');

    if (json['data'] is List) {
      products = (json['data'] as List)
          .map((e) => CampaignEligibleProductModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
  }
}
