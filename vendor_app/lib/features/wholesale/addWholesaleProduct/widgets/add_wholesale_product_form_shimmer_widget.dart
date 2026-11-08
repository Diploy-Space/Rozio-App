import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class AddWholesaleProductFormShimmerWidget extends StatelessWidget {
  const AddWholesaleProductFormShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).hintColor.withValues(alpha: 0.18),
      highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.06),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium, vertical: Dimensions.paddingSizeSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: Row(
                children: List.generate(4, (index) => Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                  child: Center(child: _block(width: 70, height: 28, borderRadius: Dimensions.radiusExtraLarge)),
                )),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            ...List.generate(4, (index) => Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _block(width: 110, height: 12),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  _block(height: 48, borderRadius: Dimensions.radiusSmall),
                ],
              ),
            )),

            _block(width: 130, height: 12),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            _block(height: 120, borderRadius: Dimensions.radiusSmall),
            const SizedBox(height: Dimensions.paddingSizeMedium),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _block(width: 80, height: 12),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      _block(height: 48, borderRadius: Dimensions.radiusSmall),
                    ],
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _block(width: 80, height: 12),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      _block(height: 48, borderRadius: Dimensions.radiusSmall),
                    ],
                  ),
                ),
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
