import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';

class WholesaleRestockBrandListModel {
  List<WholesaleRestockBrand>? brands;

  WholesaleRestockBrandListModel({this.brands});

  WholesaleRestockBrandListModel.fromJson(Map<String, dynamic> json) {
    brands = ApiListEnvelope.fromJson(json, legacyKeys: ['brands'])
        .data
        ?.whereType<Map>()
        .map((Map item) => WholesaleRestockBrand.fromJson(Map<String, dynamic>.from(item)))
        .toList() ?? <WholesaleRestockBrand>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (brands != null) {
      data['brands'] = brands!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WholesaleRestockBrand {
  int? id;
  String? name;
  String? image;
  int? brandAllProductsCount;
  int? productCount;
  bool? checked;

  WholesaleRestockBrand({this.id, this.name, this.image, this.brandAllProductsCount, this.productCount, this.checked});

  WholesaleRestockBrand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    brandAllProductsCount = json['brand_all_products_count'];
    productCount = json['product_count'];
    checked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['brand_all_products_count'] = brandAllProductsCount;
    data['product_count'] = productCount;
    return data;
  }
}
