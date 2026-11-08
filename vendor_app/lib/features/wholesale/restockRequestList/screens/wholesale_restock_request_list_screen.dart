import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/controllers/wholesale_restock_request_list_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/domain/models/wholesale_restock_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/widgets/wholesale_restock_category_button_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/widgets/wholesale_restock_list_item_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/widgets/wholesale_restock_search_bar_widget.dart';
import 'package:sixvalley_vendor_app/features/order/screens/order_screen.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/category_controller.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleRestockRequestListScreen extends StatefulWidget {
  const WholesaleRestockRequestListScreen({super.key});

  @override
  State<WholesaleRestockRequestListScreen> createState() => _WholesaleRestockRequestListScreenState();
}

class _WholesaleRestockRequestListScreenState extends State<WholesaleRestockRequestListScreen> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final locale = Provider.of<LocalizationController>(context, listen: false).locale;
    final languageCode = locale.countryCode == 'US' ? 'en' : locale.countryCode!.toLowerCase();
    Provider.of<CategoryController>(context, listen: false).getCategoryList(context, null, languageCode);
    Provider.of<WholesaleRestockRequestListController>(context, listen: false).getRestockBrandList();
    Provider.of<WholesaleRestockRequestListController>(context, listen: false).setIndex(0, null, notify: false);
    Provider.of<WholesaleRestockRequestListController>(context, listen: false).setSearching(false, isUpdate: false);
    Provider.of<WholesaleRestockRequestListController>(context, listen: false).getRestockProductList(1);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvokedWithResult: (didPop, result) async {
        final controller = Provider.of<WholesaleRestockRequestListController>(context, listen: false);
        if (controller.restockProductModel != null && (controller.restockProductModel?.data?.isEmpty ?? false)) {
          controller.emptyReStockData();
        }
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          title: getTranslated('request_restock_request', context),
          onBackPressed: () {
            final controller = Provider.of<WholesaleRestockRequestListController>(context, listen: false);
            if (controller.restockProductModel != null && (controller.restockProductModel?.data?.isEmpty ?? false)) {
              controller.emptyReStockData();
            }
            Navigator.pop(context);
          },
          isAction: true,
          isTooltip: true,
          widget: Consumer<WholesaleRestockRequestListController>(
            builder: (context, restockController, child) {
              return (restockController.restockProductModel != null && restockController.restockProductModel!.data!.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeRevenueBottom),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeVeryTiny, horizontal: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceTint.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                          border: Border.all(color: Theme.of(context).colorScheme.surfaceTint.withValues(alpha: .10), width: 0.5),
                        ),
                        child: Text(
                          restockController.restockProductModel?.totalSize.toString() ?? '',
                          style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.surfaceTint),
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          ),
        ),

        body: Consumer<WholesaleRestockRequestListController>(
          builder: (context, restockController, child) {
            return RefreshIndicator(
              onRefresh: () async {
                Provider.of<WholesaleRestockRequestListController>(context, listen: false).getRestockBrandList();
                Provider.of<WholesaleRestockRequestListController>(context, listen: false).setIndex(0, null, notify: false);
                Provider.of<WholesaleRestockRequestListController>(context, listen: false).setSearching(false, isUpdate: false);
                Provider.of<WholesaleRestockRequestListController>(context, listen: false).getRestockProductList(1);
              },
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              child: Column(children: [
                Consumer<CategoryController>(
                  builder: (context, categoryController, child) {
                    return categoryController.categoryList != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                            child: SizedBox(
                              height: 40,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: categoryController.categoryList!.isEmpty ? 1 : categoryController.categoryList!.length + 1,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                                    child: WholesaleRestockCategoryButtonWidget(
                                      text: index == 0 ? getTranslated('all', context) : categoryController.categoryList![index - 1].name,
                                      index: index,
                                      categoryId: index == 0 ? null : categoryController.categoryList![index - 1].id,
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : const SizedBox();
                  },
                ),

                (((restockController.isSearching && restockController.restockProductModel != null) ||
                            ((restockController.startDate != null && restockController.endDate != null) || restockController.selectedBrandIds.isNotEmpty)) &&
                        (restockController.restockProductModel?.data?.isEmpty ?? false))
                    ? SizedBox(height: 65, child: WholesaleRestockSearchBarWidget(showFilter: true, controller: _searchController))
                    : const SizedBox(),

                restockController.restockProductModel != null
                    ? (restockController.restockProductModel?.data?.isNotEmpty ?? false)
                        ? Expanded(
                            child: Column(children: [
                              SizedBox(height: 65, child: WholesaleRestockSearchBarWidget(showFilter: true, controller: _searchController)),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: PaginatedListViewWidget(
                                    scrollController: scrollController,
                                    onPaginate: (int? offset) async => await restockController.getRestockProductList(offset!),
                                    totalSize: restockController.restockProductModel?.totalSize,
                                    offset: restockController.restockProductModel!.offset ?? 1,
                                    itemView: ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      itemCount: restockController.restockProductModel?.data?.length ?? 0,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        WholesaleRestockProduct? product = restockController.restockProductModel?.data![index].product;
                                        double ratting = (product?.rating?.isNotEmpty ?? false) ? double.parse('${product?.rating?[0].average}') : 0;
                                        WholesaleRestockRequestData? data = restockController.restockProductModel?.data![index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                          child: WholesaleRestockListItemWidget(product: product, ratting: ratting, data: data, index: index),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                            ]),
                          )
                        : const Expanded(child: NoDataScreen(title: 'product_not_found'))
                    : const Expanded(child: OrderShimmer()),
              ]),
            );
          },
        ),
      ),
    );
  }
}
