import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/domain/models/wholesale_order_details_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order_edit/controllers/wholesale_order_edit_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order_edit/widgets/wholesale_edit_order_cart_item_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order_edit/widgets/wholesale_edit_order_search_suggestion.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleEditProductScreen extends StatefulWidget {
  final int orderId;
  final List<WholesaleOrderDetailsModel> products;
  const WholesaleEditProductScreen({super.key, required this.orderId, required this.products});

  @override
  State<WholesaleEditProductScreen> createState() => _WholesaleEditProductScreenState();
}

class _WholesaleEditProductScreenState extends State<WholesaleEditProductScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleOrderEditController>(context, listen: false).setProductToCart(widget.products);
  }

  @override
  void dispose() {
    Provider.of<WholesaleOrderEditController>(context, listen: false).emptySearchResult();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.maxFinite, 50),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Provider.of<ThemeController>(context, listen: false).darkTheme
                ? Theme.of(context).primaryColor.withValues(alpha: 0)
                : Theme.of(context).primaryColor.withValues(alpha: .10),
              offset: const Offset(0, 2.0), blurRadius: 4.0,
            ),
          ]),
          child: AppBar(
            surfaceTintColor: Theme.of(context).cardColor,
            centerTitle: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(getTranslated('edit_product', context) ?? 'Edit Product', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault), maxLines: 2),
                Text('${getTranslated('order', context) ?? 'Order'} #${widget.orderId}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: Dimensions.iconSizeDefault),
              color: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Consumer<WholesaleOrderEditController>(
        builder: (context, wholesaleOrderEditController, _) {
          return Column(children: [
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Expanded(
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const WholesaleEditOrderSearchSuggestion(),

                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Row(children: [
                      CustomAssetImageWidget(Images.infoIcon, height: 15, width: 15),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Text(getTranslated('after_editing_the_price_will_be_updated_to_the_latest', context) ?? '',
                          style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                      ),
                    ]),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Row(children: [
                      Text(getTranslated('products_list', context) ?? 'Products List',
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                        child: Text('${wholesaleOrderEditController.cartList.length}',
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
                      ),
                    ]),
                  ),

                  ListView.builder(
                    itemCount: wholesaleOrderEditController.cartList.length,
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => WholesaleEditOrderCartItemWidget(cartModel: wholesaleOrderEditController.cartList[index], index: index),
                  ),
                ]),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: ThemeShadow.getShadow(context)),
              child: SafeArea(
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(getTranslated('total_amount_text', context) ?? 'Total Amount',
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(getTranslated('vat_tax_others', context) ?? '(Vat/Tax & others)',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
                    ]),
                    Text(PriceConverter.convertPrice(context, wholesaleOrderEditController.orderAmount),
                      style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(children: [
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        onTap: () => Navigator.of(context).pop(),
                        child: CustomButtonWidget(
                          isColor: true,
                          btnTxt: getTranslated('cancel', context),
                          backgroundColor: Theme.of(context).cardColor,
                          fontColor: Theme.of(context).colorScheme.error,
                          borderColor: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: wholesaleOrderEditController.isLoading
                        ? const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()))
                        : CustomButtonWidget(
                            btnTxt: getTranslated('update_cart', context),
                            onTap: () async {
                              final bool success = await wholesaleOrderEditController.editOrderSubmit(context, widget.orderId);
                              if (success && context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                    ),
                  ]),
                ]),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
