import 'package:sixvalley_vendor_app/helper/json_converter.dart';

class ClearanceConfigModel {
  int? id;
  int? shopId;
  bool? isActive;
  String? discountType;
  double? discountAmount;
  String? offerActiveTime;
  String? offerActiveRangeStart;
  String? offerActiveRangeEnd;
  String? durationStartDate;
  String? durationEndDate;
  bool? showInShop;
  bool? showInHomepageOnce;
  dynamic seo;

  ClearanceConfigModel(
      {this.id,
        this.shopId,
        this.isActive,
        this.discountType,
        this.discountAmount,
        this.offerActiveTime,
        this.offerActiveRangeStart,
        this.offerActiveRangeEnd,
        this.durationStartDate,
        this.durationEndDate,
        this.showInShop,
        this.showInHomepageOnce,
        this.seo,
      });

  ClearanceConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    isActive = JsonConverter.toBool(json['is_active']);
    discountType = json['discount_type'];
    discountAmount = double.tryParse('${json['discount_amount']}');
    offerActiveTime = json['offer_active_time'];
    offerActiveRangeStart = json['offer_active_range_start'];
    offerActiveRangeEnd = json['offer_active_range_end'];
    durationStartDate = json['duration_start_date'];
    durationEndDate = json['duration_end_date'];
    showInShop = JsonConverter.toBool(json['show_in_shop']);
    showInHomepageOnce = JsonConverter.toBool(json['show_in_homepage_once']);
    seo = json['seo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['is_active'] = isActive;
    data['discount_type'] = discountType;
    data['discount_amount'] = discountAmount;
    data['offer_active_time'] = offerActiveTime;
    data['offer_active_range_start'] = offerActiveRangeStart;
    data['offer_active_range_end'] = offerActiveRangeEnd;
    data['duration_start_date'] = durationStartDate;
    data['duration_end_date'] = durationEndDate;
    data['show_in_shop'] = showInShop;
    data['show_in_homepage_once'] = showInHomepageOnce;
    data['seo'] = seo;
    return data;
  }
}
