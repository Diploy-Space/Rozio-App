import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class WholesaleCategoryWiseShippingCardShimmerWidget extends StatelessWidget {
  final int itemCount;
  const WholesaleCategoryWiseShippingCardShimmerWidget({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context).darkTheme;

    return ListView.builder(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).highlightColor.withValues(alpha: 0.9) : Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          boxShadow: [
            BoxShadow(
              color: isDark ? Theme.of(context).primaryColor.withValues(alpha: 0) : Theme.of(context).primaryColor.withValues(alpha: .1),
              spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).hintColor.withValues(alpha: 0.18),
          highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: .095),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.paddingSizeSmall),
                    topRight: Radius.circular(Dimensions.paddingSizeSmall),
                  ),
                ),
                child: Align(alignment: Alignment.centerLeft, child: _block(width: 160, height: 14)),
              ),

              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withValues(alpha: .05),
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeExtraSmall)),
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingEye),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.iconSizeMedium),
                              child: _block(width: 130, height: 12),
                            ),
                            _block(height: 45, borderRadius: Dimensions.radiusSmall),
                            const SizedBox(height: Dimensions.paddingSizeMedium),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(Dimensions.paddingSizeExtraSmall)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _block(width: 110, height: 12),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            _block(width: 40, height: 20, borderRadius: Dimensions.radiusExtraLarge),
                          ],
                        ),
                      ),
                    ),
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
