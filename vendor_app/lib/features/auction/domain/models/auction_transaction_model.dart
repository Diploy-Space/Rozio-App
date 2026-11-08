class AuctionTransactionListModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<AuctionTransactionModel>? transactions;

  AuctionTransactionListModel({this.totalSize, this.limit, this.offset, this.transactions});

  AuctionTransactionListModel.fromJson(Map<String, dynamic> response) {
    // v6 wraps the list in `content`; the pagination block may use either key set.
    final Map json = response['content'] is Map ? response['content'] : response;
    final Map pagination = json['pagination'] is Map ? json['pagination'] : json;
    totalSize = int.tryParse('${pagination['total'] ?? pagination['total_size']}');
    limit = int.tryParse('${pagination['per_page'] ?? pagination['limit']}');
    offset = int.tryParse('${pagination['current_page'] ?? pagination['offset']}');
    final raw = json['data'] ?? json['transactions'];
    if (raw != null) {
      final items = raw is List ? raw : (raw as Map).values.toList();
      transactions = items.map((v) => AuctionTransactionModel.fromJson(Map<String, dynamic>.from(v))).toList();
    }
  }
}

class AuctionTransactionModel {
  int? auctionProductId;
  double? amount;
  String? date;
  String? type;
  String? transactionType;

  AuctionTransactionModel({this.auctionProductId, this.amount, this.date, this.type, this.transactionType});

  AuctionTransactionModel.fromJson(Map<String, dynamic> json) {
    auctionProductId = int.tryParse('${json['auction_product_id']}');
    amount = double.tryParse('${json['amount']}');
    date = json['date'];
    type = json['type'];
    transactionType = json['transaction_type'];
  }
}
