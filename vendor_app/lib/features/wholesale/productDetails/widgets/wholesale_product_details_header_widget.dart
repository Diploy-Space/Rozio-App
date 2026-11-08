import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/image_diaglog_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_product_detail_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductDetailsHeaderWidget extends StatelessWidget {
  final WholesaleProductDetailModel product;
  const WholesaleProductDetailsHeaderWidget({super.key, required this.product});

  ({double? min, double? max}) get _priceRange {
    final List<double> prices = [...?product.wholesaleDetail?.allUnitPrices];
    if (prices.isEmpty) {
      return (min: product.unitPrice, max: product.unitPrice);
    }
    prices.sort();
    return (min: prices.first, max: prices.last);
  }

  @override
  Widget build(BuildContext context) {
    final List<ImageFullUrl> gallery = product.imagesFullUrl;
    final ({double? min, double? max}) range = _priceRange;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
      color: Theme.of(context).cardColor,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Stack(children: [
        PositionedDirectional(
          start: 0, top: 0, bottom: 0, width: 120,
          child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingEye),
            border: Border.all(color: Colors.black.withValues(alpha: 0.05), width: 1),
          ),
          child: InkWell(
            onTap: () => showDialog(context: context, builder: (_) => ImageDialogWidget(imageUrl: product.thumbnailFullUrl?.path ?? '')),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.paddingEye),
              child: CustomImageWidget(image: product.thumbnailFullUrl?.path ?? '', width: 120, height: double.infinity),
            ),
          ),
        )),

        Padding(
          padding: const EdgeInsetsDirectional.only(start: 120 + Dimensions.paddingSizeSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(
                children: [
                  Text('${getTranslated('price', context) ?? 'Price'} ',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  Flexible(
                    child: Text(range.min == range.max
                          ? PriceConverter.convertPrice(context, range.min)
                          : '${PriceConverter.convertPrice(context, range.min)} - ${PriceConverter.convertPrice(context, range.max)}',
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              _RequestStatusBadge(requestStatus: product.requestStatus),
              const SizedBox(height: Dimensions.paddingEye),

              if (gallery.isNotEmpty)
                SizedBox(
                  height: Dimensions.paddingSizeRevenueBottom,
                  child: ListView.builder(
                    itemCount: gallery.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _showImagePreview(context, gallery, index),
                        child: _GalleryImageWidget(image: gallery[index].path),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ]),

      if ((product.deniedNote?.isNotEmpty ?? false) && product.requestStatus == 2) ...[
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeSmall, vertical: Dimensions.paddingEye),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.125),
            borderRadius: BorderRadius.circular(Dimensions.paddingEye),
          ),
          child: Text.rich(TextSpan(children: [
            TextSpan(text: '${getTranslated('denied_note', context) ?? 'Denied Note'} : ', style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).colorScheme.error,
            )),

            TextSpan(text: product.deniedNote ?? '', style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            )),
          ])),
        ),
      ],
      ]),
    );
  }

  void _showImagePreview(BuildContext context, List<ImageFullUrl> gallery, int index) {
    final List<String> imageUrls = gallery.map((image) => image.path ?? '').toList();

    showDialog(
      context: context,
      builder: (_) => ImageDialogWidget(imageUrl: imageUrls[index], imageUrls: imageUrls),
    );
  }
}

class _GalleryImageWidget extends StatelessWidget {
  final String? image;
  const _GalleryImageWidget({this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingEye),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05), width: 1),
        ),
        width: Dimensions.paddingSizeRevenueBottom,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          child: CustomImageWidget(
            image: image ?? '',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _RequestStatusBadge extends StatelessWidget {
  final int? requestStatus;
  const _RequestStatusBadge({this.requestStatus});

  @override
  Widget build(BuildContext context) {
    late final String key;
    late final Color color;

    switch (requestStatus) {
      case 1:
        key = 'approved';
        color = Theme.of(context).colorScheme.onTertiaryContainer;
        break;
      case 2:
        key = 'denied';
        color = Theme.of(context).colorScheme.error;
        break;
      default:
        key = 'pending';
        color = Theme.of(context).colorScheme.outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeSmall,
        vertical: Dimensions.paddingSizeOrder,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Text(
        getTranslated(key, context) ?? key,
        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: color),
      ),
    );
  }
}
