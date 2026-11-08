import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleRefundProductCardWidget extends StatelessWidget {
  final Product product;
  final String? variant;
  final int? quantity;
  final double? unitPrice;
  const WholesaleRefundProductCardWidget({super.key, required this.product, this.variant, this.quantity, this.unitPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CustomAssetImageWidget(Images.productListIcon, height: Dimensions.iconSizeDefault, width: Dimensions.iconSizeDefault),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Text(getTranslated('product_list', context) ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
          ]),
          Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).hintColor.withValues(alpha: .3)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: CustomImageWidget(
                  image: '${product.thumbnailFullUrl?.path}',
                  width: Dimensions.productImageSizeItem,
                  height: Dimensions.productImageSizeItem,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                    if (variant != null && variant!.isNotEmpty) ...[
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Text(variant!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodySmall?.color)),
                    ],
                    if (unitPrice != null) ...[
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Text(
                        PriceConverter.convertPrice(context, unitPrice),
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          if (quantity != null) ...[
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
              child: Text('${getTranslated('qty', context) ?? 'Qty'}: $quantity', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
            ),
          ],
        ],
      ),
    );
  }
}
