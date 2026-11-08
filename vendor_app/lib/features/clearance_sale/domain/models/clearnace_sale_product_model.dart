import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/helper/json_converter.dart';

class ClearanceSaleProductModel {
  int? totalSize;
  int? limit;
  int? offset;
  String? search;
  List<Products>? products;

  ClearanceSaleProductModel(
      {this.totalSize, this.limit, this.offset, this.search, this.products});

  ClearanceSaleProductModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);

    products = envelope.data?.whereType<Map>()
        .map((Map item) => Products.fromJson(Map<String, dynamic>.from(item))).toList() ?? <Products>[];

    totalSize = envelope.totalSize ?? products!.length;
    limit = envelope.limit ?? 10;
    offset = envelope.offset ?? 1;
    search = envelope.read('search')?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    data['search'] = search;
    if (products != null) {
      data['data'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Products {
  int? id;
  int? productId;
  int? setupId;
  bool? isActive;
  String? discountType;
  double? discountAmount;
  Product? product;

  Products(
      {this.id,
        this.productId,
        this.setupId,
        this.isActive,
        this.discountType,
        this.discountAmount,
        this.product});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    setupId = json['setup_id'];
    isActive = JsonConverter.toBool(json['is_active']);
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'] !=null ? double.tryParse(json['discount_amount'].toString()) : null;
    product = json['product'] != null ? Product.fromJson(_productJson(json)) : null;
  }

  Map<String, dynamic> _productJson(Map<String, dynamic> json) {
    final Map<String, dynamic> productJson = Map<String, dynamic>.from(json['product']);

    productJson['variation'] ??= productJson['variations'];
    productJson['clearance_sale'] ??= {
      'id': id,
      'product_id': productId,
      'setup_id': setupId,
      'is_active': (isActive ?? false) ? 1 : 0,
      'discount_type': discountType,
      'discount_amount': discountAmount,
    };

    return productJson;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['setup_id'] = setupId;
    data['is_active'] = isActive;
    data['discount_type'] = discountType;
    data['discount_amount'] = discountAmount;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}
