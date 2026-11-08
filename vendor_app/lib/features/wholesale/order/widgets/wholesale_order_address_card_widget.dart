import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/order/screens/edit_address_screen.dart';
import 'package:sixvalley_vendor_app/features/order/widgets/icon_with_text_row_widget.dart';
import 'package:sixvalley_vendor_app/features/order_details/controllers/order_details_controller.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/show_on_map_dialog_widget.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/controllers/wholesale_order_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleOrderAddressCardWidget extends StatelessWidget {
  final Order order;
  final bool onlyDigital;
  const WholesaleOrderAddressCardWidget({super.key, required this.order, required this.onlyDigital});

  bool _canEdit(BuildContext context) =>
      !(order.orderStatus == 'out_for_delivery' || order.orderStatus == 'delivered' || order.orderStatus == 'returned')
          && Provider.of<SplashController>(context, listen: false).configModel?.wholesaleConfig?.vendor?.canEditOrder == true;

  BillingAddressData? get _mapAddress {
    bool hasLocation(BillingAddressData? address) => address?.latitude != null && address?.longitude != null;
    if (hasLocation(order.shippingAddressData)) return order.shippingAddressData;
    if (hasLocation(order.billingAddressData)) return order.billingAddressData;
    return null;
  }

  void _openEditAddress(BuildContext context, {required bool isBilling, required BillingAddressData address}) {
    final WholesaleOrderController wholesaleOrderController = Provider.of<WholesaleOrderController>(context, listen: false);

    Navigator.push(context, MaterialPageRoute(builder: (_) => EditAddressScreen(
      isBilling: isBilling,
      orderId: order.id.toString(),
      address: address.address,
      city: address.city,
      zip: address.zip,
      name: address.contactPersonName,
      number: address.phone,
      email: address.email,
      lat: address.latitude ?? '0',
      lng: address.longitude ?? '0',
      onSubmit: ({required addressType, required contactPersonName, required phone, required city, required zip, required address, required email}) {
        return wholesaleOrderController.updateAddress(order, addressType: addressType, contactPersonName: contactPersonName,
          phone: phone, city: city, zip: zip, address: address, email: email);
      },
    )));
  }

  void _showOnMap(BuildContext context, BillingAddressData address) {
    Provider.of<OrderDetailsController>(context, listen: false).setMarker(address);
    showDialog(context: context, builder: (_) => ShowOnMapDialogWidget(billingAddressData: address));
  }

  @override
  Widget build(BuildContext context) {
    final BillingAddressData? shipping = onlyDigital ? null : order.shippingAddressData;
    final BillingAddressData? billing = order.billingAddressData;
    final BillingAddressData? mapAddress = _mapAddress;
    final bool isMapEnabled = Provider.of<SplashController>(context, listen: false).configModel?.mapApiStatus == 1;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 1.5, blurRadius: 3)],
        color: Theme.of(context).cardColor,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(getTranslated('address', context) ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),

            if (isMapEnabled && mapAddress != null)
              InkWell(
                onTap: () => _showOnMap(context, mapAddress),
                child: Row(children: [
                  Text(getTranslated('show_on_map', context) ?? '', style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Image.asset(Images.showOnMap, width: Dimensions.iconSizeDefault),
                ]),
              ),
          ]),
        ),
        SizedBox(
          height: 1,
          child: Divider(thickness: 0.2, height: 1, color: Theme.of(context).primaryColor.withValues(alpha: 0.50))
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeMedium),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (shipping != null) ...[
              _AddressTitle(
                title: getTranslated('shipping_address', context) ?? '',
                onEdit: _canEdit(context) ? () => _openEditAddress(context, isBilling: false, address: shipping) : null,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              _AddressBody(address: shipping),
            ],

            if (shipping != null && billing != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Divider(thickness: .25, color: Theme.of(context).primaryColor.withValues(alpha: 0.50)),
              ),

            if (billing != null) ...[
              _AddressTitle(
                title: getTranslated('billing_address', context) ?? '',
                onEdit: _canEdit(context) ? () => _openEditAddress(context, isBilling: true, address: billing) : null,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              if (shipping?.id != null && shipping?.id == billing.id)
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingEye, vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  ),
                  child: Text(getTranslated('same_as_shipping_address', context) ?? '', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall)),
                )
              else
                _AddressBody(address: billing),
            ],
          ]),
        ),
      ]),
    );
  }
}

class _AddressTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onEdit;
  const _AddressTitle({required this.title, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
      if (onEdit != null)
        InkWell(
          onTap: onEdit,
          child: SizedBox(width: 15, child: Image.asset(Images.edit, color: Theme.of(context).primaryColor)),
        ),
    ]);
  }
}

class _AddressBody extends StatelessWidget {
  final BillingAddressData address;
  const _AddressBody({required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: IconWithTextRowWidget(icon: Icons.person, text: address.contactPersonName ?? '', isBold: true)),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Expanded(child: IconWithTextRowWidget(icon: Icons.call, text: address.phone ?? '', isLtr: true)),
      ]),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Row(children: [
        Expanded(child: IconWithTextRowWidget(icon: Icons.home, text: address.addressType ?? '')),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Expanded(child: IconWithTextRowWidget(icon: Icons.flag, text: address.country ?? '')),
      ]),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Row(children: [
        Expanded(child: IconWithTextRowWidget(icon: Icons.location_city, text: address.city ?? '')),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Expanded(child: IconWithTextRowWidget(icon: Icons.keyboard, text: address.zip ?? '')),
      ]),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      IconWithTextRowWidget(icon: Icons.location_on, text: address.address ?? '', textColor: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.80)),
    ]);
  }
}
