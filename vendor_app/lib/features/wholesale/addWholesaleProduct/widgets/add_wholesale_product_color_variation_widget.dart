import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/variation_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/models/config_model.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductColorVariationWidget extends StatefulWidget {
  const AddWholesaleProductColorVariationWidget({super.key});

  @override
  State<AddWholesaleProductColorVariationWidget> createState() => _AddWholesaleProductColorVariationWidgetState();
}

class _AddWholesaleProductColorVariationWidgetState extends State<AddWholesaleProductColorVariationWidget> {
  TextEditingController? _autoController;
  FocusNode? _autoFocusNode;

  Iterable<int> _getColorSuggestionsIndexList({
    required List<int> colors,
    required List<ColorList>? colorList,
    required List<String?> savedColorVariationList,
    required String pattern,
  }) {
    return colors.where((colorIndex) =>
        colorList![colorIndex].name!.toLowerCase().contains(pattern.toLowerCase()) &&
        !(savedColorVariationList.contains(colorList[colorIndex].name)));
  }

  @override
  Widget build(BuildContext context) {
    final List<int> colors = [];

    return Consumer<VariationController>(
      builder: (context, variationController, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
          ),
          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTranslated('color', context)!,
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          getTranslated('here_you_setup_color_wise_variations', context)!,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  FlutterSwitch(
                    width: 40.0,
                    height: 20.0,
                    toggleSize: 20.0,
                    value: variationController.attributeList![0].active,
                    borderRadius: 20.0,
                    activeColor: Theme.of(context).primaryColor,
                    padding: 1.0,
                    onToggle: (bool isActive) => variationController.toggleAttribute(context, 0, null),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              if (variationController.attributeList![0].active)
                Consumer<SplashController>(
                  builder: (ctx, colorProvider, child) {
                    if (colorProvider.colorList != null) {
                      for (int index = 0; index < colorProvider.colorList!.length; index++) {
                        colors.add(index);
                      }
                    }
                    return Autocomplete<int>(
                      optionsBuilder: (TextEditingValue value) {
                        return _getColorSuggestionsIndexList(
                          colors: colors,
                          colorList: colorProvider.colorList,
                          savedColorVariationList: variationController.attributeList?.first.variants ?? [],
                          pattern: value.text,
                        );
                      },
                      optionsViewBuilder: (context, void Function(int) onSelected, Iterable<int> options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - (Dimensions.paddingSizeDefault * 2),
                              height: 250,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final int optionIndex = options.elementAt(index);
                                  final colorItem = colorProvider.colorList![optionIndex];
                                  String hexString = colorItem.code!.replaceAll('#', '');
                                  Color itemColor = Color(int.parse("0xFF$hexString"));

                                  return InkWell(
                                    onTap: () => onSelected(optionIndex),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: itemColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                                            ),
                                          ),
                                          const SizedBox(width: Dimensions.paddingSizeSmall),
                                          Expanded(
                                            child: Text(
                                              colorItem.name!,
                                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      fieldViewBuilder: (context, controller, node, onComplete) {
                        _autoController ??= controller;
                        _autoFocusNode ??= node;
                        return Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha: .50)),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          ),
                          child: TextField(
                            controller: controller,
                            focusNode: node,
                            onEditingComplete: onComplete,
                            onTapOutside: (_) => node.unfocus(),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              hintText: getTranslated('type_color_name', context),
                              hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: InkWell(
                                onTap: () => node.hasFocus ? node.unfocus() : node.requestFocus(),
                                child: Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                        );
                      },
                      displayStringForOption: (value) => colorProvider.colorList![value].name!,
                      onSelected: (int value) {
                        variationController.addVariant(context, 0, colorProvider.colorList![value].name, null, true);
                        variationController.addColorCode(colorProvider.colorList![value].code);

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _autoFocusNode?.unfocus();
                        });
                      },
                    );
                  },
                ),

              SizedBox(height: (variationController.attributeList![0].variants.isNotEmpty) ? Dimensions.paddingSizeSmall : 0),

              if (variationController.attributeList?[0].active ?? false)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: variationController.attributeList![0].variants.isNotEmpty
                      ? Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Wrap(
                          spacing: Dimensions.paddingSizeSmall,
                          runSpacing: Dimensions.paddingSizeSmall,
                          children: List.generate(variationController.attributeList![0].variants.length, (index) {
                            String hexString = '';
                            if (variationController.colorCodeList.isNotEmpty && variationController.colorCodeList.length > index) {
                              hexString = variationController.colorCodeList[index]!.replaceAll('#', '');
                            }
                            Color itemColor = Color(int.parse("0xFF$hexString"));
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: itemColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                                    ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                    variationController.attributeList![0].variants[index]!,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorHelper.blendColors(Colors.white, Theme.of(context).textTheme.bodyLarge!.color!, 0.7),
                                    ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      variationController.removeVariant(context, 0, index, null);
                                      variationController.removeColorCode(index);
                                    },
                                    child: Icon(Icons.close, size: 15, color: ColorHelper.blendColors(Colors.white, Theme.of(context).textTheme.bodyLarge!.color!, 0.7)),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        )
                      : const SizedBox(),
                ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ],
          ),
        );
      },
    );
  }
}
