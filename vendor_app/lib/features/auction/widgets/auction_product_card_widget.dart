import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/image_diaglog_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

void _showImagePreview(BuildContext context, List<String> urls, int startIndex) {
  showDialog(
    context: context,
    builder: (_) => ImageDialogWidget(imageUrl: urls[startIndex], imageUrls: urls),
  );
}

class AuctionProductCardWidget extends StatelessWidget {
  final String title;
  final double startingPrice;
  final double entryFee;
  final List<String> imageUrls;

  const AuctionProductCardWidget({
    super.key,
    required this.title,
    required this.startingPrice,
    required this.entryFee,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    final mainImage = imageUrls.isNotEmpty ? imageUrls[0] : null;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSize),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: mainImage != null ? () => _showImagePreview(context, imageUrls, 0) : null,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingEye),
                border: Border.all(color: Colors.black.withValues(alpha: 0.05), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.paddingEye),
                child: CustomImageWidget(image: mainImage ?? "", width: 120, height: 120, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSize),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                PriceRow(
                  label: getTranslated('starting_price', context) ?? "",
                  amount: startingPrice,
                  amountColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: Dimensions.paddingSizeVeryTiny),

                PriceRow(
                  label: getTranslated('entry_fee', context) ?? "",
                  amount: entryFee,
                  amountColor: Theme.of(context).textTheme.bodyLarge!.color!,
                ),
                const SizedBox(height: Dimensions.paddingEye),

                if(imageUrls.length > 1)
                  ThumbnailRow(
                    imageUrls: imageUrls.sublist(1),
                    onTap: (i) => _showImagePreview(context, imageUrls, i + 1),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ThumbnailRow extends StatelessWidget {
  final List<String> imageUrls;
  final void Function(int index)? onTap;

  const ThumbnailRow({super.key, required this.imageUrls, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.paddingSizeRevenueBottom,
      child: ListView.builder(
        itemCount: imageUrls.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: onTap != null ? () => onTap!(index) : null,
            child: Padding(
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
                    image: imageUrls[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final Color amountColor;

  const PriceRow({
    super.key,
    required this.label,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label  ',
          style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)

        ),
        Text('\$ ${amount.toStringAsFixed(2)}',
          style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w700, color: amountColor)
        ),
      ],
    );
  }
}