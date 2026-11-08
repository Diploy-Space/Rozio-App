import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/title_row_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/domain/models/auction_home_stats_model.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/auction_recently_ended_card_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class AuctionRecentlyEndedWidget extends StatelessWidget {
  final List<AuctionRecentlyEndedModel> auctions;
  final VoidCallback? onViewAll;
  const AuctionRecentlyEndedWidget({super.key, required this.auctions, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: .05),
            spreadRadius: -3, blurRadius: 12, offset: Offset.fromDirection(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeLarge, Dimensions.paddingSizeDefault, 0),
            child: TitleRowWidget(title: getTranslated('recently_ended_auctions', context), onTap: onViewAll),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: auctions.length,
            itemBuilder: (context, index) {
              return AuctionRecentlyEndedCardWidget(auction: auctions[index]);
            },
          ),
        ],
      ),
    );
  }
}
