import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/controllers/wholesale_product_review_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/domain/models/wholesale_product_review_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/screens/wholesale_product_review_reply_screen.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductReviewCardWidget extends StatelessWidget {
  final WholesaleProductReviewModel review;

  const WholesaleProductReviewCardWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final DateTime? createdAt = DateTime.tryParse(review.createdAt ?? '');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [
            BoxShadow(color: Colors.grey[Provider.of<ThemeController>(context).darkTheme ? 800 : 200]!, spreadRadius: 1, blurRadius: 1),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).hintColor.withValues(alpha: 0.05),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${getTranslated('review_id', context)} #${review.id}',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        if (createdAt != null)
                          Text(
                            DateConverter.localDateToIsoStringAMPM(createdAt),
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                          ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      Icon(Icons.star_outlined, color: Colors.orange, size: Dimensions.iconSizeDefault),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                        (review.rating ?? 0).toStringAsFixed(1),
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      FlutterSwitch(
                        width: 40.0, height: 20.0, toggleSize: 18.0, padding: 2.0,
                        value: review.status == 1,
                        activeColor: Theme.of(context).primaryColor,
                        disabled: Provider.of<WholesaleProductReviewController>(context).isStatusUpdating(review.id),
                        onToggle: (_) => Provider.of<WholesaleProductReviewController>(context, listen: false).toggleReviewStatus(review),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: CustomImageWidget(image: review.productThumbnail ?? ''),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.productName ?? '',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (review.productType != null) ...[
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Text(
                          getTranslated(review.productType, context) ?? review.productType!,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                if (review.customerName != null && review.customerName!.isNotEmpty)
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                        ),
                        child: ClipOval(child: CustomImageWidget(image: review.customerImage ?? '')),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 80),
                        child: Text(
                          review.customerName!,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            if (Provider.of<SplashController>(context, listen: false).configModel?.reviewReplyStatus == true) ...[
              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomButtonWidget(
                borderRadius: Dimensions.radiusDefault,
                backgroundColor: Theme.of(context).primaryColor,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WholesaleProductReviewReplyScreen(review: review))),
                btnTxt: review.reply != null ? getTranslated('update_reply', context) : getTranslated('reply', context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
