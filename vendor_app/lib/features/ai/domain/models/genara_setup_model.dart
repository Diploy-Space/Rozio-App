import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';

class GeneralSetupModel {
  String? message;
  Data? data;
  int? remainingCount;

  GeneralSetupModel({this.message, this.data, this.remainingCount});

  GeneralSetupModel.fromJson(dynamic json) {
    final Map content = ApiEnvelope.content(json);

    message = ApiEnvelope.message(json);
    remainingCount = ApiEnvelope.remainingCount(json);

    final dynamic payload = content['data'];
    data = payload is Map ? Data.fromJson(Map<String, dynamic>.from(payload)) : null;
  }
}

class Data {
  String? categoryName;
  String? subCategoryName;
  String? subSubCategoryName;
  String? brandName;
  String? unitName;
  String? productType;
  String? deliveryType;
  List<String>? searchTags;
  int? categoryId;
  int? subCategoryId;
  int? subSubCategoryId;
  int? brandId;

  Data(
      {this.categoryName,
        this.subCategoryName,
        this.subSubCategoryName,
        this.brandName,
        this.unitName,
        this.productType,
        this.deliveryType,
        this.searchTags,
        this.categoryId,
        this.subCategoryId,
        this.subSubCategoryId,
        this.brandId});

  Data.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name']?.toString();
    subCategoryName = json['sub_category_name']?.toString();
    subSubCategoryName = json['sub_sub_category_name']?.toString();
    brandName = json['brand_name']?.toString();
    unitName = json['unit_name']?.toString();
    productType = json['product_type']?.toString();
    deliveryType = json['delivery_type']?.toString();
    searchTags = _toStringList(json['search_tags']);
    categoryId = int.tryParse(json['category_id']?.toString() ?? '');
    subCategoryId = int.tryParse(json['sub_category_id']?.toString() ?? '');
    subSubCategoryId = int.tryParse(json['sub_sub_category_id']?.toString() ?? '');
    brandId = int.tryParse(json['brand_id']?.toString() ?? '');
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) return const [];

    return value
        .map((dynamic item) => item?.toString().trim() ?? '')
        .where((String item) => item.isNotEmpty)
        .toList();
  }
}
