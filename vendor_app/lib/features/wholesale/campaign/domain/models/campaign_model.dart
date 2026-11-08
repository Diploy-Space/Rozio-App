import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/models/campaign_item_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/enums/campaign_status.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';

class CampaignModel {
  final int? id;
  final String? title;
  final String? description;
  final ImageFullUrl? imageFullUrl;
  final double? minDiscount;
  final double? maxDiscount;
  final String? startDate;
  final String? endDate;
  final String? dailyStartTime;
  final String? dailyEndTime;
  final String? scheduleStatus;
  final bool isJoinable;
  final bool acceptsItemChanges;
  final CampaignStatus status;
  final bool? participationIsActive;
  final int? itemCount;
  final String? joinedAt;
  final String? createdAt;
  final String? denyNote;
  final List<CampaignItemModel>? items;

  CampaignModel({
    this.id,
    this.title,
    this.description,
    this.imageFullUrl,
    this.minDiscount,
    this.maxDiscount,
    this.startDate,
    this.endDate,
    this.dailyStartTime,
    this.dailyEndTime,
    this.scheduleStatus,
    this.isJoinable = false,
    this.acceptsItemChanges = false,
    this.status = CampaignStatus.notJoined,
    this.participationIsActive,
    this.itemCount,
    this.joinedAt,
    this.createdAt,
    this.denyNote,
    this.items,
  });

  String? get bannerImage => imageFullUrl?.path;

  String? get activeTime => DateConverter.clockStringToTimeRange(dailyStartTime, dailyEndTime);

  String? get duration => DateConverter.utcStringToAuctionDuration(startDate, endDate);

  bool get isJoined => status != CampaignStatus.notJoined;

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? participation =
        json['participation'] is Map ? Map<String, dynamic>.from(json['participation']) : null;

    final dynamic itemList = participation != null ? participation['items'] : json['items'];

    return CampaignModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageFullUrl: json['image_full_url'] != null ? ImageFullUrl.fromDynamic(json['image_full_url']) : null,
      minDiscount: json['min_discount'] != null ? double.tryParse('${json['min_discount']}') : null,
      maxDiscount: json['max_discount'] != null ? double.tryParse('${json['max_discount']}') : null,
      startDate: json['start_date'],
      endDate: json['end_date'],
      dailyStartTime: json['daily_start_time'],
      dailyEndTime: json['daily_end_time'],
      scheduleStatus: json['schedule_status'],
      isJoinable: json['is_joinable'] ?? false,
      acceptsItemChanges: json['accepts_item_changes'] ?? false,
      status: CampaignStatus.fromString(
        participation != null ? participation['status'] : json['participation_status'],
      ),
      participationIsActive: participation != null ? participation['is_active'] : json['participation_is_active'],
      itemCount: json['enrolled_item_count'] ?? (itemList is List ? itemList.length : null),
      joinedAt: participation?['joined_at'],
      createdAt: json['created_at'],
      denyNote: participation?['deny_note'] ?? json['deny_note'],
      items: itemList is List
          ? itemList.map((e) => CampaignItemModel.fromJson(Map<String, dynamic>.from(e))).toList() : null,
    );
  }
}
