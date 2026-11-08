import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleOrderWiseShippingCardShimmerWidget extends StatelessWidget {
  const WholesaleOrderWiseShippingCardShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeMedium, 0, Dimensions.paddingSizeMedium, Dimensions.paddingSizeSmall),
      child: Container(
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          boxShadow: ThemeShadow.getShadow(context),
        ),
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).hintColor.withValues(alpha: 0.18),
          highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.06),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _block(height: 14)),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  _block(width: 48, height: 25, borderRadius: Dimensions.radiusExtraLarge),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  children: [
                    Row(children: [_block(width: 90, height: 12), const SizedBox(width: Dimensions.paddingSizeSmall), _block(width: 60, height: 12)]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Row(children: [_block(width: 90, height: 12), const SizedBox(width: Dimensions.paddingSizeSmall), _block(width: 80, height: 12)]),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _block(width: 36, height: 36, borderRadius: 100),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    _block(width: 36, height: 36, borderRadius: 100),
                  ],
                ),
              ),
            ],
          ),
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
