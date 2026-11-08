import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_details_model.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleRefundDeliverymanInfoWidget extends StatelessWidget {
  final DeliverymanDetails deliveryman;
  const WholesaleRefundDeliverymanInfoWidget({super.key, required this.deliveryman});

  @override
  Widget build(BuildContext context) {
    final String? imageBaseUrl = Provider.of<SplashController>(context, listen: false).baseUrls?.deliveryManImageUrl;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getTranslated('deliveryman_contact_details', context) ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Row(children: [
            (imageBaseUrl != null && deliveryman.image != null)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CustomImageWidget(image: '$imageBaseUrl/${deliveryman.image}', width: 44, height: 44, fit: BoxFit.cover),
                )
              : CircleAvatar(radius: 22, backgroundColor: Theme.of(context).colorScheme.secondaryContainer, child: Icon(Icons.local_shipping_outlined, color: Theme.of(context).hintColor)),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${deliveryman.fName ?? ''} ${deliveryman.lName ?? ''}'.trim(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                  if ((deliveryman.phone ?? '').isNotEmpty)
                    Text(deliveryman.phone!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color)),
                  if ((deliveryman.email ?? '').isNotEmpty)
                    Text(deliveryman.email!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color)),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
