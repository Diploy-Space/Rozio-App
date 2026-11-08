import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class ShippingTypeDropdownViewWidget extends StatefulWidget {
  final Widget categoryWise;
  final Widget orderWise;
  final Widget productWise;
  const ShippingTypeDropdownViewWidget({super.key, required this.categoryWise, required this.orderWise, required this.productWise});

  @override
  State<ShippingTypeDropdownViewWidget> createState() => _ShippingTypeDropdownViewWidgetState();
}

class _ShippingTypeDropdownViewWidgetState extends State<ShippingTypeDropdownViewWidget> {
  static const List<String> _types = ['category_wise', 'order_wise', 'product_type'];
  String _selectedType = _types.first;

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _types.indexOf(_selectedType);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              border: Border.all(width: .5, color: Theme.of(context).hintColor.withValues(alpha: .7)),
            ),
            child: DropdownButton<String>(
              value: _selectedType,
              items: _types.map((value) {
                return DropdownMenuItem<String>(value: value, child: Text(getTranslated(value, context)!));
              }).toList(),
              onChanged: (val) => setState(() => _selectedType = val!),
              isExpanded: true,
              underline: const SizedBox(),
            ),
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: selectedIndex,
            sizing: StackFit.expand,
            children: [widget.categoryWise, widget.orderWise, widget.productWise],
          ),
        ),
      ],
    );
  }
}
