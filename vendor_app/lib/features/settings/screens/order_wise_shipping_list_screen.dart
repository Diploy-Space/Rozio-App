import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/settings/controllers/business_controller.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/features/shipping/controllers/shipping_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/settings/screens/order_wise_shipping_add_screen.dart';
import 'package:sixvalley_vendor_app/features/settings/widgets/order_wise_shipping_card_widget.dart';
import 'package:sixvalley_vendor_app/features/shop/widgets/animated_floating_button_widget.dart';

class OrderWiseShippingScreen extends StatefulWidget {
  const OrderWiseShippingScreen({super.key});

  @override
  State<OrderWiseShippingScreen> createState() => OrderWiseShippingScreenState();
}

class OrderWiseShippingScreenState extends State<OrderWiseShippingScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<BusinessController>(context, listen: false).getBusinessList(context);
    Provider.of<ShippingController>(context, listen: false).getShippingList(Provider.of<AuthController>(context,listen: false).getUserToken());

    return Stack(children: [ Column( children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault,Dimensions.paddingSizeExtraSmall),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
                  decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withValues(alpha:.125),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('${getTranslated('sl', context)}    ${getTranslated('details', context)}', style: robotoMedium,),
                    Text(getTranslated('action', context)!, style: robotoMedium,)
                  ],),
                ),
              ),

              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    Consumer<ShippingController>(
                        builder: (context, shipProv, child) {
                          return  shipProv.shippingList !=null ? shipProv.shippingList!.isNotEmpty ?
                          SliverPadding(
                            padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: 70),
                            sliver: SliverList.builder(
                                itemCount: shipProv.shippingList!.length,
                                itemBuilder: (context, index){
                                  return OrderWiseShippingCardWidget(shipProv: shipProv,shippingModel: shipProv.shippingList![index], index: index,);
                                }
                            ),
                          ) : const SliverToBoxAdapter(child: NoDataScreen())
                              : SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)));
                        }
                    ),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            child: Align(
              alignment: Provider.of<LocalizationController>(context, listen: false).isLtr? Alignment.bottomRight: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
                child: ScrollingFabAnimated(
                  width: 150,
                  color: Theme.of(context).cardColor,
                  icon: SizedBox(width: Dimensions.iconSizeExtraLarge,child: Image.asset(Images.addIcon)),
                  text: Text(getTranslated('add_new', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),),
                  onPress: () => showAnimatedDialogWidget(context, const OrderWiseShippingAddScreen()),
                  animateIcon: true,
                  inverted: false,
                  scrollController: _scrollController,
                  radius: 100.0,
                ),
              ),
            ),
          )
        ],
      );
  }
}
