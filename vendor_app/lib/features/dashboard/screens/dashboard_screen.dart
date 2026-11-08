import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_dialog_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/digital_product_controller.dart';
import 'package:sixvalley_vendor_app/features/ai/controllers/ai_controller.dart';
import 'package:sixvalley_vendor_app/features/app_mode/controllers/app_mode_controller.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/enums/app_mode.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/app_mode_tutorial.dart';
import 'package:sixvalley_vendor_app/features/auction/controllers/auction_product_controller.dart';
import 'package:sixvalley_vendor_app/features/auction/screens/addAuctionProduct/add_auction_product_tab_view.dart';
import 'package:sixvalley_vendor_app/features/auction/screens/auction_home_page_screen.dart';
import 'package:sixvalley_vendor_app/features/auction/screens/auction_list_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/screens/wholesale_home_page_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/screens/wholesale_order_list_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/screens/wholesale_refund_list_screen.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/category_controller.dart';
import 'package:sixvalley_vendor_app/features/shop/controllers/shop_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/transaction/controllers/transaction_controller.dart';
import 'package:sixvalley_vendor_app/features/wallet/controllers/wallet_controller.dart';
import 'package:sixvalley_vendor_app/helper/network_info.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/features/home/screens/home_page_screen.dart';
import 'package:sixvalley_vendor_app/features/home/widgets/home_end_drawer_widget.dart';
import 'package:sixvalley_vendor_app/features/menu/widgets/menu_widget.dart';
import 'package:sixvalley_vendor_app/features/order/screens/order_screen.dart';
import 'package:sixvalley_vendor_app/features/refund/screens/refund_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  ShowcaseView? _appModeShowcaseView;
  final configModel = Provider.of<SplashController>(Get.context!, listen: false).configModel;


  @override
  void initState() {
    super.initState();
    _appModeShowcaseView = AppModeTutorial.register(context);

    String languageCode = Provider.of<LocalizationController>(context, listen: false).locale.countryCode == 'US'?
    'en':Provider.of<LocalizationController>(context, listen: false).locale.countryCode!.toLowerCase();
    Provider.of<ProfileController>(context, listen: false).getSellerInfo();
    Provider.of<DigitalProductController>(context, listen: false).getDigitalAuthor();
    Provider.of<DigitalProductController>(context, listen: false).getPublishingHouse();
    Provider.of<CategoryController>(context,listen: false).getCategoryList(context, null, languageCode);
    Provider.of<CartController>(context,listen: false).getCartData();
    Provider.of<ShopController>(context, listen: false).getShopInfo();

    Provider.of<TransactionController>(context, listen: false).getTransactionList(context,'all','','');
    Provider.of<WalletController>(context, listen: false).getPaymentInfoList();

    if(configModel?.isAuctionFeatureEnabled == true && configModel?.activeAuctionForVendor == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Provider.of<AuctionProductController>(context, listen: false).getAuctionList(tabIndex: 0, offset: 1);
        Provider.of<AuctionProductController>(context, listen: false).getAuctionProductList('pending', 1);
      });
    }

    if(Provider.of<SplashController>(context,listen: false).configModel?.isAiFeatureActive == 1) {
      Provider.of<AiController>(context,listen: false).generateLimitCheck();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AppModeTutorial.startIfNeeded(context);
    });

    NetworkInfo.checkConnectivity(context);
  }

  @override
  void dispose() {
    AppModeTutorial.unregister(owner: _appModeShowcaseView);
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildHomeTab(BuildContext context, AppMode appMode) {
    switch (appMode) {
      case AppMode.wholesale:
        return WholesaleHomePageScreen(onOpenDrawer: () => _scaffoldKey.currentState?.openEndDrawer());
      case AppMode.auction:
        return AuctionHomePageScreen(onOpenDrawer: () => _scaffoldKey.currentState?.openEndDrawer());
      case AppMode.retail:
        return HomePageScreen(
          callback: () {
            setState(() {
              setPage(1);
            });
          },
          onOpenDrawer: () => _scaffoldKey.currentState?.openEndDrawer(),
        );
    }
  }

  List<Widget> _screensFor(AppMode appMode) {
    switch (appMode) {
      case AppMode.auction:
        return const [
          AuctionListScreen(isBackButtonExist: false),
          AddAuctionProductTabView(fromPage: AddAuctionFromPage.auctionRequest, isBackButtonExist: false),
        ];
      case AppMode.wholesale:
        return const [
          WholesaleOrderListScreen(),
          WholesaleRefundListScreen(),
        ];
      case AppMode.retail:
        return const [
          OrderScreen(),
          RefundScreen(fromNotification: false),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (_pageIndex != 0) {
          setPage(0);
        } else {
          _onWillPop(context);
        }
        if(didPop) return;
      },

      child: Consumer<AppModeController>(
        builder: (context, appModeController, _) {
          final AppMode appMode = appModeController.appMode;
          final bool isAuctionMode = appMode == AppMode.auction;
          final List<Widget> screens = _screensFor(appMode);

          return Scaffold(
            key: _scaffoldKey,
            endDrawer: const HomeEndDrawerWidget(),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Theme.of(context).hintColor,
              selectedFontSize: Dimensions.fontSizeSmall,
              unselectedFontSize: Dimensions.fontSizeSmall,
              selectedLabelStyle: robotoBold,
              showUnselectedLabels: true,
              currentIndex: _pageIndex,
              type: BottomNavigationBarType.fixed,
              items: isAuctionMode
                ? [
                    _barItem(Images.home, getTranslated('home', context), 0),
                    _barItem(Images.navbarAuctionIcon, getTranslated('auctions', context), 1),
                    _barItem(Images.navbarCreateNewIcon, getTranslated('create_new', context), 2),
                    _barItem(Images.menu, getTranslated('more', context), 3),
                  ]
                : [
                    _barItem(Images.home, getTranslated('home', context), 0),
                    _barItem(Images.order, getTranslated('my_order', context), 1),
                    _barItem(Images.refund, getTranslated('refund', context), 2),
                    _barItem(Images.menu, getTranslated('menu', context), 3),
                  ],
              onTap: (int index) {
                if (index == 3) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (con) => const MenuBottomSheetWidget()
                  );
                } else {
                  setState(() {
                    setPage(index);
                  });
                }
              },
            ),
            body: PageView.builder(
              controller: _pageController,
              itemCount: screens.length + 1,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == 0) return _buildHomeTab(context, appMode);
                return screens[index - 1];
              },
            ),
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _barItem(String icon, String? label, int index) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom : Dimensions.paddingSizeExtraSmall),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(width: index == _pageIndex ? Dimensions.iconSizeLarge : Dimensions.iconSizeMedium,
              child: CustomAssetImageWidget(icon,
                width: index == _pageIndex ? Dimensions.iconSizeLarge : Dimensions.iconSizeMedium,
                height: index == _pageIndex ? Dimensions.iconSizeLarge : Dimensions.iconSizeMedium,
                color: index == _pageIndex ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
              )
            ),
          ],
        ),
      ),
      label: label,
    );
  }

  void setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    showAnimatedDialogWidget(context,  ConfirmationDialogWidget(icon: Images.logOut,
      title: getTranslated('exit_app', context),
      description: getTranslated('do_you_want_to_exit_the_app', context),
      onYesPressed: () {
        SystemNavigator.pop();
      },
    ), isFlip: true);

    return true;
  }

}
