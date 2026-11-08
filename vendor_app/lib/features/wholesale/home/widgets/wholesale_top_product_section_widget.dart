import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/title_row_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/domain/models/wholesale_top_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/widgets/wholesale_top_product_card_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class WholesaleTopProductSectionWidget extends StatelessWidget {
  final String titleKey;
  final List<WholesaleTopProductModel> products;
  final VoidCallback? onViewAll;
  const WholesaleTopProductSectionWidget({super.key, required this.titleKey, required this.products, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeLarge, Dimensions.paddingSizeDefault, 0),
          child: TitleRowWidget(title: getTranslated(titleKey, context), onTap: onViewAll),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: MediaQuery.of(context).size.width < 400 ? 1 / 1.58  : 1 / 1.66,
            ),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return WholesaleTopProductCardWidget(product: products[index]);
            },
          ),
        ),
      ],
    );
  }
}
