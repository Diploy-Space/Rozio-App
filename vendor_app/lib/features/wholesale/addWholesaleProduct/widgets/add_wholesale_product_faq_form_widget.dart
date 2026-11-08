import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/dropdown_decorator_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/widgets/add_product_section_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_faq_question_answer_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/controllers/wholesale_ai_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_faq_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/enums/wholesale_ai_image_step.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/widgets/wholesale_ai_sparkle_widget.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/models/config_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductFaqFormWidget extends StatefulWidget {
  const AddWholesaleProductFaqFormWidget({super.key});

  @override
  State<AddWholesaleProductFaqFormWidget> createState() => _AddWholesaleProductFaqFormWidgetState();
}

class _AddWholesaleProductFaqFormWidgetState extends State<AddWholesaleProductFaqFormWidget> with TickerProviderStateMixin {
  late TabController _languageTabController;

  @override
  void initState() {
    super.initState();
    final languageList = Provider.of<SplashController>(context, listen: false).configModel!.languageList!;
    _languageTabController = TabController(length: languageList.length, vsync: this);
    Provider.of<AddWholesaleProductController>(context, listen: false).initFaqControllers(languageList);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final WholesaleAiController aiController = Provider.of<WholesaleAiController>(context, listen: false);
      if (!aiController.consumeImageStep(WholesaleAiImageStep.faq)) {
        return;
      }
      if (aiController.imageLanguageIndex < _languageTabController.length) {
        _languageTabController.index = aiController.imageLanguageIndex;
      }
      _generateFaq(Provider.of<AddWholesaleProductController>(context, listen: false), languageList);
    });
  }

  @override
  void dispose() {
    _languageTabController.dispose();
    super.dispose();
  }

  String _languageName(Language language) {
    final String name = language.name ?? '';
    return name.isEmpty ? name : '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
  }

  List<Widget> _languageTabs(List<Language> languageList) {
    return List.generate(languageList.length, (index) {
      final String name = _languageName(languageList[index]);
      final String code = languageList[index].code ?? '';
      final bool showCode = code.isNotEmpty && code.toLowerCase() != name.toLowerCase();
      return Text(showCode ? '$name(${code.toUpperCase()})' : name, style: robotoBold.copyWith());
    });
  }

  List<Widget> _languageTabPages(AddWholesaleProductController controller, List<Language> languageList) {
    return List.generate(languageList.length, (index) => AddWholesaleProductFaqQuestionAnswerWidget(
      controller: controller,
      index: index,
      languageName: _languageName(languageList[index]),
    ));
  }

  void _handleSave(AddWholesaleProductController controller, List<Language> languageList) {
    final bool wasEditing = controller.editingFaqIndex != null;
    final bool isFirstLanguageMissing = controller.faqQuestionControllerList.isEmpty
        || controller.faqQuestionControllerList[0].text.trim().isEmpty
        || controller.faqAnswerControllerList[0].text.trim().isEmpty;
    if (isFirstLanguageMissing) {
      _languageTabController.animateTo(0);
    }

    if (controller.saveFaq(context, firstLanguageName: languageList.isNotEmpty ? _languageName(languageList.first) : null)) {
      showCustomSnackBarWidget(
        getTranslated(wasEditing ? 'faq_updated_successfully' : 'faq_added_successfully', context),
        context,
        sanckBarType: SnackBarType.success,
      );
    }
  }

  Future<void> _generateFaq(AddWholesaleProductController controller, List<Language> languageList) async {
    final int index = _languageTabController.index;
    final String name = controller.titleControllerList.isNotEmpty ? controller.titleControllerList.first.text.trim() : '';
    final String description = controller.descriptionControllerList.isNotEmpty ? controller.descriptionControllerList.first.text.trim() : '';

    if (name.isEmpty) {
      showCustomSnackBarWidget(getTranslated('product_name_required', context), context, sanckBarType: SnackBarType.warning);
      return;
    }
    if (description.isEmpty) {
      showCustomSnackBarWidget(getTranslated('product_description_required', context), context, sanckBarType: SnackBarType.warning);
      return;
    }

    await Provider.of<WholesaleAiController>(context, listen: false).generateFaq(
      name: name,
      description: description,
      langCode: languageList[index].code ?? 'en',
      apply: (WholesaleAiFaqModel faq) async {
        final bool isFilled = controller.fillFaqFormFromAi(index, faq);
        if (!mounted || isFilled) {
          return;
        }
        showCustomSnackBarWidget(getTranslated('ai_generated_no_faq', context), context, sanckBarType: SnackBarType.warning);
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
          title: getTranslated('add_faq', context)!,
          subTitle: getTranslated('add_faq_description', context)!,
          isAiGenerating: aiController.faqLoading,
          aiWidget: WholesaleAiSparkleWidget(
            isLoading: aiController.faqLoading,
            onTap: () => _generateFaq(controller, languageList),
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
                        dividerColor: Theme.of(context).hintColor.withValues(alpha: 0.2),
                        controller: _languageTabController,
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorWeight: 12,
                        labelColor: Theme.of(context).primaryColor,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 2.0, color: Theme.of(context).primaryColor),
                          insets: EdgeInsets.zero,
                        ),
                        indicatorPadding: const EdgeInsets.symmetric(horizontal: 0),
                        unselectedLabelStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                        labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                        tabs: _languageTabs(languageList),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child: AnimatedBuilder(
                      animation: _languageTabController,
                      builder: (context, child) {
                        return TabBarView(controller: _languageTabController, children: _languageTabPages(controller, languageList));
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(Dimensions.iconSizeSmall, 0, Dimensions.iconSizeSmall, Dimensions.paddingSizeSmall),
                    child: DropdownDecoratorWidget(
                      child: LayoutBuilder(
                        builder: (context, constraints) => PopupMenuButton<int>(
                          position: PopupMenuPosition.under,
                          constraints: BoxConstraints.tightFor(width: constraints.maxWidth),
                          color: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                          onSelected: controller.setFaqPriority,
                          itemBuilder: (context) => controller.faqPriorityList.map((priority) {
                            return PopupMenuItem<int>(
                              value: priority,
                              child: Text(priority.toString(), style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                            );
                          }).toList(),
                          child: SizedBox(
                            height: kMinInteractiveDimension,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    controller.faqPriority?.toString() ?? getTranslated('priority', context) ?? '',
                                    style: robotoMedium.copyWith(
                                      color: controller.faqPriority == null ? Theme.of(context).hintColor : Theme.of(context).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_outlined),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(
              children: [
                Expanded(
                  child: CustomButtonWidget(
                    btnTxt: getTranslated('reset', context),
                    isColor: true,
                    backgroundColor: Theme.of(context).hintColor.withValues(alpha: .1),
                    fontColor: Theme.of(context).textTheme.bodyLarge?.color,
                    onTap: controller.resetFaqForm,),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  child: CustomButtonWidget(
                    btnTxt: getTranslated('save', context),
                    onTap: () => _handleSave(controller, languageList),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],
        );
      },
    );
  }
}
