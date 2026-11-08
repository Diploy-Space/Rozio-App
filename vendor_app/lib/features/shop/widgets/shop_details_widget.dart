import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/guideline_warning_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/screens/add_product_tab_view_screen.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/app_mode_availability.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/enums/app_mode.dart';
import 'package:sixvalley_vendor_app/features/profile/widgets/verification_banner_widget.dart';
import 'package:sixvalley_vendor_app/features/shop/controllers/shop_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/shop_model.dart';
import 'package:sixvalley_vendor_app/features/shop/screens/availability_screen.dart';
import 'package:sixvalley_vendor_app/features/shop/screens/vacation_mode_setup_screen.dart';
import 'package:sixvalley_vendor_app/features/shop/widgets/shop_card_widget.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';


class ShopDetailsWidget extends StatefulWidget {
  const ShopDetailsWidget({super.key});

  @override
  State<ShopDetailsWidget> createState() => _ShopDetailsWidgetState();
}

class _ShopDetailsWidgetState extends State<ShopDetailsWidget> {
  String sellerId = '0';

  TextEditingController vacationNote = TextEditingController();

  bool freeDeliveryOver = false;

  TextEditingController minimumOrderAmountController = TextEditingController();

  TextEditingController freeDeliveryOverAmountController = TextEditingController();

  bool freeDeliveryOn = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopController>(
      builder: (context, shopInfo, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          child: SingleChildScrollView(
            child: Column(
              children: [

                if(shopInfo.showAddProductWarning && shopInfo.shopModel?.totalProducts != null && ((shopInfo.shopModel?.totalProducts ?? 0) < 1))
                Padding(
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall),
                  child: GuidelineWarningWidget(
                    guidelineStatus: GuidelineStatus.warning,
                    content: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color),
                        children: <InlineSpan>[
                          TextSpan(text: getTranslated('manage_your_shop_decoration', context) ?? ''),
                          const WidgetSpan(child: SizedBox(width: Dimensions.paddingSizeSmall)),
            
                          WidgetSpan(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_)=> const AddProductTabView(fromHome: false,)));
                              },
                              child: Text(
                                getTranslated('add_new_product', context) ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).primaryColor,
                                  decorationColor: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    showCrossButton: true,
                    onPressed: () => shopInfo.setShowAddProductWarning(false),
                  ),
                ),
            
                const ShopCardWidget(),

                if(Provider.of<SplashController>(context, listen: false).configModel?.vendorVerifiedBadge == true)...[
                  const VerificationBannerWidget(),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                ],

                if(shopInfo.shopModel != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: _ShopStatusBannerWidget(shopModel: shopInfo.shopModel!),
                ),

            
                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    boxShadow: ThemeShadow.getShadow(context)
                  ), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(getTranslated('setup_store_mode', context) ?? '',
                      style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge)
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        // boxShadow: ThemeShadow.getShadow(context)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(getTranslated('store_availability', context) ?? '',
                            style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge)
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Text(getTranslated('turning_off_the_status_will', context) ?? '',
                            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color, fontSize: Dimensions.fontSizeDefault)
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          shopInfo.shopModel != null?
                          CustomButtonWidget(
                            borderRadius: Dimensions.radiusDefault,
                            btnTxt: getTranslated('availability', context),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AvailabilityScreen()));
                            }
                          ): const SizedBox(),
                        ],
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Builder(builder: (context) {
                      final bool canSetupVacation = AppModeAvailability.availableModes(context)
                          .any((mode) => shopInfo.shopModel?.isModuleAvailable(mode.value) ?? false);

                      return Opacity(
                      opacity: canSetupVacation ? 1.0 : 0.4,
                      child: IgnorePointer(
                        ignoring: !canSetupVacation,
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(getTranslated('go_vacation_mode', context) ?? '',
                                    style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge)
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  if(shopInfo.shopModel?.vacationStatus ?? false)
                                  Text(getTranslated('active', context) ?? '',
                                    style: robotoBold.copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer, fontSize: Dimensions.fontSizeSmall)
                                  ),
                                ],
                              ),



                              Text(getTranslated('if_you_turn_on_your_shop', context) ?? '',
                                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color, fontSize: Dimensions.fontSizeDefault)
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              CustomButtonWidget(
                                borderRadius: Dimensions.radiusDefault,
                                btnTxt: getTranslated('setup_vacation_mode', context),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VacationModeScreen()));
                                }
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    }),


                  ],
                  ),
                  ),
                ),
            

            
            
            
            
            
            
            
            
              ],
            ),
          ),
        );
      }
    );
  }
}





class ShopSettingWidget extends StatelessWidget {
  final String? title;
  final String? icon;
  final bool? mode;
  final Function(bool value)? onTap;
  final Function()? onPress;
  final bool dateSelection;
  final bool showBorder;
  final Color? borderColor;
  const ShopSettingWidget({super.key, this.title, this.icon, this.mode, this.onTap, this.dateSelection = false, this.onPress, this.showBorder = true, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopController>(
        builder: (context, shop,_) {
          return Container(
            padding: showBorder ? const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSize) : null,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: showBorder ? Border.all(color: borderColor ?? Theme.of(context).hintColor.withValues(alpha: 0.50), width: 1.5) : null,
            ),
            child: Row(children: [
              Expanded(child: Text(getTranslated(title, context)!, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color))),

              dateSelection ?
              InkWell(onTap: onPress ,
                child: Container(decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: .25),
                    borderRadius: BorderRadius.circular(50)),
                  child: Padding(padding: const EdgeInsets.all(8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text((shop.shopModel != null && shop.shopModel!.vacationStartDate != null) ? shop.shopModel!.vacationStartDate!:'${getTranslated('start_date', context)}', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                          child: Icon(Icons.arrow_forward_rounded,size: Dimensions.iconSizeDefault,
                              color:  Theme.of(context).primaryColor)),
                      Text((shop.shopModel != null && shop.shopModel!.vacationEndDate != null)? shop.shopModel!.vacationEndDate! : '${getTranslated("end_date", context)}', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                    ],
                    ),
                  ),
                ),
              ):
              FlutterSwitch(
                value: mode!,
                width: 40,
                height: 27,
                activeColor: Theme.of(context).primaryColor,
                toggleSize: 20,
                padding: 2,
                onToggle: onTap!
              )

            ],),
          );
        }
    );
  }
}


class _ShopStatusBannerWidget extends StatelessWidget {
  final ShopModel shopModel;
  const _ShopStatusBannerWidget({required this.shopModel});

  static const List<String> _modules = ['retail', 'wholesale', 'auction'];

  // Model inverts temporary_close, so true means the module is open
  bool _isOpen(String module) {
    switch (module) {
      case 'wholesale':
        return shopModel.wholesaleTemporaryClose ?? true;
      case 'auction':
        return shopModel.auctionTemporaryClose ?? true;
      default:
        return shopModel.temporaryClose ?? true;
    }
  }

  String _joinModules(List<String> modules, BuildContext context) {
    final List<String> names = modules.map((module) => getTranslated(module, context) ?? module).toList();
    if (names.length == 1) return names.first;
    return '${names.sublist(0, names.length - 1).join(', ')} & ${names.last}';
  }

  List<InlineSpan> _templateSpans(String? template, String modules, TextStyle? moduleStyle) {
    final List<String> parts = (template ?? '').split('{module}');
    final List<InlineSpan> spans = [];
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) spans.add(TextSpan(text: parts[i]));
      if (i < parts.length - 1) spans.add(TextSpan(text: modules, style: moduleStyle));
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> closedModules = _modules.where((module) => !_isOpen(module)).toList();
    final List<String> vacationModules = (shopModel.vacationStatus ?? false)
        ? _modules.where((module) => shopModel.vacationModules?.contains(module) ?? false).toList()
        : [];

    final bool isOnVacation = vacationModules.isNotEmpty;
    final bool hasClosedModules = closedModules.isNotEmpty;

    final DateTime? startDate = DateTime.tryParse(shopModel.vacationStartDate ?? '');
    final DateTime? endDate = DateTime.tryParse(shopModel.vacationEndDate ?? '');
    final bool showVacationDates = shopModel.vacationDurationType != 'until_change' && startDate != null && endDate != null;

    final TextStyle dateStyle = robotoMedium.copyWith(color: Theme.of(context).colorScheme.error);
    final bool isAlert = isOnVacation || hasClosedModules;

    return GuidelineWarningWidget(
      guidelineStatus: isAlert ? GuidelineStatus.error : GuidelineStatus.success,
      icon: isAlert ? Icon(Icons.info, color: Theme.of(context).colorScheme.error, size: Dimensions.iconSizeDefault) : null,

      content: RichText(
        text: TextSpan(
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            height: 1.5,
            color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
          ),
          children: <InlineSpan>[

            if(isOnVacation)
            TextSpan(children: showVacationDates ? [
              ..._templateSpans(getTranslated('modules_scheduled_vacation', context), _joinModules(vacationModules, context), null),
              TextSpan(text: DateConverter.localToIsoString(startDate), style: dateStyle),
              TextSpan(text: ' ${getTranslated('to', context)?.toLowerCase() ?? ''} ', style: dateStyle),
              TextSpan(text: DateConverter.localToIsoString(endDate), style: dateStyle),
              TextSpan(text: getTranslated('if_you_wish_to_reopen_modules', context) ?? ''),
            ] : _templateSpans(getTranslated('modules_on_vacation_until_change', context), _joinModules(vacationModules, context), null)),

            if(isOnVacation && hasClosedModules)
            const TextSpan(text: '\n\n'),

            if(hasClosedModules)
            TextSpan(children: _templateSpans(getTranslated('modules_are_offline', context), _joinModules(closedModules, context), null)),

            if(!isOnVacation && !hasClosedModules)
            TextSpan(
              text: getTranslated('your_shop_is_running_up_do_date', context) ?? '',
              style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer),
            ),
          ],
        ),
        textAlign: TextAlign.start,
      ),
      showCrossButton: false,
    );
  }
}
