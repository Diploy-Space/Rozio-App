import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_product_detail_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_details_section_widget.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductTierPriceWidget extends StatelessWidget {
  final List<WholesalePriceTier> tiers;
  const WholesaleProductTierPriceWidget({super.key, required this.tiers});

  @override
  Widget build(BuildContext context) {
    if (tiers.isEmpty) return const SizedBox();

    return WholesaleProductDetailsSectionWidget(
      title: getTranslated('tier_price', context) ?? 'Tier Price',
      child: Wrap(
        spacing: Dimensions.paddingSizeSmall,
        runSpacing: Dimensions.paddingSizeSmall,
        children: [
          for (final WholesalePriceTier tier in tiers)
            LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                width: (MediaQuery.sizeOf(context).width - (Dimensions.paddingSizeMedium * 2) - Dimensions.paddingSizeSmall) / 2,
                child: _TierCard(tier: tier),
              ),
            ),
        ],
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  final WholesalePriceTier tier;
  const _TierCard({required this.tier});

  @override
  Widget build(BuildContext context) {
    final String range = tier.isOpenEnded
        ? '${tier.minQty ?? 0}+ ${getTranslated('pcs', context) ?? 'pcs'}'
        : '${tier.minQty ?? 0} - ${tier.maxQty} ${getTranslated('pcs', context) ?? 'pcs'}';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeSmall,
        vertical: Dimensions.paddingSizeMedium,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Column(
        children: [
          Text(
            range,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text(
            PriceConverter.convertPrice(context, tier.unitPrice),
            style: robotoBold.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
