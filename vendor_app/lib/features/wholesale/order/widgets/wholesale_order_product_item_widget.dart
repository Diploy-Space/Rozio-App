import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/domain/models/wholesale_order_details_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleOrderProductItemWidget extends StatelessWidget {
  final WholesaleOrderDetailsModel line;
  const WholesaleOrderProductItemWidget({super.key, required this.line});

  bool get _hasDiscount => (line.productDetails?.discount ?? 0) > 0 || line.productDetails?.clearanceSale != null;

  double get _unitPrice => line.wholesale?.unitPrice ?? line.price ?? line.productDetails?.unitPrice ?? 0;

  @override
  Widget build(BuildContext context) {
    final double lineTotal = line.wholesale?.totalPrice ?? (((line.price ?? 0) * (line.qty ?? 0)) - (line.discount ?? 0));

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          border: Border.all(width: .5, color: Theme.of(context).primaryColor.withValues(alpha: .125)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              child: CustomImageWidget(
                image: line.wholesale?.thumbnail ?? '${line.productDetails?.thumbnailFullUrl?.path}',
                height: Dimensions.imageSize, width: Dimensions.imageSize, fit: BoxFit.cover,
              ),
            ),

            if (_hasDiscount)
              Positioned(top: 10, left: 0, child: Container(height: 20,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.paddingSizeExtraSmall), bottomRight: Radius.circular(Dimensions.paddingSizeExtraSmall)),),

                child: Center(
                  child: Text(line.productDetails?.clearanceSale != null ?
                  PriceConverter.percentageCalculation(
                    context,
                    line.productDetails?.unitPrice,
                    line.productDetails?.clearanceSale?.discountAmount,
                    line.productDetails?.clearanceSale?.discountType,
                  ) :
                  PriceConverter.percentageCalculation(
                    context,
                    line.productDetails?.unitPrice,
                    line.productDetails?.discount,
                    line.productDetails?.discountType,
                  ), style: titilliumRegular.copyWith(
                    color: Theme.of(context).cardColor,
                    fontSize: Dimensions.fontSizeSmall,
                  )),
                ),
              )),
          ]),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(line.productDetails?.name ?? '',
                style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),

              Wrap(spacing: Dimensions.paddingSizeSmall, crossAxisAlignment: WrapCrossAlignment.center, children: [
                if ((line.productDetails?.discount ?? 0) > 0)
                  Text(PriceConverter.convertPrice(context, _unitPrice),
                    style: titilliumRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeSmall,
                        decoration: TextDecoration.lineThrough)),

                Text(PriceConverter.convertPrice(context, _unitPrice,
                    discount: line.productDetails?.discount,
                    discountType: line.productDetails?.discountType),
                  style: titilliumSemiBold.copyWith(color: Theme.of(context).primaryColor)),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              if ((line.variant ?? '').isNotEmpty) ...[
                Text(line.variant!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              ],

              Text('${getTranslated('quantity', context)}: ${line.qty ?? 0}',
                style: titilliumRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
            ]),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(PriceConverter.convertPrice(context, lineTotal),
            style: titilliumSemiBold.copyWith(color: Theme.of(context).primaryColor)),
        ]),
      ),
    );
  }
}
