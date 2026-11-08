import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleOrderTypeButtonWidget extends StatelessWidget {
  final String? text;
  final String? icon;
  final Color? color;
  final VoidCallback? onTap;
  final int? numberOfOrder;
  final bool showBorder;
  const WholesaleOrderTypeButtonWidget({super.key, required this.text, this.icon, this.onTap, required this.numberOfOrder, this.color, this.showBorder = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon != null ? SizedBox(width: Dimensions.iconSizeLarge, child: Image.asset(icon!)) : const SizedBox(),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text(text!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),

                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: color!.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeLarge),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                    child: Text(numberOfOrder.toString(), style: robotoBold.copyWith(color: color)),
                  ),
                ),
              ],
            ),
          ),
        ),
        showBorder
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
              child: Divider(thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: .2)),
            )
          : const SizedBox(),
      ]),
    );
  }
}
