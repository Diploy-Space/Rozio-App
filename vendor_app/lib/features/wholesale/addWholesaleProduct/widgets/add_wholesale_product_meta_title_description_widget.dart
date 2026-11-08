import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class AddWholesaleProductMetaTitleDescriptionWidget extends StatelessWidget {
  final AddWholesaleProductController controller;
  final int index;
  const AddWholesaleProductMetaTitleDescriptionWidget({super.key, required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.iconSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          CustomTextFieldWidget(
            formProduct: true,
            required: index == 0,
            border: true,
            borderColor: Theme.of(context).primaryColor.withValues(alpha: .25),
            controller: controller.metaTitleControllerList[index],
            textInputAction: TextInputAction.next,
            hintText: getTranslated('meta_title', context),
          ),
          const SizedBox(height: Dimensions.paddingSizeMedium),

          CustomTextFieldWidget(
            formProduct: true,
            border: true,
            borderColor: Theme.of(context).primaryColor.withValues(alpha: .25),
            controller: controller.metaDescriptionControllerList[index],
            textInputType: TextInputType.multiline,
            maxLine: 3,
            hintText: getTranslated('meta_description', context),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        ],
      ),
    );
  }
}
