import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_details_model.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/features/refund/widgets/refund_detail_shimmer.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/controllers/wholesale_refund_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/enums/wholesale_refund_status.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/widgets/wholesale_refund_approve_reject_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/widgets/wholesale_refund_attachment_list_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/widgets/wholesale_refund_change_log_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/widgets/wholesale_refund_customer_info_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/widgets/wholesale_refund_deliveryman_info_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/widgets/wholesale_refund_pricing_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/widgets/wholesale_refund_product_card_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleRefundDetailsScreen extends StatefulWidget {
  final RefundModel refund;
  final bool fromNotification;
  const WholesaleRefundDetailsScreen({super.key, required this.refund, this.fromNotification = false});

  @override
  State<WholesaleRefundDetailsScreen> createState() => _WholesaleRefundDetailsScreenState();
}

class _WholesaleRefundDetailsScreenState extends State<WholesaleRefundDetailsScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleRefundController>(context, listen: false).getRefundDetails(widget.refund.id!);
  }

  void _goToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashboardScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.fromNotification,
      onPopInvokedWithResult: (didPop, _) {
        Provider.of<WholesaleRefundController>(context, listen: false).emptyRefundDetails();
        if (!didPop) _goToDashboard();
      },
      child: Consumer<WholesaleRefundController>(
        builder: (context, wholesaleRefundController, _) {
          final RefundModel refund = wholesaleRefundController.refund ?? widget.refund;
          final RefundDetailsModel? details = wholesaleRefundController.refundDetails;
          final List<RefundStatus> statusHistory = wholesaleRefundController.statusHistory;
          final WholesaleRefundStatus status = wholesaleRefundController.currentStatus ?? WholesaleRefundStatus.fromString(refund.status);
          final bool canUpdateStatus = details != null && status != WholesaleRefundStatus.refunded && !wholesaleRefundController.isLockedByAdmin;

          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              backgroundColor: Theme.of(context).cardColor,
              surfaceTintColor: Theme.of(context).highlightColor,
              title: Text(getTranslated('refund_details', context) ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyLarge?.color),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              actions: [
                if (statusHistory.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.history, color: Theme.of(context).textTheme.bodyLarge?.color),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => WholesaleRefundChangeLogWidget(statusLogs: statusHistory, paidBy: refund.order?.paymentMethod),
                    ),
                  ),
              ],
            ),
            body: details == null
              ? (wholesaleRefundController.isDetailsLoading ? const RefundDetailShimmer() : const NoDataScreen())
              : Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => wholesaleRefundController.getRefundDetails(widget.refund.id!, reload: false),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(height: 10, color: Theme.of(context).primaryColor.withValues(alpha: .1)),

                              WholesaleRefundDataWidget(
                                refund: refund,
                                requestedAt: (details.refundRequest?.isNotEmpty ?? false) ? details.refundRequest!.first.createdAt : null,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              if (refund.product != null) ...[
                                WholesaleRefundProductCardWidget(
                                  product: refund.product!,
                                  variant: refund.orderDetails?.variant,
                                  quantity: details.quntity,
                                  unitPrice: details.productPrice,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                              ],

                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                color: Theme.of(context).cardColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Image.asset(Images.refundResonIcon, height: Dimensions.iconSizeDefault, width: Dimensions.iconSizeDefault),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),
                                      Text(getTranslated('refund_reason', context) ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
                                    ]),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),
                                    Text(refund.refundReason ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                                    if (refund.imagesFullUrl?.isNotEmpty ?? false) ...[
                                      const SizedBox(height: Dimensions.paddingSizeSmall),
                                      WholesaleRefundAttachmentListWidget(images: refund.imagesFullUrl!),
                                    ],
                                  ],
                                ),
                              ),

                              WholesaleRefundPricingWidget(details: details),

                              WholesaleRefundCustomerInfoWidget(customer: refund.customer),

                              if (details.deliverymanDetails != null)
                                WholesaleRefundDeliverymanInfoWidget(deliveryman: details.deliverymanDetails!),

                              const SizedBox(height: Dimensions.paddingSizeSmall),
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (canUpdateStatus)
                      WholesaleRefundApproveRejectWidget(refund: refund, status: status),
                  ],
                ),
          );
        },
      ),
    );
  }
}
