import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/auction/controllers/auction_home_controller.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/auction_stat_card_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AuctionBusinessAnalyticsWidget extends StatelessWidget {
  const AuctionBusinessAnalyticsWidget({super.key});

  static const List<String> _filters = ['overall', 'today', 'this_week', 'this_month', 'this_year'];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionHomeController>(
      builder: (context, auctionHomeController, child) {
        final data = auctionHomeController.businessAnalyticsData;

        return Container(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
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
                      value: _filters[auctionHomeController.analyticsFilterIndex],
                      items: _filters.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getTranslated(value, context)!,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => auctionHomeController.setAnalyticsFilterIndex(_filters.indexOf(value!)),
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
                  AuctionStatCardWidget(
                    color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                    circleColor: Theme.of(context).colorScheme.secondary,
                    image: Images.gavelIcon,
                    text: getTranslated('live', context),
                    subText: getTranslated('auctions', context),
                    number: data.liveAuctions,
                  ),
                  AuctionStatCardWidget(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
                    circleColor: Theme.of(context).colorScheme.outline,
                    image: Images.pendingOrderCardIcon,
                    text: getTranslated('upcoming', context),
                    number: data.upcoming,
                    subText: '',
                  ),
                  AuctionStatCardWidget(
                    color: Theme.of(context).colorScheme.onTertiaryContainer.withValues(alpha: 0.15),
                    circleColor: Theme.of(context).colorScheme.onTertiaryContainer,
                    image: Images.confirmOrderCardIcon,
                    text: getTranslated('purchase_complete', context),
                    subText: '',
                    number: data.purchaseComplete,
                  ),
                  AuctionStatCardWidget(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.15),
                    circleColor: Theme.of(context).colorScheme.error,
                    image: Images.closeIcon,
                    text: getTranslated('unsold', context),
                    subText: '',
                    number: data.unsold,
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
