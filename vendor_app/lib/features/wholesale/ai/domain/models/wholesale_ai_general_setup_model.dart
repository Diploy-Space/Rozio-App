class WholesaleAiGeneralSetupModel {
  final int? categoryId;
  final int? subCategoryId;
  final int? subSubCategoryId;
  final int? brandId;
  final String? unitName;
  final String? sku;
  final int? reorderLevel;
  final double? shippingCost;
  final List<String> searchTags;
  final int? remainingCount;

  WholesaleAiGeneralSetupModel({
    this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
    this.brandId,
    this.unitName,
    this.sku,
    this.reorderLevel,
    this.shippingCost,
    this.searchTags = const [],
    this.remainingCount,
  });

  factory WholesaleAiGeneralSetupModel.fromJson(Map<String, dynamic> json) {
    final dynamic content = json['content'];
    if (content is! Map<String, dynamic>) {
      return WholesaleAiGeneralSetupModel();
    }

    final dynamic data = content['data'];
    if (data is! Map<String, dynamic>) {
      return WholesaleAiGeneralSetupModel(
        remainingCount: int.tryParse(content['remaining_count']?.toString() ?? ''),
      );
    }

    return WholesaleAiGeneralSetupModel(
      categoryId: int.tryParse(data['category_id']?.toString() ?? ''),
      subCategoryId: int.tryParse(data['sub_category_id']?.toString() ?? ''),
      subSubCategoryId: int.tryParse(data['sub_sub_category_id']?.toString() ?? ''),
      brandId: int.tryParse(data['brand_id']?.toString() ?? ''),
      unitName: data['unit_name']?.toString(),
      sku: data['sku']?.toString(),
      reorderLevel: int.tryParse(data['reorder_level']?.toString() ?? ''),
      shippingCost: double.tryParse(data['shipping_cost']?.toString() ?? ''),
      searchTags: _toTagList(data['search_tags']),
      remainingCount: int.tryParse(content['remaining_count']?.toString() ?? ''),
    );
  }

  static List<String> _toTagList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map((dynamic tag) => tag?.toString().trim() ?? '')
        .where((String tag) => tag.isNotEmpty)
        .toList();
  }
}
