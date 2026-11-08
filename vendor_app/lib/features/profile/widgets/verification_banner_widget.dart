import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/profile/widgets/verification_criteria_bottom_sheet.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class VerificationBannerWidget extends StatelessWidget {
  final bool isVerified;
  const VerificationBannerWidget({super.key, this.isVerified = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium, vertical: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: .35),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Row(children: [
          Icon(Icons.verified, color: Theme.of(context).colorScheme.onTertiaryContainer, size: Dimensions.iconSizeMedium),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Text(getTranslated('want_to_verified', context) ?? '',
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
          )),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          InkWell(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => VerificationCriteriaBottomSheet(isVerified: isVerified),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium, vertical: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Text(getTranslated('view_criteria', context) ?? '',
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
