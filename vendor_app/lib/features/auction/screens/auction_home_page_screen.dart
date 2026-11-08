import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/features/app_mode/widgets/app_mode_switch_button_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/controllers/auction_home_controller.dart';
import 'package:sixvalley_vendor_app/features/auction/screens/auction_list_screen.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/auction_bid_analytics_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/auction_business_analytics_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/auction_gross_sales_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/auction_recently_ended_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/auction_top_performing_widget.dart';
import 'package:sixvalley_vendor_app/features/notification/controllers/notification_controller.dart';
import 'package:sixvalley_vendor_app/features/notification/screens/notification_screen.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AuctionHomePageScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const AuctionHomePageScreen({super.key, this.onOpenDrawer});

  @override
  State<AuctionHomePageScreen> createState() => _AuctionHomePageScreenState();
}

class _AuctionHomePageScreenState extends State<AuctionHomePageScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuctionHomeController>(context, listen: false).loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Provider.of<AuctionHomeController>(context, listen: false).loadData(reload: true),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              elevation: 0,
              toolbarHeight: 50,
              automaticallyImplyLeading: false,
              surfaceTintColor: Theme.of(context).highlightColor,
              backgroundColor: Theme.of(context).highlightColor,
              snap: true,
              flexibleSpace: Container(
                color: Theme.of(context).highlightColor,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium, vertical: Dimensions.paddingSizeSmall),
                    child: Row(
                      children: [
                        Image.asset(Images.logoWithAppName, height: 30),
                        const Spacer(),

                        const AppModeSwitchButtonWidget(),
                        const Spacer(),

                        Consumer<NotificationController>(
                          builder: (context, notificationController, _) {
                            final int unreadCount = notificationController.auctionNotificationModel?.newNotification ?? 0;

                            return InkWell(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    child: const CustomAssetImageWidget(Images.appBarNotificationIcon, height: Dimensions.iconSizeMedium, width: Dimensions.iconSizeMedium),
                                  ),
                                  if (unreadCount > 0)
                                    Positioned(
                                      top: 0, right: 0,
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context).colorScheme.error,
                                        radius: 7,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Text(
                                              '$unreadCount',
                                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall - 2, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: Dimensions.paddingSizeDefault),
                        InkWell(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          onTap: () => widget.onOpenDrawer?.call(),
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            child: const CustomAssetImageWidget(Images.appbarSettingsIcon, height: Dimensions.iconSizeMedium, width: Dimensions.iconSizeMedium),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Consumer<AuctionHomeController>(
                builder: (context, auctionHomeController, _) {
                  final topPerformingAuctions = auctionHomeController.topPerformingAuctions;
                  final recentlyEndedAuctions = auctionHomeController.recentlyEndedAuctions;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      const AuctionBusinessAnalyticsWidget(),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      const AuctionBidAnalyticsWidget(),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      const AuctionGrossSalesWidget(),

                      if (topPerformingAuctions?.isNotEmpty ?? false)
                        AuctionTopPerformingWidget(
                          auctions: topPerformingAuctions!,
                          onViewAll: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AuctionListScreen())),
                        ),

                      if (recentlyEndedAuctions?.isNotEmpty ?? false)
                        AuctionRecentlyEndedWidget(
                          auctions: recentlyEndedAuctions!,
                          onViewAll: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AuctionListScreen())),
                        ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
