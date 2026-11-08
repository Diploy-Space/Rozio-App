import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';

class WholesaleCouponSetupModel {
  Map<String, String> couponTypes = {};
  Map<String, String> discountTypes = {};
  Map<String, WholesaleCouponFieldVisibility> fieldVisibility = {};

  WholesaleCouponSetupModel({Map<String, String>? couponTypes, Map<String, String>? discountTypes, Map<String, WholesaleCouponFieldVisibility>? fieldVisibility}) {
    this.couponTypes = couponTypes ?? {};
    this.discountTypes = discountTypes ?? {};
    this.fieldVisibility = fieldVisibility ?? {};
  }

  WholesaleCouponSetupModel.fromJson(Map<String, dynamic> json) {
    final Map content = ApiEnvelope.content(json);
    couponTypes = _asStringMap(content['coupon_types']);
    discountTypes = _asStringMap(content['discount_types']);
    if (content['field_visibility'] is Map) {
      (content['field_visibility'] as Map).forEach((key, value) {
        if (value is Map) {
          fieldVisibility[key.toString()] = WholesaleCouponFieldVisibility.fromJson(Map<String, dynamic>.from(value));
        }
      });
    }
  }

  factory WholesaleCouponSetupModel.fallback() => WholesaleCouponSetupModel(
    couponTypes: {'discount_on_purchase': 'Discount on Purchase', 'free_delivery': 'Free Delivery'},
    discountTypes: {'amount': 'Amount', 'percentage': 'Percentage'},
    fieldVisibility: {
      'discount_on_purchase': WholesaleCouponFieldVisibility(targeting: true, discount: true),
      'free_delivery': WholesaleCouponFieldVisibility(targeting: true, discount: false),
    },
  );

  WholesaleCouponFieldVisibility visibilityOf(String? couponType) =>
      fieldVisibility[couponType] ?? WholesaleCouponFieldVisibility(targeting: true, discount: couponType != 'free_delivery');

  static Map<String, String> _asStringMap(dynamic value) {
    if (value is! Map) return {};
    return value.map((key, label) => MapEntry(key.toString(), label.toString()));
  }
}

class WholesaleCouponFieldVisibility {
  bool targeting;
  bool discount;

  WholesaleCouponFieldVisibility({required this.targeting, required this.discount});

  factory WholesaleCouponFieldVisibility.fromJson(Map<String, dynamic> json) => WholesaleCouponFieldVisibility(
    targeting: json['targeting'] == true,
    discount: json['discount'] == true,
  );
}
