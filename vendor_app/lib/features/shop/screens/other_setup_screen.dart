import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/app_mode_availability.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/features/shop/controllers/shop_controller.dart';
import 'package:sixvalley_vendor_app/features/shop/screens/vacation_mode_setup_screen.dart';
import 'package:sixvalley_vendor_app/features/shop/widgets/shop_details_widget.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import '../../../main.dart';
import '../../product_details/widgets/product_details_widget.dart';

class OtherSetupScreen extends StatefulWidget {
  const OtherSetupScreen({super.key});

  @override
  State<OtherSetupScreen> createState() => _OtherSetupScreenState();
}

class _OtherSetupScreenState extends State<OtherSetupScreen> {
  SplashController splashController = Provider.of<SplashController>(Get.context!, listen: false);
  ProfileController profileController = Provider.of<ProfileController>(Get.context!, listen: false);
  ShopController shopController = Provider.of<ShopController>(Get.context!, listen: false);

  final TextEditingController _minimumOrderAmountController = TextEditingController();
  final TextEditingController _freeDeliveryOverAmountController = TextEditingController();
  final TextEditingController _wholesaleFreeDeliveryOverAmountController = TextEditingController();
  final TextEditingController _reOrderLevelController = TextEditingController();

  final TextEditingController _tinNumberController = TextEditingController();
  final TextEditingController _wholesaleTinNumberController = TextEditingController();
  final TextEditingController _auctionTinNumberController = TextEditingController();


  final FocusNode _minimumOrderAmountFocus = FocusNode();
  final FocusNode _freeDeliveryOverAmountFocus = FocusNode();
  final FocusNode _wholesaleFreeDeliveryOverAmountFocus = FocusNode();
  final FocusNode _reOrderLevelFocus = FocusNode();

  bool freeDeliveryOn = false;
  bool wholesaleFreeDeliveryOn = false;

  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  void setInitialData () {
    if(splashController.configModel?.minimumOrderAmountStatus == 1 && splashController.configModel?.minimumOrderAmountStatusBySeller ==1) {
      _minimumOrderAmountController.text = profileController.userInfoModel?.minimumOrderAmount?.toString() ?? '';
    }

    if(splashController.configModel?.freeDeliveryStatus == 1 && splashController.configModel?.freeDeliveryResponsibility == 'seller') {
      freeDeliveryOn =  profileController.userInfoModel?.freeOverDeliveryAmountStatus  == 1 ? true : false;
      _freeDeliveryOverAmountController.text = profileController.userInfoModel?.freeOverDeliveryAmount?.toString() ?? '';
    }

    wholesaleFreeDeliveryOn = profileController.userInfoModel?.wholesaleFreeOverDeliveryAmountStatus == 1 ? true : false;
    _wholesaleFreeDeliveryOverAmountController.text = profileController.userInfoModel?.wholesaleFreeOverDeliveryAmount?.toString() ?? '';

    if(shopController.shopModel?.taxIdentificationNumber != null) {
      _tinNumberController.text = shopController.shopModel?.taxIdentificationNumber ?? '';
    }

    if(shopController.shopModel?.tinExpireDate != null) {
      shopController.setExpireDate(DateTime.tryParse(shopController.shopModel?.tinExpireDate ?? ''));
    }

    if(shopController.shopModel?.wholesaleTaxIdentificationNumber != null) {
      _wholesaleTinNumberController.text = shopController.shopModel?.wholesaleTaxIdentificationNumber ?? '';
    }

    if(shopController.shopModel?.wholesaleTinExpireDate != null) {
      shopController.setWholesaleExpireDate(DateTime.tryParse(shopController.shopModel?.wholesaleTinExpireDate ?? ''));
    }

    if(shopController.shopModel?.auctionTaxIdentificationNumber != null) {
      _auctionTinNumberController.text = shopController.shopModel?.auctionTaxIdentificationNumber ?? '';
    }

    if(shopController.shopModel?.auctionTinExpireDate != null) {
      shopController.setAuctionExpireDate(DateTime.tryParse(shopController.shopModel?.auctionTinExpireDate ?? ''));
    }

    if(shopController.shopModel?.reorderLevel != null) {
      _reOrderLevelController.text = shopController.shopModel?.reorderLevel.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ShopController>(
        builder: (context, shopController, child) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getTranslated('order_setup', context) ?? '',
                                  style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge)
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Text(getTranslated('here_you_can_configure_the_settings', context) ?? '',
                                  style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color, fontSize: Dimensions.fontSizeDefault)
                              ),

                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              if(splashController.configModel?.minimumOrderAmountStatus == 1 && splashController.configModel?.minimumOrderAmountStatusBySeller ==1)...[
                                CustomTextFieldWidget(
                                  formProduct: true,
                                  border: true,
                                  isDescription: true,
                                  textInputType: TextInputType.number,
                                  focusNode: _minimumOrderAmountFocus,
                                  nextNode: _freeDeliveryOverAmountFocus,
                                  hintText: '${getTranslated('minimum_order_amount', context)} ${Provider.of<SplashController>(context, listen: false).myCurrency?.symbol}' ,
                                  controller: _minimumOrderAmountController,
                                  required: true,
                                  showIconDecorationColor: false,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                              ],

                              if(splashController.configModel?.freeDeliveryStatus == 1 && splashController.configModel?.freeDeliveryResponsibility == 'seller')...[
                                TitledBorder(
                                  borderWidth: 0.9,
                                  title: '${getTranslated('retail_free_delivery', context)}',
                                  content: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                    child: ShopSettingWidget(
                                      showBorder: false,
                                      title: 'statuss',
                                      mode: freeDeliveryOn,
                                      onTap: (value) {
                                        setState(() {
                                          freeDeliveryOn = value;
                                        });
                                      }
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                              ],

                              if(splashController.configModel?.freeDeliveryStatus == 1 && splashController.configModel?.freeDeliveryResponsibility == 'seller')...[
                                CustomTextFieldWidget(
                                  idDate: !freeDeliveryOn,
                                  formProduct: true,
                                  border: true,
                                  isDescription: true,
                                  textInputType: TextInputType.number,
                                  focusNode: _freeDeliveryOverAmountFocus,
                                  nextNode: _wholesaleFreeDeliveryOverAmountFocus,
                                  hintText: '${getTranslated('free_delivery_over_amount', context)}  (${Provider.of<SplashController>(context, listen: false).myCurrency?.symbol})',
                                  controller: _freeDeliveryOverAmountController,
                                  required: true,
                                  showIconDecorationColor: false,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                              ],

                              TitledBorder(
                                borderWidth: 0.9,
                                title: '${getTranslated('wholesale_free_delivery', context)}',
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                  child: ShopSettingWidget(
                                    showBorder: false,
                                    title: 'statuss',
                                    mode: wholesaleFreeDeliveryOn,
                                    onTap: (value) {
                                      setState(() {
                                        wholesaleFreeDeliveryOn = value;
                                      });
                                    }
                                  ),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),

                              CustomTextFieldWidget(
                                idDate: !wholesaleFreeDeliveryOn,
                                formProduct: true,
                                border: true,
                                isDescription: true,
                                textInputType: TextInputType.number,
                                focusNode: _wholesaleFreeDeliveryOverAmountFocus,
                                nextNode: _reOrderLevelFocus,
                                hintText: '${getTranslated('wholesale_free_delivery_over_amount', context)}  (${Provider.of<SplashController>(context, listen: false).myCurrency?.symbol})',
                                controller: _wholesaleFreeDeliveryOverAmountController,
                                required: true,
                                showIconDecorationColor: false,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),

                              CustomTextFieldWidget(
                                formProduct: true,
                                border: true,
                                isDescription: true,
                                textInputType: TextInputType.number,
                                focusNode: _reOrderLevelFocus,
                                hintText: getTranslated('re_order_level', context),
                                controller: _reOrderLevelController,
                                required: true,
                                showIconDecorationColor: false,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getTranslated('business_tin', context) ?? '',
                                  style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge)
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Text(getTranslated('here_you_can_configure_the_settings', context) ?? '',
                                  style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color, fontSize: Dimensions.fontSizeDefault)
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              CustomTextFieldWidget(
                                formProduct: true,
                                border: true,
                                isDescription: true,
                                textInputType: TextInputType.name,
                                hintText: '${getTranslated('taxpayer_identification_number', context)}' ,
                                controller: _tinNumberController,
                                showIconDecorationColor: false,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),

                              TitledBorder(
                                title: getTranslated('expire_date', context) ?? '',
                                isRequired: false,
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          shopController.tinExpireDate != null ?
                                          DateConverter.stringToLocalDateOnly(shopController.tinExpireDate.toString()) :
                                          getTranslated('select_date', context) ?? '',
                                          style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await shopController.pickTinExpireDate(context);
                                        },
                                        child: const CustomAssetImageWidget(Images.pickTinExpireDate, width: 20, height: 20),
                                      ),
                                    ],
                                  )
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),

                              Text(getTranslated('tin_certificate', context) ?? '',
                                  style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge)
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Text(getTranslated('tin_file_size', context) ?? '',
                                  style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color, fontSize: Dimensions.fontSizeDefault)
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                  dashPattern: const [4,5],
                                  color:  shopController.tinCertificateFile != null ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                                  radius: const Radius.circular(Dimensions.paddingEye),
                                ),
                                  child: Container(
                                      height: 110,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      ),
                                      child: Stack(
                                        children: [
                                          if( shopController.tinCertificateFile != null)
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: InkWell(
                                                onTap: () {
                                                  if(shopController.tinCertificateFile == null) {

                                                  } else {
                                                    shopController.removeTinCertificateFile();
                                                  }
                                                } ,
                                                child: shopController.isLoading ? const Center(child: SizedBox(height: 25, width: 25, child: SizedBox())) : Image.asset(width:25, Images.digitalPreviewDeleteIcon))
                                            ),

                                          if(shopController.tinCertificateFile == null && shopController.shopModel?.tinCertificateFullUrl != null && shopController.shopModel?.tinCertificateFullUrl?.path != '')
                                          Positioned(
                                            top: 10, right: 10,
                                            child: shopController.isDownloadLoading ?
                                            const SizedBox(height: 25, width: 25, child: CircularProgressIndicator()) :
                                            InkWell(
                                              onTap: () {
                                                shopController.previewDownload(url: shopController.shopModel?.tinCertificateFullUrl?.path ?? '',
                                                fileName: shopController.shopModel?.tinCertificateFullUrl?.key ?? '');
                                              },
                                              child: const CustomAssetImageWidget(Images.tinDownloadIcon, width: 25, height: 25)
                                            ),
                                          ),

                                          if(shopController.tinCertificateFile == null && shopController.shopModel?.tinCertificateFullUrl?.path != null && shopController.shopModel?.tinCertificateFullUrl?.path != '')
                                          Positioned(
                                            top: 0, right: 35,
                                            child: shopController.isDownloadLoading ?
                                            const SizedBox(height: 25, width: 25) :
                                            InkWell(
                                              onTap: () {
                                                showPreview(
                                                  shopController.shopModel?.tinCertificateFullUrl?.path ?? '', '',
                                                  shopController.shopModel?.tinCertificateFullUrl?.key ?? '', context
                                                );
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                child: Icon(Icons.remove_red_eye)
                                              )
                                            ),
                                          ),

                                          if(shopController.tinCertificateFile == null && shopController.shopModel?.tinCertificateFullUrl?.path != null && shopController.shopModel?.tinCertificateFullUrl?.path != '')
                                          Positioned(
                                            top: 0, right: 80,
                                            child: shopController.isDownloadLoading ?
                                            const SizedBox(height: 25, width: 25) :
                                            InkWell(
                                              onTap: () => shopController.pickTinCertificateFile(),
                                              child: const Padding(
                                                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                child: CustomAssetImageWidget(Images.infoEditIcon, width: 24, height: 24),
                                              ),
                                            ),
                                          ),

                                          Positioned.fill(
                                            child: Center(
                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  if(shopController.tinCertificateFile == null)
                                                    ...[
                                                      Column(
                                                        children: [
                                                          SizedBox(width: 45,
                                                            child: InkWell(
                                                              onTap: () => shopController.pickTinCertificateFile(),
                                                              child: const CustomAssetImageWidget(Images.tinCertificateUploadIcon, width: 45, height: 45))),
                                                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                                          Text(
                                                            (shopController.shopModel?.tinCertificateFullUrl != null && shopController.shopModel?.tinCertificateFullUrl?.path != '')   ?
                                                            shopController.shopModel?.tinCertificateFullUrl?.key  ?? ''
                                                            : getTranslated('upload_file', context)!,
                                                              style: robotoRegular.copyWith(fontWeight: FontWeight.w600, fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color))
                                                        ],
                                                      )
                                                    ],

                                                  if(shopController.tinCertificateFile != null)
                                                    ...[
                                                      Column(
                                                        children: [
                                                          SizedBox(width: 45,
                                                            child: InkWell(
                                                              onTap: () => shopController.pickTinCertificateFile(),
                                                              child: const CustomAssetImageWidget(Images.tinCertificateUploadIcon, width: 45, height: 45))),
                                                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                                          Text(shopController.tinCertificateFile?.name ?? '',
                                                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color), overflow: TextOverflow.ellipsis)
                                                        ],
                                                      )
                                                    ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                  )
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                            ],
                          ),
                        ),
                        if (AppModeAvailability.isWholesaleEnabled(context)) ...[
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getTranslated('wholesale_tin', context) ?? '',
                                    style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge)
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                Text(getTranslated('here_you_can_configure_the_settings', context) ?? '',
                                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color, fontSize: Dimensions.fontSizeDefault)
                                ),

                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                CustomTextFieldWidget(
                                  formProduct: true,
                                  border: true,
                                  isDescription: true,
                                  textInputType: TextInputType.name,
                                  hintText: '${getTranslated('taxpayer_identification_number', context)}' ,
                                  controller: _wholesaleTinNumberController,
                                  showIconDecorationColor: false,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),

                                TitledBorder(
                                  title: getTranslated('expire_date', context) ?? '',
                                  isRequired: false,
                                  content: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            shopController.wholesaleTinExpireDate != null ?
                                            DateConverter.stringToLocalDateOnly(shopController.wholesaleTinExpireDate.toString()) :
                                            getTranslated('select_date', context) ?? '',
                                            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await shopController.pickWholesaleTinExpireDate(context);
                                          },
                                          child: const CustomAssetImageWidget(Images.pickTinExpireDate, width: 20, height: 20),
                                        ),
                                      ],
                                    )
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),

                                Text(getTranslated('tin_certificate', context) ?? '',
                                    style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge)
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                Text(getTranslated('tin_file_size', context) ?? '',
                                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color, fontSize: Dimensions.fontSizeDefault)
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    dashPattern: const [4,5],
                                    color:  shopController.wholesaleTinCertificateFile != null ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                                    radius: const Radius.circular(Dimensions.paddingEye),
                                  ),
                                    child: Container(
                                        height: 110,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        ),
                                        child: Stack(
                                          children: [
                                            if( shopController.wholesaleTinCertificateFile != null)
                                              Positioned(
                                                top: 10,
                                                right: 10,
                                                child: InkWell(
                                                  onTap: () {
                                                    if(shopController.wholesaleTinCertificateFile == null) {

                                                    } else {
                                                      shopController.removeWholesaleTinCertificateFile();
                                                    }
                                                  } ,
                                                  child: shopController.isLoading ? const Center(child: SizedBox(height: 25, width: 25, child: SizedBox())) : Image.asset(width:25, Images.digitalPreviewDeleteIcon))
                                              ),

                                            if(shopController.wholesaleTinCertificateFile == null && shopController.shopModel?.wholesaleTinCertificateFullUrl != null && shopController.shopModel?.wholesaleTinCertificateFullUrl?.path != '')
                                            Positioned(
                                              top: 10, right: 10,
                                              child: shopController.isDownloadLoading ?
                                              const SizedBox(height: 25, width: 25, child: CircularProgressIndicator()) :
                                              InkWell(
                                                onTap: () {
                                                  shopController.previewDownload(url: shopController.shopModel?.wholesaleTinCertificateFullUrl?.path ?? '',
                                                  fileName: shopController.shopModel?.wholesaleTinCertificateFullUrl?.key ?? '');
                                                },
                                                child: const CustomAssetImageWidget(Images.tinDownloadIcon, width: 25, height: 25)
                                              ),
                                            ),

                                            if(shopController.wholesaleTinCertificateFile == null && shopController.shopModel?.wholesaleTinCertificateFullUrl?.path != null && shopController.shopModel?.wholesaleTinCertificateFullUrl?.path != '')
                                            Positioned(
                                              top: 0, right: 35,
                                              child: shopController.isDownloadLoading ?
                                              const SizedBox(height: 25, width: 25) :
                                              InkWell(
                                                onTap: () {
                                                  showPreview(
                                                    shopController.shopModel?.wholesaleTinCertificateFullUrl?.path ?? '', '',
                                                    shopController.shopModel?.wholesaleTinCertificateFullUrl?.key ?? '', context
                                                  );
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                  child: Icon(Icons.remove_red_eye)
                                                )
                                              ),
                                            ),

                                            if(shopController.wholesaleTinCertificateFile == null && shopController.shopModel?.wholesaleTinCertificateFullUrl?.path != null && shopController.shopModel?.wholesaleTinCertificateFullUrl?.path != '')
                                            Positioned(
                                              top: 0, right: 80,
                                              child: shopController.isDownloadLoading ?
                                              const SizedBox(height: 25, width: 25) :
                                              InkWell(
                                                onTap: () => shopController.pickWholesaleTinCertificateFile(),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                  child: CustomAssetImageWidget(Images.infoEditIcon, width: 24, height: 24),
                                                ),
                                              ),
                                            ),

                                            Positioned.fill(
                                              child: Center(
                                                child:Column(
                                                  mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    if(shopController.wholesaleTinCertificateFile == null)
                                                      ...[
                                                        Column(
                                                          children: [
                                                            SizedBox(width: 45,
                                                              child: InkWell(
                                                                onTap: () => shopController.pickWholesaleTinCertificateFile(),
                                                                child: const CustomAssetImageWidget(Images.tinCertificateUploadIcon, width: 45, height: 45))),
                                                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                                            Text(
                                                              (shopController.shopModel?.wholesaleTinCertificateFullUrl != null && shopController.shopModel?.wholesaleTinCertificateFullUrl?.path != '')   ?
                                                              shopController.shopModel?.wholesaleTinCertificateFullUrl?.key  ?? ''
                                                              : getTranslated('upload_file', context)!,
                                                                style: robotoRegular.copyWith(fontWeight: FontWeight.w600, fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color))
                                                          ],
                                                        )
                                                      ],

                                                    if(shopController.wholesaleTinCertificateFile != null)
                                                      ...[
                                                        Column(
                                                          children: [
                                                            SizedBox(width: 45,
                                                              child: InkWell(
                                                                onTap: () => shopController.pickWholesaleTinCertificateFile(),
                                                                child: const CustomAssetImageWidget(Images.tinCertificateUploadIcon, width: 45, height: 45))),
                                                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                                            Text(shopController.wholesaleTinCertificateFile?.name ?? '',
                                                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color), overflow: TextOverflow.ellipsis)
                                                          ],
                                                        )
                                                      ],
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    )
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                              ],
                            ),
                          ),
                        ],
                        if (AppModeAvailability.isAuctionEnabled(context)) ...[
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getTranslated('auction_tin', context) ?? '',
                                    style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge)
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                Text(getTranslated('here_you_can_configure_the_settings', context) ?? '',
                                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color, fontSize: Dimensions.fontSizeDefault)
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                CustomTextFieldWidget(
                                  formProduct: true,
                                  border: true,
                                  isDescription: true,
                                  textInputType: TextInputType.name,
                                  hintText: '${getTranslated('taxpayer_identification_number', context)}' ,
                                  controller: _auctionTinNumberController,
                                  showIconDecorationColor: false,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),

                                TitledBorder(
                                  title: getTranslated('expire_date', context) ?? '',
                                  isRequired: false,
                                  content: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            shopController.auctionTinExpireDate != null ?
                                            DateConverter.stringToLocalDateOnly(shopController.auctionTinExpireDate.toString()) :
                                            getTranslated('select_date', context) ?? '',
                                            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                                          ),
                                        ),

                                        InkWell(
                                          onTap: () async {
                                            await shopController.pickAuctionTinExpireDate(context);
                                          },
                                          child: const CustomAssetImageWidget(Images.pickTinExpireDate, width: 20, height: 20),
                                        ),
                                      ],
                                    )
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),

                                Text(getTranslated('tin_certificate', context) ?? '',
                                    style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge)
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                Text(getTranslated('tin_file_size', context) ?? '',
                                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color, fontSize: Dimensions.fontSizeDefault)
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    dashPattern: const [4,5],
                                    color:  shopController.auctionTinCertificateFile != null ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                                    radius: const Radius.circular(Dimensions.paddingEye),
                                  ),
                                    child: Container(
                                        height: 110,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        ),
                                        child: Stack(
                                          children: [
                                            if( shopController.auctionTinCertificateFile != null)
                                              Positioned(
                                                top: 10,
                                                right: 10,
                                                child: InkWell(
                                                  onTap: () {
                                                    if(shopController.auctionTinCertificateFile == null) {

                                                    } else {
                                                      shopController.removeAuctionTinCertificateFile();
                                                    }
                                                  } ,
                                                  child: shopController.isLoading ? const Center(child: SizedBox(height: 25, width: 25, child: SizedBox())) : Image.asset(width:25, Images.digitalPreviewDeleteIcon))
                                              ),

                                            if(shopController.auctionTinCertificateFile == null && shopController.shopModel?.auctionTinCertificateFullUrl != null && shopController.shopModel?.auctionTinCertificateFullUrl?.path != '')
                                            Positioned(
                                              top: 10, right: 10,
                                              child: shopController.isDownloadLoading ?
                                              const SizedBox(height: 25, width: 25, child: CircularProgressIndicator()) :
                                              InkWell(
                                                onTap: () {
                                                  shopController.previewDownload(url: shopController.shopModel?.auctionTinCertificateFullUrl?.path ?? '',
                                                  fileName: shopController.shopModel?.auctionTinCertificateFullUrl?.key ?? '');
                                                },
                                                child: const CustomAssetImageWidget(Images.tinDownloadIcon, width: 25, height: 25)
                                              ),
                                            ),

                                            if(shopController.auctionTinCertificateFile == null && shopController.shopModel?.auctionTinCertificateFullUrl?.path != null && shopController.shopModel?.auctionTinCertificateFullUrl?.path != '')
                                            Positioned(
                                              top: 0, right: 35,
                                              child: shopController.isDownloadLoading ?
                                              const SizedBox(height: 25, width: 25) :
                                              InkWell(
                                                onTap: () {
                                                  showPreview(
                                                    shopController.shopModel?.auctionTinCertificateFullUrl?.path ?? '', '',
                                                    shopController.shopModel?.auctionTinCertificateFullUrl?.key ?? '', context
                                                  );
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                  child: Icon(Icons.remove_red_eye)
                                                )
                                              ),
                                            ),

                                            if(shopController.auctionTinCertificateFile == null && shopController.shopModel?.auctionTinCertificateFullUrl?.path != null && shopController.shopModel?.auctionTinCertificateFullUrl?.path != '')
                                            Positioned(
                                              top: 0, right: 80,
                                              child: shopController.isDownloadLoading ?
                                              const SizedBox(height: 25, width: 25) :
                                              InkWell(
                                                onTap: () => shopController.pickAuctionTinCertificateFile(),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                  child: CustomAssetImageWidget(Images.infoEditIcon, width: 24, height: 24),
                                                ),
                                              ),
                                            ),

                                            Positioned.fill(
                                              child: Center(
                                                child:Column(
                                                  mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [

                                                    if(shopController.auctionTinCertificateFile == null)
                                                      ...[
                                                        Column(
                                                          children: [
                                                            SizedBox(width: 45,
                                                              child: InkWell(
                                                                onTap: () => shopController.pickAuctionTinCertificateFile(),
                                                                child: const CustomAssetImageWidget(Images.tinCertificateUploadIcon, width: 45, height: 45))),
                                                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                                            Text(
                                                              (shopController.shopModel?.auctionTinCertificateFullUrl != null && shopController.shopModel?.auctionTinCertificateFullUrl?.path != '')   ?
                                                              shopController.shopModel?.auctionTinCertificateFullUrl?.key  ?? ''
                                                              : getTranslated('upload_file', context)!,
                                                                style: robotoRegular.copyWith(fontWeight: FontWeight.w600, fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color))
                                                          ],
                                                        )
                                                      ],

                                                    if(shopController.auctionTinCertificateFile != null)
                                                      ...[
                                                        Column(
                                                          children: [
                                                            SizedBox(width: 45,
                                                              child: InkWell(
                                                                onTap: () => shopController.pickAuctionTinCertificateFile(),
                                                                child: const CustomAssetImageWidget(Images.tinCertificateUploadIcon, width: 45, height: 45))),
                                                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                                            Text(shopController.auctionTinCertificateFile?.name ?? '',
                                                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color), overflow: TextOverflow.ellipsis)
                                                          ],
                                                        )
                                                      ],

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    )
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              Container(height: 60,
                color: Theme.of(context).cardColor,
                child: Consumer<ShopController>(
                  builder: (context, shopProvider, _) {
                    return Padding(padding: const  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButtonWidget(
                              backgroundColor: Theme.of(context).hintColor.withValues(alpha: .1),
                              isColor: true,
                              fontColor: Theme.of(context).textTheme.bodyLarge?.color,
                              btnTxt: getTranslated('reset', context),
                              onTap: () {
                                setInitialData();
                                setState(() {});
                              }
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(
                            child: shopProvider.isLoading?
                            const Center(child: CircularProgressIndicator())
                              : CustomButtonWidget(
                              btnTxt: getTranslated('save', context),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if(freeDeliveryOn && _freeDeliveryOverAmountController.text.isEmpty) {
                                  showCustomSnackBarWidget(getTranslated('free_delivery_over_amount_is_empty', context), sanckBarType: SnackBarType.warning, context, isError: false);
                                } else if(wholesaleFreeDeliveryOn && _wholesaleFreeDeliveryOverAmountController.text.isEmpty) {
                                  showCustomSnackBarWidget(getTranslated('wholesale_free_delivery_over_amount_is_empty', context), sanckBarType: SnackBarType.warning, context, isError: false);
                                } else if(_reOrderLevelController.text.trim().isEmpty) {
                                  showCustomSnackBarWidget(getTranslated('reorder_level_is_empty', context), sanckBarType: SnackBarType.warning, context, isError: false);
                                } else {
                                  if(Provider.of<ShopController>(context, listen: false).shopModel?.setupGuideApp != null && Provider.of<ShopController>(context, listen: false).shopModel?.setupGuideApp?['order_setup'] != 1) {
                                    Provider.of<ShopController>(context, listen: false).updateTutorialFlow('order_setup');
                                    Provider.of<ShopController>(context, listen: false).updateSetupGuideApp('order_setup', 1);
                                  }
                                  shopProvider.updateShopInfo(
                                    freeDeliveryOverAmount: _freeDeliveryOverAmountController.text.trim(),
                                    freeDeliveryStatus: freeDeliveryOn? "1" : "0",
                                    wholesaleFreeDeliveryOverAmount: _wholesaleFreeDeliveryOverAmountController.text.trim(),
                                    wholesaleFreeDeliveryStatus: wholesaleFreeDeliveryOn? "1" : "0",
                                    minimumOrderAmount: _minimumOrderAmountController.text.trim(),
                                    taxIdentificationNumber: _tinNumberController.text,
                                    tinExpireDate: shopController.tinExpireDate.toString(),
                                    tinCertificate: shopController.tinCertificateFile,
                                    wholesaleTaxIdentificationNumber: _wholesaleTinNumberController.text,
                                    wholesaleTinExpireDate: shopController.wholesaleTinExpireDate.toString(),
                                    wholesaleTinCertificate: shopController.wholesaleTinCertificateFile,
                                    auctionTaxIdentificationNumber: _auctionTinNumberController.text,
                                    auctionTinExpireDate: shopController.auctionTinExpireDate.toString(),
                                    auctionTinCertificate: shopController.auctionTinCertificateFile,
                                    stockLimit: _reOrderLevelController.text
                                  );
                                }
                              }
                            ),
                          )
                        ],
                      ),
                    );
                  }
                )
              )
            ],
          );
        }
      ),


    );
  }
}
