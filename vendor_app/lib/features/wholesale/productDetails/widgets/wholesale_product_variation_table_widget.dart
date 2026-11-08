import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_product_detail_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_details_section_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductVariationTableWidget extends StatelessWidget {
  final List<WholesaleStock> stocks;
  const WholesaleProductVariationTableWidget({super.key, required this.stocks});

  String _qty(double? value) {
    if (value == null) return '0';
    return value == value.roundToDouble() ? value.toInt().toString() : value.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (stocks.isEmpty) return const SizedBox();

    return WholesaleProductDetailsSectionWidget(
      child: Column(
        children: [
          _Row(
            variation: getTranslated('attribute_variation', context) ?? 'Attribute Variation',
            sku: getTranslated('sku', context) ?? 'SKU',
            stock: getTranslated('stock', context) ?? 'Stock',
            isHeader: true,
          ),
          Divider(height: Dimensions.paddingSizeMedium, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),

          for (int index = 0; index < stocks.length; index++) ...[
            _Row(
              variation: stocks[index].variant ?? '',
              sku: stocks[index].sku ?? '',
              stock: _qty(stocks[index].qty),
            ),
            if (index != stocks.length - 1)
              Divider(height: Dimensions.paddingSizeMedium, color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String variation;
  final String sku;
  final String stock;
  final bool isHeader;
  const _Row({required this.variation, required this.sku, required this.stock, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    final TextStyle style = (isHeader ? robotoBold : robotoRegular).copyWith(
      fontSize: Dimensions.fontSizeDefault,
      color: isHeader
          ? Theme.of(context).textTheme.bodyLarge?.color
          : Theme.of(context).textTheme.bodyLarge?.color,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: Text(variation, style: style)),
        Expanded(flex: 4, child: Text(sku, style: style)),
        Expanded(flex: 2, child: Text(stock, style: style, textAlign: TextAlign.end)),
      ],
    );
  }
}
