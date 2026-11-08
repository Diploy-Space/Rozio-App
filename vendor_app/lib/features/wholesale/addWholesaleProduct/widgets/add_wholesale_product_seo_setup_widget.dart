import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart' show FlutterSwitch;
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/dropdown_decorator_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/widgets/add_product_section_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductSeoSetupWidget extends StatelessWidget {
  const AddWholesaleProductSeoSetupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddWholesaleProductController>(
      builder: (context, controller, _) {
        return AddProductSectionWidget(
          title: getTranslated('other_seo_setup', context)!,
          subTitle: getTranslated('seo_setup_description', context)!,
          childrenPadding: Dimensions.paddingSizeMedium,
          childrens: [
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.25)),
              ),
              child: RadioGroup<String>(
                groupValue: controller.metaSeoInfo.metaIndex,
                onChanged: (String? value) {
                  if (value != null) {
                    controller.setMetaIndexOption(value);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => controller.setMetaIndexOption('index'),
                        child: Row(
                          children: [
                            Radio<String>(value: 'index', visualDensity: const VisualDensity(horizontal: -4, vertical: -4)),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Text(getTranslated('index', context) ?? 'Index', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => controller.setMetaIndexOption('noindex'),
                        child: Row(
                          children: [
                            Radio<String>(value: 'noindex', visualDensity: const VisualDensity(horizontal: -4, vertical: -4)),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Text(getTranslated('no_index', context) ?? 'No Index', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.25)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SeoCheckboxItem(
                          title: 'no_follow',
                          value: controller.metaSeoInfo.metaNoFollow == 'nofollow',
                          callback: (value) => controller.setMetaNoFollow(value ?? false),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: _SeoCheckboxItem(
                          title: 'no_archive',
                          value: controller.metaSeoInfo.metaNoArchive == '1',
                          callback: (value) => controller.setMetaNoArchive(value ?? false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Row(
                    children: [
                      Expanded(
                        child: _SeoCheckboxItem(
                          title: 'no_image_index',
                          value: controller.metaSeoInfo.metaNoImageIndex == '1',
                          callback: (value) => controller.setMetaNoImageIndex(value ?? false),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: _SeoCheckboxItem(
                          title: 'no_snippet',
                          value: controller.metaSeoInfo.metaNoSnippet == '1',
                          callback: (value) => controller.setMetaNoSnippet(value ?? false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _SeoToggleCard(
              title: getTranslated('max_snippet', context) ?? '',
              subtitle: getTranslated('maximum_characters_for', context) ?? '',
              value: controller.metaSeoInfo.metaMaxSnippet == '1',
              onToggle: controller.toggleMetaMaxSnippet,
              child: CustomTextFieldWidget(
                textInputType: TextInputType.number,
                controller: controller.maxSnippetValueController,
                border: true,
                hintText: getTranslated('input_snippet_value', context),
                onChanged: controller.setMetaMaxSnippetValue,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _SeoToggleCard(
              title: getTranslated('max_video_preview', context) ?? '',
              subtitle: getTranslated('maximum_seconds_for_the_video', context) ?? '',
              value: controller.metaSeoInfo.metaMaxVideoPreview == '1',
              onToggle: controller.toggleMetaMaxVideoPreview,
              child: CustomTextFieldWidget(
                textInputType: TextInputType.number,
                controller: controller.maxVideoPreviewValueController,
                border: true,
                hintText: getTranslated('input_max_video_preview_value', context),
                onChanged: controller.setMetaMaxVideoPreviewValue,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _SeoToggleCard(
              title: getTranslated('max_image_preview', context) ?? '',
              subtitle: getTranslated('determine_the_maximum_size_or', context) ?? '',
              value: controller.metaSeoInfo.metaMaxImagePreview == '1',
              onToggle: controller.toggleMetaMaxImagePreview,
              child: DropdownDecoratorWidget(
                title: getTranslated('max_image_preview_value', context),
                isRequired: true,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.imagePreviewTypeList.contains(controller.metaSeoInfo.metaMaxImagePreviewValue)
                        ? controller.metaSeoInfo.metaMaxImagePreviewValue
                        : null,
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    isExpanded: true,
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                    items: controller.imagePreviewTypeList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(getTranslated(value, context) ?? value, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                      );
                    }).toList(),
                    onChanged: (value) => controller.setMetaMaxImagePreviewValue(value ?? controller.metaSeoInfo.metaMaxImagePreviewValue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],
        );
      },
    );
  }
}

class _SeoToggleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onToggle;
  final Widget child;

  const _SeoToggleCard({required this.title, required this.subtitle, required this.value, required this.onToggle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(subtitle, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                  ],
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              FlutterSwitch(
                width: 35.0,
                height: 20.0,
                toggleSize: 20.0,
                value: value,
                borderRadius: 20.0,
                activeColor: Theme.of(context).primaryColor,
                padding: 1.0,
                onToggle: onToggle,
              ),
            ],
          ),
          if (value) ...[
            const SizedBox(height: Dimensions.paddingSizeDefault),
            child,
          ],
        ],
      ),
    );
  }
}

class _SeoCheckboxItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?> callback;

  const _SeoCheckboxItem({required this.title, required this.value, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: Dimensions.paddingSizeDefault,
            width: Dimensions.paddingSizeDefault,
            child: Checkbox(checkColor: Theme.of(context).cardColor, value: value, onChanged: callback),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Flexible(
            child: Text(
              getTranslated(title, context)!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
        ],
      ),
    );
  }
}
