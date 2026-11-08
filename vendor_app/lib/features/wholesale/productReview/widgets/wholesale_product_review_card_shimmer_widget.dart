import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class WholesaleProductReviewCardShimmerWidget extends StatelessWidget {
  const WholesaleProductReviewCardShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Theme.of(context).hintColor.withValues(alpha: 0.18);
    final Color hlColor = Theme.of(context).hintColor.withValues(alpha: 0.06);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(color: Colors.grey[Provider.of<ThemeController>(context).darkTheme ? 800 : 200]!, spreadRadius: 1, blurRadius: 1),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: hlColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _block(width: 110, height: 14),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    _block(width: 80, height: 12),
                  ],
                ),

                Row(
                  children: [
                    _block(width: Dimensions.iconSizeDefault, height: Dimensions.iconSizeDefault, borderRadius: Dimensions.radiusExtraLarge),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    _block(width: 24, height: 14),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    _block(width: 40, height: 20, borderRadius: Dimensions.radiusExtraLarge),
                  ],
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            _block(height: 12),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            _block(height: 10),
            const SizedBox(height: Dimensions.paddingSizeOrder),
            _block(width: 200, height: 10),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _block(width: 90, height: 10),
                _block(width: 60, height: 10),
              ],
            ),
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
