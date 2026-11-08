import 'package:sixvalley_vendor_app/helper/json_converter.dart';

class VerificationCriteriaModel {
  bool? isVerified;
  bool? isBadgeEnabled;
  bool? isQualified;
  bool? showPrompt;
  List<VerificationCriterion> criteria = [];

  VerificationCriteriaModel.fromJson(Map<String, dynamic> json) {
    isVerified = JsonConverter.toBool(json['is_verified']) ?? false;
    isBadgeEnabled = JsonConverter.toBool(json['is_badge_enabled']) ?? false;
    isQualified = JsonConverter.toBool(json['is_qualified']) ?? false;
    showPrompt = JsonConverter.toBool(json['show_prompt']) ?? false;
    if (json['criteria'] is List) {
      criteria = List<VerificationCriterion>.from((json['criteria'] as List).map((item) => VerificationCriterion.fromJson(Map<String, dynamic>.from(item))));
    }
  }
}

class VerificationCriterion {
  String? key;
  String? leading;
  String? highlight;
  String? trailing;
  String? label;
  String? current;
  bool met = false;

  VerificationCriterion.fromJson(Map<String, dynamic> json) {
    key = json['key']?.toString();
    leading = json['leading']?.toString();
    highlight = json['highlight']?.toString();
    trailing = json['trailing']?.toString();
    label = json['label']?.toString();
    current = json['current']?.toString();
    met = JsonConverter.toBool(json['met']) ?? false;
  }
}
