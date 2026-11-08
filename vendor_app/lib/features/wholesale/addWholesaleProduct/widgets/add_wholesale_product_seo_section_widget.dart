import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/widgets/add_product_section_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_meta_image_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_meta_title_description_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/controllers/wholesale_ai_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_seo_section_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/enums/wholesale_ai_image_step.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/widgets/wholesale_ai_sparkle_widget.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/models/config_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductSeoSectionWidget extends StatefulWidget {
  const AddWholesaleProductSeoSectionWidget({super.key});

  @override
  State<AddWholesaleProductSeoSectionWidget> createState() => _AddWholesaleProductSeoSectionWidgetState();
}

class _AddWholesaleProductSeoSectionWidgetState extends State<AddWholesaleProductSeoSectionWidget> with TickerProviderStateMixin {
  late TabController _languageTabController;

  @override
  void initState() {
    super.initState();
    final languageList = Provider.of<SplashController>(context, listen: false).configModel!.languageList!;
    _languageTabController = TabController(length: languageList.length, vsync: this);
    Provider.of<AddWholesaleProductController>(context, listen: false).initMetaSeoControllers(languageList);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final WholesaleAiController aiController = Provider.of<WholesaleAiController>(context, listen: false);
      if (!aiController.consumeImageStep(WholesaleAiImageStep.seo)) {
        return;
      }
      if (aiController.imageLanguageIndex < _languageTabController.length) {
        _languageTabController.index = aiController.imageLanguageIndex;
      }
      _generateSeoSection(Provider.of<AddWholesaleProductController>(context, listen: false));
    });
  }

  @override
  void dispose() {
    _languageTabController.dispose();
    super.dispose();
  }

  List<Widget> _languageTabs(List<Language> languageList) {
    return List.generate(languageList.length, (index) {
      final String name = languageList[index].name ?? '';
      final String capitalized = name.isEmpty ? name : '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
      return Text(capitalized, style: robotoBold.copyWith());
    });
  }

  List<Widget> _languageTabPages(AddWholesaleProductController controller, int languageCount) {
    return List.generate(languageCount, (index) => AddWholesaleProductMetaTitleDescriptionWidget(controller: controller, index: index));
  }

  Future<void> _generateSeoSection(AddWholesaleProductController controller) async {
    final int index = _languageTabController.index;
    final String name = index < controller.titleControllerList.length ? controller.titleControllerList[index].text.trim() : '';
    final String description = index < controller.descriptionControllerList.length ? controller.descriptionControllerList[index].text.trim() : '';

    if (name.isEmpty) {
      showCustomSnackBarWidget(getTranslated('product_name_required', context), context, sanckBarType: SnackBarType.warning);
      return;
    }

    await Provider.of<WholesaleAiController>(context, listen: false).generateSeoSection(
      name: name,
      description: description,
      apply: (WholesaleAiSeoSectionModel seo) async {
        if (!mounted) {
          return;
        }
        controller.applyAiSeoSection(seo, languageIndex: index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageList = Provider.of<SplashController>(context, listen: false).configModel!.languageList!;
    final WholesaleAiController aiController = Provider.of<WholesaleAiController>(context);

    return Consumer<AddWholesaleProductController>(
      builder: (context, controller, _) {
        return AddProductSectionWidget(
          title: getTranslated('seo_section', context)!,
          subTitle: getTranslated('add_meta_titles_descriptions_and_images_for_products', context)!,
          isAiGenerating: aiController.seoSectionLoading,
          aiWidget: WholesaleAiSparkleWidget(
            isLoading: aiController.seoSectionLoading,
            onTap: () => _generateSeoSection(controller),
          ),
          childrenPadding: Dimensions.paddingSizeMedium,
          childrens: [
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
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
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 2.0, color: Theme.of(context).primaryColor),
                          insets: EdgeInsets.zero,
                        ),
                        indicatorPadding: const EdgeInsets.symmetric(horizontal: 0),
                        unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                        labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                        tabs: _languageTabs(languageList),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 220,
                    child: AnimatedBuilder(
                      animation: _languageTabController,
                      builder: (context, child) {
                        return TabBarView(controller: _languageTabController, children: _languageTabPages(controller, languageList.length));
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text(
              getTranslated('meta_image', context)!,
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Text(
              getTranslated('product_additional_image_info', context) ?? '',
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            const AddWholesaleProductMetaImageWidget(),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],
        );
      },
    );
  }
}
