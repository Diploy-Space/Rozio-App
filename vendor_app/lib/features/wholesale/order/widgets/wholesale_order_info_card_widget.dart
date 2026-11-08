import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleOrderInfoCardWidget extends StatelessWidget {
  final Order order;
  final bool showVerificationCode;
  const WholesaleOrderInfoCardWidget({super.key, required this.order, required this.showVerificationCode});

  @override
  Widget build(BuildContext context) {
    final double bringChangeAmount = order.bringCashAmount ?? 0;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 1.5, blurRadius: 3)],
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Column(children: [
          const SizedBox(height: Dimensions.paddingSizeMedium),

          if (showVerificationCode && order.orderType != 'POS') ...[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(getTranslated('order_verification_code', context) ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.titleMedium?.color)),
              Text(order.verificationCode ?? '', style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault)),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(getTranslated('order_date_details', context) ?? '', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)),
            Text(order.createdAt != null ? DateConverter.localDateToIsoStringAMPMOrder(DateTime.parse(order.createdAt!)) : '',
              style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault)),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(getTranslated('order_type', context) ?? '', style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.titleMedium?.color)
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
              ),
              padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeOrder, horizontal: Dimensions.paddingEye),
              child: Text(getTranslated(order.orderType == 'POS' ? 'pos_order_small' : 'online_order', context) ?? ' ',
                style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          if (bringChangeAmount > 0)
            Container(
              padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    offset: const Offset(0, 3),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getTranslated('change_request', context) ?? ' ',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: '${getTranslated('please_bring', context)} ',
                        style: robotoRegular.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                        children: [
                          TextSpan(
                            text: PriceConverter.convertPrice(context, bringChangeAmount),
                            style: robotoBold.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                          TextSpan(
                            text: ' ${getTranslated('in_change_when_making_the_delivery', context) ?? ''}',
                            style: robotoRegular.copyWith(
                              color: Theme.of(context).textTheme.headlineLarge?.color,
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ]),
      ),
    );
  }
}
