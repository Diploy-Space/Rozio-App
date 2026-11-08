import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/domain/models/wholesale_coupon_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleCouponDetailsDialogWidget extends StatelessWidget {
  final WholesaleCoupon? coupon;
  const WholesaleCouponDetailsDialogWidget({super.key, this.coupon});

  String _formatDate(String? date) {
    final DateTime? parsed = DateTime.tryParse(date ?? '');
    return parsed != null ? DateConverter.localDateToIsoStringDate(parsed) : '';
  }

  @override
  Widget build(BuildContext context) {
    final bool freeDelivery = coupon!.couponType == 'free_delivery';
    final bool isPercentage = coupon!.discountType == 'percentage';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: IntrinsicHeight(
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsetsDirectional.only(
                        top: Dimensions.paddingSizeSmall,
                        bottom: Dimensions.paddingSizeDefault,
                        start: Dimensions.paddingSizeDefault,
                        end: Dimensions.paddingSizeSmall,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadiusDirectional.only(
                          topStart: Radius.circular(Dimensions.radiusDefault),
                          bottomStart: Radius.circular(Dimensions.radiusDefault),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(coupon!.title ?? '',
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Row(
                            children: [
                              Flexible(
                                child: Text(getTranslated(coupon!.couponType, context) ?? '',
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              Flexible(child: InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: coupon!.code ?? ''));
                                  showCustomSnackBarWidget(getTranslated('coupon_code_copied', context), context, isError: false);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(coupon!.code ?? '',
                                          maxLines: 1, overflow: TextOverflow.ellipsis,
                                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(Icons.copy, size: 14, color: Theme.of(context).primaryColor),
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ),

                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          _DetailRow(translationKey: 'min_purchase', value: PriceConverter.convertPrice(context, coupon!.minPurchase)),
                          if (!freeDelivery && isPercentage)
                            _DetailRow(translationKey: 'max_discount', value: PriceConverter.convertPrice(context, coupon!.maxDiscount)),
                          if (coupon!.customerId == 0)
                            _DetailRow(translationKey: 'coupon_for', value: getTranslated('all_customer', context) ?? 'All Customers'),
                          _DetailRow(translationKey: 'user_limit', value: '${coupon!.limit}'),
                          _DetailRow(translationKey: 'start_date', value: _formatDate(coupon!.startDate), isLtr: true),
                          _DetailRow(translationKey: 'expire_date', value: _formatDate(coupon!.expireDate), isLtr: true),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadiusDirectional.only(
                          topEnd: Radius.circular(Dimensions.radiusDefault),
                          bottomEnd: Radius.circular(Dimensions.radiusDefault),
                        ),
                      ),
                      child: Stack(
                        children: [
                          PositionedDirectional(
                            top: 10, end: 10,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: Icon(Icons.close, size: 16, color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ),

            PositionedDirectional(
              end: (MediaQuery.of(context).size.width * 0.25) - 80,
              bottom: 30,
              child: Container(
                height: 90, width: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, spreadRadius: 1)
                  ],
                ),
                child: Center(
                  child: freeDelivery
                    ? Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Image.asset(Images.freeDelivery, width: 40),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(isPercentage
                                  ? '${coupon!.discount?.toInt()}%'
                                  : PriceConverter.convertPrice(context, coupon!.discount),
                                style: robotoBold.copyWith(fontSize: 19, color: Theme.of(context).primaryColor),
                                maxLines: 1, softWrap: false,
                              ),
                              Text(getTranslated('off', context) ?? 'Off',
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor.withValues(alpha: 0.7)),
                                maxLines: 1, softWrap: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String translationKey;
  final String value;
  final bool isLtr;

  const _DetailRow({required this.translationKey, required this.value, this.isLtr = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeVeryTiny),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text('${getTranslated(translationKey, context)}',
              style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
            ),
          ),
          const Text(' :  '),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(value,
                style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),
                maxLines: 1, overflow: TextOverflow.ellipsis,
                textDirection: isLtr ? TextDirection.ltr : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
