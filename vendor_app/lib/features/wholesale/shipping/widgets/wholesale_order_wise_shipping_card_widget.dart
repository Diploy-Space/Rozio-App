import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/wholesale/shipping/controllers/wholesale_shipping_controller.dart';
import 'package:sixvalley_vendor_app/features/shipping/domain/models/shipping_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/shipping/screens/wholesale_order_wise_shipping_add_screen.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';

class WholesaleOrderWiseShippingCardWidget extends StatelessWidget {
  final WholesaleShippingController? shipProv;
  final ShippingModel? shippingModel;
  final int? index;
  const WholesaleOrderWiseShippingCardWidget({super.key, this.shipProv, this.shippingModel, this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeMedium,0,Dimensions.paddingSizeMedium,Dimensions.paddingSizeSmall,),
      child: Container(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,Dimensions.paddingSizeSmall,),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          boxShadow: ThemeShadow.getShadow(context),),
        child: Stack(
          children: [
            Column(children: [
              Row(children: [Expanded(child: Text('${index!+1}.  ${shippingModel!.title}',
                  maxLines: 1,overflow: TextOverflow.ellipsis,
                  style: robotoMedium.copyWith())),

                FlutterSwitch(value: shippingModel!.status == 1?true:false,
                  activeColor: Theme.of(context).primaryColor,
                  width: 48,height: 25,toggleSize: 20,padding: 2,
                  onToggle: (value){
                    shipProv!.shippingOnOff(shippingModel!, value?1:0);
                  },
                ),
                ],),



             Container(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
               child: Column(children: [
                 Row(
                 children: [
                   Text('${getTranslated('duration', context)}  :   ', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                   Text('${shippingModel!.duration}', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),

                 ],
               ),
                 const SizedBox(height: Dimensions.paddingSizeSmall),
                 Row(
                 children: [
                   Text('${getTranslated('cost', context)}           :   ', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),),
                   Text(PriceConverter.convertPrice(context, shippingModel!.cost),
                       style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                 ],
               ),
             ],),),

            ],
      ),
            Positioned(bottom: 10,right: 5,
              child: Row(children: [

                InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (BuildContext context){
                        return Consumer<WholesaleShippingController>(
                          builder: (context, shippingController, _) => ConfirmationDialogWidget(icon: Images.delete,
                              description: getTranslated('are_you_sure_want_to_delete_this_shipping_method', context),
                              isLoading: shippingController.isLoading,
                              onYesPressed: () => shippingController.deleteShipping(shippingModel!.id),
                          ),
                        );});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        boxShadow: ThemeShadow.getShadow(context),
                        borderRadius: BorderRadius.circular(100)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Image.asset(Images.delete,  width: Dimensions.iconSizeMedium),
                        ))),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                InkWell(
                  onTap: (){
                    showDialog(context: context, builder: (_)=>WholesaleOrderWiseShippingAddScreen(shipping: shippingModel));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: ThemeShadow.getShadow(context),
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Image.asset(Images.editIcon, width: Dimensions.iconSizeMedium, color: Theme.of(context).primaryColor),
                      )),
                ),



              ],),
            )
          ],
        ),
    ),
    );
  }
}
