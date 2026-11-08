class WholesaleAiPricingSetupModel {
  final String? priceSetup;

  final int? minimumOrderQty;
  final double? discount;
  final String? discountType;

  final double? variationDiscount;

  final List<int> taxIds;
  final List<WholesaleAiPriceTier> tiers;
  final int? remainingCount;

  WholesaleAiPricingSetupModel({
    this.priceSetup,
    this.minimumOrderQty,
    this.discount,
    this.discountType,
    this.variationDiscount,
    this.taxIds = const [],
    this.tiers = const [],
    this.remainingCount,
  });

  bool get isQuantityBased {
    final String setup = (priceSetup ?? '').toLowerCase();
    return setup.contains('quantity') || setup == 'both';
  }

  bool get isVariationBased {
    final String setup = (priceSetup ?? '').toLowerCase();
    return setup.contains('variation') || setup == 'both';
  }

  factory WholesaleAiPricingSetupModel.fromJson(Map<String, dynamic> json) {
    final dynamic content = json['content'];
    if (content is! Map<String, dynamic>) {
      return WholesaleAiPricingSetupModel();
    }

    final int? remainingCount = int.tryParse(content['remaining_count']?.toString() ?? '');

    final dynamic data = content['data'];
    if (data is! Map<String, dynamic>) {
      return WholesaleAiPricingSetupModel(remainingCount: remainingCount);
    }

    return WholesaleAiPricingSetupModel(
      priceSetup: data['price_setup']?.toString(),
      minimumOrderQty: int.tryParse(data['minimum_order_qty']?.toString() ?? ''),
      discount: double.tryParse(data['discount']?.toString() ?? ''),
      discountType: data['discount_type']?.toString(),
      variationDiscount: double.tryParse(data['variation_discount']?.toString() ?? ''),
      taxIds: _toIdList(data['tax_ids']),
      tiers: _toTierList(data['tiers']),
      remainingCount: remainingCount,
    );
  }

  static List<int> _toIdList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map((dynamic id) => int.tryParse(id?.toString() ?? ''))
        .whereType<int>()
        .toList();
  }

  static List<WholesaleAiPriceTier> _toTierList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> tier) => WholesaleAiPriceTier.fromJson(tier))
        .toList();
  }
}

class WholesaleAiPriceTier {
  final int? minQty;
  final int? maxQty;
  final double? unitPrice;

  WholesaleAiPriceTier({this.minQty, this.maxQty, this.unitPrice});

  factory WholesaleAiPriceTier.fromJson(Map<String, dynamic> json) {
    return WholesaleAiPriceTier(
      minQty: int.tryParse(json['min_qty']?.toString() ?? ''),
      maxQty: int.tryParse(json['max_qty']?.toString() ?? ''),
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? ''),
    );
  }
}
