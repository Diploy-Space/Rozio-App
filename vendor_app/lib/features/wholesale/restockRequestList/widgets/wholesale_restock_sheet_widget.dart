import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/controllers/wholesale_restock_request_list_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/domain/models/wholesale_restock_product_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleRestockSheetWidget extends StatefulWidget {
  final String? title;
  final VoidCallback onYesPressed;
  final TextEditingController? stockQuantityController;
  final WholesaleRestockProduct? product;
  final List<String>? variantKeys;
  const WholesaleRestockSheetWidget({super.key, this.title, required this.onYesPressed, this.product, this.stockQuantityController, this.variantKeys});

  @override
  State<WholesaleRestockSheetWidget> createState() => _WholesaleRestockSheetWidgetState();
}

class _WholesaleRestockSheetWidgetState extends State<WholesaleRestockSheetWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleRestockRequestListController>(context, listen: false).setCurrentStock(widget.product!.currentStock.toString());
    Provider.of<WholesaleRestockRequestListController>(context, listen: false).initVariationController(widget.product!.variation ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              ),
              child: Consumer<WholesaleRestockRequestListController>(
                builder: (context, restockController, child) {
                  widget.stockQuantityController!.text = restockController.totalQuantityController.text;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          child: Container(
                            height: 3, width: 40,
                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)), color: Theme.of(context).hintColor),
                          ),
                        ),
                      ]),

                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            child: Icon(Icons.close, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeMedium),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: .10), width: 0.5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                child: CustomImageWidget(image: widget.product?.thumbnailFullUrl?.path ?? '', height: 84, width: 84),
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  widget.product?.name ?? '',
                                  maxLines: 2, overflow: TextOverflow.ellipsis,
                                  style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                Text(
                                  PriceConverter.convertPrice(context, widget.product?.unitPrice, discountType: widget.product?.discountType, discount: widget.product?.discount),
                                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                                ),
                              ]),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeMedium),

                          Text(getTranslated('main_stock', context)!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                          const SizedBox(height: Dimensions.paddingSizeMedium),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).hintColor.withValues(alpha: 0.25)),
                            child: Row(children: [
                              Text(widget.stockQuantityController!.text, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                            ]),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeMedium),

                          Text(getTranslated('variation', context)!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                          const SizedBox(height: Dimensions.paddingSizeMedium),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).hintColor.withValues(alpha: 0.25)),
                            child: Column(
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(getTranslated('variation', context)!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.headlineLarge?.color)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                                    child: Text(getTranslated('stock', context)!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.headlineLarge?.color)),
                                  ),
                                ]),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: widget.product?.variation?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(text: widget.product?.variation![index].type ?? '', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color)),
                                                  (widget.variantKeys != null && widget.product?.variation![index].type != null)
                                                      ? TextSpan(
                                                          text: widget.variantKeys!.contains(widget.product?.variation![index].type) ? ' *' : '',
                                                          style: robotoMedium.copyWith(color: Theme.of(context).colorScheme.error),
                                                        )
                                                      : const TextSpan(),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeSmall),
                                        Expanded(
                                          flex: 4,
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            CustomTextFieldWidget(
                                              variant: true,
                                              border: true,
                                              hintText: 'Ex: 345',
                                              controller: restockController.variationQuantityController[index],
                                              focusNode: restockController.variationQuantityFocusnode[index],
                                              nextNode: index != widget.product!.variation!.length - 1 ? restockController.variationQuantityFocusnode[index + 1] : null,
                                              textInputAction: index != widget.product!.variation!.length - 1 ? TextInputAction.next : TextInputAction.done,
                                              isAmount: false,
                                              amountIcon: false,
                                              textInputType: TextInputType.number,
                                              isFullNumber: true,
                                              onChanged: (String cng) {
                                                restockController.calculateVariationQuantity();
                                              },
                                            ),
                                          ]),
                                        ),
                                      ]),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeMedium),
                        ]),
                      ),

                      Container(
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
                          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            Expanded(
                              child: CustomButtonWidget(
                                backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.25),
                                fontColor: Theme.of(context).colorScheme.error,
                                borderRadius: Dimensions.radiusSmall,
                                btnTxt: getTranslated('cancel', context),
                                onTap: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            !restockController.isLoading
                                ? Expanded(
                                    child: CustomButtonWidget(
                                      borderRadius: Dimensions.radiusSmall,
                                      btnTxt: getTranslated('update', context),
                                      onTap: widget.onYesPressed,
                                    ),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                    child: Center(child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator())),
                                  ),
                          ]),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
