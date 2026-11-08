import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order_edit/controllers/wholesale_order_edit_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order_edit/domain/models/wholesale_order_edit_cart_model.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleEditOrderCartItemWidget extends StatelessWidget {
  final WholesaleOrderEditCartModel cartModel;
  final int index;
  const WholesaleEditOrderCartItemWidget({super.key, required this.cartModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Consumer<WholesaleOrderEditController>(
        builder: (context, wholesaleOrderEditController, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
            child: Container(
              decoration: BoxDecoration(
                color: cartModel.isOrderProduct ? Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.6) : Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2)),
                ],
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50, width: 50,
                    decoration: BoxDecoration(border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.1))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImageWidget(image: cartModel.thumbnail ?? '', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(cartModel.name ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(PriceConverter.convertPrice(context, cartModel.unitPrice),
                              style: robotoBold.copyWith(color: ColorHelper.blendColors(Colors.white, Theme.of(context).textTheme.bodyLarge!.color!, 0.7))),

                            Row(children: [
                              InkWell(
                                onTap: () {
                                  if (cartModel.quantity <= 1) {
                                    showCustomSnackBarWidget(getTranslated('minimum_order_quantity_is', context) ?? '', context, sanckBarType: SnackBarType.error);
                                    return;
                                  }
                                  wholesaleOrderEditController.setQuantity(index, cartModel.quantity - 1);
                                },
                                child: Container(
                                  width: 28, height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: cartModel.quantity > 1 ? Theme.of(context).hintColor.withValues(alpha: 0.1) : Theme.of(context).hintColor.withValues(alpha: 0.5),
                                    border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                                  ),
                                  child: Icon(Icons.remove, size: 16, color: Theme.of(context).textTheme.bodyLarge?.color),
                                ),
                              ),

                              SizedBox(width: 30, child: Center(
                                child: Text('${cartModel.quantity}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
                              )),

                              InkWell(
                                onTap: () => wholesaleOrderEditController.setQuantity(index, cartModel.quantity + 1),
                                child: Container(
                                  width: 28, height: 28,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      Positioned(
        top: 0, right: 2,
        child: Consumer<WholesaleOrderEditController>(
          builder: (context, wholesaleOrderEditController, _) {
            return InkWell(
              onTap: () {
                if (wholesaleOrderEditController.cartList.length == 1) {
                  showCustomSnackBarWidget(getTranslated('cannot_delete_all_product', context) ?? '', context, sanckBarType: SnackBarType.error);
                } else {
                  wholesaleOrderEditController.removeFromCart(index);
                }
              },
              child: Container(
                height: 25, width: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorHelper.blendColors(Theme.of(context).cardColor, Theme.of(context).colorScheme.error, 0.1),
                  border: Border.all(color: Theme.of(context).cardColor, width: 2),
                ),
                child: Icon(Icons.close, size: 17, color: Theme.of(context).colorScheme.error),
              ),
            );
          },
        ),
      ),
    ]);
  }
}
