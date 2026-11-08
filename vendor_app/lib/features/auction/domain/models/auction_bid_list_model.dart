import 'package:sixvalley_vendor_app/features/auction/domain/models/auction_product_details_model.dart';
import 'package:sixvalley_vendor_app/helper/json_converter.dart';

class AuctionBidListModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<AuctionBid>? bids;

  AuctionBidListModel({this.totalSize, this.limit, this.offset, this.bids});

  factory AuctionBidListModel.fromJson(Map<String, dynamic> raw) {
    // v6 wraps the list in `content` with `data` + `pagination`; v3 is flat with `bids`.
    final Map<String, dynamic> json = raw['content'] is Map ? Map<String, dynamic>.from(raw['content']) : raw;
    final Map<String, dynamic>? pagination = json['pagination'] is Map ? Map<String, dynamic>.from(json['pagination']) : null;
    final dynamic items = json['data'] is List ? json['data'] : json['bids'];

    return AuctionBidListModel(
      totalSize: _toInt(pagination != null ? pagination['total'] : json['total_size']),
      limit: _toInt(pagination != null ? pagination['per_page'] : json['limit']),
      offset: _toInt(pagination != null ? pagination['current_page'] : json['offset']),
      bids: items is List
          ? items
              .whereType<Map>()
              .map((i) => AuctionBid.fromJson(Map<String, dynamic>.from(i)))
              .toList()
          : null,
    );
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

class AuctionBid {
  int? id;
  int? auctionProductId;
  double? bidAmount;
  bool? isAutoBid;
  bool? isWithdrawBid;
  bool? isRollbackBid;
  String? bidTime;
  bool? isLeadBid;
  String? claimStartTime;
  AuctionBidCustomer? bidder;
  UserContext? userContext;

  AuctionBid({
    this.id,
    this.auctionProductId,
    this.bidAmount,
    this.isAutoBid,
    this.isWithdrawBid,
    this.isRollbackBid,
    this.bidTime,
    this.isLeadBid,
    this.claimStartTime,
    this.bidder,
    this.userContext,
  });

  factory AuctionBid.fromJson(Map<String, dynamic> json) {
    // v6 names the bidder `bidder`; v3 called it `customer`.
    final dynamic bidder = json['bidder'] ?? json['customer'];
    return AuctionBid(
      id: _toInt(json['id']),
      auctionProductId: _toInt(json['auction_product_id']),
      bidAmount: _toDouble(json['bid_amount']),
      isAutoBid: JsonConverter.toBool(json['is_auto_bid']) ?? false,
      isWithdrawBid: JsonConverter.toBool(json['is_withdraw_bid']) ?? false,
      isRollbackBid: JsonConverter.toBool(json['is_rollback_bid']) ?? false,
      bidTime: json['bid_time']?.toString(),
      isLeadBid: JsonConverter.toBool(json['is_lead_bid']) ?? false,
      claimStartTime: json['claim_start_time']?.toString(),
      bidder: bidder is Map ? AuctionBidCustomer.fromJson(Map<String, dynamic>.from(bidder)) : null,
      userContext: json['user_context'] is Map
          ? UserContext.fromJson(Map<String, dynamic>.from(json['user_context']))
          : null,
    );
  }
}

class UserContext {
  int? myPosition;
  bool? isLeading;
  bool? isWinner;
  String? claimEndTime;
  int? claimTimeRemaining;
  bool? isClaimExpired;

  UserContext({
    this.myPosition,
    this.isLeading,
    this.isWinner,
    this.claimEndTime,
    this.claimTimeRemaining,
    this.isClaimExpired,
  });

  factory UserContext.fromJson(Map<String, dynamic> json) {
    return UserContext(
      myPosition: _toInt(json['my_position']),
      isLeading: json['is_leading'] == true,
      isWinner: json['is_winner'] == true,
      claimEndTime: json['claim_end_time']?.toString(),
      claimTimeRemaining: _toInt(json['claim_time_remaining']),
      isClaimExpired: json['is_claim_expired'] == true,
    );
  }
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString());
}
