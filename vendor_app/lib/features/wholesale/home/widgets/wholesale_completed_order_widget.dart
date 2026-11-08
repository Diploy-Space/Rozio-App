import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/controllers/wholesale_home_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/widgets/wholesale_order_type_button_widget.dart';
import 'package:sixvalley_vendor_app/helper/order_status_color_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleCompletedOrderWidget extends StatelessWidget {
  const WholesaleCompletedOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleHomeController>(
      builder: (context, wholesaleHomeController, child) {
        final data = wholesaleHomeController.businessAnalyticsFilterData;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: .05),
                spreadRadius: -3, blurRadius: 12, offset: Offset.fromDirection(0, 6),
              ),
            ],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeDefault, 0),
              child: Text(getTranslated('completed_orders', context)!,
                style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge),
              ),
            ),

            SizedBox(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  WholesaleOrderTypeButtonWidget(
                    color: OrderStatusColorHelper.statusTextColor(context, 'delivered'),
                    icon: Images.delivered,
                    text: getTranslated('delivered', context),
                    numberOfOrder: data.delivered,
                  ),
                  WholesaleOrderTypeButtonWidget(
                    color: OrderStatusColorHelper.statusTextColor(context, 'canceled'),
                    icon: Images.cancelled,
                    text: getTranslated('cancelled', context),
                    numberOfOrder: data.canceled,
                  ),
                  WholesaleOrderTypeButtonWidget(
                    color: OrderStatusColorHelper.statusTextColor(context, 'returned'),
                    icon: Images.returned,
                    text: getTranslated('returned', context),
                    numberOfOrder: data.returned,
                  ),
                  WholesaleOrderTypeButtonWidget(
                    showBorder: false,
                    color: OrderStatusColorHelper.statusTextColor(context, 'failed'),
                    icon: Images.failed,
                    text: getTranslated('failed_title', context),
                    numberOfOrder: data.failed,
                  ),
                ],
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeSmall),
          ]),
        );
      },
    );
  }
}
