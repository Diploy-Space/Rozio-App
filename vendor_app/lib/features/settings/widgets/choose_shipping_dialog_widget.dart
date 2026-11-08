import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/interface/shipping_type_host.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/helper/debounce_helper.dart';

class ChooseShippingDialogWidget<T extends ShippingTypeHost> extends StatefulWidget {

  const ChooseShippingDialogWidget({super.key});

  @override
  State<ChooseShippingDialogWidget<T>> createState() => _ChooseShippingDialogWidgetState<T>();
}

class _ChooseShippingDialogWidgetState<T extends ShippingTypeHost> extends State<ChooseShippingDialogWidget<T>> {
  final DebounceHelper _updateDebounce = DebounceHelper(milliseconds: 500);
  bool _isUpdating = false;

  @override
  void dispose() {
    _updateDebounce.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<T>(context,listen: false).getSelectedShippingMethodType(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog( surfaceTintColor: Theme.of(context).cardColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      backgroundColor: Theme.of(context).highlightColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Consumer<T>(
        builder: (cont, shippingProvider, _) {
          return Column(mainAxisSize: MainAxisSize.min, children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraLarge, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
              child: Text(getTranslated('choose_shipping', context)!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
              child: Text(getTranslated('select_shipping_method', context)!,textAlign: TextAlign.center,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
            ),

            Consumer<SplashController>(
              builder: (context, splash, child) {
                List<String?> valueList = [];
                for (var shipping in splash.shippingTypeList) {
                  valueList.add(getTranslated(shipping, context));
                }

                return Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: GridView.builder(
                    itemCount: valueList.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width < 380? 1/.7 : 1/.5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10

                      ),
                      itemBuilder: (context, i){
                    return GestureDetector(
                      onTap: (){
                        shippingProvider.setShippingType(i);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                        color:  shippingProvider.shippingIndex ==i? Theme.of(context).primaryColor: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        boxShadow: [BoxShadow(color: Provider.of<ThemeController>(context, listen: false).darkTheme?Theme.of(context).primaryColor.withValues(alpha:0):
                        Theme.of(context).hintColor.withValues(alpha:.25), blurRadius: 5, spreadRadius: 1, offset: const Offset(1,2))]
                      ),
                        child: Stack(children: [
                          Center(child: Text('${valueList[i]}\n ${getTranslated('shipping', context)}',textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(color: shippingProvider.shippingIndex ==i?
                              Colors.white : Theme.of(context).hintColor))),

                          shippingProvider.shippingIndex ==i?
                          Align(
                            alignment : Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Icon(Icons.check_circle, color: Theme.of(context).cardColor),
                              )):const SizedBox()

                      ],),),
                    );
                  }),
                );
              },
            ),


            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Row(children: [
                Expanded(
                  child: CustomButtonWidget(fontColor: Theme.of(context).textTheme.bodyLarge?.color,
                      btnTxt: getTranslated('cancel', context),
                  backgroundColor: Theme.of(context).hintColor.withValues(alpha:.5),
                  onTap: () => Navigator.pop(context)),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault,),
                Expanded(
                  child: CustomButtonWidget(
                    fontColor: Colors.white,
                      btnTxt: getTranslated('update', context),
                      isLoading: _isUpdating,
                      onTap: () => _updateDebounce.run(() async {
                      if(_isUpdating) return;
                      setState(() => _isUpdating = true);
                      String? type;
                      if(shippingProvider.shippingIndex == 0){
                        type =  'order_wise';
                      }else if(shippingProvider.shippingIndex == 1){
                        type =  'product_wise';
                      }else if(shippingProvider.shippingIndex ==2){
                        type =  'category_wise';
                      }
                      final value = await shippingProvider.setShippingMethodType(context, type);
                      if(value.response?.statusCode == 200){
                        Provider.of<SplashController>(Get.context!, listen: false).initConfig();
                        if(context.mounted) Navigator.pop(context);
                      } else if(mounted) {
                        setState(() => _isUpdating = false);
                      }
                  })),
                ),

              ]),
            ),

          ]);
        }
      ),
    );
  }
}