import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_container_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_date_picker_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_drop_down_item_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/controllers/wholesale_product_review_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/widgets/wholesale_product_review_list_tile_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/controllers/wholesale_product_list_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/domain/models/wholesale_product_list_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductReviewFilterBottomSheetWidget extends StatefulWidget {
  const WholesaleProductReviewFilterBottomSheetWidget({super.key});

  @override
  State<WholesaleProductReviewFilterBottomSheetWidget> createState() => _WholesaleProductReviewFilterBottomSheetWidgetState();
}

class _WholesaleProductReviewFilterBottomSheetWidgetState extends State<WholesaleProductReviewFilterBottomSheetWidget> {

  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleProductReviewController>(context, listen: false).initFilterData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Consumer<WholesaleProductReviewController>(
        builder: (context, reviewController, _) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Dimensions.paddingSizeDefault),
                topRight: Radius.circular(Dimensions.paddingSizeDefault),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 30),
                      Text(
                        getTranslated('filter_data', context)!,
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                          child: Icon(Icons.close, size: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.1), height: 1),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                CustomContainerWidget(
                  title: reviewController.filterProductName,
                  onTap: () => showDialog(context: context, builder: (_) => const _WholesaleReviewProductFilterDialog()),
                ),

                CustomDropDownItemWidget(
                  widget: DropdownButtonFormField<String>(
                    initialValue: reviewController.reviewStatusList[reviewController.filterStatusIndex],
                    isExpanded: true,
                    decoration: const InputDecoration(border: InputBorder.none),
                    iconSize: 24, elevation: 16, style: robotoRegular,
                    onChanged: (value) {
                      reviewController.setFilterStatusIndex(reviewController.reviewStatusList.indexOf(value!));
                    },
                    items: reviewController.reviewStatusList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(getTranslated(value, context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                      );
                    }).toList(),
                  ),
                ),

                Row(children: [
                  Expanded(child: CustomDatePickerWidget(
                    prefixIcon: false,
                    title: getTranslated('from', context),
                    image: Images.reviewCalenderIcon,
                    text: reviewController.filterStartDate != null
                        ? reviewController.dateFormat.format(reviewController.filterStartDate!)
                        : getTranslated('select_date', context),
                    selectDate: () => reviewController.selectDate('start', context),
                  )),
                  Expanded(child: CustomDatePickerWidget(
                    prefixIcon: false,
                    title: getTranslated('to', context),
                    image: Images.reviewCalenderIcon,
                    text: reviewController.filterEndDate != null
                        ? reviewController.dateFormat.format(reviewController.filterEndDate!)
                        : getTranslated('select_date', context),
                    selectDate: () => reviewController.selectDate('end', context),
                  )),
                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButtonWidget(
                          isColor: true,
                          btnTxt: getTranslated('clear_filter', context),
                          backgroundColor: Theme.of(context).hintColor.withValues(alpha: .1),
                          fontColor: Theme.of(context).textTheme.bodyLarge?.color,
                          onTap: () {
                            reviewController.clearFilterData();
                            Navigator.pop(context);
                          },),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),
                      Expanded(
                        child: CustomButtonWidget(
                          btnTxt: getTranslated('filter', context),
                          onTap: () {
                            if (reviewController.applyFilter(context)) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WholesaleReviewProductFilterDialog extends StatefulWidget {
  const _WholesaleReviewProductFilterDialog();

  @override
  State<_WholesaleReviewProductFilterDialog> createState() => _WholesaleReviewProductFilterDialogState();
}

class _WholesaleReviewProductFilterDialogState extends State<_WholesaleReviewProductFilterDialog> {

  @override
  void initState() {
    super.initState();
    final WholesaleProductListController productController = Provider.of<WholesaleProductListController>(context, listen: false);

    if (productController.hasActiveQuery) {
      productController.resetForNewVisit();
      productController.getProductList(offset: 1, reload: true, isUpdate: false);
    } else if (productController.products == null) {
      productController.getProductList(offset: 1, isUpdate: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        child: Consumer<WholesaleProductListController>(
          builder: (context, productController, _) {
            final List<WholesaleProductListModel>? products = productController.products;

            if (products == null) {
              return const WholesaleProductReviewListTileShimmerWidget();
            }
            if (products.isEmpty) {
              return Center(child: Text(getTranslated('no_data_found', context) ?? '', style: robotoRegular.copyWith(color: Theme.of(context).hintColor)));
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 50) {
                  productController.loadNextPage();
                }
                return false;
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                itemCount: products.length + (productController.isLoadingMore ? 1 : 0),
                separatorBuilder: (context, index) => Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                itemBuilder: (context, index) {
                  if (index == products.length) {
                    return const WholesaleProductReviewListTileShimmerWidget(itemCount: 2);
                  }

                  final WholesaleProductListModel product = products[index];
                  return InkWell(
                    onTap: () {
                      Provider.of<WholesaleProductReviewController>(context, listen: false).setFilterProduct(product.id, product.name);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                      child: Text(
                        product.name ?? '',
                        style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
