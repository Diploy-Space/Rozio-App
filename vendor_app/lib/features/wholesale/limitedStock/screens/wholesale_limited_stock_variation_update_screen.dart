import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/controllers/wholesale_limited_stock_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/domain/models/wholesale_limited_stock_product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleLimitedStockVariationUpdateScreen extends StatefulWidget {
  final WholesaleLimitedStockProductModel product;
  const WholesaleLimitedStockVariationUpdateScreen({super.key, required this.product});

  @override
  State<WholesaleLimitedStockVariationUpdateScreen> createState() => _WholesaleLimitedStockVariationUpdateScreenState();
}

class _WholesaleLimitedStockVariationUpdateScreenState extends State<WholesaleLimitedStockVariationUpdateScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleLimitedStockController>(context, listen: false).initVariationControllers(widget.product);
  }

  Future<void> _onUpdate(WholesaleLimitedStockController limitedStockController) async {
    final bool isEmpty = limitedStockController.variationQuantityController.any((controller) => int.tryParse(controller.text.trim()) == null);
    if (isEmpty || widget.product.id == null) {
      showCustomSnackBarWidget(getTranslated('variation_quantity_is_required', context), context, sanckBarType: SnackBarType.error);
      return;
    }
    final List<WholesaleLimitedStockVariation> variations = limitedStockController.editedVariations(widget.product);
    final int currentStock = variations.fold(0, (total, variation) => total + variation.qty);
    final bool isSuccess = await limitedStockController.updateProductQuantity(widget.product.id!, currentStock, variations);
    if (isSuccess && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: '${widget.product.name ?? ''} - ${getTranslated('product_variations', context)}'),
      body: Consumer<WholesaleLimitedStockController>(
        builder: (context, limitedStockController, _) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  itemCount: widget.product.variation.length,
                  separatorBuilder: (context, index) => const SizedBox(height: Dimensions.paddingSizeLarge),
                  itemBuilder: (context, index) {
                    final variation = widget.product.variation[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                variation.type?.split('-').join(' - ') ?? '',
                                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                              ),
                              if (variation.sku != null) ...[
                                const SizedBox(height: Dimensions.paddingSizeVeryTiny),
                                Text(
                                  '${getTranslated('sku', context)}: ${variation.sku}',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          flex: 4,
                          child: CustomTextFieldWidget(
                            variant: true,
                            border: true,
                            hintText: 'Ex: 345',
                            controller: limitedStockController.variationQuantityController[index],
                            focusNode: limitedStockController.variationQuantityFocusNode[index],
                            nextNode: index != widget.product.variation.length - 1 ? limitedStockController.variationQuantityFocusNode[index + 1] : null,
                            textInputAction: index != widget.product.variation.length - 1 ? TextInputAction.next : TextInputAction.done,
                            textInputType: TextInputType.number,
                            isFullNumber: true,
                            onChanged: (value) => limitedStockController.calculateVariationQuantity(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: ThemeShadow.getShadow(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(getTranslated('total_quantity', context)!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                        Text(
                          limitedStockController.totalQuantityController.text,
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    SizedBox(
                      height: 40,
                      child: CustomButtonWidget(
                        borderRadius: 10,
                        isLoading: limitedStockController.isUpdating,
                        btnTxt: getTranslated('update_quantity', context),
                        onTap: () => _onUpdate(limitedStockController),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
