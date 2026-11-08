import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/invoice_download_button_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/controllers/wholesale_order_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/enums/wholesale_order_status.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_order_card_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleOrderTopSectionWidget extends StatelessWidget {
  final Order? order;
  final VoidCallback onBack;
  const WholesaleOrderTopSectionWidget({super.key, required this.order, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final WholesaleOrderStatus status = WholesaleOrderStatus.fromString(order?.orderStatus);

    return Row(children: [
      InkWell(
        onTap: onBack,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: 0),
          child: Icon(CupertinoIcons.back),
        ),
      ),
      const Spacer(),

      if (order != null)
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: '${getTranslated('order', context)}# ',
                style: robotoRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: Dimensions.fontSizeDefault,
                ),
                children: [
                  TextSpan(
                    text: order?.id.toString(),
                    style: robotoBold.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                  TextSpan(
                    text: ' (${getTranslated('wholesale', context) ?? 'Wholesale'})',
                    style: robotoRegular.copyWith(
                      color: Theme.of(context).textTheme.headlineLarge?.color,
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            RichText(
              text: TextSpan(
                text: getTranslated('your_order_is', context),
                style: titilliumRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).hintColor,
                ),
                children: [
                  TextSpan(
                    text: ' ${getTranslated(status.translationKey, context) ?? status.translationKey}',
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: wholesaleOrderStatusColor(context, status),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      const Spacer(),

      if (order != null) ...[
        // InkWell(
        //   onTap: () => showCustomSnackBarWidget(getTranslated('vendors_are_not_allowed_to_edit', context) ?? '', context, sanckBarType: SnackBarType.warning),
        //   child: Padding(
        //     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        //     child: CustomAssetImageWidget(Images.editOrderIcon, height: 20, width: 20,
        //       color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
        //     ),
        //   ),
        // ),

        Consumer<WholesaleOrderController>(
          builder: (context, wholesaleOrderController, _) => InvoiceDownloadButtonWidget(
            isLoading: wholesaleOrderController.isInvoiceLoading,
            onDownload: () => wholesaleOrderController.getOrderInvoice(order!.id!),
          ),
        ),
      ],
    ]);
  }
}
