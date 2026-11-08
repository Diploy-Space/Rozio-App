int _toInt(dynamic value) => value is int ? value : (num.tryParse('$value')?.toInt() ?? 0);

double _toDouble(dynamic value) => value is num ? value.toDouble() : (double.tryParse('$value') ?? 0);

int? _secondsUntil(dynamic isoTime) {
  final DateTime? time = isoTime == null ? null : DateTime.tryParse('$isoTime');
  if (time == null) return null;
  final int seconds = time.difference(DateTime.now()).inSeconds;
  return seconds > 0 ? seconds : 0;
}

class AuctionBusinessAnalyticsModel {
  final int liveAuctions;
  final int upcoming;
  final int purchaseComplete;
  final int unsold;

  const AuctionBusinessAnalyticsModel({
    required this.liveAuctions,
    required this.upcoming,
    required this.purchaseComplete,
    required this.unsold,
  });

  factory AuctionBusinessAnalyticsModel.fromJson(Map json) {
    return AuctionBusinessAnalyticsModel(
      liveAuctions: _toInt(json['live']),
      upcoming: _toInt(json['upcoming']),
      purchaseComplete: _toInt(json['purchase_complete']),
      unsold: _toInt(json['unsold']),
    );
  }

  static const AuctionBusinessAnalyticsModel empty = AuctionBusinessAnalyticsModel(liveAuctions: 0, upcoming: 0, purchaseComplete: 0, unsold: 0);
}

class AuctionBidAnalyticsModel {
  final int totalBids;
  final int activeBidders;
  final double highestBid;
  final int averageBidsPerAuction;

  const AuctionBidAnalyticsModel({
    required this.totalBids,
    required this.activeBidders,
    required this.highestBid,
    required this.averageBidsPerAuction,
  });

  factory AuctionBidAnalyticsModel.fromJson(Map json) {
    return AuctionBidAnalyticsModel(
      totalBids: _toInt(json['total_bids']),
      activeBidders: _toInt(json['active_bidders']),
      highestBid: _toDouble(json['highest_bid']),
      averageBidsPerAuction: _toInt(json['average_bids_per_auction']),
    );
  }

  static const AuctionBidAnalyticsModel empty = AuctionBidAnalyticsModel(totalBids: 0, activeBidders: 0, highestBid: 0, averageBidsPerAuction: 0);
}

class AuctionTopPerformingModel {
  final int id;
  final String title;
  final String? thumbnail;
  final double highestBid;
  final int views;
  final int bidCount;
  final int closesInSeconds;
  final bool isLive;

  const AuctionTopPerformingModel({
    required this.id,
    required this.title,
    this.thumbnail,
    required this.highestBid,
    required this.views,
    required this.bidCount,
    required this.closesInSeconds,
    this.isLive = true,
  });

  factory AuctionTopPerformingModel.fromJson(Map json) {
    return AuctionTopPerformingModel(
      id: _toInt(json['id']),
      title: json['title']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString(),
      highestBid: _toDouble(json['highest_bid']),
      views: _toInt(json['views']),
      bidCount: _toInt(json['bid_count']),
      closesInSeconds: _secondsUntil(json['ends_at']) ?? 0,
      isLive: json['is_live'] == true || json['is_live'] == 1,
    );
  }
}

class AuctionRecentlyEndedModel {
  final int id;
  final String title;
  final String? thumbnail;
  final double finalBidPrice;
  final String winnerName;
  final String? winnerAvatar;
  final String statusKey;
  final int? remainingClaimSeconds;

  const AuctionRecentlyEndedModel({
    required this.id,
    required this.title,
    this.thumbnail,
    required this.finalBidPrice,
    required this.winnerName,
    this.winnerAvatar,
    required this.statusKey,
    this.remainingClaimSeconds,
  });

  factory AuctionRecentlyEndedModel.fromJson(Map json) {
    return AuctionRecentlyEndedModel(
      id: _toInt(json['id']),
      title: json['title']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString(),
      finalBidPrice: _toDouble(json['final_bid_price']),
      winnerName: json['winner_name']?.toString() ?? '',
      winnerAvatar: json['winner_avatar']?.toString(),
      statusKey: json['status']?.toString() ?? '',
      remainingClaimSeconds: _secondsUntil(json['claim_expires_at']),
    );
  }
}
