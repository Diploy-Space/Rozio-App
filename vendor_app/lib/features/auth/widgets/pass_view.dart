import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';


class PassView extends StatelessWidget {
  const PassView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Consumer<AuthController>(
    builder: (authContext, authProvider, _)  {
        return Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          child: Wrap(children: [

            _PasswordCheckItem(title: getTranslated('8_or_more_character', context)!, done: authProvider.lengthCheck),

            _PasswordCheckItem(title: getTranslated('1_number', context)!, done: authProvider.numberCheck),

            _PasswordCheckItem(title: getTranslated('1_upper_case', context)!, done: authProvider.uppercaseCheck),

            _PasswordCheckItem(title: getTranslated('1_lower_case', context)!, done: authProvider.lowercaseCheck),

            _PasswordCheckItem(title: getTranslated('1_special_character', context)!, done: authProvider.spatialCheck),

          ]),
        );
      }
    );
  }
}

class _PasswordCheckItem extends StatelessWidget {
  final String title;
  final bool done;

  const _PasswordCheckItem({required this.title, required this.done});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(done ? Icons.check : Icons.clear, color: done ? Colors.green : Colors.red, size: 12),
        Text(title, style: titilliumRegular.copyWith(color: done ? Colors.green : Colors.red, fontSize: 12))
      ]),
    );
  }
}
