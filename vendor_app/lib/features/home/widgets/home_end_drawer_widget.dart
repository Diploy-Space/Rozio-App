import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/features/bank_info/screens/bank_info_screen.dart';
import 'package:sixvalley_vendor_app/features/chat/screens/inbox_screen.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/screens/delivery_man_setup_screen.dart';
import 'package:sixvalley_vendor_app/features/language/screens/change_language_screen.dart';
import 'package:sixvalley_vendor_app/features/menu/widgets/sign_out_confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/features/more/screens/html_view_screen.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/features/profile/screens/profile_view_screen.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/shop/screens/shop_screen.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/models/business_pages_model.dart';
import 'package:sixvalley_vendor_app/features/wallet/screens/wallet_screen.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import '../../../main.dart';

void _navigate(BuildContext context, Widget screen) {
  Navigator.of(context).pop();
  Future.microtask(() => Navigator.push(Get.context!, MaterialPageRoute(builder: (_) => screen)));
}

TextStyle _drawerTextStyle(BuildContext context, {Color? color}) {
  return robotoRegular.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0,
    color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
  );
}

BusinessPageModel? _pageFor(String slug, List<BusinessPageModel>? pages) {
  if (pages == null || pages.isEmpty) return null;
  for (final page in pages) {
    if (page.slug == slug) return page;
  }
  return null;
}

class _MenuEntry {
  final String icon;
  final String label;
  final Widget Function() destination;
  const _MenuEntry({required this.icon, required this.label, required this.destination});
}

class HomeEndDrawerWidget extends StatelessWidget {
  const HomeEndDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Theme.of(context).cardColor,
      child: SafeArea(
        child: Column(
          children: [
            const _DrawerHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<SplashController>(
                      builder: (context, splashController, _) {
                        final pages = splashController.defaultBusinessPages;

                        final entries = <_MenuEntry>[
                          _MenuEntry(
                            icon: Images.myShop,
                            label: getTranslated('my_shop', context) ?? 'My Shop',
                            destination: () => const ShopScreen(),
                          ),
                          _MenuEntry(
                            icon: Images.message,
                            label: getTranslated('inbox', context) ?? 'Inbox',
                            destination: () => const InboxScreen(),
                          ),
                          _MenuEntry(
                            icon: Images.deliveryManIcon,
                            label: getTranslated('deliveryman', context) ?? 'Deliveryman Setup',
                            destination: () => const DeliveryManSetupScreen(),
                          ),
                          _MenuEntry(
                            icon: Images.wallet,
                            label: getTranslated('wallet', context) ?? 'Wallet',
                            destination: () => const WalletScreen(),
                          ),
                          _MenuEntry(
                            icon: Images.bankingInfo,
                            label: getTranslated('bank_info', context) ?? 'Bank info',
                            destination: () => const BankInfoScreen(),
                          ),
                          if (_pageFor('terms-and-conditions', pages) != null)
                            _MenuEntry(
                              icon: Images.termsAndCondition,
                              label: getTranslated('terms_and_condition', context) ?? 'Terms & Condition',
                              destination: () => HtmlViewScreen(page: _pageFor('terms-and-conditions', pages)),
                            ),
                          if (_pageFor('about-us', pages) != null)
                            _MenuEntry(
                              icon: Images.aboutUs,
                              label: getTranslated('about_us', context) ?? 'About Us',
                              destination: () => HtmlViewScreen(page: _pageFor('about-us', pages)),
                            ),
                          if (_pageFor('privacy-policy', pages) != null)
                            _MenuEntry(
                              icon: Images.privacyPolicy,
                              label: getTranslated('privacy_policy', context) ?? 'Privacy Policy',
                              destination: () => HtmlViewScreen(page: _pageFor('privacy-policy', pages)),
                            ),
                          if (_pageFor('refund-policy', pages) != null)
                            _MenuEntry(
                              icon: Images.refundPolicy,
                              label: getTranslated('refund_policy', context) ?? 'Refund Policy',
                              destination: () => HtmlViewScreen(page: _pageFor('refund-policy', pages)),
                            ),
                          if (_pageFor('return-policy', pages) != null)
                            _MenuEntry(
                              icon: Images.returnPolicy,
                              label: getTranslated('return_policy', context) ?? 'Return Policy',
                              destination: () => HtmlViewScreen(page: _pageFor('return-policy', pages)),
                            ),
                          if (_pageFor('cancellation-policy', pages) != null)
                            _MenuEntry(
                              icon: Images.cPolicy,
                              label: getTranslated('cancellation_policy', context) ?? 'Cancellation Policy',
                              destination: () => HtmlViewScreen(page: _pageFor('cancellation-policy', pages)),
                            ),
                        ];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final entry in entries) ...[
                              _DrawerMenuItem(
                                icon: entry.icon,
                                label: entry.label,
                                onTap: () => _navigate(context, entry.destination()),
                              ),
                              if (entry != entries.last) const SizedBox(height: 24),
                            ],
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    const _LanguageRow(),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                  ],
                ),
              ),
            ),
            const _DrawerFooter(),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeLarge,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _navigate(context, const ProfileScreenView()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<ProfileController>(
                    builder: (context, profileController, _) {
                      final imagePath = profileController.userInfoModel?.imageFullUrl?.path;
                      final hasImage = imagePath != null && imagePath.isNotEmpty;
                      return hasImage
                          ? CustomImageWidget(image: imagePath, height: 25, width: 25, fit: BoxFit.cover)
                          : Container(height: 25, width: 25, alignment: Alignment.center,
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              child: Icon(Icons.person, size: 10, color: Theme.of(context).primaryColor));
                    },
                  ),
                  const SizedBox(width: 3),
                  Text(
                    getTranslated('profile', context) ?? 'Profile',
                    style: _drawerTextStyle(context),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Icon(Icons.close, size: Dimensions.iconSizeMedium, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  const _DrawerMenuItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CustomAssetImageWidget(icon, height: 16, width: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: _drawerTextStyle(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationController>(
      builder: (context, localizationController, _) {
        final int index = localizationController.languageIndex ?? 0;
        final currentLanguage = AppConstants.languages[index];

        return InkWell(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          onTap: () => _navigate(context, const ChooseLanguageScreen()),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            child: Row(
              children: [
                Text(
                  getTranslated('language', context) ?? 'Language',
                  style: _drawerTextStyle(context),
                ),
                const Spacer(),
                if (currentLanguage.imageUrl != null) CustomAssetImageWidget(currentLanguage.imageUrl!, height: 20, width: 20),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Icon(Icons.keyboard_arrow_down, size: Dimensions.iconSizeDefault, color: Theme.of(context).hintColor),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              '${getTranslated('app_version', context) ?? 'Version'} ${AppConstants.appVersion}',
              style: _drawerTextStyle(context, color: Theme.of(context).hintColor),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeMedium),
          InkWell(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            onTap: () {
              Navigator.of(context).pop();
              Future.microtask(
                () => showModalBottomSheet(context: Get.context!, builder: (_) => const SignOutConfirmationDialogWidget()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMedium),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Center(
                child: Text(
                  getTranslated('logout', context) ?? 'Logout',
                  style: _drawerTextStyle(context, color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
