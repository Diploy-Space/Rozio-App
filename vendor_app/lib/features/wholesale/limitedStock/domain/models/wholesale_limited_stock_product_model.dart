import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_product_detail_model.dart';

class WholesaleLimitedStockVariation {
  final String? type;
  final String? sku;
  final double? price;
  int qty;

  WholesaleLimitedStockVariation({this.type, this.sku, this.price, this.qty = 0});

  factory WholesaleLimitedStockVariation.fromStock(WholesaleStock stock) {
    return WholesaleLimitedStockVariation(
      type: stock.variant,
      sku: stock.sku,
      price: stock.price,
      qty: stock.qty?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'price': price, 'sku': sku, 'qty': qty};
}

class WholesaleLimitedStockProductModel {
  final int? id;
  final String? name;
  final String? thumbnail;
  int currentStock;
  final List<WholesaleLimitedStockVariation> variation;

  WholesaleLimitedStockProductModel({
    this.id,
    this.name,
    this.thumbnail,
    this.currentStock = 0,
    this.variation = const [],
  });

  factory WholesaleLimitedStockProductModel.fromJson(Map<String, dynamic> json) {
    final dynamic thumbnail = json['thumbnail_full_url'];
    return WholesaleLimitedStockProductModel(
      id: int.tryParse('${json['id']}'),
      name: json['name'],
      thumbnail: thumbnail is Map ? thumbnail['path'] : null,
      currentStock: int.tryParse('${json['current_stock']}') ?? 0,
    );
  }

  WholesaleLimitedStockProductModel withStock(WholesaleProductDetailModel details) {
    return WholesaleLimitedStockProductModel(
      id: id,
      name: name,
      thumbnail: thumbnail,
      currentStock: details.currentStock ?? currentStock,
      variation: details.stocks.map(WholesaleLimitedStockVariation.fromStock).toList(),
    );
  }
}
