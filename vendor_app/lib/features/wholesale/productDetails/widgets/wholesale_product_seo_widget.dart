import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_product_detail_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_details_section_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductSeoWidget extends StatelessWidget {
  final WholesaleSeo? seo;
  const WholesaleProductSeoWidget({super.key, this.seo});

  @override
  Widget build(BuildContext context) {
    final bool hasTitle = seo?.title?.isNotEmpty ?? false;
    final bool hasDescription = seo?.description?.isNotEmpty ?? false;
    final bool hasImage = seo?.imageFullUrl?.path?.isNotEmpty ?? false;
    if (!hasTitle && !hasDescription && !hasImage) return const SizedBox();

    return WholesaleProductDetailsSectionWidget(
      title: getTranslated('product_seo_and_meta_data', context) ?? 'Product SEO & Meta data',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasTitle)
            Text(
              seo!.title!,
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          if (hasDescription) ...[
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
              seo!.description!,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
          if (hasImage) ...[
            const SizedBox(height: Dimensions.paddingSizeMedium),
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: CustomImageWidget(
                image: seo!.imageFullUrl!.path!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
