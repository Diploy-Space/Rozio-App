import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductBottomNavWidget extends StatelessWidget {
  final bool showGoBack;
  final VoidCallback? onGoBack;
  final String actionLabel;
  final VoidCallback? onAction;
  final bool isLoading;
  final bool isAiGenerating;

  const AddWholesaleProductBottomNavWidget({
    super.key,
    this.showGoBack = true,
    this.onGoBack,
    required this.actionLabel,
    this.onAction,
    this.isLoading = false,
    this.isAiGenerating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: ThemeShadow.getShadow(context),
      ),
      height: 80,
      child: Row(
        children: [
          if (showGoBack) ...[
            Expanded(
              child: CustomButtonWidget(
                isColor: true,
                btnTxt: getTranslated('go_back', context),
                backgroundColor: Theme.of(context).hintColor.withValues(alpha: .1),
                fontColor: Theme.of(context).textTheme.bodyLarge?.color,
                buttonHeight: 55,
                onTap: onGoBack,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
          ],
          Expanded(
            child: isAiGenerating
                ? Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.30),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            getTranslated('ai_is_generating_product_details', context) ?? '',
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Shimmer.fromColors(
                          baseColor: Theme.of(context).hintColor.withValues(alpha: 0.18),
                          highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.06),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.auto_awesome, color: Theme.of(context).primaryColor),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Text(getTranslated('generating', context) ?? '', style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                          ]),
                        ),
                      ],
                    ),
                  )
                : isLoading
                ? const Center(child: SizedBox(height: 35, width: 35, child: CircularProgressIndicator()))
                : CustomButtonWidget(
                    btnTxt: actionLabel,
                    buttonHeight: 55,
                    onTap: onAction,
                  ),
          ),
        ],
      ),
    );
  }
}
