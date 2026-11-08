import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/attribute_view_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/dropdown_decorator_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/add_product_image_controller.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/variation_controller.dart';
import 'package:sixvalley_vendor_app/features/addProduct/widgets/add_product_section_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_bottom_nav_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_category_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_color_variation_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_tag_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_title_and_description_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/controllers/wholesale_ai_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_general_setup_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_variation_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/widgets/wholesale_ai_sparkle_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/attribute/controllers/wholesale_attribute_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/brand/controllers/wholesale_brand_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/category/controllers/wholesale_category_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/models/config_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddWholesaleProductGeneralSetupScreen extends StatefulWidget {
  final Function(int) onTabChanged;
  const AddWholesaleProductGeneralSetupScreen({super.key, required this.onTabChanged});

  @override
  State<AddWholesaleProductGeneralSetupScreen> createState() => AddWholesaleProductGeneralSetupScreenState();
}

class AddWholesaleProductGeneralSetupScreenState extends State<AddWholesaleProductGeneralSetupScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _languageTabController;
  late TextfieldTagsController _tagsController;
  bool _isGeneratingSku = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final languageList = Provider.of<SplashController>(context, listen: false).configModel!.languageList!;
    _languageTabController = TabController(length: languageList.length, vsync: this);
    _tagsController = TextfieldTagsController();
    Provider.of<AddWholesaleProductController>(context, listen: false).initTitleAndDescriptionControllers(languageList);
    Provider.of<WholesaleCategoryController>(context, listen: false).resetSelection(notify: false);
    Provider.of<WholesaleCategoryController>(context, listen: false).getCategoryList(isUpdate: false);
    Provider.of<WholesaleBrandController>(context, listen: false).reset(notify: false);
    Provider.of<WholesaleBrandController>(context, listen: false).getBrandList(isUpdate: false);
    Provider.of<AddProductImageController>(context, listen: false).removeProductImage();
    Provider.of<VariationController>(context, listen: false).initColorCode();
    Provider.of<SplashController>(context, listen: false).getColorList();

    _loadWholesaleAttributes();
  }

  Future<void> _loadWholesaleAttributes() async {
    final WholesaleAttributeController attributeController = Provider.of<WholesaleAttributeController>(context, listen: false);
    Provider.of<VariationController>(context, listen: false).setAttributeList(attributeController.variationAttributes, notify: false);

    await attributeController.getAttributeList(isUpdate: false);

    if (!mounted) {
      return;
    }
    Provider.of<VariationController>(context, listen: false).setAttributeList(attributeController.variationAttributes);
  }

  @override
  void dispose() {
    _languageTabController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _goNext() => widget.onTabChanged(1);

  Future<void> runImageAutoFill(String name) async {
    final AddWholesaleProductController controller = Provider.of<AddWholesaleProductController>(context, listen: false);
    final WholesaleAiController aiController = Provider.of<WholesaleAiController>(context, listen: false);
    final List<Language> languageList = Provider.of<SplashController>(context, listen: false).configModel!.languageList!;
    final int index = _languageTabController.index;

    if (name.trim().isEmpty || aiController.imageAutoFillRunning || index >= controller.titleControllerList.length || index >= controller.descriptionControllerList.length) {
      return;
    }

    aiController.startImageAutoFill(languageIndex: index);
    controller.titleControllerList[index].text = name.trim();

    await aiController.generateDescription(
      name: name,
      langCode: languageList[index].code ?? 'en',
      descriptionController: controller.descriptionControllerList[index],
    );

    final bool hasDescription = controller.descriptionControllerList[index].text.trim().isNotEmpty;

    if (mounted && hasDescription) {
      await _generateGeneralSetup(controller, languageIndex: index);
    }
    if (mounted && hasDescription) {
      await _generateVariationSetup(controller, languageIndex: index);
    }

    aiController.finishImageAutoFill(armFollowUps: hasDescription);

    if (mounted && hasDescription) {
      showCustomSnackBarWidget(getTranslated('tap_next_to_automatically_generate', context), context, sanckBarType: SnackBarType.warning);
    }
  }

  String _generateSku() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    String sku = '';
    for (int i = 0; i < 6; i++) {
      sku += chars[random.nextInt(chars.length)];
    }
    return sku;
  }

  Future<void> _onGenerateSku(AddWholesaleProductController controller) async {
    if (_isGeneratingSku) {
      return;
    }
    setState(() => _isGeneratingSku = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      return;
    }
    controller.productCode.text = _generateSku();
    setState(() => _isGeneratingSku = false);
  }

  List<Widget> _languageTabs(List<Language> languageList) {
    return List.generate(languageList.length, (index) {
      final String name = languageList[index].name ?? '';
      final String capitalized = name.isEmpty ? name : '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
      return Text(capitalized, style: robotoBold.copyWith());
    });
  }

  Future<void> _generateGeneralSetup(AddWholesaleProductController controller, {int? languageIndex}) async {
    final int index = languageIndex ?? _languageTabController.index;
    final String name = controller.titleControllerList[index].text.trim();
    final String description = controller.descriptionControllerList[index].text.trim();

    if (name.isEmpty) {
      showCustomSnackBarWidget(getTranslated('product_name_required', context), context, sanckBarType: SnackBarType.warning);
      return;
    }
    if (description.isEmpty) {
      showCustomSnackBarWidget(getTranslated('product_description_required', context), context, sanckBarType: SnackBarType.warning);
      return;
    }

    final WholesaleAiController aiController = Provider.of<WholesaleAiController>(context, listen: false);

    await aiController.generateGeneralSetup(
      name: name,
      description: description,
      apply: (WholesaleAiGeneralSetupModel setup) async {
        if (!mounted) {
          return;
        }

        await controller.applyAiGeneralSetup(context, setup);

        if (setup.searchTags.isNotEmpty) {
          _tagsController.clearTags();
          for (final String tag in setup.searchTags) {
            _tagsController.addTag = tag;
          }
        }
      },
    );
  }

  Future<void> _generateVariationSetup(AddWholesaleProductController controller, {int? languageIndex}) async {
    final int index = languageIndex ?? _languageTabController.index;
    final String name = controller.titleControllerList[index].text.trim();
    final String description = controller.descriptionControllerList[index].text.trim();

    if (name.isEmpty) {
      showCustomSnackBarWidget(getTranslated('product_name_required', context), context, sanckBarType: SnackBarType.warning);
      return;
    }
    if (description.isEmpty) {
      showCustomSnackBarWidget(getTranslated('product_description_required', context), context, sanckBarType: SnackBarType.warning);
      return;
    }

    final WholesaleAiController aiController = Provider.of<WholesaleAiController>(context, listen: false);
    final VariationController variationController = Provider.of<VariationController>(context, listen: false);

    await aiController.generateVariationSetup(
      name: name,
      description: description,
      apply: (WholesaleAiVariationModel variation) async {
        if (!mounted) {
          return;
        }

        if (!controller.isAttributeActive) {
          controller.setIsAttributeActive(true);
        }

        variationController.addAiColorVariation(variation.colorsActive, variation.colors, null);
        variationController.addAiAttribute(variation.choiceAttributes, null, variation.generatedVariations);
      },
    );
  }

  List<Widget> _languageTabPages(AddWholesaleProductController controller, List<Language> languageList) {
    return List.generate(
      languageList.length,
      (index) => AddWholesaleProductTitleAndDescriptionWidget(
        controller: controller,
        index: index,
        langCode: languageList[index].code ?? 'en',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final languageList = Provider.of<SplashController>(context, listen: false).configModel!.languageList!;
    final bool isBrandActive = Provider.of<SplashController>(context, listen: false)
        .configModel?.wholesaleConfig?.product?.brandEnabled == true;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMedium),
            child: Consumer<AddWholesaleProductController>(
              builder: (context, controller, _) {

                final WholesaleAiController aiController = Provider.of<WholesaleAiController>(context);

                return Column(
                  children: [
                    AddProductSectionWidget(
                      title: getTranslated('basic_info', context)!,
                      subTitle: getTranslated('here_you_can_setup_the_product', context)!,

                      isAiGenerating: aiController.titleLoading || aiController.descLoading,
                      childrens: [
                        Container(
                          margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: Dimensions.paddingSizeMedium, left: Dimensions.paddingEye, bottom: Dimensions.paddingEye),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TabBar(
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    tabAlignment: TabAlignment.start,
                                    isScrollable: true,
                                    dividerColor: Theme.of(context).hintColor,
                                    controller: _languageTabController,
                                    indicatorColor: Theme.of(context).primaryColor,
                                    indicatorWeight: 12,
                                    labelColor: Theme.of(context).primaryColor,
                                    indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 2.0, color: Theme.of(context).primaryColor), insets: EdgeInsets.zero),
                                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 0),
                                    unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                    labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                                    tabs: _languageTabs(languageList),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 235,
                                child: AnimatedBuilder(
                                  animation: _languageTabController,
                                  builder: (BuildContext context, Widget? child) {
                                    return TabBarView(controller: _languageTabController, children: _languageTabPages(controller, languageList));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: Dimensions.paddingSizeLarge),


                    AddProductSectionWidget(
                      title: getTranslated('general_setup', context)!,
                      subTitle: getTranslated('here_you_can_set_up_the_foundational_details', context)!,
                      isAiGenerating: aiController.generalSetupLoading,
                      aiWidget: WholesaleAiSparkleWidget(
                        isLoading: aiController.generalSetupLoading,
                        onTap: () => _generateGeneralSetup(controller),
                      ),
                      childrenPadding: Dimensions.paddingSize,
                      childrens: [
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        const AddWholesaleProductCategoryWidget(),

                        if (isBrandActive)
                          Consumer<WholesaleBrandController>(
                            builder: (context, brandController, _) {
                              final bool isBrandListed = (brandController.brandList ?? [])
                                  .any((brand) => brand.id == brandController.selectedBrandId);

                              return Column(
                                children: [
                                  DropdownDecoratorWidget(
                                    child: DropdownButton<int>(
                                      value: isBrandListed ? brandController.selectedBrandId : null,
                                      icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor),
                                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingEye)),
                                      hint: Text(
                                        getTranslated('select_brand', context)!,
                                        style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                      ),
                                      items: (brandController.brandList ?? []).map((brand) {
                                        return DropdownMenuItem<int>(
                                          value: brand.id,
                                          child: Text(
                                            brand.name ?? '',
                                            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (int? value) => brandController.setSelectedBrandId(value),
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeVeryTiny),
                                ],
                              );
                            },
                          ),

                        Row(
                          children: [
                            const Spacer(),
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () => _onGenerateSku(controller),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                child: _isGeneratingSku
                                    ? SizedBox(
                                        height: Dimensions.iconSizeDefault,
                                        width: Dimensions.iconSizeDefault,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).primaryColor),
                                      )
                                    : Text(getTranslated('generate_code', context)!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        CustomTextFieldWidget(
                          formProduct: true,
                          required: true,
                          border: true,
                          borderColor: Theme.of(context).primaryColor.withValues(alpha: .25),
                          fillColor: Theme.of(context).cardColor,
                          controller: controller.productCode,
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.text,
                          hintText: getTranslated('product_code_sku', context)!,
                        ),
                        const SizedBox(height: Dimensions.paddingSize),

                        DropdownDecoratorWidget(
                          child: DropdownButton<String>(
                            icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingEye)),
                            hint: (controller.unitValue == null || controller.unitValue == 'select_unit')
                                ? Text(getTranslated('select_unit_required', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color))
                                : Text(controller.unitValue!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                            items: Provider.of<SplashController>(context, listen: false).configModel!.unit!.map((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)));
                            }).toList(),
                            onChanged: (val) => controller.setValueForUnit(val),
                            isExpanded: true,
                            underline: const SizedBox(),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSize),

                        CustomTextFieldWidget(
                          border: true,
                          fillColor: Theme.of(context).cardColor,
                          controller: controller.reOrderLevelController,
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.number,
                          isAmount: true,
                          hintText: getTranslated('re_order_level', context)!,
                          formProduct: true,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomTextFieldWidget(
                          border: true,
                          required: true,
                          fillColor: Theme.of(context).cardColor,
                          controller: controller.shippingCostController,
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.number,
                          isAmount: true,
                          hintText: getTranslated('shipping_cost', context)!,
                          formProduct: true,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        DropdownDecoratorWidget(
                          title: 'shipping_cost_multiply',
                          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: Dimensions.fontSizeDefault),
                                child: Text(getTranslated('statuss', context)!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color!)),
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            FlutterSwitch(
                              width: 35.0,
                              height: 20.0,
                              toggleSize: 20.0,
                              value: controller.isMultiply,
                              borderRadius: 20.0,
                              activeColor: Theme.of(context).primaryColor,
                              padding: 1.0,
                              onToggle: (bool isActive) => controller.toggleMultiply(),
                            ),
                          ]),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeMedium),
                        AddWholesaleProductTagWidget(controller: controller, textfieldTagsController: _tagsController),
                        const SizedBox(height: Dimensions.paddingSizeMedium),

                      ],
                    ),
                    SizedBox(height: Dimensions.paddingSizeLarge),


                    Consumer<VariationController>(
                      builder: (context, variationController, _) {
                        final bool attributesLoaded = variationController.attributeList != null && variationController.attributeList!.isNotEmpty;

                        return AddProductSectionWidget(
                          title: getTranslated('product_variation', context)!,
                          subTitle: getTranslated('here_you_setup_color_wise_variations', context)!,
                          isAiGenerating: aiController.variationSetupLoading,
                          aiWidget: WholesaleAiSparkleWidget(
                            isLoading: aiController.variationSetupLoading,
                            onTap: () => _generateVariationSetup(controller),
                          ),
                          button: Padding(
                            padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                            child: FlutterSwitch(
                              width: 40.0,
                              height: 20.0,
                              toggleSize: 20.0,
                              value: controller.isAttributeActive,
                              borderRadius: 20.0,
                              activeColor: Theme.of(context).primaryColor,
                              padding: 1.0,
                              onToggle: (bool isActive) => controller.setIsAttributeActive(isActive),
                            ),
                          ),
                          childrenPadding: Dimensions.paddingSize,
                          childrens: [
                            if (!controller.isAttributeActive) const SizedBox(height: Dimensions.paddingSizeSmall),

                            if (controller.isAttributeActive && attributesLoaded)
                              Column(
                                children: [
                                  const SizedBox(height: Dimensions.paddingSizeDefault),

                                  const AddWholesaleProductColorVariationWidget(),
                                  const SizedBox(height: Dimensions.paddingSizeDefault),

                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                                    ),
                                    padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          getTranslated('other_attributes', context)!,
                                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          getTranslated('here_you_can_setup_the_product_attribute', context)!,
                                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        AttributeViewWidget(product: null, colorOn: variationController.attributeList![0].active),
                                        const SizedBox(height: Dimensions.paddingSizeSmall),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeDefault)
                                ],
                              ),

                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        AddWholesaleProductBottomNavWidget(
          showGoBack: false,
          actionLabel: getTranslated('next', context) ?? 'Next',
          onAction: _goNext,
          isAiGenerating: context.select<WholesaleAiController, bool>((aiController) => aiController.imageAutoFillRunning),
        ),
      ],
      ),
    );
  }
}
