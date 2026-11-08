import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CustomFieldWithTitleWidget extends StatelessWidget {
  final Widget customTextField;
  final String? title;
  final bool requiredField;
  final bool isPadding;
  final bool isSKU;
  final bool limitSet;
  final String? setLimitTitle;
  final Function? onTap;
  final bool isCoupon;
  final String? errorText;
  const CustomFieldWithTitleWidget({
    super.key,
    required this.customTextField,
    this.title,
    this.setLimitTitle,
    this.requiredField = false,
    this.isPadding = true,
    this.isSKU = false,
    this.limitSet = false,
    this.onTap, this.isCoupon = false, this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isCoupon? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall): isPadding ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: title, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                children: <TextSpan>[
                 requiredField ? TextSpan(text: '  *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)) : const TextSpan(),
                ],
              ),
            ),
         ],
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        
        customTextField,

        if (errorText != null) ...[
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text(errorText!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error)),
        ],
      ],),
    );
  }
}
