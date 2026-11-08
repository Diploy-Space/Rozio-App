import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductCardShimmerWidget extends StatelessWidget {
  const WholesaleProductCardShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Theme.of(context).hintColor.withValues(alpha: 0.18);
    final Color hlColor = Theme.of(context).hintColor.withValues(alpha: 0.06);

    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: ThemeShadow.getShadow(context),
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: hlColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _block(
              width: Dimensions.productImageSizeItem,
              height: Dimensions.productImageSizeItem,
              borderRadius: Dimensions.radiusSmall,
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name — two lines, the second one short.
                  _block(height: 12),
                  const SizedBox(height: Dimensions.paddingSizeOrder),
                  _block(width: 120, height: 12),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  // Price range.
                  _block(width: 140, height: 12),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  // Status badge.
                  _block(width: 70, height: 20, borderRadius: Dimensions.radiusSmall),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            // Popup menu icon.
            _block(width: Dimensions.iconSizeMedium, height: Dimensions.iconSizeMedium),
          ],
        ),
      ),
    );
  }

  Widget _block({double? width, required double height, double borderRadius = 6}) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
