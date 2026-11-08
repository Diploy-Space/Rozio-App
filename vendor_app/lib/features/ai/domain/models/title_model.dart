import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';

class TitleModel {
  String? message;
  String? data;
  int? remainingCount;

  TitleModel({this.message, this.data, this.remainingCount});

  TitleModel.fromJson(dynamic json) {
    final Map content = ApiEnvelope.content(json);

    message = ApiEnvelope.message(json);
    remainingCount = ApiEnvelope.remainingCount(json);

    final dynamic payload = content['data'];
    data = (payload is Map || payload is List) ? null : payload?.toString();
  }
}
