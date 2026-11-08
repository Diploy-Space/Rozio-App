import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_order_card_widget.dart' show wholesaleOrderPaymentIcon;
import 'package:sixvalley_vendor_app/features/wholesale/refund/enums/wholesale_refund_status.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

Color wholesaleRefundStatusColor(BuildContext context, WholesaleRefundStatus status) {
  switch (status) {
    case WholesaleRefundStatus.pending:
      return Theme.of(context).colorScheme.outline;
    case WholesaleRefundStatus.approved:
    case WholesaleRefundStatus.refunded:
      return Theme.of(context).colorScheme.onTertiaryContainer;
    case WholesaleRefundStatus.rejected:
      return Theme.of(context).colorScheme.error;
  }
}

class WholesaleRefundCardWidget extends StatelessWidget {
  final RefundModel refund;
  final VoidCallback? onTap;
  const WholesaleRefundCardWidget({super.key, required this.refund, this.onTap});

  @override
  Widget build(BuildContext context) {
    final WholesaleRefundStatus status = WholesaleRefundStatus.fromString(refund.status);
    final String? paymentMethod = refund.order?.paymentMethod;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        padding: const EdgeInsets.all(Dimensions.paddingSize),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: ThemeShadow.getShadow(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: '${getTranslated('refund_no', context) ?? 'Refund'} ',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      TextSpan(
                        text: '#${refund.id}',
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                _StatusBadge(status: status),
              ],
            ),

            Text(
              refund.createdAt != null ? DateConverter.isoStringToLocalDateAndTime(refund.createdAt!) : '',
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            if (refund.product?.name != null)
              Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Text(
                  refund.product!.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
              ),

            Text.rich(
              TextSpan(children: [
                TextSpan(text: '${getTranslated('reason', context) ?? 'Reason'}: ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color)),
                TextSpan(text: refund.refundReason ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
              ]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (paymentMethod != null)
                  Row(children: [
                    CustomAssetImageWidget(wholesaleOrderPaymentIcon(paymentMethod), height: Dimensions.iconSizeDefault, width: Dimensions.iconSizeDefault),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Text(
                      getTranslated(paymentMethod, context) ?? '',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color),
                    ),
                  ])
                else
                  const SizedBox(),
                Text(
                  PriceConverter.convertPrice(context, refund.amount),
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final WholesaleRefundStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color = wholesaleRefundStatusColor(context, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingEye, vertical: Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
      ),
      child: Text(
        getTranslated(status.translationKey, context) ?? '',
        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: color),
      ),
    );
  }
}
