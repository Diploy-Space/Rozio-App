import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/domain/models/wholesale_limited_stock_product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleLimitedStockProductCardWidget extends StatelessWidget {
  final WholesaleLimitedStockProductModel product;
  final VoidCallback onUpdateTap;
  final bool isLoading;
  const WholesaleLimitedStockProductCardWidget({super.key, required this.product, required this.onUpdateTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final bool isStockOut = product.currentStock == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: ThemeShadow.getShadow(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: Dimensions.productImageSizeItem,
            width: Dimensions.productImageSizeItem,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: CustomImageWidget(image: product.thumbnail ?? '', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? '',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeVeryTiny),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    color: isStockOut ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSecondary,
                  ),
                  child: Text(
                    '${product.currentStock} ${getTranslated(isStockOut ? 'stock_out' : 'in_stock', context)}',
                    style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                  ),
                ),

                if (product.variation.isNotEmpty) ...[
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Text(
                    '${product.variation.length} ${getTranslated('variation', context)}',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                  ),
                ],
              ],
            ),
          ),

          InkWell(
            onTap: isLoading ? null : onUpdateTap,
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(20),
              ),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
