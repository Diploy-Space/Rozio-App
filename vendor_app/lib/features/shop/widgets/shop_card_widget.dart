import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/app_mode_availability.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/features/shop/controllers/shop_controller.dart';
import 'package:sixvalley_vendor_app/features/shop/screens/shop_update_screen.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class ShopCardWidget extends StatelessWidget {
  const ShopCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final configModel = Provider.of<SplashController>(context, listen: false).configModel;
    final bool isAuctionActive = configModel?.isAuctionFeatureEnabled == true && configModel?.activeAuctionForVendor == true;

    final bool showVerifiedBadge = configModel?.vendorVerifiedBadge == true
        && Provider.of<ProfileController>(context).userInfoModel?.isVerified == true;

    return  Consumer<ShopController>(
      builder: (context, shopInfo, child) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
            child: Stack(children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        height: MediaQuery.of(context).size.width/3,
                        child:  ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeDefault), topRight: Radius.circular(Dimensions.paddingSizeDefault)),
                          child: CustomImageWidget(image: '${shopInfo.shopModel?.bannerFullUrl?.path}')
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left:  Dimensions.paddingSizeMedium,
                        right:  Dimensions.paddingSizeMedium,
                        bottom:  Dimensions.paddingSizeLarge,
                        top:  Dimensions.paddingSizeSmall,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(width: 75),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Flexible(child: Text(
                                        shopInfo.shopModel?.name ?? '',
                                        style: robotoBold.copyWith(
                                          color: Theme.of(context).textTheme.titleMedium?.color,
                                          fontSize: Dimensions.fontSizeLarge, height: 1.0,
                                          overflow: TextOverflow.ellipsis
                                        ),
                                        maxLines: 1,
                                      )),

                                      if(showVerifiedBadge)...[
                                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                        Icon(Icons.verified, color: Theme.of(context).colorScheme.onTertiaryContainer, size: Dimensions.iconSizeMedium),
                                      ],
                                    ]),
                                    if (DateTime.tryParse(shopInfo.shopModel?.createdAt ?? '') case final DateTime createdAt) ...[
                                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                      Text(
                                        '${getTranslated('created_at', context)} ${DateConverter.localToIsoString(createdAt)}',
                                        style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color, fontSize: Dimensions.fontSizeSmall, height: 1.0)
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              const SizedBox(width: Dimensions.paddingSizeSmall),
                              InkWell(
                                onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShopUpdateScreen())),
                                child: const CustomAssetImageWidget(Images.infoEditIcon, width: 24, height: 24),
                              )
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeMedium),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ShopTypeStatCard(
                                  title: getTranslated('retail', context) ?? '',
                                  isActive: shopInfo.shopModel?.temporaryClose ?? true,
                                  metrics: [
                                    ShopTypeMetric(
                                      label: getTranslated('products', context) ?? '',
                                      count: shopInfo.shopModel?.totalProducts.toString() ?? '0',
                                      image: Images.productsIcon,
                                      color: Theme.of(context).colorScheme.surfaceTint,
                                    ),
                                    ShopTypeMetric(
                                      label: getTranslated('orders', context) ?? '',
                                      count: shopInfo.shopModel?.totalOrder.toString() ?? '0',
                                      image: Images.orderIcon,
                                      color: ColorHelper.darken(Theme.of(context).colorScheme.onSecondary, 0.1),
                                    ),
                                    ShopTypeMetric(
                                      label: getTranslated('reviews', context) ?? '',
                                      count: shopInfo.shopModel?.totalReview.toString() ?? '0',
                                      image: Images.reviewsIcon,
                                      color: ColorHelper.darken(Theme.of(context).colorScheme.onTertiaryContainer, 0.1),
                                    ),
                                  ],
                                  taxIdentificationNumber: shopInfo.shopModel?.taxIdentificationNumber,
                                  tinExpireDate: shopInfo.shopModel?.tinExpireDate,
                                ),
                                if (AppModeAvailability.isWholesaleEnabled(context)) ...[
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  ShopTypeStatCard(
                                    title: getTranslated('wholesale', context) ?? '',
                                    isActive: shopInfo.shopModel?.wholesaleTemporaryClose ?? true,
                                    metrics: [
                                      ShopTypeMetric(
                                        label: getTranslated('products', context) ?? '',
                                        count: '${shopInfo.shopModel?.wholesaleTotals?.totalProducts ?? 0}',
                                        image: Images.productsIcon,
                                        color: Theme.of(context).colorScheme.surfaceTint,
                                      ),
                                      ShopTypeMetric(
                                        label: getTranslated('orders', context) ?? '',
                                        count: '${shopInfo.shopModel?.wholesaleTotals?.totalOrders ?? 0}',
                                        image: Images.orderIcon,
                                        color: ColorHelper.darken(Theme.of(context).colorScheme.onSecondary, 0.1),
                                      ),
                                      ShopTypeMetric(
                                        label: getTranslated('reviews', context) ?? '',
                                        count: '${shopInfo.shopModel?.wholesaleTotals?.totalReviews ?? 0}',
                                        image: Images.reviewsIcon,
                                        color: ColorHelper.darken(Theme.of(context).colorScheme.onTertiaryContainer, 0.1),
                                      ),
                                    ],
                                    taxIdentificationNumber: shopInfo.shopModel?.wholesaleTaxIdentificationNumber,
                                    tinExpireDate: shopInfo.shopModel?.wholesaleTinExpireDate,
                                  ),
                                ],
                                if (AppModeAvailability.isAuctionEnabled(context)) ...[
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  ShopTypeStatCard(
                                    title: getTranslated('auction', context) ?? '',
                                    isActive: isAuctionActive && (shopInfo.shopModel?.auctionTemporaryClose ?? true),
                                    metrics: [
                                      ShopTypeMetric(
                                        label: getTranslated('auction', context) ?? '',
                                        count: '${shopInfo.shopModel?.auctionTotals?.totalAuctionCreated ?? 0}',
                                        image: Images.auctionStoreCardIcon,
                                        color: Theme.of(context).colorScheme.surfaceTint,
                                      ),
                                      ShopTypeMetric(
                                        label: getTranslated('delivered', context) ?? '',
                                        count: '${shopInfo.shopModel?.auctionTotals?.totalDelivered ?? 0}',
                                        image: Images.orderIcon,
                                        color: ColorHelper.darken(Theme.of(context).colorScheme.onSecondary, 0.1),
                                      ),
                                    ],
                                    taxIdentificationNumber: shopInfo.shopModel?.auctionTaxIdentificationNumber,
                                    tinExpireDate: shopInfo.shopModel?.auctionTinExpireDate,
                                  ),
                                ],
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),

                Positioned(
                  top: 103,
                  left: 15,
                  child: Container(
                    height: 60,
                    width: 60,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
                    ),
                    child: CustomImageWidget(image: '${shopInfo.shopModel?.imageFullUrl?.path}', width: 60, height: 60, fit: BoxFit.cover),
                  )),

              ]),
          ),
        );
      }
    );
  }
}


class ShopTypeMetric {
  final String label;
  final String count;
  final String image;
  final Color? color;
  const ShopTypeMetric({required this.label, required this.count, required this.image, this.color});
}

class ShopTypeStatCard extends StatelessWidget {
  final String title;
  final bool isActive;
  final List<ShopTypeMetric> metrics;
  final String? taxIdentificationNumber;
  final String? tinExpireDate;
  final double width;

  const ShopTypeStatCard({super.key, required this.title, required this.isActive, required this.metrics, this.taxIdentificationNumber, this.tinExpireDate, this.width = 270});

  @override
  Widget build(BuildContext context) {
    final Color successColor = Theme.of(context).colorScheme.onTertiaryContainer;

    return Container(
      width: width,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge)
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 2),
                decoration: BoxDecoration(
                  color: (isActive ? successColor : Theme.of(context).colorScheme.error).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                ),
                child: Text(
                  getTranslated(isActive ? 'active' : 'inactive', context) ?? '',
                  style: robotoMedium.copyWith(color: isActive ? successColor : Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeSmall)
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeMedium),

          Row(
            children: metrics.map((metric) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CustomAssetImageWidget(metric.image, width: 16, height: 16),
                        const SizedBox(width: Dimensions.paddingSizeVeryTiny),
                        Flexible(
                          child: Text(
                            metric.label,
                            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: Dimensions.fontSizeSmall),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(
                      metric.count,
                      style: robotoBold.copyWith(color: metric.color, fontSize: Dimensions.fontSizeLarge, height: 1.0),
                    ),
                  ],
                ),
              ),
            )).toList(),
          ),

          if(taxIdentificationNumber != null && tinExpireDate != null) ...[
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Row(
                children: [
                  CustomAssetImageWidget(Images.tinIdIcon, width: 16, height: 16),
                  const SizedBox(width: Dimensions.paddingSizeVeryTiny),
                  Expanded(
                    child: Text(
                      '${getTranslated('tin', context)}: $taxIdentificationNumber',
                      style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    '${getTranslated('exp', context)}: ${DateConverter.dateToShortSlash(DateTime.parse(tinExpireDate!))}',
                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),
                  ),
                ],
              ),
            ),
          ],


        ],
      ),
    );
  }
}
