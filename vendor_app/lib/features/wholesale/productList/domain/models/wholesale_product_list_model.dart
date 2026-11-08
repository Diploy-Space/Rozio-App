import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/data/model/pagination_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/enums/wholesale_product_status.dart';

class WholesaleProductListModel {
  final int? id;
  final String? name;
  final String? slug;
  final String? code;
  final String? productType;
  final ImageFullUrl? thumbnailFullUrl;
  final int? categoryId;
  final int? subCategoryId;
  final int? subSubCategoryId;
  final int? brandId;
  final String? unit;
  final double? unitPrice;
  final int? minimumOrderQty;
  final int? currentStock;
  final double? shippingCost;
  final double? tempShippingCost;
  final bool isShippingCostUpdated;

  final int? status;

  final int? requestStatus;

  final String? createdAt;
  final double? minPrice;
  final double? maxPrice;
  final String? deniedNote;
  final int? reorderLevel;
  final bool featured;

  WholesaleProductListModel({
    this.id,
    this.name,
    this.slug,
    this.code,
    this.productType,
    this.thumbnailFullUrl,
    this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
    this.brandId,
    this.unit,
    this.unitPrice,
    this.minimumOrderQty,
    this.currentStock,
    this.shippingCost,
    this.tempShippingCost,
    this.isShippingCostUpdated = false,
    this.status,
    this.requestStatus,
    this.createdAt,
    this.minPrice,
    this.maxPrice,
    this.deniedNote,
    this.reorderLevel,
    this.featured = false,
  });

  WholesaleProductStatus get approvalStatus => WholesaleProductStatus.fromRequestStatus(requestStatus);

  bool get isActive => status == 1;

  String? get thumbnail => thumbnailFullUrl?.path;

  WholesaleProductListModel copyWithStatus(int status) {
    return WholesaleProductListModel(
      id: id,
      name: name,
      slug: slug,
      code: code,
      productType: productType,
      thumbnailFullUrl: thumbnailFullUrl,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      subSubCategoryId: subSubCategoryId,
      brandId: brandId,
      unit: unit,
      unitPrice: unitPrice,
      minimumOrderQty: minimumOrderQty,
      currentStock: currentStock,
      shippingCost: shippingCost,
      tempShippingCost: tempShippingCost,
      isShippingCostUpdated: isShippingCostUpdated,
      status: status,
      requestStatus: requestStatus,
      createdAt: createdAt,
      minPrice: minPrice,
      maxPrice: maxPrice,
      deniedNote: deniedNote,
      reorderLevel: reorderLevel,
      featured: featured,
    );
  }

  factory WholesaleProductListModel.fromJson(Map<String, dynamic> json) {
    final dynamic priceRange = json['price_range'];

    return WholesaleProductListModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      code: json['code'],
      productType: json['product_type'],
      thumbnailFullUrl: json['thumbnail_full_url'] != null ? ImageFullUrl.fromJson(json['thumbnail_full_url']) : null,
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
      subSubCategoryId: json['sub_sub_category_id'],
      brandId: json['brand_id'],
      unit: json['unit'],
      unitPrice: double.tryParse('${json['unit_price']}'),
      minimumOrderQty: json['minimum_order_qty'],
      currentStock: json['current_stock'],
      shippingCost: double.tryParse('${json['shipping_cost']}'),
      tempShippingCost: json['temp_shipping_cost'] != null ? double.tryParse('${json['temp_shipping_cost']}') : null,
      isShippingCostUpdated: json['is_shipping_cost_updated'] == 1 || json['is_shipping_cost_updated'] == true,
      status: json['status'],
      requestStatus: json['request_status'],
      createdAt: json['created_at'],
      minPrice: priceRange != null ? double.tryParse('${priceRange['min']}') : null,
      maxPrice: priceRange != null ? double.tryParse('${priceRange['max']}') : null,
      deniedNote: json['denied_note'],
      reorderLevel: json['reorder_level'],
      featured: json['featured'] == true || json['featured'] == 1,
    );
  }
}

class WholesaleProductListResponseModel {
  List<WholesaleProductListModel> products;
  PaginationModel? pagination;

  WholesaleProductListResponseModel({List<WholesaleProductListModel>? products, this.pagination}) : products = products ?? [];

  WholesaleProductListResponseModel.fromJson(Map<String, dynamic> json) : products = [] {
    final dynamic content = json['content'];
    if (content == null) {
      return;
    }

    if (content['data'] != null) {
      for (final dynamic product in content['data']) {
        products.add(WholesaleProductListModel.fromJson(product));
      }
    }

    if (content['pagination'] != null) {
      pagination = PaginationModel.fromJson(content['pagination']);
    }
  }
}
