import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/auction_product_details_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_details_section_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class WholesaleProductVideoWidget extends StatelessWidget {
  final String? videoUrl;
  final String? videoFileUrl;
  const WholesaleProductVideoWidget({super.key, this.videoUrl, this.videoFileUrl});

  @override
  Widget build(BuildContext context) {
    if (videoFileUrl?.isNotEmpty ?? false) {
      return WholesaleProductDetailsSectionWidget(
        title: getTranslated('product_video', context) ?? 'Product Video',
        child: AuctionCustomVideoPlayerWidget(key: ValueKey(videoFileUrl), url: videoFileUrl!),
      );
    }

    if (videoUrl == null || videoUrl!.isEmpty) return const SizedBox();

    return WholesaleProductDetailsSectionWidget(
      title: getTranslated('product_video', context) ?? 'Product Video',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated('youtube_video_link', context) ?? 'Youtube Video Link',
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          InkWell(
            onTap: () async {
              final Uri uri = Uri.parse(videoUrl!);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: Text(
              videoUrl!,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).primaryColor,
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
