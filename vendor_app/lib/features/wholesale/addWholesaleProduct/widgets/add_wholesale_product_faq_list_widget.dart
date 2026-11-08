import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_faq_model.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/models/config_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/enums/faq_menu_action.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductFaqListWidget extends StatelessWidget {
  const AddWholesaleProductFaqListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddWholesaleProductController>(
      builder: (context, controller, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranslated('faq_list', context) ?? '',
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              if (controller.faqList.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                  child: Center(
                    child: Text(getTranslated('no_faq_added_yet', context) ?? '', style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                  ),
                )
              else
                ...List.generate(controller.faqList.length, (index) {
                  final WholesaleFaqModel faq = controller.faqList[index];
                  return _FaqListItemWidget(
                    key: ValueKey(faq),
                    faq: faq,
                    onMenuSelected: (action) {
                      if (action == FaqMenuAction.edit) {
                        controller.editFaq(index);
                      } else {
                        controller.removeFaq(index);
                      }
                    },
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class _FaqListItemWidget extends StatefulWidget {
  final WholesaleFaqModel faq;
  final ValueChanged<FaqMenuAction> onMenuSelected;
  const _FaqListItemWidget({super.key, required this.faq, required this.onMenuSelected});

  @override
  State<_FaqListItemWidget> createState() => _FaqListItemWidgetState();
}

class _FaqListItemWidgetState extends State<_FaqListItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String question = widget.faq.questionList.isNotEmpty ? widget.faq.questionList[0] : '';
    final List<Language> languageList = Provider.of<SplashController>(context, listen: false).configModel?.languageList ?? [];
    final List<int> filledIndexes = [
      for (int index = 0; index < widget.faq.questionList.length; index++)
        if (widget.faq.questionList[index].isNotEmpty) index,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: ThemeShadow.getShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Row(
            children: [
              _PriorityBadge(priority: widget.faq.priority),
              const Spacer(),
              _FaqMenu(onSelected: widget.onMenuSelected),
            ],
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: filledIndexes.map((index) => _FaqTranslationWidget(
                  languageName: index < languageList.length ? (languageList[index].name ?? '') : '',
                  question: index == 0 ? null : widget.faq.questionList[index],
                  answer: index < widget.faq.answerList.length ? widget.faq.answerList[index] : '',
                  showLanguage: filledIndexes.length > 1,
                )).toList(),
              ),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}

class _FaqTranslationWidget extends StatelessWidget {
  final String languageName;
  final String? question;
  final String answer;
  final bool showLanguage;
  const _FaqTranslationWidget({required this.languageName, this.question, required this.answer, required this.showLanguage});

  @override
  Widget build(BuildContext context) {
    final String label = languageName.isEmpty ? languageName : '${languageName[0].toUpperCase()}${languageName.substring(1).toLowerCase()}';

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLanguage && label.isNotEmpty)
            Text(label, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
          if (question != null)
            Text(question!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
          if (answer.isNotEmpty)
            Text(answer, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color)),
        ],
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final int priority;
  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeOrder),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
      ),
      child: Text(
        '${getTranslated('priority', context)} $priority',
        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
    );
  }
}

class _FaqMenu extends StatelessWidget {
  final ValueChanged<FaqMenuAction>? onSelected;
  const _FaqMenu({this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FaqMenuAction>(
      padding: EdgeInsets.zero,
      offset: const Offset(0, 30),
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      onSelected: (action) => onSelected?.call(action),
      itemBuilder: (context) => [
        _buildItem(context, value: FaqMenuAction.edit, icon: Icons.edit_outlined, label: getTranslated('edit', context) ?? 'Edit'),
        _buildItem(context, value: FaqMenuAction.delete, icon: Icons.delete_outline, label: getTranslated('delete', context) ?? 'Delete'),
      ],
      // Use `child` (not `icon`) so the tap target is not forced to the
      // 48x48 IconButton minimum and stays tight to the icon.
      child: Icon(Icons.more_vert, size: Dimensions.iconSizeMedium, color: Theme.of(context).hintColor),
    );
  }

  PopupMenuItem<FaqMenuAction> _buildItem(
    BuildContext context, {
    required FaqMenuAction value,
    required IconData icon,
    required String label,
  }) {
    return PopupMenuItem<FaqMenuAction>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: Dimensions.iconSizeDefault, color: Theme.of(context).primaryColor),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Text(label, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
        ],
      ),
    );
  }
}
