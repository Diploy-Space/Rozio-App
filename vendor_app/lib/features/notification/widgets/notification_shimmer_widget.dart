import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class NotificationShimmerWidget extends StatelessWidget {
  final int itemCount;
  final bool hasLeadingIcon;
  const NotificationShimmerWidget({super.key, this.itemCount = 7, this.hasLeadingIcon = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(top: hasLeadingIcon ? 0 : Dimensions.paddingSizeSmall),
        child: Container(
          width: double.infinity,
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).hintColor.withValues(alpha: 0.18),
            highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.06),
            child: hasLeadingIcon ? _leadingIconRow() : _stackedRow(),
          ),
        ),
      ),
    );
  }

  Widget _stackedRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _block(height: 14),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        _block(width: 90, height: 10),
      ],
    );
  }

  Widget _leadingIconRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _block(width: 45, height: 45, borderRadius: 45),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _block(height: 14)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  _block(width: 45, height: 10),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              _block(height: 10),
              const SizedBox(height: Dimensions.paddingSizeOrder),
              _block(width: 180, height: 10),
            ],
          ),
        ),
      ],
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
