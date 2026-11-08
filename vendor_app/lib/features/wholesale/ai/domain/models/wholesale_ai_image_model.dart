class WholesaleAiImageModel {
  final String? name;
  final int? remainingCount;

  WholesaleAiImageModel({this.name, this.remainingCount});

  factory WholesaleAiImageModel.fromJson(dynamic json) {
    final dynamic content = json is Map ? json['content'] : null;
    if (content is! Map) {
      return WholesaleAiImageModel();
    }

    final dynamic data = content['data'];
    final String? name = data is Map ? data['name']?.toString().trim() : data?.toString().trim();

    return WholesaleAiImageModel(
      name: (name?.isNotEmpty ?? false) ? name : null,
      remainingCount: int.tryParse(content['remaining_count']?.toString() ?? ''),
    );
  }
}
