class AuctionSaleModel {
  final int id;
  final String name;
  final String thumbnailUrl;
  final String endTime;
  final String status;
  final double startingPrice;
  final double soldAmount;
  final double vatTax;
  final double shippingFee;
  final double adminCommission;
  final bool? adminCommissionGiven;

  double get grossSalesBeforeCommission => soldAmount + vatTax + shippingFee;
  double get grossSalesAfterCommission => grossSalesBeforeCommission - adminCommission;

  const AuctionSaleModel({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.endTime,
    required this.status,
    required this.startingPrice,
    required this.soldAmount,
    required this.vatTax,
    required this.shippingFee,
    required this.adminCommission,
    required this.adminCommissionGiven,
  });

  factory AuctionSaleModel.fromJson(Map<String, dynamic> json) {
    return AuctionSaleModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      thumbnailUrl: _thumbnail(json['thumbnail_full_url']),
      endTime: json['end_time'] as String? ?? '',
      status: json['auction_current_status'] as String? ?? 'pending',
      startingPrice: _d(json['starting_price']),
      soldAmount: _d(json['current_highest_bid_amount']),
      vatTax: _d(json['total_tax_amount']),
      shippingFee: _d(json['shipping_fee']),
      adminCommission: _d(json['admin_commission']),
      adminCommissionGiven: json['admin_commission_given'] ?? false,
    );
  }

  static double _d(dynamic v) => v == null ? 0 : double.tryParse('$v') ?? 0;

  static String _thumbnail(dynamic v) {
    if (v is Map) return v['path']?.toString() ?? '';
    return v is String ? v : '';
  }
}

class AuctionSalesReportModel {
  int? totalAuctionsCreated;
  int? totalAuctionsSold;
  double? totalProductSalesValue;
  double? totalVatTax;
  double? totalShippingFee;
  double? grossSalesAmount;
  SalesTrend? salesTrend;
  int? totalSize;
  int? limit;
  int? offset;
  List<AuctionSaleModel>? auctions;

  AuctionSalesReportModel({
    this.totalAuctionsCreated,
    this.totalAuctionsSold,
    this.totalProductSalesValue,
    this.totalVatTax,
    this.totalShippingFee,
    this.grossSalesAmount,
    this.salesTrend,
    this.totalSize,
    this.limit,
    this.offset,
    this.auctions,
  });

  factory AuctionSalesReportModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawContent = json['content'];
    final Map<String, dynamic> content = rawContent is Map ? Map<String, dynamic>.from(rawContent) : json;

    final dynamic rawSummary = content['summary'];
    final Map<String, dynamic> summary = rawSummary is Map ? Map<String, dynamic>.from(rawSummary) : const {};

    final dynamic rawPagination = content['pagination'];
    final Map<String, dynamic> pagination = rawPagination is Map ? Map<String, dynamic>.from(rawPagination) : const {};

    final auctions = (content['data'] as List?)
            ?.whereType<Map>()
            .map((e) => AuctionSaleModel.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        [];

    return AuctionSalesReportModel(
      totalAuctionsCreated: int.tryParse('${summary['total_auctions_created']}') ?? 0,
      totalAuctionsSold: int.tryParse('${summary['total_auctions_sold']}') ?? 0,
      totalProductSalesValue: _toDouble(summary['total_product_sales_value']),
      totalVatTax: _toDouble(summary['total_vat_tax']),
      totalShippingFee: _toDouble(summary['total_shipping_fee']),
      grossSalesAmount: _toDouble(summary['gross_sales_amount']),
      salesTrend: summary['sales_trend'] is Map
          ? SalesTrend.fromJson(Map<String, dynamic>.from(summary['sales_trend']))
          : null,
      // Paging follows the delivered-row count, not the created-auction total.
      totalSize: int.tryParse('${pagination['total']}') ?? 0,
      limit: int.tryParse('${pagination['per_page']}') ?? 10,
      offset: int.tryParse('${pagination['current_page']}') ?? 1,
      auctions: auctions,
    );
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0;
    if (val is double) return val;
    return double.tryParse('$val') ?? 0;
  }
}

class SalesTrend {
  List<String>? labels;
  List<double>? data;

  SalesTrend({this.labels, this.data});

  factory SalesTrend.fromJson(Map<String, dynamic> json) {
    return SalesTrend(
      labels: (json['labels'] as List?)?.map((e) => e.toString()).toList(),
      data: (json['data'] as List?)?.map((e) => double.tryParse('$e') ?? 0.0).toList(),
    );
  }
}
