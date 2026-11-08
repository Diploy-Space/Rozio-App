import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class WholesaleProductReviewListTileShimmerWidget extends StatelessWidget {
  final int itemCount;
  const WholesaleProductReviewListTileShimmerWidget({super.key, this.itemCount = 5});

  static const List<double> _widths = [220, 170, 240, 150, 200, 260, 180, 210];

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).hintColor.withValues(alpha: 0.18),
      highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.06),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        separatorBuilder: (context, index) => Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: _widths[index % _widths.length],
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
