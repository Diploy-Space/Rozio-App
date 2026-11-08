import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';

class AiLimitModel {
  final int? remainingCount;

  AiLimitModel({this.remainingCount});

  factory AiLimitModel.fromJson(dynamic json) {
    final int? count = ApiEnvelope.remainingCount(json);
    if (count != null) return AiLimitModel(remainingCount: count);

    final dynamic payload = ApiEnvelope.content(json)['data'];
    if (payload is Map || payload is List) return AiLimitModel();

    return AiLimitModel(remainingCount: int.tryParse(payload?.toString() ?? ''));
  }
}
