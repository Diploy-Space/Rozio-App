import 'package:sixvalley_vendor_app/features/order_details/domain/models/order_details_model.dart';

class WholesaleOrderBillingModel {
  final double itemsPrice;
  final double discount;
  final double tax;
  final double coupon;
  final double shipping;
  final double extraDiscount;
  final double referralDiscount;
  final bool isFreeShipping;
  final bool onlyDigital;

  const WholesaleOrderBillingModel({
    required this.itemsPrice,
    required this.discount,
    required this.tax,
    required this.coupon,
    required this.shipping,
    required this.extraDiscount,
    required this.referralDiscount,
    required this.isFreeShipping,
    required this.onlyDigital,
  });

  double get total => itemsPrice + tax - discount + (isFreeShipping ? 0 : shipping) - coupon - extraDiscount - referralDiscount;

  factory WholesaleOrderBillingModel.fromLines(List<OrderDetailsModel> lines) {
    double itemsPrice = 0;
    double discount = 0;
    bool onlyDigital = true;

    for (final OrderDetailsModel line in lines) {
      if (line.productDetails?.productType == 'physical') {
        onlyDigital = false;
      }
      itemsPrice += (line.price ?? 0) * (line.qty ?? 0);
      discount += line.discount ?? 0;
    }

    final order = lines.isNotEmpty ? lines.first.order : null;
    final double coupon = order?.discountAmount ?? 0;
    final bool isPos = order?.orderType == 'POS';

    double extraDiscount = 0;
    if (isPos) {
      extraDiscount = order?.extraDiscountType == 'percent'
        ? (itemsPrice - coupon - discount) * ((order?.extraDiscount ?? 0) / 100)
        : (order?.extraDiscount ?? 0);
    }

    return WholesaleOrderBillingModel(
      itemsPrice: itemsPrice,
      discount: discount,
      tax: order?.totalTaxAmount ?? 0,
      coupon: coupon,
      shipping: order?.shippingCost ?? 0,
      extraDiscount: extraDiscount,
      referralDiscount: isPos ? 0 : (order?.referAndEarnDiscount ?? 0),
      isFreeShipping: order?.isShippingFree ?? false,
      onlyDigital: onlyDigital,
    );
  }
}
