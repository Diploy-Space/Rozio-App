import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleAiSparkleWidget extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const WholesaleAiSparkleWidget({super.key, required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: isLoading ? null : onTap,
          child: isLoading
              ? Shimmer.fromColors(
                  baseColor: Theme.of(context).hintColor.withValues(alpha: 0.18),
                  highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.06),
                  child: Row(children: [
                    const Icon(Icons.auto_awesome, color: Colors.blue),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text(getTranslated('generating', context) ?? '', style: robotoBold.copyWith(color: Colors.blue)),
                  ]),
                )
              : const Icon(Icons.auto_awesome, color: Colors.blue),
        ),
      ],
    );
  }
}
