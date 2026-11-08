import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_sliver_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/app_mode/controllers/app_mode_controller.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/enums/app_mode.dart';
import 'package:sixvalley_vendor_app/features/notification/controllers/notification_controller.dart';
import 'package:sixvalley_vendor_app/features/notification/domain/models/notification_model.dart';
import 'package:sixvalley_vendor_app/features/notification/widgets/auction_notification_item_widget.dart';
import 'package:sixvalley_vendor_app/features/notification/widgets/notification_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/notification/widgets/wholesale_notification_item_widget.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with TickerProviderStateMixin {
  bool _isAuctionEnabled = false;
  bool _isWholesaleEnabled = false;
  TabController? _tabController;
  final ScrollController _generalScrollController = ScrollController();
  final ScrollController _auctionScrollController = ScrollController();
  final ScrollController _wholesaleScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final config = Provider.of<SplashController>(context, listen: false).configModel;
    _isAuctionEnabled = config?.isAuctionFeatureEnabled == true;
    _isWholesaleEnabled = config?.isWholesaleFeatureEnabled == true;

    final int tabCount = 1 + (_isAuctionEnabled ? 1 : 0) + (_isWholesaleEnabled ? 1 : 0);
    if (tabCount > 1) {
      _tabController = TabController(
        length: tabCount,
        vsync: this,
        initialIndex: _tabIndexOf(Provider.of<AppModeController>(context, listen: false).appMode),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nc = Provider.of<NotificationController>(context, listen: false);
      nc.getNotificationList(1);
      if (_isAuctionEnabled) nc.getAuctionNotificationList(1);
      if (_isWholesaleEnabled) nc.getWholesaleNotificationList(1);
    });
  }

  int _tabIndexOf(AppMode mode) {
    switch (mode) {
      case AppMode.auction:
        return _isAuctionEnabled ? 1 : 0;
      case AppMode.wholesale:
        return _isWholesaleEnabled ? 1 + (_isAuctionEnabled ? 1 : 0) : 0;
      case AppMode.retail:
        return 0;
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _generalScrollController.dispose();
    _auctionScrollController.dispose();
    _wholesaleScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Tab> tabs = [
      Tab(text: getTranslated('general', context) ?? 'General'),
      if (_isAuctionEnabled) Tab(text: getTranslated('auction', context) ?? 'Auction'),
      if (_isWholesaleEnabled) Tab(text: getTranslated('wholesale', context) ?? 'Wholesale'),
    ];

    final List<Widget> views = [
      _GeneralNotificationTab(scrollController: _generalScrollController),
      if (_isAuctionEnabled) _AuctionNotificationTab(scrollController: _auctionScrollController),
      if (_isWholesaleEnabled) _WholesaleNotificationTab(scrollController: _wholesaleScrollController),
    ];

    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('notification', context)),
      body: _tabController != null
          ? Column(children: [
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
                tabs: tabs,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController!,
                  children: views,
                ),
              ),
            ])
          : views.first,
    );
  }
}

class _GeneralNotificationTab extends StatelessWidget {
  final ScrollController scrollController;

  const _GeneralNotificationTab({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationController>(
      builder: (context, notificationController, _) {
        return notificationController.notificationModel != null
              ? (notificationController.notificationModel!.notification != null &&
                      notificationController.notificationModel!.notification!.isNotEmpty)
                  ? CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        PaginatedSliverListView(
                          scrollController: scrollController,
                          onPaginate: (int? offset) async {
                            await notificationController.getNotificationList(offset!);
                          },
                          totalSize: notificationController.notificationModel?.totalSize,
                          offset: notificationController.notificationModel?.offset,
                          itemView: SliverList.builder(
                            itemCount: notificationController.notificationModel?.notification?.length,
                            addAutomaticKeepAlives: false,
                            addRepaintBoundaries: false,
                            itemBuilder: (context, index) {
                              return NotificationCard(
                                  notificationItem: notificationController.notificationModel!.notification![index]);
                            },
                          ),
                        ),
                      ],
                    )
                  : const Center(child: IntrinsicHeight(child: NoDataScreen()))
              : const NotificationShimmerWidget();
      },
    );
  }
}

class _AuctionNotificationTab extends StatelessWidget {
  final ScrollController scrollController;

  const _AuctionNotificationTab({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationController>(
      builder: (context, nc, _) {
        if (nc.isAuctionNotificationLoading) return const NotificationShimmerWidget(hasLeadingIcon: true);

        final model = nc.auctionNotificationModel;
        if (model == null || (model.notifications?.isEmpty ?? true)) {
          return const Center(child: IntrinsicHeight(child: NoDataScreen()));
        }

        return CustomScrollView(
          controller: scrollController,
          slivers: [
            PaginatedSliverListView(
              scrollController: scrollController,
              totalSize: model.totalSize,
              offset: model.offset,
              onPaginate: (int? offset) async {
                await nc.getAuctionNotificationList(offset!);
              },
              itemView: SliverList.builder(
                itemCount: model.notifications!.length,
                itemBuilder: (_, i) => AuctionNotificationItemWidget(
                  item: model.notifications![i],
                  index: i,
                  allItems: model.notifications!,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WholesaleNotificationTab extends StatelessWidget {
  final ScrollController scrollController;

  const _WholesaleNotificationTab({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationController>(
      builder: (context, nc, _) {
        if (nc.isWholesaleNotificationLoading) return const NotificationShimmerWidget(hasLeadingIcon: true);

        final model = nc.wholesaleNotificationModel;
        if (model == null || (model.notifications?.isEmpty ?? true)) {
          return const Center(child: IntrinsicHeight(child: NoDataScreen()));
        }

        return CustomScrollView(
          controller: scrollController,
          slivers: [
            PaginatedSliverListView(
              scrollController: scrollController,
              totalSize: model.totalSize,
              offset: model.offset,
              onPaginate: (int? offset) async {
                await nc.getWholesaleNotificationList(offset!);
              },
              itemView: SliverList.builder(
                itemCount: model.notifications!.length,
                itemBuilder: (_, i) => WholesaleNotificationItemWidget(
                  item: model.notifications![i],
                  index: i,
                  allItems: model.notifications!,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notificationItem;
  const NotificationCard({super.key, required this.notificationItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: () {
          Provider.of<NotificationController>(context, listen: false).seenNotification(notificationItem.id!);
          showDialog(
              context: context,
              builder: (_) => NotificationDialog(title: notificationItem.title!, subTitle: notificationItem.createdAt!));
        },
        child: Stack(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(notificationItem.title!,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Text(
                  DateConverter.customTime(DateTime.parse(notificationItem.createdAt!)),
                  style: robotoRegular.copyWith(fontSize: Dimensions.paddingSizeSmall),
                ),
              ]),
            ),
          ),
          if (notificationItem.notificationSeenStatus == 0)
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CircleAvatar(
                radius: 4,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
        ]),
      ),
    );
  }
}

class NotificationDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  const NotificationDialog({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0,
            Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Padding(
                padding: EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Icon(CupertinoIcons.clear),
                ]),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              child: SizedBox(
                  width: 40, child: Image.asset(Images.notificationDialog)),
            ),
            Center(
              child: Text('${AppConstants.companyName} $title',
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Text(
                DateConverter.customTime(DateTime.parse(subTitle)),
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).hintColor),
              ),
            ),
            const SizedBox(height: Dimensions.fontSizeDefault),
            Text(getTranslated('notification_message', context) ?? '', textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: '${getTranslated('note', context)} : ',
                  style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
              TextSpan(
                  text: '${getTranslated('notification_note', context)}',
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: .75))),
            ])),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            CustomButtonWidget(
              btnTxt: '${getTranslated('visit', context)}',
              onTap: () {
                _launchUrl(
                    '${AppConstants.baseUrl}/shopView/${Provider.of<ProfileController>(context, listen: false).userId}');
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  if(kDebugMode){
    print("=====>Url is $url");
  }
  if (!await launchUrl(Uri.parse(url),
      mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
