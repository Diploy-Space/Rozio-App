import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/app_mode/controllers/app_mode_controller.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/enums/app_mode.dart';
import 'package:sixvalley_vendor_app/features/notification/screens/notification_screen.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/models/campaign_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/screens/campaign_details_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/screens/wholesale_order_details_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/screens/wholesale_product_details_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/screens/wholesale_product_review_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/screens/wholesale_refund_details_screen.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/notification/models/notification_body.dart';

class WholesaleNotificationRouter {
  static void route(NotificationBody body, {required bool fromLaunch}) {
    final NavigatorState? navigator = Get.navigator;
    final BuildContext? context = Get.context;
    if (navigator == null || context == null) return;

    final bool isWholesaleEnabled = Provider.of<SplashController>(context, listen: false)
        .configModel?.isWholesaleFeatureEnabled == true;

    if (fromLaunch && isWholesaleEnabled) {
      Provider.of<AppModeController>(context, listen: false).setAppMode(AppMode.wholesale);
    }

    final Widget screen = isWholesaleEnabled ? _screenFor(body, fromLaunch) : const NotificationScreen();

    final MaterialPageRoute route = MaterialPageRoute(builder: (_) => screen);
    if (fromLaunch) {
      navigator.pushReplacement(route);
    } else {
      navigator.push(route);
    }
  }

  static Widget _screenFor(NotificationBody body, bool fromNotification) {
    switch (body.type) {
      case 'order':
        if (body.orderId != null) {
          return WholesaleOrderDetailsScreen(orderId: body.orderId!, fromNotification: fromNotification);
        }
        break;

      case 'refund':
        if (body.refundId != null) {
          return WholesaleRefundDetailsScreen(refund: RefundModel(id: body.refundId), fromNotification: fromNotification);
        }
        break;

      case 'product_request_approved_message':
        if (body.productId != null) {
          return WholesaleProductDetailsScreen(productId: body.productId!, fromNotification: fromNotification);
        }
        break;

      case 'campaign':
        if (body.campaignId != null) {
          return CampaignDetailsScreen(campaign: CampaignModel(id: body.campaignId), fromNotification: fromNotification);
        }
        break;

      case 'review':
        return WholesaleProductReviewScreen(fromNotification: fromNotification);
    }

    return const NotificationScreen();
  }
}
