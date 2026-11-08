import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/domain/models/wholesale_order_details_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_order_product_item_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleOrderProductListCardWidget extends StatefulWidget {
  final List<WholesaleOrderDetailsModel> products;
  const WholesaleOrderProductListCardWidget({super.key, required this.products});

  @override
  State<WholesaleOrderProductListCardWidget> createState() => _WholesaleOrderProductListCardWidgetState();
}

class _WholesaleOrderProductListCardWidgetState extends State<WholesaleOrderProductListCardWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: .2), spreadRadius: 1.5, blurRadius: 3)],
        color: Theme.of(context).cardColor,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Text(getTranslated('product_list', context) ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor.withValues(alpha: 0.15)),
                  child: Text('${widget.products.length}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
                ),
              ]),

              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: AnimatedRotation(
                  turns: _isExpanded ? 0 : 0.5,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ],
          ),
        ),
        Divider(thickness: 0.2, height: 1, color: Theme.of(context).hintColor.withValues(alpha: .65)),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _isExpanded
            ? Container(
                padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, 0),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) => WholesaleOrderProductItemWidget(line: widget.products[index]),
                ),
              )
            : const SizedBox(),
        ),

        if (_isExpanded) const SizedBox(height: Dimensions.paddingSizeSmall),
      ]),
    );
  }
}
