import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/controllers/wholesale_home_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/widgets/wholesale_order_type_button_head_widget.dart';
import 'package:sixvalley_vendor_app/helper/order_status_color_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleBusinessAnalyticsWidget extends StatelessWidget {
  const WholesaleBusinessAnalyticsWidget({super.key});

  static const List<String> _filters = ['overall', 'today', 'this_week', 'this_month', 'this_year'];

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleHomeController>(
      builder: (context, wholesaleHomeController, child) {
        final data = wholesaleHomeController.businessAnalyticsFilterData;

        return Container(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: ThemeShadow.getShadow(context),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(getTranslated('business_analytics', context)!,
                    style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge),
                  ),
                  const Expanded(child: SizedBox(width: Dimensions.paddingSizeExtraLarge)),
                  Container(
                    height: 40, width: 120,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(width: .7, color: Theme.of(context).hintColor.withValues(alpha: .3)),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    ),
                    child: DropdownButton<String>(
                      iconEnabledColor: Theme.of(context).primaryColor,
                      value: _filters[wholesaleHomeController.analyticsFilterIndex],
                      items: _filters.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getTranslated(value, context)!,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => wholesaleHomeController.setAnalyticsFilterIndex(_filters.indexOf(value!)),
                      isExpanded: true,
                      underline: const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall, 0, Dimensions.paddingSizeSmall, Dimensions.fontSizeSmall),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: (1 / .65),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  WholesaleOrderTypeButtonHeadWidget(
                    color: OrderStatusColorHelper.analyticsBgColor(context, 'pending'),
                    circleColor: OrderStatusColorHelper.analyticsTextColor(context, 'pending'),
                    image: Images.pendingOrderCardIcon,
                    text: getTranslated('pending', context),
                    subText: getTranslated('orders', context),
                    numberOfOrder: data.pending ?? 0,
                  ),
                  WholesaleOrderTypeButtonHeadWidget(
                    color: OrderStatusColorHelper.analyticsBgColor(context, 'processing'),
                    circleColor: OrderStatusColorHelper.analyticsTextColor(context, 'processing'),
                    image: Images.packagingOrdersCardIcon,
                    text: getTranslated('processing', context),
                    numberOfOrder: data.processing ?? 0,
                    subText: getTranslated('orders', context),
                  ),
                  WholesaleOrderTypeButtonHeadWidget(
                    color: OrderStatusColorHelper.analyticsBgColor(context, 'confirmed'),
                    circleColor: OrderStatusColorHelper.analyticsTextColor(context, 'confirmed'),
                    image: Images.confirmOrderCardIcon,
                    text: getTranslated('confirmed', context),
                    subText: getTranslated('orders', context),
                    numberOfOrder: data.confirmed ?? 0,
                  ),
                  WholesaleOrderTypeButtonHeadWidget(
                    color: OrderStatusColorHelper.analyticsBgColor(context, 'out_for_delivery'),
                    circleColor: OrderStatusColorHelper.analyticsTextColor(context, 'out_for_delivery'),
                    image: Images.outForDeliveryCardIcon,
                    text: getTranslated('out_for_delivery', context),
                    subText: '',
                    numberOfOrder: data.outForDelivery ?? 0,
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
