import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/app_mode/controllers/app_mode_controller.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/app_mode_availability.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/enums/app_mode.dart';
import 'package:sixvalley_vendor_app/features/app_mode/widgets/app_mode_welcome_bottom_sheet.dart';
import 'package:sixvalley_vendor_app/features/wholesale/attribute/controllers/wholesale_attribute_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatTax/controllers/wholesale_vat_tax_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/brand/controllers/wholesale_brand_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/category/controllers/wholesale_category_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class ShoppingModeBottomSheet extends StatelessWidget {
  const ShoppingModeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: close button + title + subtitle
            Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeMedium,
                  Dimensions.paddingSizeDefault, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.6),
                        child: const Icon(Icons.close, color: Colors.white, size: Dimensions.iconSizeDefault),
                      ),
                    ),
                  ),
                  Text(
                    getTranslated('choose_your_shopping_mode', context) ?? '',
                    textAlign: TextAlign.center,
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(
                    getTranslated('choose_shopping_mode_subtitle', context) ?? '',
                    textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.headlineLarge?.color,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeDefault),

            Consumer<AppModeController>(
              builder: (context, appModeController, _) {
                final List<AppMode> modes = AppModeAvailability.availableModes(context);

                return Column(
                  children: modes
                    .map((mode) => _ModeCard(
                      mode: mode,
                      isSelected: appModeController.appMode == mode,
                      onTap: () => _onSelectMode(context, appModeController, mode),
                    )).toList(),
                );
              },
            ),

            const SizedBox(height: Dimensions.paddingSizeSmall),
            Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),

            // Note
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '#${getTranslated('note', context) ?? 'Note'} : ',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: getTranslated('switch_modules_note', context) ?? '',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelectMode(BuildContext context, AppModeController controller, AppMode mode) {
    // Captured before this sheet is popped, so it stays valid for whatever we
    // show next.
    final BuildContext hostContext = Navigator.of(context).context;
    final bool isFirstVisit = controller.shouldShowModeWelcome(mode);

    controller.setAppMode(mode);

    if (mode == AppMode.wholesale) {
      Provider.of<WholesaleCategoryController>(context, listen: false).getCategoryList(reload: true);
      Provider.of<WholesaleBrandController>(context, listen: false).getBrandList(reload: true);
      Provider.of<WholesaleAttributeController>(context, listen: false).getAttributeList(reload: true);
      Provider.of<WholesaleVatTaxController>(context, listen: false).getVatTaxSetup(reload: true);
    }

    Navigator.pop(context);

    // The very first switch into wholesale/auction gets the welcome sheet
    // instead of the usual confirmation snack bar.
    if (isFirstVisit) {
      controller.setModeWelcomeShown(mode);
      showModalBottomSheet(
        context: hostContext,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AppModeWelcomeBottomSheet(appMode: mode),
      );
      return;
    }

    showCustomSnackBarWidget(
      '${getTranslated(mode.titleKey, context) ?? ''} ${getTranslated('mode_selected', context) ?? 'mode selected'}',
      context,
      isError: false,
      sanckBarType: SnackBarType.success,
    );
  }
}

class _ModeCard extends StatelessWidget {
  final AppMode mode;
  final bool isSelected;
  final VoidCallback onTap;
  const _ModeCard({required this.mode, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.03)
              : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),

            border: Border.all(
              color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.4)
              : Theme.of(context).hintColor.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              CustomAssetImageWidget(mode.icon, height: Dimensions.iconSizeMedium, width: Dimensions.iconSizeMedium),

              const SizedBox(width: Dimensions.paddingSizeMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTranslated(mode.titleKey, context) ?? '',
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(
                      getTranslated(mode.descriptionKey, context) ?? '',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),


              if (isSelected) ...[
                const SizedBox(width: Dimensions.paddingSizeSmall),
                CircleAvatar(
                  radius: 9,
                  backgroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                  child: const Icon(Icons.check, color: Colors.white, size: Dimensions.iconSizeSmall),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
