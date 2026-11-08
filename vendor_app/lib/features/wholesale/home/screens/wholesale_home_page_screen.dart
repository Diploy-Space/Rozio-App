import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/features/app_mode/widgets/app_mode_switch_button_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/controllers/wholesale_home_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/widgets/wholesale_business_analytics_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/widgets/wholesale_completed_order_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/widgets/wholesale_earning_statistics_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/widgets/wholesale_home_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/widgets/wholesale_top_product_section_widget.dart';
import 'package:sixvalley_vendor_app/features/notification/controllers/notification_controller.dart';
import 'package:sixvalley_vendor_app/features/notification/screens/notification_screen.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleHomePageScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const WholesaleHomePageScreen({super.key, this.onOpenDrawer});

  @override
  State<WholesaleHomePageScreen> createState() => _WholesaleHomePageScreenState();
}

class _WholesaleHomePageScreenState extends State<WholesaleHomePageScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleHomeController>(context, listen: false).loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Provider.of<WholesaleHomeController>(context, listen: false).loadData(reload: true),
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
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
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
                            final int unreadCount = notificationController.notificationModel?.newNotificationItem ?? 0;

                            return InkWell(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
                              child: Stack(
                                children: [
                                  Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    child: const CustomAssetImageWidget(
                                        Images.appBarNotificationIcon,
                                        height: Dimensions.iconSizeMedium,
                                        width: Dimensions.iconSizeMedium),
                                  ),
                                  if (unreadCount > 0)
                                    Positioned(top: 0, right: 0,
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context).colorScheme.error,
                                        radius: 7,
                                        child: Center(
                                          child: Padding(padding: const EdgeInsets.all(1.0),
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
                          child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            child: const CustomAssetImageWidget(
                                Images.appbarSettingsIcon,
                                height: Dimensions.iconSizeMedium,
                                width: Dimensions.iconSizeMedium),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Consumer<WholesaleHomeController>(
                builder: (context, wholesaleHomeController, _) {
                  if (wholesaleHomeController.isInitialLoading) {
                    return const WholesaleHomeShimmerWidget();
                  }

                  final topSellingProducts = wholesaleHomeController.topSellingProducts;
                  final mostPopularProducts = wholesaleHomeController.mostPopularProducts;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      const WholesaleBusinessAnalyticsWidget(),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      const WholesaleCompletedOrderWidget(),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      const WholesaleEarningStatisticsWidget(),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      if (topSellingProducts?.isNotEmpty ?? false)
                        WholesaleTopProductSectionWidget(titleKey: 'top_selling_products', products: topSellingProducts!),

                      if (mostPopularProducts?.isNotEmpty ?? false)
                        WholesaleTopProductSectionWidget(titleKey: 'most_popular_products', products: mostPopularProducts!),

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
