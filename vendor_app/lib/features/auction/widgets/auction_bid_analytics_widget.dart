import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/auction/controllers/auction_home_controller.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AuctionBidAnalyticsWidget extends StatelessWidget {
  const AuctionBidAnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionHomeController>(
      builder: (context, auctionHomeController, child) {
        final data = auctionHomeController.bidAnalyticsData;
        final colorScheme = Theme.of(context).colorScheme;

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
              padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, 0),
              child: Text(getTranslated('bid_analytics', context)!,
                style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge),
              ),
            ),

            _BidAnalyticsRow(
              icon: Icons.gavel,
              color: colorScheme.error,
              label: getTranslated('total_bids', context) ?? 'Total Bids',
              value: '${data.totalBids}',
            ),
            _BidAnalyticsRow(
              icon: Icons.people_alt,
              color: colorScheme.outline,
              label: getTranslated('active_bidders', context) ?? 'Active Bidders',
              value: '${data.activeBidders}',
            ),
            _BidAnalyticsRow(
              icon: Icons.trending_up,
              color: colorScheme.onTertiaryContainer,
              label: getTranslated('highest_bid', context) ?? 'Highest Bid',
              value: PriceConverter.convertPrice(context, data.highestBid),
            ),
            _BidAnalyticsRow(
              icon: Icons.query_stats,
              color: colorScheme.tertiary,
              label: getTranslated('average_bids_auction', context) ?? 'Average Bids/Auction',
              value: '${data.averageBidsPerAuction}',
              showBorder: false,
            ),

            const SizedBox(height: Dimensions.paddingSizeSmall),
          ]),
        );
      },
    );
  }
}

class _BidAnalyticsRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final bool showBorder;
  const _BidAnalyticsRow({required this.icon, required this.color, required this.label, required this.value, this.showBorder = true});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
        child: Row(children: [
          Container(
            height: 30, width: 30,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: .15)),
            child: Icon(icon, size: Dimensions.iconSizeDefault - 2, color: color),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Text(label, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
          const Spacer(),
          Text(value, style: robotoBold.copyWith(color: color, fontSize: Dimensions.fontSizeLarge)),
        ]),
      ),
      showBorder
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
            child: Divider(thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: .2)),
          )
        : const SizedBox(),
    ]);
  }
}
