import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/title_row_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/domain/models/auction_home_stats_model.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/auction_top_performing_card_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class AuctionTopPerformingWidget extends StatelessWidget {
  final List<AuctionTopPerformingModel> auctions;
  final VoidCallback? onViewAll;
  const AuctionTopPerformingWidget({super.key, required this.auctions, this.onViewAll});

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
            child: TitleRowWidget(title: getTranslated('top_performing_auctions', context), onTap: onViewAll),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeLarge, Dimensions.paddingSizeDefault, 0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: MediaQuery.of(context).size.width < 400 ? 1 / 1.58 : 1 / 1.66,
              ),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: auctions.length,
              itemBuilder: (context, index) {
                return AuctionTopPerformingCardWidget(auction: auctions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
