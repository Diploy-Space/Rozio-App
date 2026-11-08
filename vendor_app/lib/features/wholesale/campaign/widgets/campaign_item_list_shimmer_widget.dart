import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class CampaignItemListShimmerWidget extends StatelessWidget {
  final int itemCount;
  final bool showTitle;
  const CampaignItemListShimmerWidget({super.key, this.itemCount = 3, this.showTitle = true});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Theme.of(context).hintColor.withValues(alpha: 0.18);
    final Color hlColor = Theme.of(context).hintColor.withValues(alpha: 0.06);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: hlColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) ...[
            _block(width: 120, height: 16),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],

          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Column(
              children: List.generate(itemCount, (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Row(
                  children: [
                    _block(width: 10, height: 14),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    _block(width: 36, height: 36, borderRadius: Dimensions.radiusSmall),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(child: _block(width: double.infinity, height: 12)),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    _block(width: 70, height: 36, borderRadius: Dimensions.radiusSmall),
                  ],
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _block({required double width, required double height, double borderRadius = 6}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
