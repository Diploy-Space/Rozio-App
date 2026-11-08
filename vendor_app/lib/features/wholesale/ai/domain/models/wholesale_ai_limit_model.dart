class WholesaleAiLimitModel {
  final int remainingCount;

  WholesaleAiLimitModel({this.remainingCount = 0});

  factory WholesaleAiLimitModel.fromJson(Map<String, dynamic> json) {
    final dynamic content = json['content'];
    if (content is! Map<String, dynamic>) {
      return WholesaleAiLimitModel();
    }

    final dynamic count = content['remaining_count'];
    return WholesaleAiLimitModel(remainingCount: count is int ? count : (int.tryParse(count?.toString() ?? '') ?? 0));
  }
}
