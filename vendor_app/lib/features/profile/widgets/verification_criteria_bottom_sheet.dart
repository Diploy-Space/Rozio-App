import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/features/profile/domain/models/verification_criteria_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class VerificationCriteriaBottomSheet extends StatefulWidget {
  final bool isVerified;
  const VerificationCriteriaBottomSheet({super.key, this.isVerified = false});

  @override
  State<VerificationCriteriaBottomSheet> createState() => _VerificationCriteriaBottomSheetState();
}

class _VerificationCriteriaBottomSheetState extends State<VerificationCriteriaBottomSheet> {

  bool _fetched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ProfileController>(context, listen: false).getVerificationCriteria();
      if (mounted) setState(() => _fetched = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color successColor = Theme.of(context).colorScheme.onTertiaryContainer;
    final Color failColor = Theme.of(context).colorScheme.error;
    final ProfileController profile = Provider.of<ProfileController>(context);
    final List<VerificationCriterion> criteria = profile.verificationCriteria?.criteria ?? [];
    final bool isVerified = profile.verificationCriteria?.isVerified ?? widget.isVerified;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
        ),
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeLarge, Dimensions.paddingSizeSmall, Dimensions.paddingSizeLarge, Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [

          Center(
            child: Container(
              width: 30, height: 4,
              margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha: .3), borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(color: Theme.of(context).cardColor.withValues(alpha: .15), shape: BoxShape.circle),
                child: Icon(Icons.close, size: Dimensions.iconSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(getTranslated('verification_criteria', context) ?? '', textAlign: TextAlign.center,
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(getTranslated('verification_criteria_description', context) ?? '', textAlign: TextAlign.center,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.headlineLarge?.color, height: 1.4)),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(color: Theme.of(context).cardColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(getTranslated('they_qualified_the_criteria', context) ?? '',
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              if(profile.isCriteriaLoading || !_fetched)
                const _CriteriaShimmer()
              else
                for(int i = 0; i < criteria.length; i++) ...[
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    criteria[i].met ?
                    Icon(Icons.check_circle, color: successColor, size: Dimensions.iconSizeMedium) :
                    Container(
                      width: Dimensions.iconSizeMedium - 2, height: Dimensions.iconSizeMedium - 2,
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: failColor, width: 1)),
                      child: Icon(Icons.close, color: failColor, size: Dimensions.iconSizeSmall - 2),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(text: criteria[i].leading ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.headlineLarge?.color)),
                              TextSpan(text: criteria[i].highlight ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                              TextSpan(text: criteria[i].trailing ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.headlineLarge?.color)),
                            ]),
                          ),
                          if(criteria[i].current != null && criteria[i].current!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              '${getTranslated('current', context) ?? 'Current'}: ${criteria[i].current}',
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ]),
                  if(i != criteria.length - 1) const SizedBox(height: Dimensions.paddingSizeMedium),
                ],
            ]),
          ),

          if(isVerified) ...[
            const SizedBox(height: Dimensions.paddingSizeLarge),
            InkWell(
              onTap: null,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMedium),
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                child: Text(getTranslated('contact_with_admin', context) ?? '',
                  style: robotoBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault)),
              ),
            ),
          ],
        ]),
      ),
    );
  }
}

class _CriteriaShimmer extends StatelessWidget {
  const _CriteriaShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).hintColor.withValues(alpha: .15),
      highlightColor: Theme.of(context).hintColor.withValues(alpha: .05),
      child: Column(children: [
        for(int i = 0; i < 5; i++) ...[
          Row(children: [
            Container(width: Dimensions.iconSizeMedium, height: Dimensions.iconSizeMedium,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(child: Container(height: 14,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)))),
          ]),
          if(i != 4) const SizedBox(height: Dimensions.paddingSizeMedium),
        ],
      ]),
    );
  }
}
