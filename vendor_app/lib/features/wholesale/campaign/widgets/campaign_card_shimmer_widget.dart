import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CampaignCardShimmerWidget extends StatelessWidget {
  const CampaignCardShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Theme.of(context).hintColor.withValues(alpha: 0.18);
    final Color hlColor = Theme.of(context).hintColor.withValues(alpha: 0.06);

    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: ThemeShadow.getShadow(context),
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: hlColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row: icon + title
            Row(
              children: [
                _block(width: Dimensions.iconSizeMedium, height: Dimensions.iconSizeMedium),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                _block(width: 150, height: 14),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            // Discount limit + items
            _block(width: 200, height: 12),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            // Active time + status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _block(width: 130, height: 12),
                _block(width: 64, height: 22, borderRadius: Dimensions.radiusExtraLarge),
              ],
            ),
          ],
        ),
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
