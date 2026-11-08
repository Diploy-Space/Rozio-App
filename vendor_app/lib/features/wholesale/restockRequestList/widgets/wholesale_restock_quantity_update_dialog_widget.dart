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

class WholesaleRestockQuantityUpdateDialogWidget extends StatefulWidget {
  final VoidCallback onYesPressed;
  final TextEditingController? stockQuantityController;
  final WholesaleRestockProduct? product;
  const WholesaleRestockQuantityUpdateDialogWidget({super.key, required this.onYesPressed, this.product, this.stockQuantityController});

  @override
  State<WholesaleRestockQuantityUpdateDialogWidget> createState() => _WholesaleRestockQuantityUpdateDialogWidgetState();
}

class _WholesaleRestockQuantityUpdateDialogWidgetState extends State<WholesaleRestockQuantityUpdateDialogWidget> {
  @override
  void initState() {
    super.initState();
    widget.stockQuantityController!.text = widget.product?.currentStock.toString() ?? '0';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeVeryTiny),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),
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
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault), color: Theme.of(context).hintColor.withValues(alpha: 0.25)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(getTranslated('main_stock', context)!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        CustomTextFieldWidget(
                          border: true,
                          textInputType: TextInputType.number,
                          controller: widget.stockQuantityController,
                          textInputAction: TextInputAction.next,
                          isAmount: true,
                          hintText: 'Ex: 500',
                        ),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Consumer<WholesaleRestockRequestListController>(builder: (context, restockController, child) {
                      return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        SizedBox(
                          height: 30, width: 80,
                          child: CustomButtonWidget(
                            backgroundColor: restockController.isLoading ? Theme.of(context).hintColor.withValues(alpha: 0.25) : Theme.of(context).colorScheme.error.withValues(alpha: 0.25),
                            fontColor: Theme.of(context).colorScheme.error,
                            borderRadius: Dimensions.radiusSmall,
                            btnTxt: getTranslated('cancel', context),
                            onTap: () => restockController.isLoading ? null : Navigator.pop(context),
                          ),
                        ),
                        !restockController.isLoading
                            ? Padding(
                                padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                child: SizedBox(
                                  height: 30, width: 80,
                                  child: CustomButtonWidget(
                                    borderRadius: Dimensions.radiusSmall,
                                    btnTxt: getTranslated('update', context),
                                    onTap: widget.onYesPressed,
                                  ),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                child: Center(child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator())),
                              ),
                      ]);
                    }),
                  ]),
                ),
                Positioned(
                  top: 10, right: 10,
                  child: SizedBox(
                    height: 15, width: 15,
                    child: IconButton(padding: EdgeInsets.zero, onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 15)),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
