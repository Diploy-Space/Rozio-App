import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/features/product/widgets/product_filter_bottomsheet_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/brand/controllers/wholesale_brand_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/category/controllers/wholesale_category_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/category/domain/models/wholesale_category_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/controllers/wholesale_product_list_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductFilterBottomSheet extends StatefulWidget {
  const WholesaleProductFilterBottomSheet({super.key});

  @override
  State<WholesaleProductFilterBottomSheet> createState() => _WholesaleProductFilterBottomSheetState();
}

class _WholesaleProductFilterBottomSheetState extends State<WholesaleProductFilterBottomSheet> {
  final List<String> _sortingOptions = [
    'default_recent_created',
    'show_older_first',
    'top_selling_products',
    'most_popular_products',
  ];

  final Map<int, String> _productStatusOptions = {1: 'active', 0: 'inactive'};

  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleProductListController>(context, listen: false).initFilterData();
    Provider.of<WholesaleBrandController>(context, listen: false).getBrandList(isUpdate: false);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final WholesaleCategoryController categoryController = Provider.of<WholesaleCategoryController>(context, listen: false);
    final Set<int> expandedCategoryIds = Provider.of<WholesaleProductListController>(context, listen: false).expandedCategoryIds;

    await categoryController.getCategoryList(isUpdate: false);

    for (final WholesaleCategoryModel category in categoryController.categoryList ?? []) {
      if (category.id == null) continue;
      if (expandedCategoryIds.contains(category.id)) {
        _loadSubCategories(categoryController, category.id!);
      } else {
        categoryController.loadSubCategoriesOf(category.id!);
      }
    }
  }

  Future<void> _loadSubCategories(WholesaleCategoryController categoryController, int categoryId) async {
    await categoryController.loadSubCategoriesOf(categoryId);

    for (final WholesaleCategoryModel subCategory in categoryController.subCategoriesOf(categoryId) ?? []) {
      if (subCategory.id != null) {
        categoryController.loadSubSubCategoriesOf(subCategory.id!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Consumer<WholesaleProductListController>(builder: (context, productListController, _) {
      return Container(
        constraints: BoxConstraints(maxHeight: size.height * 0.95),
        color: Theme.of(context).cardColor,
        child: Column(children: [
          const FilterTitleWidget(),
          Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: .15), thickness: 1),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    _FilterSectionWidget(
                      title: getTranslated('sorting', context)!,
                      child: RadioGroup<int>(
                        groupValue: productListController.filterSortIndex,
                        onChanged: (int? value) => productListController.setFilterSortIndex(value!),
                        child: Column(
                          children: List.generate(_sortingOptions.length, (index) {
                            return RadioListTile<int>(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              activeColor: Theme.of(context).primaryColor,
                              title: Text(
                                getTranslated(_sortingOptions[index], context) ?? _sortingOptions[index],
                                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                              ),
                              value: index,
                            );
                          }),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    _FilterSectionWidget(
                      title: getTranslated('product_status', context)!,
                      child: Row(
                        children: _productStatusOptions.entries.map((entry) {
                          return Expanded(
                            child: CheckboxItemWidget(
                              isStart: true,
                              title: getTranslated(entry.value, context),
                              checked: productListController.selectedProductStatuses.contains(entry.key),
                              onTap: () => productListController.onChangeProductStatus(entry.key),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    Consumer<WholesaleBrandController>(builder: (context, brandController, _) {
                      final List brands = brandController.brandList ?? [];

                      return _FilterSectionWidget(
                        title: getTranslated('brand', context)!,
                        footer: brands.length > 4
                            ? ViewMoreWidget(
                                count: (brands.length - 4).toString(),
                                onTap: () => productListController.toggleBrandSeeMore(),
                                isMore: productListController.brandSeeMore,
                                isActive: true,
                              )
                            : null,
                        child: Column(
                          children: [
                            CheckboxItemWidget(
                              title: getTranslated('all', context),
                              checked: productListController.selectedBrandIds.isEmpty,
                              onTap: () => productListController.onClearBrandIds(),
                            ),

                            ListView.builder(
                              itemCount: brands.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (!productListController.brandSeeMore && index > 3) return const SizedBox.shrink();
                                if (brands[index].id == null) return const SizedBox.shrink();

                                return CheckboxItemWidget(
                                  title: brands[index].name,
                                  checked: productListController.selectedBrandIds.contains(brands[index].id),
                                  onTap: () => productListController.onChangeBrandIds(brands[index].id!),
                                );
                              },
                            ),
                            SizedBox(height: Dimensions.paddingSizeSmall),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: Dimensions.paddingSizeMedium),

                    Consumer<WholesaleCategoryController>(builder: (context, categoryController, _) {
                      final List<WholesaleCategoryModel> categories = categoryController.categoryList ?? [];

                      return _FilterSectionWidget(
                        title: getTranslated('category', context)!,
                        footer: categories.length > 4
                            ? ViewMoreWidget(
                                count: (categories.length - 4).toString(),
                                onTap: () => productListController.toggleCategorySeeMore(),
                                isMore: productListController.categorySeeMore,
                                isActive: true,
                              )
                            : null,
                        child: ListView.builder(
                          itemCount: categories.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (!productListController.categorySeeMore && index > 3) return const SizedBox.shrink();

                            final WholesaleCategoryModel category = categories[index];
                            final bool isExpanded = productListController.expandedCategoryIds.contains(category.id);
                            final List<WholesaleCategoryModel> subCategories = categoryController.subCategoriesOf(category.id ?? -1) ?? [];

                            return Column(
                              children: [
                                CheckboxItemWidget(
                                  title: category.name,
                                  checked: productListController.selectedCategoryIds.contains(category.id),
                                  showDropdown: subCategories.isNotEmpty,
                                  onTap: () {
                                    productListController.onChangeCategoryId(category.id!);
                                    productListController.toggleCategoryExpanded(category.id!);
                                    _loadSubCategories(categoryController, category.id!);
                                  },
                                ),

                                if (isExpanded)
                                  ListView.builder(
                                    itemCount: subCategories.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, subIndex) {
                                      final WholesaleCategoryModel subCategory = subCategories[subIndex];
                                      final bool isSubExpanded = productListController.expandedSubCategoryIds.contains(subCategory.id);
                                      final List<WholesaleCategoryModel> subSubCategories =
                                          categoryController.subSubCategoriesOf(subCategory.id ?? -1) ?? [];

                                      return Column(
                                        children: [
                                          CheckboxItemWidget(
                                            isSubCategory: true,
                                            title: subCategory.name,
                                            checked: productListController.selectedSubCategoryIds.contains(subCategory.id),
                                            showDropdown: subSubCategories.isNotEmpty,
                                            onTap: () {
                                              productListController.onChangeSubCategoryId(subCategory.id!);
                                              productListController.toggleSubCategoryExpanded(subCategory.id!);
                                              categoryController.loadSubSubCategoriesOf(subCategory.id!);
                                            },
                                          ),

                                          if (isSubExpanded)
                                            ListView.builder(
                                              itemCount: subSubCategories.length,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, subSubIndex) {
                                                final WholesaleCategoryModel subSubCategory = subSubCategories[subSubIndex];

                                                return CheckboxItemWidget(
                                                  isSubSubCategory: true,
                                                  title: subSubCategory.name,
                                                  checked: productListController.selectedSubSubCategoryIds.contains(subSubCategory.id),
                                                  showDropdown: false,
                                                  onTap: () => productListController.onChangeSubSubCategoryId(subSubCategory.id!),
                                                );
                                              },
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                              ],
                            );
                          },
                        ),
                      );
                    }),
                    SizedBox(height: Dimensions.paddingSizeSmall),
                  ],
                ),
              ),
            ),
          ),

          const _WholesaleFilterButtonWidget(),
        ]),
      );
    });
  }
}

class _FilterSectionWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? footer;

  const _FilterSectionWidget({required this.title, required this.child, this.footer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: title),

          Material(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: child,
            ),
          ),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

class _WholesaleFilterButtonWidget extends StatelessWidget {
  const _WholesaleFilterButtonWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      color: Theme.of(context).cardColor,
      child: Consumer<WholesaleProductListController>(builder: (ctx, productListController, _) {
        return Row(children: [
          Expanded(child: CustomButtonWidget(
            isColor: true,
            btnTxt: '${getTranslated('clear_filter', context)}',
            backgroundColor: Theme.of(context).hintColor.withValues(alpha: .1),
            fontColor: Theme.of(context).textTheme.bodyLarge?.color,
            onTap: () {
              productListController.clearFilterData();
              Navigator.pop(context);
            },)),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: CustomButtonWidget(
            btnTxt: '${getTranslated('filter', context)}',
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () {
              productListController.applyFilter();
              Navigator.pop(context);
            },
          )),
        ]);
      }),
    );
  }
}
