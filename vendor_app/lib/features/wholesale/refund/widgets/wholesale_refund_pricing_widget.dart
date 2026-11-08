import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_details_model.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleRefundDataWidget extends StatelessWidget {
  final RefundModel refund;
  final String? requestedAt;
  const WholesaleRefundDataWidget({super.key, required this.refund, this.requestedAt});

  @override
  Widget build(BuildContext context) {
    final String? createdAt = requestedAt ?? refund.createdAt;
    final String? paymentMethod = refund.order?.paymentMethod;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (createdAt != null)
            _row(context, getTranslated('order_date_details', context) ?? 'Date', DateConverter.localDateToIsoStringAMPMOrder(DateTime.parse(createdAt))),
          _row(context, getTranslated('refund_id', context) ?? 'Refund Id', '#${refund.id}'),
          _row(context, getTranslated('order_id_small', context) ?? 'Order Id', '#${refund.orderId}'),
          if (paymentMethod != null)
            _row(context, getTranslated('payment_method', context) ?? 'Payment Method', getTranslated(paymentMethod, context) ?? paymentMethod.replaceAll('_', ' ')),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color)),
          Text(value, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
        ],
      ),
    );
  }
}

class WholesaleRefundPricingWidget extends StatelessWidget {
  final RefundDetailsModel details;
  const WholesaleRefundPricingWidget({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final int quantity = details.quntity ?? 1;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CustomAssetImageWidget(Images.billingSummeryIcon, height: Dimensions.iconSizeDefault, width: Dimensions.iconSizeDefault),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Text(getTranslated('billing_summery', context) ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
          ]),
          Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).hintColor.withValues(alpha: .3)),

          _priceRow(context, getTranslated('product_price', context) ?? 'Product Price', (details.productPrice ?? 0) * quantity, qty: quantity, isPositive: true),
          _priceRow(context, getTranslated('product_discount', context) ?? 'Discount', details.productTotalDiscount ?? 0, isNegative: true),
          _priceRow(context, getTranslated('coupon_discount', context) ?? 'Coupon Discount', details.couponDiscount ?? 0, isNegative: true),
          _priceRow(context, getTranslated('product_tax', context) ?? 'Tax', details.productTotalTax ?? 0, isPositive: true),
          _priceRow(context, getTranslated('subtotal', context) ?? 'Subtotal', details.subtotal ?? 0),
          if ((details.referralDiscount ?? 0) > 0)
            _priceRow(context, getTranslated('referral_discount', context) ?? 'Referral Discount', details.referralDiscount!, isNegative: true),
          Divider(color: Theme.of(context).hintColor.withValues(alpha: .3)),
          _priceRow(context, getTranslated('total_refund_amount', context) ?? 'Total Refundable Amount', details.refundAmount ?? 0, isBold: true),
        ],
      ),
    );
  }

  Widget _priceRow(BuildContext context, String title, double price, {int? qty, bool isNegative = false, bool isPositive = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            qty != null ? '$title (x $qty)' : title,
            style: (isBold ? robotoBold : robotoRegular).copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          Text(
            '${isNegative ? '- ' : isPositive ? '+ ' : ''}${PriceConverter.convertPrice(context, price)}',
            style: (isBold ? robotoBold : robotoRegular).copyWith(fontSize: Dimensions.fontSizeDefault, color: isBold ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ],
      ),
    );
  }
}
