import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/image_diaglog_widget.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';

class WholesaleReviewAttachmentsWidget extends StatelessWidget {
  final List<String>? attachments;
  const WholesaleReviewAttachmentsWidget({super.key, required this.attachments});

  @override
  Widget build(BuildContext context) {
    final List<String> images = attachments?.where((url) => url.isNotEmpty).toList() ?? [];
    if (images.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
      child: SizedBox(
        height: 45,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (_) => ImageDialogWidget(imageUrl: images[index], imageUrls: images),
              ),
              child: Container(
                margin: const EdgeInsetsDirectional.only(end: Dimensions.paddingSizeSmall),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholderImage, height: 45, width: 45, fit: BoxFit.cover,
                    image: images[index],
                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, height: 45, width: 45, fit: BoxFit.cover),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}