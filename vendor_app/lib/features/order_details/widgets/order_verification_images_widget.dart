import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/image_diaglog_widget.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/models/order_details_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class OrderVerificationImagesWidget extends StatelessWidget {
  final List<VerificationImages> verificationImages;
  const OrderVerificationImagesWidget({super.key, required this.verificationImages});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,  Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall),
        child: Text('${getTranslated('completed_service_picture', context)}',
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),)
      ),

      SizedBox(height: 120,
        child: ListView.builder(
          itemCount: verificationImages.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){

            return InkWell(onTap: () => showDialog(context: context, builder: (_)=> ImageDialogWidget(imageUrl: '${verificationImages[index].imageFullUrl?.path}')),
              child: Padding(padding:  EdgeInsets.only(left: Dimensions.paddingSizeSmall,
                  right: verificationImages.length == index+1? Dimensions.paddingSizeSmall : 0),
                child: SizedBox(width: 200,
                  child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    child: Container(decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.25), width: .25),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                      child: CustomImageWidget(image: '${verificationImages[index].imageFullUrl?.path}')
                    ),
                  ),
                ),
              ),
            );
          }),
      ),
    ],
    );
  }
}
