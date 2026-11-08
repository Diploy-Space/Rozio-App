import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/chat/domain/models/chat_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleRefundCustomerInfoWidget extends StatelessWidget {
  final Customer? customer;
  const WholesaleRefundCustomerInfoWidget({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getTranslated('customer_information', context) ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          customer == null
            ? Text(getTranslated('customer_not_found', context) ?? '', style: robotoMedium.copyWith(color: Theme.of(context).colorScheme.error))
            : Row(children: [
                customer!.imageFullUrl?.path != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CustomImageWidget(image: customer!.imageFullUrl!.path!, width: 44, height: 44, fit: BoxFit.cover),
                    )
                  : CircleAvatar(radius: 22, backgroundColor: Theme.of(context).colorScheme.secondaryContainer, child: Icon(Icons.person, color: Theme.of(context).hintColor)),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${customer!.fName ?? ''} ${customer!.lName ?? ''}'.trim(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                      if ((customer!.phone ?? '').isNotEmpty)
                        Text(customer!.phone!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color)),
                      if ((customer!.email ?? '').isNotEmpty)
                        Text(customer!.email!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color)),
                    ],
                  ),
                ),
              ]),
        ],
      ),
    );
  }
}
