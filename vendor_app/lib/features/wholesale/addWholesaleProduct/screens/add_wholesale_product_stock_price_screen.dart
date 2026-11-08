import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatTax/controllers/wholesale_vat_tax_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_bottom_nav_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_pricing_setup_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_stock_setup_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class AddWholesaleProductStockPriceScreen extends StatefulWidget {
  final Function(int) onTabChanged;
  const AddWholesaleProductStockPriceScreen({super.key, required this.onTabChanged});

  @override
  State<AddWholesaleProductStockPriceScreen> createState() => AddWholesaleProductStockPriceScreenState();
}

class AddWholesaleProductStockPriceScreenState extends State<AddWholesaleProductStockPriceScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleVatTaxController>(context, listen: false).getVatTaxSetup(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMedium),
            child: Column(
              children: [
                const AddWholesaleProductStockSetupWidget(),
                SizedBox(height: Dimensions.paddingSizeLarge),
                const AddWholesaleProductPricingSetupWidget(),
              ],
            ),
          ),
        ),
        AddWholesaleProductBottomNavWidget(
          onGoBack: () => widget.onTabChanged(0),
          actionLabel: getTranslated('next', context) ?? 'Next',
          onAction: () => widget.onTabChanged(2),
        ),
      ],
    );
  }
}
