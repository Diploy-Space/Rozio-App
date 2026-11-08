import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class WholesaleOrderBuyerContactCardWidget extends StatelessWidget {
  final Order order;
  const WholesaleOrderBuyerContactCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final bool isGuest = order.isGuest ?? false;
    final BillingAddressData? address = order.shippingAddressData ?? order.billingAddressData;

    final String name = isGuest
      ? (address?.contactPersonName ?? '')
      : '${order.customer?.fName ?? ''} ${order.customer?.lName ?? ''}'.trim();
    final String phone = (isGuest ? address?.phone : order.customer?.phone) ?? '';
    final String email = (isGuest ? address?.email : order.customer?.email) ?? '';
    final String location = [address?.city, address?.country].where((value) => (value ?? '').trim().isNotEmpty).join(', ');
    final String? imagePath = order.customer?.imageFullPath?.path;
    final bool hasContact = order.customerId != 0;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 1.5, blurRadius: 3)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          child: Text(
            isGuest ? '${getTranslated('customer_info', context)} (${getTranslated('guest_customer', context)})' : getTranslated('customer_info', context) ?? '',
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ),
        Divider(thickness: 0.2, height: 1, color: Theme.of(context).hintColor.withValues(alpha: .65)),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CustomImageWidget(image: imagePath, height: 50, width: 50, fit: BoxFit.cover),
                  )
                : CircleAvatar(radius: 25, backgroundColor: Theme.of(context).primaryColor.withValues(alpha: .1),
                    child: Icon(Icons.storefront_outlined, color: Theme.of(context).primaryColor)),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                      style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault),
                      maxLines: 1, overflow: TextOverflow.ellipsis),

                    if (location.isNotEmpty) ...[
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Text(location,
                        style: titilliumRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ],
                ),
              ),

              if (hasContact && email.isNotEmpty) ...[
                const SizedBox(width: Dimensions.paddingSizeLarge),
                InkWell(onTap: () => _sendEmail(email), child: CustomAssetImageWidget(Images.email, height: 30, width: 30)),
              ],

              if (hasContact && phone.isNotEmpty) ...[
                const SizedBox(width: Dimensions.paddingSizeLarge),
                InkWell(onTap: () => _callPhone(phone), child: CustomAssetImageWidget(Images.customerCallIcon, height: 30, width: 30)),
              ],
            ],
          ),
        ),
      ]),
    );
  }

  Future<void> _sendEmail(String email) async {
    final Uri url = Uri(scheme: 'mailto', path: email, query: Uri.encodeFull('subject=Support&body='));
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _callPhone(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
