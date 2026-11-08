class WholesaleAiTextModel {
  final String? data;
  final int? remainingCount;

  WholesaleAiTextModel({this.data, this.remainingCount});

  factory WholesaleAiTextModel.fromJson(Map<String, dynamic> json) {
    final dynamic content = json['content'];
    if (content is! Map<String, dynamic>) {
      return WholesaleAiTextModel();
    }

    return WholesaleAiTextModel(
      data: content['data']?.toString(),
      remainingCount: int.tryParse(content['remaining_count']?.toString() ?? ''),
    );
  }
}
