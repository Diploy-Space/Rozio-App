import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductTagWidget extends StatelessWidget {
  final AddWholesaleProductController controller;
  final TextfieldTagsController textfieldTagsController;
  const AddWholesaleProductTagWidget({super.key, required this.controller, required this.textfieldTagsController});

  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      key: ValueKey(controller.tagListVersion),
      textfieldTagsController: textfieldTagsController,
      initialTags: controller.tagList.isNotEmpty ? controller.tagList : const [],
      textSeparators: const [' ', ','],
      letterCase: LetterCase.normal,
      validator: (String? tag) {
        if (textfieldTagsController.getTags!.contains(tag)) {
          return 'you already entered that';
        }
        return null;
      },
      inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
        return (context, sc, tags, onTagDelete) {
          if (!_sameTags(controller.tagList, tags)) {
            WidgetsBinding.instance.addPostFrameCallback((_) => controller.setTagList(tags.whereType<String>().toList()));
          }

          final Color fadedBorder = Theme.of(context).primaryColor.withValues(alpha: .25);
          final Color solidBorder = Theme.of(context).primaryColor;

          final OutlineInputBorder outline = OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            borderSide: BorderSide(color: fadedBorder, width: .75),
          );

          return AnimatedBuilder(
            animation: Listenable.merge([fn, tec]),
            builder: (context, child) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusScope.of(context).requestFocus(fn);
                  tec.selection = TextSelection.collapsed(offset: tec.text.length);
                },
                child: InputDecorator(
                  isFocused: fn.hasFocus,
                  isEmpty: tags.isEmpty && tec.text.isEmpty,
                  decoration: InputDecoration(
                    labelText: getTranslated('enter_tag', context),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelStyle: titilliumRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                    floatingLabelStyle: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                    contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                    border: outline,
                    enabledBorder: outline,
                    focusedBorder: outline.copyWith(borderSide: BorderSide(color: solidBorder, width: .75)),
                    errorText: error,
                    errorStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error),
                  ),
                  child: child,
                ),
              );
            },
            child: Wrap(
              spacing: Dimensions.paddingSizeExtraSmall,
              runSpacing: Dimensions.paddingSizeExtraSmall,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...tags.map((String? tag) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                      color: Theme.of(context).primaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text('$tag', style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 4.0),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () => onTagDelete(tag!),
                        child: const Icon(Icons.cancel, size: 14.0, color: Color.fromARGB(255, 233, 233, 233)),
                      ),
                    ]),
                  );
                }),
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: tec,
                    focusNode: fn,
                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                    decoration: const InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      border: InputBorder.none,
                    ),
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                  ),
                ),
              ],
            ),
          );
        };
      },
    );
  }

  bool _sameTags(List<String> a, List<String?> b) {
    if (a.length != b.length) {
      return false;
    }
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }
}
