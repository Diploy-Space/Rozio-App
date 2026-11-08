import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_update_payment_status_bottom_sheet_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';


class WholesaleOrderPaymentDetailsCardWidget extends StatelessWidget {
  final Order order;
  const WholesaleOrderPaymentDetailsCardWidget({super.key, required this.order});

  void _openUpdatePaymentStatusSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => WholesaleUpdatePaymentStatusBottomSheetWidget(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isPaid = order.paymentStatus == 'paid';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 1.5, blurRadius: 3)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(getTranslated('payment_details', context) ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),

            if (!isPaid)
              InkWell(
                onTap: () => _openUpdatePaymentStatusSheet(context),
                child: Row(children: [
                  Icon(Icons.edit, size: Dimensions.iconSizeSmall, color: Theme.of(context).primaryColor),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(getTranslated('update_payment_status', context) ?? '',
                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
                ]),
              ),
          ]),
        ),
        Divider(thickness: 0.2, height: 1, color: Theme.of(context).hintColor.withValues(alpha: .65)),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(getTranslated(order.paymentMethod ?? '', context) ?? '',
              style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault)
            ),

            Text(getTranslated(order.paymentStatus ?? '', context) ?? '',
              style: robotoRegular.copyWith(color: isPaid ? Colors.green : Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeSmall)
            )
          ]),
        ),
      ]),
    );
  }
}
