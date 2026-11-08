import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';

class WholesaleRestockProductListModel {
  List<WholesaleRestockRequestData>? data;
  int? totalSize;
  int? limit;
  int? offset;
  int? lastPage;

  WholesaleRestockProductListModel({this.data, this.totalSize, this.limit, this.offset, this.lastPage});

  WholesaleRestockProductListModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);

    data = envelope.data
        ?.whereType<Map>()
        .map((Map item) => WholesaleRestockRequestData.fromJson(Map<String, dynamic>.from(item)))
        .toList() ?? <WholesaleRestockRequestData>[];

    totalSize = envelope.totalSize ?? data!.length;
    limit = envelope.limit ?? 10;
    offset = envelope.offset ?? 1;
    lastPage = envelope.lastPage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    map['total_size'] = totalSize;
    map['limit'] = limit;
    map['offset'] = offset;
    return map;
  }
}

class WholesaleRestockRequestData {
  int? id;
  int? productId;
  String? variant;
  String? createdAt;
  String? updatedAt;
  int? restockProductCustomersCount;
  WholesaleRestockProduct? product;
  List<String>? variantKeys;

  WholesaleRestockRequestData({
    this.id,
    this.productId,
    this.variant,
    this.createdAt,
    this.updatedAt,
    this.restockProductCustomersCount,
    this.product,
    this.variantKeys,
  });

  WholesaleRestockRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    variant = json['variant'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    restockProductCustomersCount = json['restock_product_customers_count'];
    product = json['product'] != null ? WholesaleRestockProduct.fromJson(json['product']) : null;
    if (json['variant_keys'] != null) {
      variantKeys = (json['variant_keys'] as List<dynamic>?)
          ?.where((element) => element != null)
          .map((element) => element as String)
          .toList();
    } else {
      variantKeys = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['variant'] = variant;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['restock_product_customers_count'] = restockProductCustomersCount;
    return data;
  }
}

class WholesaleRestockProduct {
  int? id;
  String? name;
  ImageFullUrl? thumbnailFullUrl;
  double? unitPrice;
  double? discount;
  String? discountType;
  int? currentStock;
  List<WholesaleRestockVariation>? variation;
  List<WholesaleRestockRating>? rating;

  WholesaleRestockProduct({
    this.id,
    this.name,
    this.thumbnailFullUrl,
    this.unitPrice,
    this.discount,
    this.discountType,
    this.currentStock,
    this.variation,
    this.rating,
  });

  WholesaleRestockProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    thumbnailFullUrl = json['thumbnail_full_url'] != null ? ImageFullUrl.fromJson(json['thumbnail_full_url']) : null;
    unitPrice = json['unit_price']?.toDouble();
    discount = json['discount']?.toDouble();
    discountType = json['discount_type'];
    currentStock = json['current_stock'];
    if (json['variation'] != null) {
      variation = <WholesaleRestockVariation>[];
      json['variation'].forEach((v) {
        variation!.add(WholesaleRestockVariation.fromJson(v));
      });
    }
    if (json['rating'] != null) {
      rating = <WholesaleRestockRating>[];
      json['rating'].forEach((v) {
        rating!.add(WholesaleRestockRating.fromJson(v));
      });
    }
  }
}

class WholesaleRestockVariation {
  String? type;
  double? price;
  String? sku;
  int? qty;

  WholesaleRestockVariation({this.type, this.price, this.sku, this.qty});

  WholesaleRestockVariation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = json['price']?.toDouble();
    sku = json['sku'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['price'] = price;
    data['sku'] = sku;
    data['qty'] = qty;
    return data;
  }
}

class WholesaleRestockRating {
  String? average;
  int? productId;

  WholesaleRestockRating({this.average, this.productId});

  WholesaleRestockRating.fromJson(Map<String, dynamic> json) {
    average = json['average'].toString();
    productId = json['product_id'];
  }
}

class ImageFullUrl {
  String? key;
  String? path;
  int? status;

  ImageFullUrl({this.key, this.path, this.status});

  ImageFullUrl.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    path = json['path'];
    status = json['status'];
  }
}
