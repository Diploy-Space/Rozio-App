import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/tab_bar_widget.dart';
import 'package:sixvalley_vendor_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_product_detail_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/screens/add_wholesale_product_tab_view_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/controllers/wholesale_product_details_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/enums/wholesale_product_details_tab.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_attribute_images_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_description_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_details_header_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_details_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_faq_tab_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_info_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_review_tab_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_seo_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_tier_price_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_variation_table_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_video_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/controllers/wholesale_product_review_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/domain/models/wholesale_product_review_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/widgets/wholesale_product_review_card_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatTax/controllers/wholesale_vat_tax_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';

class WholesaleProductDetailsScreen extends StatefulWidget {
  final int productId;
  final bool fromNotification;
  const WholesaleProductDetailsScreen({super.key, required this.productId, this.fromNotification = false});

  @override
  State<WholesaleProductDetailsScreen> createState() => _WholesaleProductDetailsScreenState();
}

class _WholesaleProductDetailsScreenState extends State<WholesaleProductDetailsScreen> {

  int get _productId => widget.productId;

  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleProductDetailsController>(context, listen: false).getProductDetails(_productId, isUpdate: false);
    Provider.of<WholesaleProductReviewController>(context, listen: false).getProductReviews(_productId);
    Provider.of<WholesaleVatTaxController>(context, listen: false).getVatTaxSetup(reload: true, isUpdate: false);
  }

  void _confirmStatusToggle(WholesaleProductDetailsController controller) {
    if (controller.isStatusUpdating) return;
    final bool isTurningOff = controller.isActive;

    showAnimatedDialogWidget(
      context,
      CustomConfirmationDialogWidget(
        icon: Images.powerIcons,
        title: isTurningOff
            ? (getTranslated('turn_off_this_product', context) ?? 'Turn off this product?')
            : (getTranslated('turn_on_this_product', context) ?? 'Turn on this product?'),
        description: isTurningOff
            ? (getTranslated('product_turn_off_description', context) ?? '')
            : (getTranslated('product_turn_on_description', context) ?? ''),
        yesButtonText: isTurningOff ? (getTranslated('turn_off', context) ?? 'Turn Off') : (getTranslated('turn_on', context) ?? 'Turn On'),
        noButtonText: getTranslated('cancel', context) ?? 'Cancel',
        onYesPressed: () async {
          Navigator.of(context).pop();
          final bool isSuccess = await controller.toggleStatus(_productId);
          if (isSuccess && mounted) {
            showCustomSnackBarWidget(getTranslated('status_updated_successfully', context), context, isError: false);
          }
        },
      ),
    );
  }

  void _goToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashboardScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.fromNotification,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goToDashboard();
      },
      child: Consumer<WholesaleProductDetailsController>(
      builder: (context, controller, _) {
        final WholesaleProductDetailModel? product = controller.product;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBarWidget(
            title: getTranslated('product_details', context) ?? 'Product Details',
            centerTitle: true,
            isBackButtonExist: true,
            onBackPressed: widget.fromNotification ? _goToDashboard : null,
            isAction: product?.requestStatus == 1,
            isSwitch: true,
            switchValue: controller.isActive,
            switchAction: (bool _) => _confirmStatusToggle(controller),
          ),
          body: controller.isLoading
              ? const WholesaleProductDetailsShimmerWidget()
              : product == null
                  ? Center(child: Text(getTranslated('no_data_found', context) ?? 'No data found'))
                  : Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: TabBarWidget(
                              selectedIndex: controller.selectedTabIndex,
                              tabs: WholesaleProductDetailsTab.values.map((tab) => getTranslated(tab.translationKey, context) ?? tab.fallbackLabel).toList(),
                              onTabChanged: controller.onChangeTab,
                            ),
                          ),
                        ),

                        Expanded(child: SingleChildScrollView(child: _buildTab(context, controller, product))),
                      ],
                    ),
          bottomNavigationBar: product == null || controller.selectedTab != WholesaleProductDetailsTab.overview
              ? null
              : SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
                    color: Theme.of(context).cardColor,
                    child: CustomButtonWidget(
                      borderRadius: Dimensions.radiusDefault,
                      btnTxt: getTranslated('edit', context) ?? 'Edit',
                      buttonHeight: 45,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddWholesaleProductTabView(productId: _productId))),
                    ),
                  ),
                ),
        );
      },
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    WholesaleProductDetailsController controller,
    WholesaleProductDetailModel product,
  ) {
    switch (controller.selectedTab) {
      case WholesaleProductDetailsTab.overview:
        return Column(
          children: [
            WholesaleProductDetailsHeaderWidget(product: product),
            WholesaleProductDescriptionWidget(details: product.details),
            WholesaleProductInfoWidget(product: product),
            WholesaleProductPriceInfoWidget(product: product),
            WholesaleProductTierPriceWidget(tiers: product.wholesaleDetail?.tierLadder ?? const []),
            WholesaleProductVariationTableWidget(stocks: product.stocks),
            const WholesaleProductAttributeImagesWidget(),
            WholesaleProductSeoWidget(seo: product.seo),
            WholesaleProductVideoWidget(videoUrl: product.videoUrl, videoFileUrl: product.hasVideoFile ? product.videoFileFullUrl : null),
          ],
        );

      case WholesaleProductDetailsTab.reviews:
        final WholesaleProductReviewController reviewController = Provider.of<WholesaleProductReviewController>(context);
        final List<WholesaleProductReviewModel>? reviews = reviewController.productReviews;
        if (reviews == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: Column(
              children: List.generate(4, (index) => const WholesaleProductReviewCardShimmerWidget()),
            ),
          );
        }
        return WholesaleProductReviewTabWidget(summary: reviewController.productRatingSummary, reviews: reviews);

      case WholesaleProductDetailsTab.faq:
        return WholesaleProductFaqTabWidget(faqs: controller.faqs);
    }
  }
}
