import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/domain/models/wholesale_top_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/screens/wholesale_product_details_screen.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'dart:ui' as ui;

class WholesaleTopProductCardWidget extends StatelessWidget {
  final WholesaleTopProductModel product;
  const WholesaleTopProductCardWidget({super.key, required this.product});

  String _priceText(BuildContext context, {bool withDiscount = true}) {
    final double? discount = withDiscount ? product.discount : null;
    final String minPrice = PriceConverter.convertPrice(context, product.minPrice, discount: discount, discountType: product.discountType);
    if (product.maxPrice == null || product.maxPrice == product.minPrice) return minPrice;
    return '$minPrice - ${PriceConverter.convertPrice(context, product.maxPrice, discount: discount, discountType: product.discountType)}';
  }

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = (product.discount ?? 0) > 0;

    return InkWell(
      onTap: product.id == null ? null : () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => WholesaleProductDetailsScreen(productId: product.id!))),
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: ThemeShadow.getShadow(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radiusDefault),
                      topRight: Radius.circular(Dimensions.radiusDefault),
                    ),
                    child: Container(
                      color: Theme.of(context).primaryColor.withValues(alpha: .06),
                      child: CustomImageWidget(image: product.thumbnail ?? '', fit: BoxFit.cover),
                    ),
                  ),
                ),

                if (hasDiscount)
                  _DiscountTagWidget(
                    percentage: PriceConverter.percentageCalculation(context, product.minPrice, product.discount, product.discountType),
                  ),

                Positioned(
                  left: 0, right: 0, bottom: 10,
                  child: Center(child: _ProductBadge(product: product)),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault -1, color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  if (hasDiscount)
                    Text(_priceText(context, withDiscount: false),
                      style: robotoRegular.copyWith(
                        color: Theme.of(context).hintColor,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Theme.of(context).hintColor,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),

                  Text(_priceText(context),
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault + 1, color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),

                  Text('${getTranslated('moq', context) ?? 'MOQ'} : ${product.moq ?? 0} ${getTranslated('pcs', context) ?? 'Pcs'}',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscountTagWidget extends StatelessWidget {
  final String percentage;
  const _DiscountTagWidget({required this.percentage});

  @override
  Widget build(BuildContext context) {
    final bool isLtr = Provider.of<LocalizationController>(context, listen: false).isLtr;

    return Positioned(
      top: 5, left: isLtr ? 0 : null, right: !isLtr ? 0 : null,
      child: Container(
        transform: Matrix4.translationValues(-1, 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 3),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(isLtr ? Dimensions.paddingSizeSmall : 0),
            topRight: Radius.circular(isLtr ? Dimensions.paddingSizeSmall : 0),
            bottomLeft: Radius.circular(!isLtr ? Dimensions.paddingSizeSmall : 0),
            topLeft: Radius.circular(!isLtr ? Dimensions.paddingSizeSmall : 0),
          )
        ),
        child: Center(
          child: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Text(percentage,
              style: robotoBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductBadge extends StatelessWidget {
  final WholesaleTopProductModel product;
  const _ProductBadge({required this.product});

  @override
  Widget build(BuildContext context) {
    if (product.rating != null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.star_rate_rounded, color: Colors.white, size: Dimensions.fontSizeLarge),
          Text(product.rating!.toStringAsFixed(1), style: robotoMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall)),
        ]),
      );
    }

    if (product.soldCount != null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        ),
        child: Text('${product.soldCount} ${getTranslated('sold', context)}',
          style: robotoMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
