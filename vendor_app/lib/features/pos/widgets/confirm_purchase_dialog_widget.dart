import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/helper/debounce_helper.dart';


class ConfirmPurchaseDialogWidget extends StatefulWidget {
  final Function? onYesPressed;
  const ConfirmPurchaseDialogWidget({super.key, required this.onYesPressed});

  @override
  State<ConfirmPurchaseDialogWidget> createState() => _ConfirmPurchaseDialogWidgetState();
}

class _ConfirmPurchaseDialogWidgetState extends State<ConfirmPurchaseDialogWidget> {
  final DebounceHelper _confirmDebounce = DebounceHelper(milliseconds: 500);
  bool _isPlacing = false;

  @override
  void dispose() {
    _confirmDebounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog( surfaceTintColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
        child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
        height: 240,
          child: Column(children: [
            SizedBox(width: 70,height: 70,
            child: Image.asset(Images.confirmPurchase),),
            Text(getTranslated('confirm_purchase', context)!),
            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: SizedBox(height: 40,
                child: Row(children: [
                  Expanded(child: CustomButtonWidget(btnTxt: getTranslated('cancel', context),
                      backgroundColor: Theme.of(context).hintColor,
                      onTap: ()=>Navigator.pop(context))), const SizedBox(width: Dimensions.paddingSizeDefault),
                  Expanded(child: CustomButtonWidget(btnTxt: getTranslated('yes', context),
                    isLoading: _isPlacing,
                    onTap: () => _confirmDebounce.run(() async {
                      if(_isPlacing || widget.onYesPressed == null) return;
                      setState(() => _isPlacing = true);
                      try {
                        await widget.onYesPressed!();
                      } finally {
                        if(context.mounted) {
                          final ModalRoute? dialogRoute = ModalRoute.of(context);
                          if(dialogRoute != null && dialogRoute.isActive) {
                            Navigator.of(context).removeRoute(dialogRoute);
                          }
                        }
                      }
                    }),)),
                ],),
              ),
            )
          ],),
        ));
  }
}
