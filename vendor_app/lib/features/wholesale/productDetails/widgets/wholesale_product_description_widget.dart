import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/controllers/wholesale_product_details_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_details_section_widget.dart';
import 'package:sixvalley_vendor_app/helper/product_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductDescriptionWidget extends StatelessWidget {
  final String? details;
  const WholesaleProductDescriptionWidget({super.key, this.details});

  static const int _collapsedLines = 5;

  @override
  Widget build(BuildContext context) {
    final String text = ProductHelper.htmlToPlainText(details ?? '').trim();
    if (text.isEmpty) return const SizedBox();

    return Consumer<WholesaleProductDetailsController>(
      builder: (context, controller, _) {
        final TextStyle style = robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeDefault,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        );

        return WholesaleProductDetailsSectionWidget(
          title: getTranslated('title_and_description', context) ?? 'Title & Description',
          child: LayoutBuilder(builder: (context, constraints) {
            final TextPainter painter = TextPainter(
              text: TextSpan(text: text, style: style),
              maxLines: _collapsedLines,
              textDirection: Directionality.of(context),
              textScaler: MediaQuery.textScalerOf(context),
            )..layout(maxWidth: constraints.maxWidth);
            final bool isLong = painter.didExceedMaxLines;
            painter.dispose();
            final bool isExpanded = !isLong || controller.isDescriptionExpanded;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  maxLines: isExpanded ? null : _collapsedLines,
                  overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: style,
                ),
                if (isLong) ...[
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: controller.toggleDescription,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeMedium,
                          vertical: Dimensions.paddingSizeExtraSmall,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          boxShadow: ThemeShadow.getShadow(context),
                        ),
                        child: Text(
                          isExpanded ? getTranslated('see_less', context) ?? 'See Less' : getTranslated('see_more', context) ?? 'See More',
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          }),
        );
      },
    );
  }
}
