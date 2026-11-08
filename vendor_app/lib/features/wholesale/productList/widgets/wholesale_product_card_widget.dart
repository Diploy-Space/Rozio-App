import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/domain/models/wholesale_product_list_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/enums/wholesale_product_menu_action.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/enums/wholesale_product_status.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductCardWidget extends StatelessWidget {
  final WholesaleProductListModel product;
  final ValueChanged<WholesaleProductMenuAction>? onMenuSelected;
  final VoidCallback? onTap;
  const WholesaleProductCardWidget({super.key, required this.product, this.onMenuSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isLtr = Provider.of<LocalizationController>(context, listen: false).isLtr;

    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child: Container(
            margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              boxShadow: ThemeShadow.getShadow(context),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: Dimensions.productImageSizeItem,
                  width: Dimensions.productImageSizeItem,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: CustomImageWidget(image: product.thumbnailFullUrl?.path ?? '', fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Text(
                          product.name ?? '',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Text(
                        '${PriceConverter.convertPrice(context, product.minPrice)} - ${PriceConverter.convertPrice(context, product.maxPrice)}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      _StatusBadge(status: product.approvalStatus),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: 10,
          right: isLtr ? 10 : null,
          left: isLtr ? null : 10,
          child: _ProductMenu(
            status: product.approvalStatus,
            isActive: product.isActive,
            onSelected: onMenuSelected,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final WholesaleProductStatus status;
  const _StatusBadge({required this.status});

  Color _color(BuildContext context) {
    switch (status) {
      case WholesaleProductStatus.approved:
        return Theme.of(context).colorScheme.onTertiaryContainer;
      case WholesaleProductStatus.denied:
        return Theme.of(context).colorScheme.error;
      case WholesaleProductStatus.newProduct:
        return Theme.of(context).primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = _color(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeOrder),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Text(
        getTranslated(status.translationKey, context) ?? '',
        style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
      ),
    );
  }
}

class _ProductMenu extends StatelessWidget {
  final WholesaleProductStatus status;
  final bool isActive;
  final ValueChanged<WholesaleProductMenuAction>? onSelected;
  const _ProductMenu({required this.status, required this.isActive, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<WholesaleProductMenuAction>(
      padding: EdgeInsets.zero,
      offset: const Offset(0, 30),
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      onSelected: (action) => onSelected?.call(action),
      itemBuilder: (context) => [
        _buildItem(context, value: WholesaleProductMenuAction.view, icon: Icons.remove_red_eye_outlined, label: getTranslated('view', context) ?? 'View'),
        _buildItem(context, value: WholesaleProductMenuAction.edit, icon: Icons.edit_outlined, label: getTranslated('edit', context) ?? 'Edit'),

        if (status == WholesaleProductStatus.approved)
          _buildItem(
            context,
            value: WholesaleProductMenuAction.toggleStatus,
            icon: isActive ? Icons.toggle_on_outlined : Icons.toggle_off_outlined,
            label: isActive
                ? (getTranslated('turn_off', context) ?? 'Turn Off')
                : (getTranslated('turn_on', context) ?? 'Turn On'),
          ),

        _buildItem(context, value: WholesaleProductMenuAction.delete, icon: Icons.delete_outline, label: getTranslated('delete', context) ?? 'Delete'),
      ],
      // Use `child` (not `icon`) so the tap target is not forced to the
      // 48x48 IconButton minimum and stays tight to the icon.
      child: Icon(Icons.more_vert, size: Dimensions.iconSizeMedium, color: Theme.of(context).hintColor),
    );
  }

  PopupMenuItem<WholesaleProductMenuAction> _buildItem(BuildContext context, {required WholesaleProductMenuAction value, required IconData icon, required String label}) {
    return PopupMenuItem<WholesaleProductMenuAction>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: Dimensions.iconSizeDefault, color: Theme.of(context).primaryColor),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Text(label, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
        ],
      ),
    );
  }
}
