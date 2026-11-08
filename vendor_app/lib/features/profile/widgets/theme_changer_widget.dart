import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/features/bank_info/screens/bank_info_screen.dart';
import 'package:sixvalley_vendor_app/features/language/screens/change_language_screen.dart';
import 'package:sixvalley_vendor_app/features/menu/widgets/sign_out_confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/features/settings/screens/setting_screen.dart';
import 'package:sixvalley_vendor_app/features/shipping/screens/shipping_main_screen.dart';

class ThemeChangerWidget extends StatelessWidget {
  const ThemeChangerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context).darkTheme;

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        boxShadow: ThemeShadow.getShadow(context),
      ),
      child: Column(
        children: [

          SectionItemWidget(
            icon: Images.profileDarkModeIcon,
            title: 'dark_theme',
            trailing: FlutterSwitch(width: 50.0, height: 28.0, toggleSize: 20.0,
              value: isDark,
              borderRadius: 20.0,
              activeColor: Theme.of(context).primaryColor,
              padding: 3.0,
              activeIcon: Image.asset(Images.darkMode, width: 30, height: 30, fit: BoxFit.scaleDown),
              inactiveIcon: Image.asset(Images.lightMode, width: 30, height: 30, fit: BoxFit.scaleDown),
              onToggle: (bool isActive) => Provider.of<ThemeController>(context, listen: false).toggleTheme(),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall,),

          SectionItemWidget(icon: Images.profileLanguageIcon, title: 'language',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChooseLanguageScreen())),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall,),

          SectionItemWidget(icon: Images.profileBankInfoIcon, title: 'bank_info',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BankInfoScreen())),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall,),

          SectionItemWidget(icon: Images.profileDeleteIcon, title: 'delete_account',
            onTap: () => showModalBottomSheet(context: context, builder: (_) => const SignOutConfirmationDialogWidget(isDelete: true)),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall,),

          SectionItemWidget(icon: Images.box, title: 'shipping_method',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShippingMainScreen())),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall,),

          SectionItemWidget(icon: Images.editProfile, title: 'settings',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),

        ],
      ),
    );
  }
}

class SectionItemWidget extends StatelessWidget {
  final String? icon;
  final String? title;
  final VoidCallback? onTap;
  final Widget? trailing;
  const SectionItemWidget({super.key, this.onTap, this.icon, this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        height: Dimensions.profileCardHeight,
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Row(children: [
            SizedBox(width: Dimensions.iconSizeLarge, height: Dimensions.iconSizeLarge,
                child: CustomAssetImageWidget(icon!, width: Dimensions.iconSizeLarge, height: Dimensions.iconSizeLarge)),
            const SizedBox(width: Dimensions.paddingSizeSmall,),

            Expanded(child: Text(getTranslated(title, context)!,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),),

            trailing ?? SizedBox(width: Dimensions.iconSizeDefault,
                child: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor, size: Dimensions.iconSizeDefault,))
          ],),
        ),
      ),
    );
  }
}
