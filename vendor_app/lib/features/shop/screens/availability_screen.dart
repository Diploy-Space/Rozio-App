import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/app_mode_availability.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/enums/app_mode.dart';
import 'package:sixvalley_vendor_app/features/shop/controllers/shop_controller.dart';
import 'package:sixvalley_vendor_app/features/shop/widgets/shop_details_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {

  static const Map<String, String> _moduleDescriptions = {
    'retail': 'retail_availability_description',
    'wholesale': 'wholesale_availability_description',
    'auction': 'auction_availability_description',
  };

  @override
  void initState() {
    super.initState();
    Provider.of<ShopController>(context, listen: false).setAvailableModules(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> activeModules = AppModeAvailability.availableModes(context).map((mode) => mode.value).toList();

    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('availability', context)),

      body: Consumer<ShopController>(
        builder: (context, shopController, child) {
          return Column(children: [

            Expanded(child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              children: _moduleDescriptions.entries.where((module) => activeModules.contains(module.key)).map((module) => Container(
                margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeMedium, right: Dimensions.paddingSizeMedium),
                padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(getTranslated(module.key, context) ?? '',
                    style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(getTranslated(module.value, context) ?? '',
                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color, fontSize: Dimensions.fontSizeSmall),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  ShopSettingWidget(
                    title: 'statuss',
                    borderColor: Theme.of(context).hintColor.withValues(alpha: 0.20),
                    mode: shopController.availableModules.contains(module.key),
                    onTap: (value) => shopController.toggleAvailableModule(module.key),
                  ),
                ]),
              )).toList(),
            )),

            Container(height: 60,
              color: Theme.of(context).cardColor,
              child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(children: [
                  Expanded(child: CustomButtonWidget(
                    backgroundColor: Theme.of(context).hintColor.withValues(alpha: .1),
                    isColor: true,
                    fontColor: Theme.of(context).textTheme.bodyLarge?.color,
                    btnTxt: getTranslated('reset', context),
                    onTap: () => shopController.resetAvailableModules(context, activeModules),)),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(child: shopController.isLoading ?
                    const Center(child: CircularProgressIndicator()) :
                    CustomButtonWidget(
                      btnTxt: getTranslated('save', context),
                      onTap: () => shopController.shopTemporaryClose(context, List<String>.from(shopController.availableModules)),
                    ),
                  ),
                ]),
              ),
            ),

          ]);
        },
      ),
    );
  }
}
