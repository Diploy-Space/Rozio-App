import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/wholesale/shipping/controllers/wholesale_shipping_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/shipping/widgets/wholesale_category_wise_shipping_card_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/shipping/widgets/wholesale_category_wise_shipping_card_widget.dart';



class WholesaleCategoryWiseShippingScreen extends StatefulWidget {
  const WholesaleCategoryWiseShippingScreen({super.key});

  @override
  State<WholesaleCategoryWiseShippingScreen> createState() => _WholesaleCategoryWiseShippingScreenState();
}

class _WholesaleCategoryWiseShippingScreenState extends State<WholesaleCategoryWiseShippingScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleShippingController>(context, listen: false).getCategoryWiseShippingMethod();
  }

  void _onSave(WholesaleShippingController shipProv) {
    final List<double> costing = [];
    for (final TextEditingController cost in shipProv.shippingCostController) {
      final double? value = double.tryParse(cost.text.trim());
      if (value == null) {
        showCustomSnackBarWidget(getTranslated('enter_cost', context), context, sanckBarType: SnackBarType.warning);
        return;
      }
      costing.add(value);
    }
    shipProv.setCategoryWiseShippingCost(shipProv.ids, costing, shipProv.isMultiplyInt);
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<WholesaleShippingController>(
      builder: (context, shipProv, child) {
        return  Stack(
          children: [
            Column(
              children: [
                shipProv.categoryWiseShipping != null ? shipProv.categoryWiseShipping!.isNotEmpty ?
                Expanded(
                    child: Padding(
                      padding:  const EdgeInsets.only(bottom: 80, top: Dimensions.paddingSizeSmall),
                      child: ListView.builder(
                        itemCount: shipProv.categoryWiseShipping!.length,
                        itemBuilder: (context, index) {
                          return WholesaleCategoryWiseShippingCardWidget(shipProv: shipProv,index: index,categoryName: shipProv.categoryWiseShipping![index].categoryName);
                        }
                      ),
                    ))
                    : const Expanded(child: NoDataScreen())
                    : const Expanded(child: WholesaleCategoryWiseShippingCardShimmerWidget())
              ],
            ),
            if (shipProv.categoryWiseShipping?.isNotEmpty ?? false)
              Positioned(bottom: 10,left: 20,right: 20,
                  child:shipProv.isLoading?
                  SizedBox(width:30, height: 40,child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor))) :
                  CustomButtonWidget(borderRadius: 12,
                    fontColor: Colors.white,
                    btnTxt: getTranslated('save_update', context),
                    onTap: () => _onSave(shipProv),
                  ))
          ],
        );
      }

    );
  }
}
