import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class WholesaleProductDetailsShimmerWidget extends StatelessWidget {
  const WholesaleProductDetailsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).hintColor.withValues(alpha: 0.18),
      highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.06),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSize),
            child: Row(
              children: [
                _block(width: 90, height: 34, borderRadius: Dimensions.fontSizeWithdrawableAmount),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                _block(width: 80, height: 34, borderRadius: Dimensions.fontSizeWithdrawableAmount),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                _block(width: 64, height: 34, borderRadius: Dimensions.fontSizeWithdrawableAmount),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  _HeaderShimmer(block: _block),

                  _Section(
                    titleWidth: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < 5; i++) ...[
                          _block(width: i == 4 ? 180 : null, height: 12),
                          if (i < 4) const SizedBox(height: Dimensions.paddingSizeExtraSmall + 2),
                        ],
                      ],
                    ),
                  ),

                  _Section(
                    titleWidth: 110,
                    child: Column(children: List.generate(6, (index) => _InfoRowShimmer(block: _block, valueWidth: index.isEven ? 120 : 90))),
                  ),

                  _Section(
                    titleWidth: 150,
                    child: Column(children: List.generate(4, (index) => _InfoRowShimmer(block: _block, valueWidth: index.isEven ? 80 : 110))),
                  ),

                  _Section(
                    titleWidth: 90,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double cardWidth = (constraints.maxWidth - Dimensions.paddingSizeSmall * 2) / 3;
                        return Wrap(
                          spacing: Dimensions.paddingSizeSmall,
                          runSpacing: Dimensions.paddingSizeSmall,
                          children: List.generate(3, (index) => _block(width: cardWidth, height: 64, borderRadius: Dimensions.radiusDefault)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _block({double? width, required double height, double borderRadius = 6}) {
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

typedef _BlockBuilder = Widget Function({double? width, required double height, double borderRadius});

class _HeaderShimmer extends StatelessWidget {
  final _BlockBuilder block;
  const _HeaderShimmer({required this.block});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 120,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Dimensions.paddingEye)),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  block(height: 16),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  block(width: 120, height: 16),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Row(children: [
                    block(width: 40, height: 14),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    block(width: 90, height: 14),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  block(width: 72, height: 24, borderRadius: Dimensions.radiusSmall),
                  const SizedBox(height: Dimensions.paddingEye),

                  Row(
                    children: List.generate(3, (index) => Padding(
                      padding: const EdgeInsetsDirectional.only(end: Dimensions.paddingSizeSmall),
                      child: block(width: Dimensions.paddingSizeRevenueBottom, height: Dimensions.paddingSizeRevenueBottom, borderRadius: Dimensions.paddingEye),
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final double titleWidth;
  final Widget child;
  const _Section({required this.titleWidth, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
            child: WholesaleProductDetailsShimmerWidget._block(width: titleWidth, height: 16),
          ),
          Divider(height: 1, thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeMedium), child: child),
        ],
      ),
    );
  }
}

class _InfoRowShimmer extends StatelessWidget {
  final _BlockBuilder block;
  final double valueWidth;
  const _InfoRowShimmer({required this.block, required this.valueWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(
        children: [
          SizedBox(width: 120, child: Align(alignment: AlignmentDirectional.centerStart, child: block(width: 84, height: 12))),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          block(width: valueWidth, height: 12),
        ],
      ),
    );
  }
}
