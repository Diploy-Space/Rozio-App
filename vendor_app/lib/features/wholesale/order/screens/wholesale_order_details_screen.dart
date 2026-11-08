import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/models/order_details_model.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/delivery_man_information_widget.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/order_details_shimmer.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/order_note_widget.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/order_verification_images_widget.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/third_party_delivery_info_widget.dart';
import 'package:sixvalley_vendor_app/features/third_party_deliveryman/controllers/third_party_deliveryman_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/controllers/wholesale_order_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/domain/models/wholesale_order_billing_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/domain/models/wholesale_order_details_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_order_address_card_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_order_billing_summary_card_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_order_buyer_contact_card_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_order_info_card_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_order_payment_details_card_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_order_product_list_card_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_order_setup_bottom_sheet.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_order_top_section_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/third_party_deliveryman/controllers/wholesale_third_party_deliveryman_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleOrderDetailsScreen extends StatefulWidget {
  final int orderId;
  final bool fromNotification;
  const WholesaleOrderDetailsScreen({super.key, required this.orderId, this.fromNotification = false});

  @override
  State<WholesaleOrderDetailsScreen> createState() => _WholesaleOrderDetailsScreenState();
}

class _WholesaleOrderDetailsScreenState extends State<WholesaleOrderDetailsScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleOrderController>(context, listen: false).getOrderDetails(widget.orderId);
  }

  void _openOrderSetup(Order order, bool onlyDigital, CourierShipmentModel? courierShipment) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).cardColor,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      context: context,
      builder: (_) => WholesaleOrderSetupBottomSheet(order: order, onlyDigital: onlyDigital, courierShipment: courierShipment),
    );
  }

  void _goToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashboardScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.fromNotification,
      onPopInvokedWithResult: (didPop, result) {
        Provider.of<WholesaleOrderController>(context, listen: false).emptyOrderDetails();
        if (!didPop) _goToDashboard();
      },
      child: Consumer<WholesaleOrderController>(
        builder: (context, wholesaleOrderController, _) {
          final List<WholesaleOrderDetailsModel>? lines = wholesaleOrderController.orderDetails;
          final Order? order = wholesaleOrderController.order;
          final WholesaleOrderBillingModel? billing = (lines != null && lines.isNotEmpty) ? WholesaleOrderBillingModel.fromLines(lines) : null;

          return Scaffold(
            appBar: AppBar(
              elevation: 1, backgroundColor: Theme.of(context).cardColor, toolbarHeight: 80,
              leadingWidth: 0, automaticallyImplyLeading: false,
              surfaceTintColor: Theme.of(context).highlightColor,
              title: WholesaleOrderTopSectionWidget(order: order, onBack: () => Navigator.of(context).maybePop()),
            ),

            body: lines == null
              ? const OrderDetailsShimmer()
              : (order == null || billing == null)
                ? const NoDataScreen()
                : RefreshIndicator(
                    onRefresh: () => wholesaleOrderController.getOrderDetails(widget.orderId, reload: false),
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(children: [
                            const SizedBox(height: 10),

                            Container(
                              decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: ThemeShadow.getShadow(context)),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                WholesaleOrderInfoCardWidget(order: order, showVerificationCode: wholesaleOrderController.deliveryVerificationEnabled),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                if (order.orderType != 'POS') ...[
                                  WholesaleOrderAddressCardWidget(order: order, onlyDigital: billing.onlyDigital),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                ],

                                WholesaleOrderProductListCardWidget(products: lines),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                WholesaleOrderBuyerContactCardWidget(order: order),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                if (order.deliveryMan != null || (order.shippingResponsibility == 'sellerwise_shipping' && !billing.onlyDigital
                                    && order.orderType != 'POS' && order.deliveryType != 'third_party_delivery')) ...[
                                  DeliveryManContactInformationWidget(orderModel: order, orderType: order.orderType, onlyDigital: billing.onlyDigital),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                ],

                                WholesaleOrderPaymentDetailsCardWidget(order: order),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                WholesaleOrderBillingSummaryCardWidget(
                                  subTotal: billing.itemsPrice,
                                  tax: billing.tax,
                                  discount: billing.discount,
                                  shippingFee: billing.shipping,
                                  total: billing.total,
                                  couponDiscount: billing.coupon,
                                  referralDiscount: billing.referralDiscount,
                                  extraDiscount: billing.extraDiscount,
                                  showShippingFee: !billing.onlyDigital,
                                  isFreeShipping: billing.isFreeShipping,
                                ),

                                if ((order.orderNote ?? '').trim().isNotEmpty) ...[
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                  OrderNoteWidget(note: order.orderNote!),
                                ],

                                if (order.deliveryType == 'third_party_delivery') ...[
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                  ChangeNotifierProvider<ThirdPartyDeliverymanController>.value(
                                    value: Provider.of<WholesaleThirdPartyDeliverymanController>(context, listen: false),
                                    child: ThirdPartyDeliveryInfoWidget(orderModel: order, courierShipment: lines.first.courierShipment),
                                  ),
                                ],

                                if (lines.first.verificationImages?.isNotEmpty ?? false)
                                  OrderVerificationImagesWidget(verificationImages: lines.first.verificationImages!),
                              ]),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeSmall),
                          ]),
                        ),
                      ],
                    ),
                  ),

            bottomNavigationBar: (order == null || billing == null || order.orderType == 'POS')
              ? const SizedBox()
              : Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: ThemeShadow.getShadow(context)),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                  child: SafeArea(
                    child: CustomButtonWidget(
                      backgroundColor: Theme.of(context).primaryColor,
                      borderRadius: Dimensions.paddingSizeExtraSmall,
                      btnTxt: getTranslated('order_setup', context),
                      onTap: () => _openOrderSetup(order, billing.onlyDigital, lines?.first.courierShipment),
                    ),
                  ),
                ),
          );
        },
      ),
    );
  }
}
