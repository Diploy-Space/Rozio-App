import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class AddWholesaleProductFaqQuestionAnswerWidget extends StatelessWidget {
  final AddWholesaleProductController controller;
  final int index;
  final String languageName;
  const AddWholesaleProductFaqQuestionAnswerWidget({super.key, required this.controller, required this.index, this.languageName = ''});

  String _withLanguage(String? label) {
    final String base = label ?? '';
    return languageName.isEmpty ? base : '$base ($languageName)';
  }

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
            controller: controller.faqQuestionControllerList[index],
            textInputAction: TextInputAction.next,
            labelText: _withLanguage(getTranslated('question', context)),
            hintText: getTranslated('type_question', context),
            maxSize: 50,
          ),
          const SizedBox(height: Dimensions.paddingSizeMedium),

          CustomTextFieldWidget(
            border: true,
            borderColor: Theme.of(context).primaryColor.withValues(alpha: .25),
            controller: controller.faqAnswerControllerList[index],
            textInputType: TextInputType.multiline,
            maxLine: 3,
            hintText: _withLanguage(getTranslated('answer', context)),
            maxSize: 150,
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        ],
      ),
    );
  }
}
