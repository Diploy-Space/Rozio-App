import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/controllers/wholesale_ai_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/widgets/wholesale_ai_sparkle_widget.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class AddWholesaleProductTitleAndDescriptionWidget extends StatelessWidget {
  final AddWholesaleProductController controller;
  final int index;

  final String langCode;

  const AddWholesaleProductTitleAndDescriptionWidget({super.key, required this.controller, required this.index, required this.langCode});

  @override
  Widget build(BuildContext context) {
    final bool isAiFeatureActive = Provider.of<SplashController>(context, listen: false).configModel?.isAiFeatureActive == 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.iconSizeSmall),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (isAiFeatureActive)
          Consumer<WholesaleAiController>(
            builder: (context, aiController, _) {
              return WholesaleAiSparkleWidget(
                isLoading: aiController.titleLoading,
                onTap: () {
                  if (controller.titleControllerList[index].text.trim().isEmpty) {
                    showCustomSnackBarWidget(getTranslated('product_name_required', context), context, sanckBarType: SnackBarType.warning);
                    return;
                  }

                  aiController.generateTitle(
                    name: controller.titleControllerList[index].text,
                    langCode: langCode,
                    nameController: controller.titleControllerList[index],
                  );
                },
              );
            },
          ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        CustomTextFieldWidget(
          formProduct: true,
          textInputAction: TextInputAction.next,
          controller: controller.titleControllerList[index],
          textInputType: TextInputType.name,
          required: true,
          hintText: getTranslated('product_name', context),
          maxSize: 255,
          border: true,
          borderColor: Theme.of(context).primaryColor.withValues(alpha: .25),
          onChanged: (String text) => controller.setTitle(index, text),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        if (isAiFeatureActive)
          Consumer<WholesaleAiController>(
            builder: (context, aiController, _) {
              return WholesaleAiSparkleWidget(
                isLoading: aiController.descLoading,
                onTap: () {
                  if (controller.titleControllerList[index].text.trim().isEmpty) {
                    showCustomSnackBarWidget(getTranslated('product_name_required', context), context, sanckBarType: SnackBarType.warning);
                    return;
                  }

                  aiController.generateDescription(
                    name: controller.titleControllerList[index].text,
                    langCode: langCode,
                    descriptionController: controller.descriptionControllerList[index],
                  );
                },
              );
            },
          ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        CustomTextFieldWidget(
          formProduct: true,
          required: true,
          isDescription: true,
          controller: controller.descriptionControllerList[index],
          onChanged: (String text) => controller.setDescription(index, text),
          textInputType: TextInputType.multiline,
          maxLine: 3,
          border: true,
          borderColor: Theme.of(context).primaryColor.withValues(alpha: .25),
          hintText: getTranslated('product_description', context),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
      ]),
    );
  }
}
