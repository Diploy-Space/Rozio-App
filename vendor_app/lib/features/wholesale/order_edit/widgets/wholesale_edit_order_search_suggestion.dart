import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order_edit/controllers/wholesale_order_edit_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/domain/models/wholesale_product_list_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleEditOrderSearchSuggestion extends StatefulWidget {
  const WholesaleEditOrderSearchSuggestion({super.key});

  @override
  State<WholesaleEditOrderSearchSuggestion> createState() => _WholesaleEditOrderSearchSuggestionState();
}

class _WholesaleEditOrderSearchSuggestionState extends State<WholesaleEditOrderSearchSuggestion> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Consumer<WholesaleOrderEditController>(
        builder: (context, wholesaleOrderEditController, _) {
          return SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Autocomplete<WholesaleProductListModel>(
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  searchController = controller;
                  searchFocusNode = focusNode;
                  return Material(
                    child: TextFormField(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      textInputAction: TextInputAction.search,
                      onChanged: (val) {
                        if (val.isEmpty) {
                          wholesaleOrderEditController.emptySearchResult();
                        }
                      },
                      onFieldSubmitted: (value) {
                        if (value.trim().isEmpty) {
                          showCustomSnackBarWidget(getTranslated('enter_somethings', context) ?? '', context);
                        }
                      },
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall), borderSide: BorderSide(color: Colors.grey[300]!)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall), borderSide: BorderSide(color: Colors.grey[300]!)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall), borderSide: BorderSide(color: Colors.grey[300]!)),
                        hintText: getTranslated('search_by_product_name', context),
                        hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                        suffixIcon: SizedBox(
                          width: controller.text.isNotEmpty ? 70 : 50,
                          child: Row(children: [
                            if (controller.text.isNotEmpty)
                              InkWell(onTap: () => setState(() => controller.clear()), child: const Icon(Icons.clear, size: 20)),
                            InkWell(
                              onTap: () {
                                if (controller.text.trim().isNotEmpty) {
                                  focusNode.unfocus();
                                } else {
                                  showCustomSnackBarWidget(getTranslated('enter_somethings', context) ?? '', context);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  width: 40, height: 50,
                                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall))),
                                  child: SizedBox(width: 18, height: 18, child: Padding(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                    child: Image.asset(Images.search, color: Colors.white),
                                  )),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  );
                },

                optionsBuilder: (TextEditingValue textEditingValue) {
                  wholesaleOrderEditController.searchProduct(textEditingValue.text);
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<WholesaleProductListModel>.empty();
                  }
                  return wholesaleOrderEditController.searchResult;
                },
                optionsViewOpenDirection: OptionsViewOpenDirection.down,

                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final product = options.elementAt(index);
                            return InkWell(
                              onTap: () {
                                searchFocusNode.unfocus();
                                searchController.clear();
                                wholesaleOrderEditController.addToCart(product);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                child: Container(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: BorderRadius.only(
                                      topRight: index == 0 ? const Radius.circular(Dimensions.radiusDefault) : Radius.zero,
                                      topLeft: index == 0 ? const Radius.circular(Dimensions.radiusDefault) : Radius.zero,
                                      bottomLeft: options.length - 1 == index ? const Radius.circular(Dimensions.radiusDefault) : Radius.zero,
                                      bottomRight: options.length - 1 == index ? const Radius.circular(Dimensions.radiusDefault) : Radius.zero,
                                    ),
                                    border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.15), width: .75),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 50, width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                          border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), width: .75),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                          child: CustomImageWidget(image: product.thumbnail ?? ''),
                                        ),
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(product.name ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color), maxLines: 2),
                                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                            Text(PriceConverter.convertPrice(context, product.minPrice), style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(),
                          itemCount: options.length,
                        ),
                      ),
                    ),
                  );
                },

                onSelected: (_) {},
              ),
            ),
          );
        },
      ),
    );
  }
}
