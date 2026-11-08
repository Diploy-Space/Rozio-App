import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_product_detail_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_details_section_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatTax/controllers/wholesale_vat_tax_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatTax/domain/models/wholesale_vat_tax_setup_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';

class WholesaleProductInfoWidget extends StatelessWidget {
  final WholesaleProductDetailModel product;
  const WholesaleProductInfoWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return WholesaleProductDetailsSectionWidget(
      title: getTranslated('product_info', context) ?? 'Product Info',
      child: Column(
        children: [
          if (product.categoryName?.isNotEmpty ?? false)
            WholesaleProductInfoRowWidget(
              label: getTranslated('category', context) ?? 'Category',
              value: product.categoryName ?? '',
            ),
          if (product.subCategoryName?.isNotEmpty ?? false)
            WholesaleProductInfoRowWidget(
              label: getTranslated('sub_category', context) ?? 'Sub Category',
              value: product.subCategoryName ?? '',
            ),
          WholesaleProductInfoRowWidget(
            label: getTranslated('brand', context) ?? 'Brand',
            value: (product.brandName?.isNotEmpty ?? false) ? product.brandName! : (getTranslated('no_brand', context) ?? 'No Brand'),
          ),
          WholesaleProductInfoRowWidget(
            label: getTranslated('product_unit', context) ?? 'Product Unit',
            value: product.unit ?? '',
          ),
          WholesaleProductInfoRowWidget(
            label: getTranslated('current_stock', context) ?? 'Current Stock',
            value: '${product.currentStock ?? 0}',
          ),
          WholesaleProductInfoRowWidget(
            label: getTranslated('sku', context) ?? 'SKU',
            value: product.code ?? '',
          ),
        ],
      ),
    );
  }
}

class WholesaleProductPriceInfoWidget extends StatelessWidget {
  final WholesaleProductDetailModel product;
  const WholesaleProductPriceInfoWidget({super.key, required this.product});

  String _discountText(BuildContext context) {
    final double discount = product.discount ?? 0;
    if (product.discountType == 'percent') return '$_number%';
    return PriceConverter.convertPrice(context, discount);
  }

  String get _number {
    final double discount = product.discount ?? 0;
    return discount == discount.roundToDouble() ? discount.toInt().toString() : discount.toString();
  }

  String _rate(double? rate) {
    final double value = rate ?? 0;
    return value == value.roundToDouble() ? value.toInt().toString() : value.toStringAsFixed(2);
  }

  String _taxText(BuildContext context, WholesaleVatTaxController vatTaxController) {
    final WholesaleVatTaxSetupModel? setup = vatTaxController.setup;
    if (setup == null) return '';

    if (setup.isProductWise) {
      final List<WholesaleTaxModel> taxes = vatTaxController.taxList
          .where((tax) => tax.id != null && tax.id != 0 && product.taxIds.contains(tax.id))
          .toList();
      if (taxes.isEmpty) return '0%';
      return taxes.map((tax) => '${tax.name ?? ''} (${_rate(tax.taxRate)}%)').join(', ');
    }

    return setup.isCategoryWise
        ? (getTranslated('category_wise', context) ?? 'Category wise')
        : (getTranslated('order_wise', context) ?? 'Order wise');
  }

  @override
  Widget build(BuildContext context) {
    final String shippingCost = PriceConverter.convertPrice(context, product.shippingCost);

    return WholesaleProductDetailsSectionWidget(
      title: getTranslated('price_information', context) ?? 'Price Information',
      child: Column(
        children: [
          WholesaleProductInfoRowWidget(
            label: getTranslated('shipping_cost', context) ?? 'Shipping Cost',
            value: product.multiplyQty
                ? '$shippingCost (${getTranslated('multiply_with_quantity', context) ?? 'Multiply with quantity'})'
                : shippingCost,
          ),
          WholesaleProductInfoRowWidget(
            label: getTranslated('discount', context) ?? 'Discount',
            value: _discountText(context),
          ),
          Consumer<WholesaleVatTaxController>(
            builder: (context, vatTaxController, _) {
              final WholesaleVatTaxSetupModel? setup = vatTaxController.setup;
              if (setup == null) return const SizedBox();

              return Column(
                children: [
                  WholesaleProductInfoRowWidget(
                    label: getTranslated('vat', context) ?? 'Vat/Tax',
                    value: _taxText(context, vatTaxController),
                  ),
                  WholesaleProductInfoRowWidget(
                    label: getTranslated('tax_type', context) ?? 'Tax Type',
                    value: setup.isIncluded
                        ? (getTranslated('tax_included', context) ?? 'Tax Included')
                        : (getTranslated('tax_excluded', context) ?? 'Tax Excluded'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
