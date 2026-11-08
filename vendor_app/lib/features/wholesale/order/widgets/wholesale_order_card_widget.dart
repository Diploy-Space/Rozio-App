import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/enums/wholesale_order_status.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

String wholesaleOrderPaymentIcon(String? paymentMethod) {
  switch (paymentMethod) {
    case 'pay_by_wallet':
      return Images.payByWalletIcon;
    case 'cash_on_delivery':
      return Images.cashPaymentIcon;
    default:
      return Images.digitalPaymentIcon;
  }
}

Color wholesaleOrderStatusColor(BuildContext context, WholesaleOrderStatus status) {
  switch (status) {
    case WholesaleOrderStatus.confirmed:
    case WholesaleOrderStatus.delivered:
      return Theme.of(context).colorScheme.onTertiaryContainer;
    case WholesaleOrderStatus.pending:
      return Theme.of(context).colorScheme.outline;
    case WholesaleOrderStatus.processing:
      return Theme.of(context).colorScheme.tertiary;
    case WholesaleOrderStatus.outForDelivery:
    case WholesaleOrderStatus.returned:
      return Theme.of(context).colorScheme.secondary;
    case WholesaleOrderStatus.cancelled:
    case WholesaleOrderStatus.failed:
      return Theme.of(context).colorScheme.error;
  }
}

class WholesaleOrderCardWidget extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;
  const WholesaleOrderCardWidget({super.key, required this.order, this.onTap});

  String get _paymentIcon => wholesaleOrderPaymentIcon(order.paymentMethod);

  @override
  Widget build(BuildContext context) {
    final WholesaleOrderStatus status = WholesaleOrderStatus.fromString(order.orderStatus);

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
                  child: Row(
                    children: [
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${getTranslated('order_no', context) ?? 'Order'} ',
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              ),
                              TextSpan(
                                text: '#${order.id}',
                                style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),


                      Text(
                        '(${order.orderDetails?.length ?? 0} ${getTranslated('items', context) ?? 'Items'})',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.headlineLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                _StatusBadge(status: status),
              ],
            ),

            Text(
              order.createdAt != null ? DateConverter.localDateToIsoStringAMPMOrder(DateTime.parse(order.createdAt!)) : '',
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CustomAssetImageWidget(_paymentIcon, height: Dimensions.iconSizeDefault, width: Dimensions.iconSizeDefault),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Text(
                      getTranslated(order.paymentMethod ?? '', context) ?? '',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color),
                    ),
                  ],
                ),
                Text(
                  PriceConverter.convertPrice(context, order.orderAmount),
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
  final WholesaleOrderStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color = wholesaleOrderStatusColor(context, status);
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
