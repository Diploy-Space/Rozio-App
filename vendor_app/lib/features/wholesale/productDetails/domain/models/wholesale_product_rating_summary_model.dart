class WholesaleProductRatingSummaryModel {
  final double average;
  final int totalReviews;
  final double excellent;
  final double good;
  final double avg;
  final double belowAverage;
  final double poor;

  const WholesaleProductRatingSummaryModel({
    this.average = 0,
    this.totalReviews = 0,
    this.excellent = 0,
    this.good = 0,
    this.avg = 0,
    this.belowAverage = 0,
    this.poor = 0,
  });

  factory WholesaleProductRatingSummaryModel.fromJson(Map<String, dynamic> json) {
    final Map<int, int> counts = {};
    if (json['group-wise-rating'] is List) {
      for (final dynamic group in json['group-wise-rating']) {
        if (group is! Map) continue;
        final int? rating = int.tryParse('${group['rating']}');
        final int total = int.tryParse('${group['total']}') ?? 0;
        if (rating != null) counts[rating] = (counts[rating] ?? 0) + total;
      }
    }

    final int totalReviews = counts.values.fold(0, (sum, count) => sum + count);
    final int ratingSum = counts.entries.fold(0, (sum, entry) => sum + entry.key * entry.value);
    double percent(int rating) => totalReviews == 0 ? 0 : (counts[rating] ?? 0) * 100 / totalReviews;

    return WholesaleProductRatingSummaryModel(
      average: double.tryParse('${json['average_rating']}') ?? (totalReviews == 0 ? 0 : ratingSum / totalReviews),
      totalReviews: totalReviews,
      excellent: percent(5),
      good: percent(4),
      avg: percent(3),
      belowAverage: percent(2),
      poor: percent(1),
    );
  }
}
