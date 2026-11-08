import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/clearance_sale/controllers/clearance_sale_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/helper/debounce_helper.dart';

class ShowConfirmationBottomSheetWidget extends StatefulWidget {
  final bool isActive;
  const ShowConfirmationBottomSheetWidget ({super.key, required this.isActive});

  @override
  State<ShowConfirmationBottomSheetWidget> createState() => ShowConfirmationBottomSheetWidgetState();
}

class ShowConfirmationBottomSheetWidgetState extends State<ShowConfirmationBottomSheetWidget> {
  final DebounceHelper _debounce = DebounceHelper(milliseconds: 500);
  bool _isConfirming = false;

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Provider.of<ThemeController>(context).darkTheme ? Theme.of(context).cardColor : Theme.of(context).highlightColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: [

                const SizedBox(height: 30),
                Container(width: 52, height: 52, padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                  ),
                  child: Image.asset(
                    Images.clearanceSaleImage,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(
                      Dimensions.paddingSizeDefault, 13,
                      Dimensions.paddingSizeDefault, 0
                  ),
                  child: Text(getTranslated('clearance_sale_confirmation', context)!,
                      style: titilliumSemiBold.copyWith(fontSize:Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                      textAlign: TextAlign.center),
                ),


                Padding(
                  padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeLarge, 13, Dimensions.paddingSizeLarge,0),
                  child: Text(getTranslated('clearance_sale_customer_message', context)!,
                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
                      textAlign: TextAlign.center
                  ),
                ),

                SizedBox(height: 80,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,24,Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [

                        Expanded(
                          child: CustomButtonWidget(borderRadius: 15,
                            btnTxt: getTranslated('cancel', context),
                            isColor: true,
                            fontColor: Theme.of(context).textTheme.bodyLarge?.color,
                            backgroundColor: Theme.of(context).hintColor.withValues(alpha:.25),
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(
                          child: CustomButtonWidget(borderRadius: 15,
                            btnTxt: getTranslated('ok', context),
                            backgroundColor: Theme.of(context).primaryColor,
                            fontColor: Colors.white,
                            isColor: true,
                            isLoading: _isConfirming,
                            onTap: () => _debounce.run(() async {
                              if (_isConfirming) return;
                              setState(() => _isConfirming = true);
                              final clearanceController = Provider.of<ClearanceSaleController>(context, listen: false);
                              await clearanceController.updateConfigStatus(widget.isActive ? 1 : 0);

                              if (context.mounted) {
                                Navigator.pop(context);
                              } else if (mounted) {
                                setState(() => _isConfirming = false);
                              }
                            }),
                          ),
                        ),

                      ]),
                    ),
                  ),
                ),
              ]),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(margin: const EdgeInsets.all(Dimensions.paddingSeven),
                    decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha: 0.30), shape: BoxShape.circle),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: SizedBox(width: Dimensions.iconSizeExtraSmall,
                      child: Image.asset(Images.cross, color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
