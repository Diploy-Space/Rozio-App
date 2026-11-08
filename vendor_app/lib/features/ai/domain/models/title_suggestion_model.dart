import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';

class TitleSuggestionModel {
  Data? data;
  int? remainingCount;

  TitleSuggestionModel({this.data, this.remainingCount});

  TitleSuggestionModel.fromJson(dynamic json) {
    final Map content = ApiEnvelope.content(json);

    remainingCount = ApiEnvelope.remainingCount(json);

    final dynamic payload = content['data'];
    data = payload is Map ? Data.fromJson(Map<String, dynamic>.from(payload)) : null;
  }
}

class Data {
  List<String>? titles;

  Data({this.titles});

  Data.fromJson(Map<String, dynamic> json) {
    titles = _toStringList(json['titles']);
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) return const [];

    return value
        .map((dynamic item) => item?.toString().trim() ?? '')
        .where((String item) => item.isNotEmpty)
        .toList();
  }
}
