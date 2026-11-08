import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/features/refund/widgets/image_diaglog_widget.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class WholesaleRefundAttachmentListWidget extends StatelessWidget {
  final List<ImageFullUrl> images;
  const WholesaleRefundAttachmentListWidget({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.productImageSize,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
          child: InkWell(
            onTap: () => showDialog(context: context, builder: (_) => ImageDialogWidget(imageUrl: '${images[index].path}')),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: CustomImageWidget(image: '${images[index].path}', width: Dimensions.productImageSize, height: Dimensions.productImageSize, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
