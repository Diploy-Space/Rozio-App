import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/dropdown_decorator_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/category/controllers/wholesale_category_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/category/domain/models/wholesale_category_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductCategoryWidget extends StatelessWidget {
  const AddWholesaleProductCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleCategoryController>(
      builder: (context, categoryController, child) {
        if (categoryController.categoryList != null && categoryController.categoryList!.isEmpty) {
          return const NoDataScreen(title: 'no_category_found');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (categoryController.categoryList != null)
              _CategoryDropdownWidget(
                hintKey: 'select_category_required',
                isRequired: true,
                items: categoryController.categoryList!,
                value: categoryController.selectedCategoryId,
                onChanged: (int? id) => categoryController.onSelectCategory(id),
              ),

            if (categoryController.subCategoryList != null && categoryController.subCategoryList!.isNotEmpty)
              _CategoryDropdownWidget(
                hintKey: 'sub_category',
                items: categoryController.subCategoryList!,
                value: categoryController.selectedSubCategoryId,
                onChanged: (int? id) => categoryController.onSelectSubCategory(id),
              ),

            if (categoryController.subSubCategoryList != null && categoryController.subSubCategoryList!.isNotEmpty)
              _CategoryDropdownWidget(
                hintKey: 'sub_sub_category',
                items: categoryController.subSubCategoryList!,
                value: categoryController.selectedSubSubCategoryId,
                onChanged: (int? id) => categoryController.onSelectSubSubCategory(id),
              ),
          ],
        );
      },
    );
  }
}

class _CategoryDropdownWidget extends StatelessWidget {
  final String hintKey;
  final bool isRequired;
  final List<WholesaleCategoryModel> items;
  final int? value;
  final ValueChanged<int?> onChanged;

  const _CategoryDropdownWidget({
    required this.hintKey,
    this.isRequired = false,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isValueListed = items.any((WholesaleCategoryModel category) => category.id == value);

    return Column(
      children: [
        DropdownDecoratorWidget(
          isRequired: isRequired,
          child: DropdownButton<int>(
            icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor),
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingEye)),
            hint: Text(getTranslated(hintKey, context)!, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
            value: isValueListed ? value : null,
            items: items.map((WholesaleCategoryModel category) {
              return DropdownMenuItem<int>(
                value: category.id,
                child: Text(
                  category.name ?? '',
                  style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox(),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeVeryTiny),
      ],
    );
  }
}
