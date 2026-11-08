import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/domain/models/wholesale_product_rating_summary_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/controllers/wholesale_product_review_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/domain/models/wholesale_product_review_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/screens/wholesale_product_review_reply_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/widgets/wholesale_review_attachments_widget.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductReviewTabWidget extends StatelessWidget {
  final WholesaleProductRatingSummaryModel? summary;
  final List<WholesaleProductReviewModel> reviews;
  const WholesaleProductReviewTabWidget({super.key, this.summary, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (summary != null) ...[
            _SummaryCard(summary: summary!),
            const SizedBox(height: Dimensions.paddingSizeDefault),
          ],

          if (reviews.isEmpty)
            const NoDataScreen(title: 'no_reviews_found')
          else ...[
            Text(
              getTranslated('review_list', context) ?? 'Review List',
              style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            for (final WholesaleProductReviewModel review in reviews) _ReviewCard(review: review),
          ],
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final WholesaleProductRatingSummaryModel summary;
  const _SummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeMedium,
              vertical: Dimensions.paddingSizeDefault,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  summary.average.toStringAsFixed(1),
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeOverlarge,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      size: Dimensions.fontSizeDefault,
                      color: index < summary.average.round()
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).hintColor.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text(
                  '${summary.totalReviews} ${getTranslated('reviews', context) ?? 'Reviews'}',
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeMedium),

          Expanded(
            child: Column(
              children: [
                _RatingBar(label: getTranslated('excellent', context) ?? 'Excellent', percent: summary.excellent),
                _RatingBar(label: getTranslated('good', context) ?? 'Good', percent: summary.good),
                _RatingBar(label: getTranslated('average', context) ?? 'Average', percent: summary.avg),
                _RatingBar(label: getTranslated('below_average', context) ?? 'Below Average', percent: summary.belowAverage),
                _RatingBar(label: getTranslated('poor', context) ?? 'Poor', percent: summary.poor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final String label;
  final double percent;
  const _RatingBar({required this.label, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeVeryTiny),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: LinearProgressIndicator(
                value: (percent / 100).clamp(0, 1),
                minHeight: 5,
                backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            flex: 2,
            child: Text(
              '${percent.toInt()}%',
              textAlign: TextAlign.end,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final WholesaleProductReviewModel review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: ThemeShadow.getShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: CustomImageWidget(image: review.customerImage ?? '', width: 52, height: 52, fit: BoxFit.cover),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(review.customerName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Text(
                          '${getTranslated('order', context) ?? 'Order'} #${review.orderId ?? ''}',
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        _ReviewActionMenu(review: review),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: Dimensions.iconSizeMedium, color: Theme.of(context).colorScheme.tertiary),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Text('${review.rating ?? 0}',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          child: Text(
                            DateTime.tryParse(review.createdAt ?? '') != null
                                ? DateConverter.formatTimeDateShort(DateTime.parse(review.createdAt!).toLocal()) : review.createdAt ?? '',
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(review.comment ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              height: 1.5,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
            ),
          ),
          WholesaleReviewAttachmentsWidget(attachments: review.attachments),
        ],
      ),
    );
  }
}

class _ReviewActionMenu extends StatelessWidget {
  final WholesaleProductReviewModel review;
  const _ReviewActionMenu({required this.review});

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = robotoRegular.copyWith(
      fontSize: Dimensions.fontSizeDefault,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Icon(Icons.more_vert, size: Dimensions.iconSizeMedium, color: Theme.of(context).textTheme.bodyLarge?.color),
      onSelected: (value) {
        if (value == 'reply') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => WholesaleProductReviewReplyScreen(review: review)));
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Consumer<WholesaleProductReviewController>(
            builder: (context, reviewController, _) => Row(children: [
              Expanded(child: Text(getTranslated('statuss', context) ?? 'Status', style: labelStyle)),
              const SizedBox(width: Dimensions.paddingSizeDefault),
              FlutterSwitch(
                width: 50.0, height: 26.0, toggleSize: 22.0, padding: 2.0,
                value: review.status == 1,
                activeColor: Theme.of(context).primaryColor,
                disabled: reviewController.isStatusUpdating(review.id),
                onToggle: (_) => reviewController.toggleReviewStatus(review),
              ),
            ]),
          ),
        ),
        if (Provider.of<SplashController>(context, listen: false).configModel?.reviewReplyStatus == true)
          PopupMenuItem<String>(
            value: 'reply',
            child: Row(children: [
              const CustomAssetImageWidget(Images.reviewReplyIcon, height: Dimensions.iconSizeMedium, width: Dimensions.iconSizeMedium),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text(getTranslated(review.reply != null ? 'view_reply' : 'review_reply', context) ?? 'Review Reply', style: labelStyle),
            ]),
          ),
      ],
    );
  }
}
