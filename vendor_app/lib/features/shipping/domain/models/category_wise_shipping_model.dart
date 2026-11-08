class AllCategoryShippingCost {
  int? id;
  int? sellerId;
  int? categoryId;
  String? categoryName;
  double? cost;
  bool? multiplyQty;
  String? createdAt;
  String? updatedAt;

  AllCategoryShippingCost(
      {this.id,
        this.sellerId,
        this.categoryId,
        this.categoryName,
        this.cost,
        this.multiplyQty,
        this.createdAt,
        this.updatedAt});

  AllCategoryShippingCost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerId = json['seller_id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    cost = json['cost'].toDouble();
    multiplyQty = json['multiply_qty'] == true || json['multiply_qty'] == 1;

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['seller_id'] = sellerId;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['cost'] = cost;
    data['multiply_qty'] = multiplyQty;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
