import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/wholesale/shipping/screens/wholesale_category_wise_shipping_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/shipping/screens/wholesale_order_wise_shipping_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/shipping/screens/wholesale_product_wise_shipping_screen.dart';
import 'package:sixvalley_vendor_app/features/shipping/widgets/product_wise_shipping_widget.dart';
import 'package:sixvalley_vendor_app/features/shipping/widgets/shipping_type_dropdown_view_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/features/settings/screens/order_wise_shipping_list_screen.dart';
import 'package:sixvalley_vendor_app/features/shipping/screens/category_wise_shipping_screen.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class ShippingMainScreen extends StatefulWidget {
  final int initialModeIndex;
  const ShippingMainScreen({super.key, this.initialModeIndex = 0});

  @override
  State<ShippingMainScreen> createState() => _ShippingMainScreenState();
}

class _ShippingMainScreenState extends State<ShippingMainScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialModeIndex);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('shipping_method', context)),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            dividerColor: Colors.transparent,
            labelStyle: titilliumRegular.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: Dimensions.fontSizeDefault,
            ),
            tabs: [
              Tab(text: getTranslated('retail', context) ?? 'Retail'),
              Tab(text: getTranslated('wholesale', context) ?? 'Wholesale'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ShippingTypeDropdownViewWidget(
                  categoryWise: CategoryWiseShippingScreen(),
                  orderWise: OrderWiseShippingScreen(),
                  productWise: ProductWiseShippingWidget(),
                ),
                ShippingTypeDropdownViewWidget(
                  categoryWise: WholesaleCategoryWiseShippingScreen(),
                  orderWise: WholesaleOrderWiseShippingScreen(),
                  productWise: WholesaleProductWiseShippingScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
