class WholesaleTopProductModel {
  final int? id;
  final String? name;
  final String? thumbnail;
  final double? minPrice;
  final double? maxPrice;
  final double? discount;
  final String? discountType;
  final int? moq;
  final int? soldCount;
  final double? rating;

  const WholesaleTopProductModel({
    this.id,
    this.name,
    this.thumbnail,
    this.minPrice,
    this.maxPrice,
    this.discount,
    this.discountType,
    this.moq,
    this.soldCount,
    this.rating,
  });

  factory WholesaleTopProductModel.fromProductJson(Map<String, dynamic> json, {int? soldCount, bool withRating = false}) {
    final double? unitPrice = double.tryParse('${json['unit_price']}');
    final dynamic priceRange = json['price_range'];
    final dynamic thumbnail = json['thumbnail_full_url'];

    return WholesaleTopProductModel(
      id: json['id'],
      name: json['name'],
      thumbnail: thumbnail is Map ? thumbnail['path'] : null,
      minPrice: (priceRange is Map ? double.tryParse('${priceRange['min']}') : null) ?? unitPrice,
      maxPrice: (priceRange is Map ? double.tryParse('${priceRange['max']}') : null) ?? unitPrice,
      discount: double.tryParse('${json['discount']}'),
      discountType: json['discount_type'],
      moq: int.tryParse('${json['minimum_order_qty']}'),
      soldCount: soldCount,
      rating: withRating ? double.tryParse('${json['ratings_average']}') : null,
    );
  }

  factory WholesaleTopProductModel.fromTopSellingJson(Map<String, dynamic> json) {
    final Map<String, dynamic> product = json['product'] is Map ? Map<String, dynamic>.from(json['product']) : {'id': json['product_id']};
    return WholesaleTopProductModel.fromProductJson(product, soldCount: int.tryParse('${json['count']}') ?? 0);
  }

  factory WholesaleTopProductModel.fromMostPopularJson(Map<String, dynamic> json) {
    return WholesaleTopProductModel.fromProductJson(json, withRating: true);
  }
}
