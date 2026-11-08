import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/addProduct/screens/add_product_tab_view_screen.dart';
import 'package:sixvalley_vendor_app/features/app_mode/controllers/app_mode_controller.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/enums/app_mode.dart';
import 'package:sixvalley_vendor_app/features/auction/screens/auction_request_list_screen.dart';
import 'package:sixvalley_vendor_app/features/auction/screens/auction_sales_report_screen.dart';
import 'package:sixvalley_vendor_app/features/auction/screens/auction_tax_report_screen.dart';
import 'package:sixvalley_vendor_app/features/auction/screens/auction_transaction_list_screen.dart';
import 'package:sixvalley_vendor_app/features/vat_management/screens/vat_report_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/screens/add_wholesale_product_tab_view_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/screens/campaign_list_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/screens/wholesale_coupon_list_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/screens/wholesale_product_list_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/screens/wholesale_product_review_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatReport/screens/wholesale_vat_report_screen.dart';
import 'package:sixvalley_vendor_app/features/clearance_sale/screens/clearance_sale_screen.dart';
import 'package:sixvalley_vendor_app/features/restock/screens/restock_list_screen.dart';
import 'package:sixvalley_vendor_app/features/shipping/screens/shipping_main_screen.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/models/config_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_bottom_sheet_widget.dart';
import 'package:sixvalley_vendor_app/features/coupon/screens/coupon_list_screen.dart';
import 'package:sixvalley_vendor_app/features/dashboard/screens/nav_bar_screen.dart';
import 'package:sixvalley_vendor_app/features/product/screens/product_list_screen.dart';
import 'package:sixvalley_vendor_app/features/review/screens/product_review_screen.dart';

import '../../../main.dart';

class MenuBottomSheetWidget extends StatelessWidget {
  const MenuBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigModel? configModel = Provider.of<SplashController>(context, listen: false).configModel;
    final AppMode appMode = Provider.of<AppModeController>(context, listen: false).appMode;

    final addProductItem = CustomBottomSheetWidget(image: Images.addProduct, title: getTranslated('add_product', context),
      onTap: () => _handleMenuTap(context, const AddProductTabView(fromHome: false)),
    );

    final addWholesaleProductItem = CustomBottomSheetWidget(image: Images.addProduct, title: getTranslated('add_product', context),
      onTap: () => _handleMenuTap(context, const AddWholesaleProductTabView()),
    );

    final productsItem = CustomBottomSheetWidget(image: Images.productIconPp, title: getTranslated('products', context),
      onTap: () => _handleMenuTap(context, const ProductListMenuScreen()),
    );

    final wholesaleProductsItem = CustomBottomSheetWidget(image: Images.productIconPp, title: getTranslated('products', context),
      onTap: () => _handleMenuTap(context, WholesaleProductListScreen()),
    );

    final reviewsItem = CustomBottomSheetWidget(image: Images.reviewIcon, title: getTranslated('reviews', context),
      onTap: () => _handleMenuTap(context, const ProductReviewScreen()),
    );

    final wholesaleReviewsItem = CustomBottomSheetWidget(image: Images.reviewIcon, title: getTranslated('reviews', context),
      onTap: () => _handleMenuTap(context, const WholesaleProductReviewScreen()),
    );

    final couponsItem = CustomBottomSheetWidget(image: Images.couponIcon, title: getTranslated('coupons', context),
      onTap: () => _handleMenuTap(context, const CouponListScreen()),
    );

    final wholesaleCouponsItem = CustomBottomSheetWidget(image: Images.couponIcon, title: getTranslated('coupons', context),
      onTap: () => _handleMenuTap(context, const WholesaleCouponListScreen()),
    );

    final bool posEnabled =configModel?.posActive == 1
        && Provider.of<ProfileController>(context, listen: false).userInfoModel?.posActive == 1;
    final posItem = CustomBottomSheetWidget(image: Images.pos, title: getTranslated('pos', context),
      onTap: () => _handleMenuTap(context, const NavBarScreen()),
    );

    final shippingSetupItem = CustomBottomSheetWidget(image: Images.shippingIcon, title: getTranslated('shipping_method', context),
      onTap: () => _handleMenuTap(context, const ShippingMainScreen()),
    );

    final wholesaleShippingSetupItem = CustomBottomSheetWidget(image: Images.shippingIcon, title: getTranslated('shipping_method', context),
      onTap: () => _handleMenuTap(context, const ShippingMainScreen(initialModeIndex: 1)),
    );

    final restockItem = CustomBottomSheetWidget(image: Images.restockIcon, title: getTranslated('restock', context),
      onTap: () => _handleMenuTap(context, const RestockListScreen()),
    );

    // final wholesaleRestockItem = CustomBottomSheetWidget(image: Images.restockIcon, title: getTranslated('restock', context),
    //   onTap: () => _handleMenuTap(context, const WholesaleRestockRequestListScreen()),
    // );

    final clearanceSaleItem = CustomBottomSheetWidget(image: Images.clearanceSaleImage, title: getTranslated('clearance_sale', context),
      onTap: () => _handleMenuTap(context, const ClearanceSaleScreen()),
    );

    final wholesaleCampaign = CustomBottomSheetWidget(image: Images.campaignIcon, title: getTranslated('campaign', context),
      onTap: () => _handleMenuTap(context, const CampaignList()),
    );

    final taxReportItem = CustomBottomSheetWidget(image: Images.auctionTaxReportIcon, title: getTranslated('tax_report', context),
      onTap: () => _handleMenuTap(context, const VatReportScreen()),
    );

    final wholesaleTaxReportItem = CustomBottomSheetWidget(image: Images.auctionTaxReportIcon, title: getTranslated('tax_report', context),
      onTap: () => _handleMenuTap(context, const WholesaleVatReportScreen()),
    );

    final auctionRequestListItem = CustomBottomSheetWidget(image: Images.auctionRequestListIcon, title: getTranslated('request_list', context),
      onTap: () => _handleMenuTap(context, const AuctionRequestListScreen()),
    );

    final auctionSalesReportItem = CustomBottomSheetWidget(image: Images.auctionSalesReportIcon, title: getTranslated('sales_report', context),
      onTap: () => _handleMenuTap(context, const AuctionSalesReportScreen()),
    );

    final auctionTransactionItem = CustomBottomSheetWidget(image: Images.auctionTransactionWithAdminIcon, title: getTranslated('transaction_with_admin', context),
      onTap: () => _handleMenuTap(context, const AuctionTransactionListScreen()),
    );

    final auctionTaxReportItem = CustomBottomSheetWidget(image: Images.auctionTaxReportIcon, title: getTranslated('tax_report', context),
      onTap: () => _handleMenuTap(context, const AuctionTaxReportScreen()),
    );

    final List<CustomBottomSheetWidget> activateMenu;
    switch (appMode) {
      case AppMode.retail:
        activateMenu = [
          addProductItem,
          productsItem,
          reviewsItem,
          couponsItem,
          if (posEnabled) posItem,
          shippingSetupItem,
          restockItem,
          clearanceSaleItem,
          taxReportItem,
        ];
        break;

      case AppMode.wholesale:
        activateMenu = [
          addWholesaleProductItem,
          wholesaleProductsItem,
          wholesaleReviewsItem,
          wholesaleCouponsItem,
          wholesaleShippingSetupItem,
          // wholesaleRestockItem,
          wholesaleCampaign,
          wholesaleTaxReportItem,
        ];
        break;

      case AppMode.auction:
        activateMenu = [
          auctionRequestListItem,
          auctionSalesReportItem,
          auctionTransactionItem,
          auctionTaxReportItem,
        ];
        break;
    }

    return Container(decoration: BoxDecoration(
        color: Provider.of<ThemeController>(context).darkTheme
            ? Theme.of(context).highlightColor : Theme.of(context).highlightColor,
        borderRadius: const BorderRadius.only(topLeft:  Radius.circular(25), topRight: Radius.circular(25))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
          GestureDetector(onTap: ()=> Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_down_outlined,color: Theme.of(context).hintColor, size: Dimensions.iconSizeLarge,)),

          const SizedBox(height: Dimensions.paddingSizeVeryTiny),
          Consumer<ProfileController>(
            builder: (context, profileProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: activateMenu,
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  void _handleMenuTap(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close bottom sheet
    Future.microtask(() => Navigator.push(
      Get.context!,
      MaterialPageRoute(builder: (_) => screen),
    ));
  }

}
