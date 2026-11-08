import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/dropdown_decorator_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_product_detail_model.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/models/config_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/controllers/wholesale_product_details_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductFaqEditBottomSheetWidget extends StatefulWidget {
  final WholesaleFaq faq;
  const WholesaleProductFaqEditBottomSheetWidget({super.key, required this.faq});

  @override
  State<WholesaleProductFaqEditBottomSheetWidget> createState() => _WholesaleProductFaqEditBottomSheetWidgetState();
}

class _WholesaleProductFaqEditBottomSheetWidgetState extends State<WholesaleProductFaqEditBottomSheetWidget> with SingleTickerProviderStateMixin {
  static final List<int> _priorityList = List.generate(10, (index) => index + 1);

  late final List<Language> _languageList;
  late final TabController _languageTabController;
  late final List<TextEditingController> _questionControllers;
  late final List<TextEditingController> _answerControllers;
  late int _priority;

  @override
  void initState() {
    super.initState();
    _languageList = Provider.of<SplashController>(context, listen: false).configModel?.languageList ?? [];
    _languageTabController = TabController(length: _languageList.isEmpty ? 1 : _languageList.length, vsync: this);
    _questionControllers = List.generate(_languageTabController.length, (index) => TextEditingController(text: _initialText(index, isQuestion: true)));
    _answerControllers = List.generate(_languageTabController.length, (index) => TextEditingController(text: _initialText(index, isQuestion: false)));
    _priority = (widget.faq.priority ?? 1).clamp(_priorityList.first, _priorityList.last);
  }

  String _initialText(int index, {required bool isQuestion}) {
    final String? locale = index < _languageList.length ? _languageList[index].code : null;
    final WholesaleFaqTranslation? translation = widget.faq.translationFor(locale);
    final String? translated = isQuestion ? translation?.question : translation?.answer;
    if (translated != null && translated.isNotEmpty) return translated;
    if (index == 0) return (isQuestion ? widget.faq.question : widget.faq.answer) ?? '';
    return '';
  }

  @override
  void dispose() {
    _languageTabController.dispose();
    for (final TextEditingController controller in [..._questionControllers, ..._answerControllers]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _onUpdate(WholesaleProductDetailsController controller) async {
    if (_questionControllers.first.text.trim().isEmpty) {
      _languageTabController.animateTo(0);
      showCustomSnackBarWidget(getTranslated('please_write_the_question', context), context, sanckBarType: SnackBarType.warning);
      return;
    }
    if (_answerControllers.first.text.trim().isEmpty) {
      _languageTabController.animateTo(0);
      showCustomSnackBarWidget(getTranslated('please_write_the_answer', context), context, sanckBarType: SnackBarType.warning);
      return;
    }

    final List<String> languages = [];
    final List<String> questions = [];
    final List<String> answers = [];
    for (int index = 0; index < _languageList.length; index++) {
      languages.add(_languageList[index].code ?? '');
      questions.add(_questionControllers[index].text.trim());
      answers.add(_answerControllers[index].text.trim());
    }

    final bool isSuccess = await controller.updateFaq(widget.faq, languages: languages, questions: questions, answers: answers, priority: _priority);
    if (isSuccess && mounted) Navigator.of(context).pop();
  }

  String _languageName(Language language) {
    final String name = language.name ?? '';
    return name.isEmpty ? name : '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getTranslated('edit_faq', context) ?? 'Edit FAQ',
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor.withValues(alpha: .1)),
                    child: const Icon(Icons.close, size: 18),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_languageList.length > 1) ...[
                    TabBar(
                      controller: _languageTabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Theme.of(context).hintColor.withValues(alpha: 0.2),
                      indicatorColor: Theme.of(context).primaryColor,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Theme.of(context).hintColor,
                      labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                      unselectedLabelStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                      tabs: _languageList.map((language) => Tab(text: _languageName(language))).toList(),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeMedium),
                  ],

                  AnimatedBuilder(
                    animation: _languageTabController,
                    builder: (context, _) => Column(
                      children: [
                        CustomTextFieldWidget(
                          key: ValueKey('question_${_languageTabController.index}'),
                          required: _languageTabController.index == 0,
                          border: true,
                          borderColor: Theme.of(context).primaryColor.withValues(alpha: .25),
                          controller: _questionControllers[_languageTabController.index],
                          textInputAction: TextInputAction.next,
                          labelText: getTranslated('question', context),
                          hintText: getTranslated('type_question', context),
                          maxSize: 50,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeMedium),

                        CustomTextFieldWidget(
                          key: ValueKey('answer_${_languageTabController.index}'),
                          border: true,
                          required: _languageTabController.index == 0,
                          borderColor: Theme.of(context).primaryColor.withValues(alpha: .25),
                          controller: _answerControllers[_languageTabController.index],
                          textInputType: TextInputType.multiline,
                          maxLine: 5,
                          labelText: getTranslated('answer', context),
                          hintText: getTranslated('type_answer', context),
                          maxSize: 150,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeMedium),

                  DropdownDecoratorWidget(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _priority,
                        isExpanded: true,
                        dropdownColor: Theme.of(context).cardColor,
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        items: _priorityList.map((priority) => DropdownMenuItem<int>(
                          value: priority,
                          child: Text(
                            '${getTranslated('priority', context) ?? 'Priority'} $priority',
                            style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                          ),
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _priority = value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Consumer<WholesaleProductDetailsController>(
              builder: (context, controller, _) => controller.isFaqUpdating
                  ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor))
                  : CustomButtonWidget(
                      borderRadius: Dimensions.radiusDefault,
                      btnTxt: getTranslated('update', context),
                      onTap: () => _onUpdate(controller),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
