import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/notification/domain/models/wholesale_notification_model.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleNotificationBottomSheetWidget extends StatelessWidget {
  final WholesaleNotificationItem item;

  const WholesaleNotificationBottomSheetWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: CustomAssetImageWidget(
                Images.wholesaleIcon,
                width: 36,
                height: 36,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(
              item.typeLabel,
              textAlign: TextAlign.center,
              style: titilliumBold.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),

          if (item.message != null && item.message!.isNotEmpty) ...[
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Text(
                item.message!,
                textAlign: TextAlign.center,
                style: titilliumRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ],

          if (item.wholesaleProductName != null) ...[
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: CustomImageWidget(
                      image: item.wholesaleProductThumbnailFullUrl ?? '',
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                    child: Text(
                      item.wholesaleProductName!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: titilliumRegular.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
      ),
    );
  }
}
