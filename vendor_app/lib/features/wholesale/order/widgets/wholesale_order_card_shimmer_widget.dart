import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleOrderCardShimmerWidget extends StatelessWidget {
  const WholesaleOrderCardShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Theme.of(context).hintColor.withValues(alpha: 0.18);
    final Color hlColor = Theme.of(context).hintColor.withValues(alpha: 0.06);

    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
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
            // Order no + item count, status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _block(width: 160, height: 14),
                _block(width: 70, height: 22, borderRadius: Dimensions.radiusExtraLarge),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            // Date
            _block(width: 130, height: 12),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            // Payment method + price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _block(width: 120, height: 14),
                _block(width: 60, height: 16),
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
