import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_divider_widget.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleOrderBillingSummaryCardWidget extends StatelessWidget {
  final double subTotal;
  final double tax;
  final double discount;
  final double shippingFee;
  final double? total;
  final double couponDiscount;
  final double referralDiscount;
  final double extraDiscount;
  final bool showShippingFee;
  final bool isFreeShipping;
  const WholesaleOrderBillingSummaryCardWidget({
    super.key,
    required this.subTotal,
    required this.tax,
    required this.discount,
    required this.shippingFee,
    required this.total,
    this.couponDiscount = 0,
    this.referralDiscount = 0,
    this.extraDiscount = 0,
    this.showShippingFee = true,
    this.isFreeShipping = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 1.5, blurRadius: 3)],
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Row(children: [
            Text(getTranslated('billing_summery', context) ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeMedium),

        Divider(thickness: 0.2, height: 1, color: Theme.of(context).hintColor.withValues(alpha: .65)),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Column(children: [
            _BillingRow(label: getTranslated('sub_total', context) ?? '', value: PriceConverter.convertPrice(context, subTotal)),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            _BillingRow(label: getTranslated('tax', context) ?? '', value: '+ ${PriceConverter.convertPrice(context, tax)}'),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            _BillingRow(label: getTranslated('discount', context) ?? '', value: '- ${PriceConverter.convertPrice(context, discount)}'),

            if (extraDiscount > 0) ...[
              const SizedBox(height: Dimensions.paddingSizeSmall),
              _BillingRow(label: getTranslated('extra_discount', context) ?? '', value: '- ${PriceConverter.convertPrice(context, extraDiscount)}'),
            ],

            if (couponDiscount > 0) ...[
              const SizedBox(height: Dimensions.paddingSizeSmall),
              _BillingRow(label: getTranslated('coupon_discount', context) ?? '', value: '- ${PriceConverter.convertPrice(context, couponDiscount)}'),
            ],

            if (referralDiscount > 0) ...[
              const SizedBox(height: Dimensions.paddingSizeSmall),
              _BillingRow(label: getTranslated('referral_discount', context) ?? '', value: '- ${PriceConverter.convertPrice(context, referralDiscount)}'),
            ],

            if (showShippingFee) ...[
              const SizedBox(height: Dimensions.paddingSizeSmall),
              _BillingRow(label: getTranslated('shipping_fee', context) ?? '', value: '${isFreeShipping ? '' : '+ '}${PriceConverter.convertPrice(context, shippingFee)}'),
            ],

            const Padding(padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall), child: CustomDividerWidget()),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(getTranslated('total_amount', context) ?? '', style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
              Text(PriceConverter.convertPrice(context, total),
                style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
            ]),
          ]),
        ),
      ]),
    );
  }
}

class _BillingRow extends StatelessWidget {
  final String label;
  final String value;
  const _BillingRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final Color color = ColorHelper.blendColors(Colors.white, Theme.of(context).textTheme.bodyLarge!.color!, 0.7);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: titilliumRegular.copyWith(color: color)),
      Text(value, style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
    ]);
  }
}
