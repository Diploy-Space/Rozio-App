class WholesaleTaxModel {
  int? id;
  String? name;
  double? taxRate;

  WholesaleTaxModel({this.id, this.name, this.taxRate});

  WholesaleTaxModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    taxRate = double.tryParse(json['tax_rate'].toString());
  }
}

class WholesaleVatTaxSetupModel {
  bool isProductWise;
  bool isCategoryWise;
  bool isIncluded;

  WholesaleVatTaxSetupModel({
    this.isProductWise = false,
    this.isCategoryWise = false,
    this.isIncluded = false,
  });

  factory WholesaleVatTaxSetupModel.fromJson(Map<String, dynamic> json) {
    final dynamic content = json['content'];
    if (content is! Map) {
      return WholesaleVatTaxSetupModel();
    }

    return WholesaleVatTaxSetupModel(
      isProductWise: content['is_product_wise'] == true || content['is_product_wise'] == 1,
      isCategoryWise: content['is_category_wise'] == true || content['is_category_wise'] == 1,
      isIncluded: content['is_included'] == true || content['is_included'] == 1,
    );
  }
}
