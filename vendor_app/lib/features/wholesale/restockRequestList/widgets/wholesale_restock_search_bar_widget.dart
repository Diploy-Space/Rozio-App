import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/controllers/wholesale_restock_request_list_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/widgets/wholesale_restock_product_filter_dialog_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';

class WholesaleRestockSearchBarWidget extends StatefulWidget {
  final bool showFilter;
  final TextEditingController controller;
  const WholesaleRestockSearchBarWidget({super.key, this.showFilter = true, required this.controller});

  @override
  State<WholesaleRestockSearchBarWidget> createState() => _WholesaleRestockSearchBarWidgetState();
}

class _WholesaleRestockSearchBarWidgetState extends State<WholesaleRestockSearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
      child: Consumer<WholesaleRestockRequestListController>(
        builder: (context, restockController, child) {
          return Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              flex: 7,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.50)),
                ),
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeVeryTiny),
                    child: CustomTextFieldWidget(
                      border: false,
                      focusBorder: false,
                      hintText: getTranslated('search_by_product_info', context)!,
                      controller: widget.controller,
                      onChanged: (text) {
                        restockController.setSearchText(text);
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          if (widget.controller.text.isEmpty) {
                            showCustomSnackBarWidget(getTranslated('type_something_to_search_for_products', context), context, sanckBarType: SnackBarType.warning);
                          } else if (restockController.isSearching) {
                            restockController.setSearching(false);
                            widget.controller.text = '';
                            restockController.setSearchText('');
                            restockController.getRestockProductList(1);
                          } else {
                            restockController.setSearching(true);
                            restockController.getRestockProductList(1);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.showFilter ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeSmall,
                          ),
                          margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          ),
                          child: Icon(!restockController.isSearching ? Icons.search : Icons.close, color: Theme.of(context).cardColor, size: 15),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            if (widget.showFilter) ...[
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: Theme.of(context).hintColor),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (c) => const WholesaleRestockProductFilterDialogWidget(),
                      );
                    },
                    child: Image.asset(Images.filterIcon, color: Colors.white),
                  ),
                ),
              ),
            ],
          ]);
        },
      ),
    );
  }
}
