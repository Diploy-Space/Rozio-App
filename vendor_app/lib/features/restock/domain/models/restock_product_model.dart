import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';

class RestockProductModel {
  List<Data>? data;
  int? totalSize;
  int? limit;
  int? offset;
  int? lastPage;

  RestockProductModel({this.data, this.totalSize, this.limit, this.offset, this.lastPage});

  RestockProductModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);

    data = envelope.data
        ?.whereType<Map>()
        .map((Map item) => Data.fromJson(Map<String, dynamic>.from(item)))
        .toList() ?? <Data>[];

    totalSize = envelope.totalSize ?? data!.length;
    limit = envelope.limit ?? 10;
    offset = envelope.offset ?? 1;
    lastPage = envelope.lastPage;
  }
}

class Data {
  int? id;
  int? productId;
  String? variant;
  String? createdAt;
  String? updatedAt;
  int? restockProductCustomersCount;
  Product? product;
  List<String>? variantKeys;

  Data(
      {this.id,
        this.productId,
        this.variant,
        this.createdAt,
        this.updatedAt,
        this.restockProductCustomersCount,
        this.product,
        this.variantKeys
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    variant = json['variant'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    restockProductCustomersCount = json['restock_product_customers_count'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    if(json['variant_keys'] != null) {
      // variantKeys = json['variant_keys'].cast<String>();
      variantKeys = (json['variant_keys'] as List<dynamic>?)
          ?.where((element) => element != null) // Remove null values
          .map((element) => element as String) // Cast remaining elements to String
          .toList();
    }else {
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
