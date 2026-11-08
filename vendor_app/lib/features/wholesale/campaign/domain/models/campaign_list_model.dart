import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/models/campaign_model.dart';

class CampaignListModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<CampaignModel>? campaigns;

  CampaignListModel({this.totalSize, this.limit, this.offset, this.campaigns});

  CampaignListModel.fromJson(Map<String, dynamic> raw) {
    final Map<String, dynamic> json = raw['content'] is Map ? Map<String, dynamic>.from(raw['content']) : raw;
    final Map<String, dynamic>? pagination =
        json['pagination'] is Map ? Map<String, dynamic>.from(json['pagination']) : null;

    totalSize = int.tryParse('${pagination?['total']}');
    limit = int.tryParse('${pagination?['per_page']}');
    offset = int.tryParse('${pagination?['current_page']}');

    if (json['data'] is List) {
      campaigns = (json['data'] as List)
          .map((e) => CampaignModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
  }
}
