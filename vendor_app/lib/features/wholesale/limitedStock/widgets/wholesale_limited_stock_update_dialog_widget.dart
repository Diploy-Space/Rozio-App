import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/controllers/wholesale_limited_stock_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/domain/models/wholesale_limited_stock_product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleLimitedStockUpdateDialogWidget extends StatefulWidget {
  final WholesaleLimitedStockProductModel product;
  const WholesaleLimitedStockUpdateDialogWidget({super.key, required this.product});

  @override
  State<WholesaleLimitedStockUpdateDialogWidget> createState() => _WholesaleLimitedStockUpdateDialogWidgetState();
}

class _WholesaleLimitedStockUpdateDialogWidgetState extends State<WholesaleLimitedStockUpdateDialogWidget> {
  late final TextEditingController _stockQuantityController;

  @override
  void initState() {
    super.initState();
    _stockQuantityController = TextEditingController(text: widget.product.currentStock.toString());
  }

  @override
  void dispose() {
    _stockQuantityController.dispose();
    super.dispose();
  }

  Future<void> _onUpdate(WholesaleLimitedStockController limitedStockController) async {
    final int? quantity = int.tryParse(_stockQuantityController.text.trim());
    if (quantity == null || widget.product.id == null) {
      showCustomSnackBarWidget(getTranslated('product_quantity_is_required', context), context);
      return;
    }
    final bool isSuccess = await limitedStockController.updateProductQuantity(widget.product.id!, quantity, const []);
    if (isSuccess && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    child: Text(
                      widget.product.name ?? '',
                      textAlign: TextAlign.center,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeSmall),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(getTranslated('total_quantity', context)!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      CustomTextFieldWidget(
                        border: true,
                        textInputType: TextInputType.number,
                        controller: _stockQuantityController,
                        textInputAction: TextInputAction.done,
                        isFullNumber: true,
                        hintText: 'Ex: 500',
                      ),
                    ]),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: SizedBox(
                      height: 40,
                      child: Consumer<WholesaleLimitedStockController>(
                        builder: (context, limitedStockController, _) => CustomButtonWidget(
                          borderRadius: 10,
                          isLoading: limitedStockController.isUpdating,
                          btnTxt: getTranslated('update_quantity', context),
                          onTap: () => _onUpdate(limitedStockController),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),

              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: SizedBox(width: 18, child: Image.asset(Images.cross)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
