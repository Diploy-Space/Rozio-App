import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductDetailsSectionWidget extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const WholesaleProductDetailsSectionWidget({super.key, this.title, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry contentPadding = padding ?? const EdgeInsets.all(Dimensions.paddingSizeMedium);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: contentPadding,
              child: Text(
                title!,
                style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            Divider(height: 1, thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
          ],
          Padding(padding: contentPadding, child: child),
        ],
      ),
    );
  }
}

class WholesaleProductInfoRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final Widget? valueWidget;
  const WholesaleProductInfoRowWidget({super.key, required this.label, this.value = '', this.valueWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Text(
            ':  ',
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          Expanded(
            child: valueWidget ??
                Text(
                  value,
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
