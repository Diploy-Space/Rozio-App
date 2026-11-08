import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleHomeShimmerWidget extends StatelessWidget {
  const WholesaleHomeShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimensions.paddingSizeSmall),
        const _BusinessAnalyticsShimmer(),
        const _CompletedOrderShimmer(),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        const _EarningStatisticsShimmer(),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        const _TopProductSectionShimmer(),
        const SizedBox(height: Dimensions.paddingSizeSmall),
      ],
    );
  }
}

class _BusinessAnalyticsShimmer extends StatelessWidget {
  const _BusinessAnalyticsShimmer();

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
            child: Row(
              children: [
                _block(width: 150, height: 16),
                const Spacer(),
                _block(width: 120, height: 40, borderRadius: Dimensions.paddingSizeExtraSmall),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall, 0, Dimensions.paddingSizeSmall, Dimensions.fontSizeSmall),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: (1 / .65),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: List.generate(4, (index) => Container(
                margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Row(
                  children: [
                    _block(width: 40, height: 40, borderRadius: Dimensions.radiusExtraLarge),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _block(height: 14),
                          const SizedBox(height: Dimensions.paddingSizeOrder),
                          _block(width: 40, height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall),
        ],
      ),
    );
  }
}

class _CompletedOrderShimmer extends StatelessWidget {
  const _CompletedOrderShimmer();

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeDefault, 0),
            child: _block(width: 150, height: 16),
          ),

          ...List.generate(4, (index) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                child: Row(
                  children: [
                    _block(width: Dimensions.iconSizeLarge, height: Dimensions.iconSizeLarge),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    _block(width: 90, height: 12),
                    const Spacer(),
                    _block(width: 45, height: 22, borderRadius: Dimensions.paddingSizeLarge),
                  ],
                ),
              ),
              if (index != 3)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                  child: Divider(thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: .2)),
                ),
            ],
          )),

          const SizedBox(height: Dimensions.paddingSizeSmall),
        ],
      ),
    );
  }
}

class _EarningStatisticsShimmer extends StatelessWidget {
  const _EarningStatisticsShimmer();

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingEye),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _block(width: 150, height: 16),
                  const Spacer(),
                  _block(width: 120, height: 40, borderRadius: Dimensions.paddingSizeExtraSmall),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _block(width: Dimensions.iconSizeDefault, height: Dimensions.iconSizeDefault, borderRadius: Dimensions.radiusExtraLarge),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  _block(width: 70, height: 12),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  _block(width: Dimensions.iconSizeDefault, height: Dimensions.iconSizeDefault, borderRadius: Dimensions.radiusExtraLarge),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  _block(width: 90, height: 12),
                ],
              ),
              const SizedBox(height: 38),

              Expanded(child: _block(height: double.infinity, borderRadius: Dimensions.radiusDefault)),
              const SizedBox(height: Dimensions.paddingSize),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopProductSectionShimmer extends StatelessWidget {
  const _TopProductSectionShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeLarge, Dimensions.paddingSizeDefault, 0),
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).hintColor.withValues(alpha: 0.18),
            highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.06),
            child: Row(
              children: [
                _block(width: 140, height: 16),
                const Spacer(),
                _block(width: 60, height: 12),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
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
            itemCount: 4,
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: ThemeShadow.getShadow(context),
              ),
              child: Shimmer.fromColors(
                baseColor: Theme.of(context).hintColor.withValues(alpha: 0.18),
                highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radiusDefault),
                            topRight: Radius.circular(Dimensions.radiusDefault),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _block(height: 12),
                          const SizedBox(height: Dimensions.paddingSizeOrder),
                          _block(width: 80, height: 14),
                          const SizedBox(height: Dimensions.paddingSizeOrder),
                          _block(width: 60, height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _CardSurface({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: .05),
            spreadRadius: -3, blurRadius: 12, offset: Offset.fromDirection(0, 6),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).hintColor.withValues(alpha: 0.18),
        highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.06),
        child: child,
      ),
    );
  }
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
