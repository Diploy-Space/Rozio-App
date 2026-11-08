import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/controllers/wholesale_coupon_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/domain/models/wholesale_coupon_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/screens/wholesale_add_coupon_screen.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleCouponCardWidget extends StatelessWidget {
  final WholesaleCoupon? coupon;
  final int? index;
  const WholesaleCouponCardWidget({super.key, this.coupon, this.index});

  String _dateRange() {
    final DateTime? start = DateTime.tryParse(coupon!.startDate ?? '');
    final DateTime? end = DateTime.tryParse(coupon!.expireDate ?? '');
    if (start == null || end == null) return '';
    return '${DateConverter.localDateToIsoStringDate(start)} - ${DateConverter.localDateToIsoStringDate(end)}';
  }

  void _confirmDelete(BuildContext context) {
    showAnimatedDialogWidget(
      context,
      Consumer<WholesaleCouponController>(
        builder: (dialogContext, couponProvider, _) => CustomConfirmationDialogWidget(
          iconWidget: Icon(Icons.delete_outline, size: 50, color: Theme.of(context).colorScheme.error),
          title: getTranslated('delete_coupon', context) ?? 'Delete Coupon',
          description: getTranslated('are_you_sure_you_want_to_delete_this_coupon', context) ?? '',
          yesButtonText: getTranslated('delete', context) ?? 'Delete',
          noButtonText: getTranslated('cancel', context) ?? 'Cancel',
          isLoading: couponProvider.isLoading,
          onYesPressed: () async {
            await couponProvider.deleteCoupon(coupon!.id);
            if (dialogContext.mounted) Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool adminCoupon = !(coupon!.isEditable ?? false);
    final bool freeDelivery = coupon!.couponType == 'free_delivery';

    return Padding(
      padding: const EdgeInsets.only(
        top: Dimensions.paddingSizeSmall,
        left: Dimensions.paddingSizeDefault,
        right: Dimensions.paddingSizeDefault,
      ),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(Images.couponIcon, width: 20, height: 20),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Text(coupon!.title ?? '',
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Consumer<WholesaleCouponController>(
                  builder: (context, couponProvider, _) {
                    return SizedBox(
                      height: 25, width: 25,
                      child: PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                        icon: Icon(Icons.more_vert, size: 20, color: Theme.of(context).hintColor),
                        onSelected: (String result) async {
                          if (adminCoupon) {
                            showCustomSnackBarWidget(getTranslated('coupon_tooltip', context), context);
                          } else if (result == 'delete') {
                            _confirmDelete(context);
                          } else if (result == 'edit') {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => WholesaleAddCouponScreen(coupon: coupon)));
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'status',
                            enabled: false,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                if (adminCoupon) {
                                  showCustomSnackBarWidget(getTranslated('coupon_tooltip', context), context);
                                } else {
                                  couponProvider.updateCouponStatus(coupon!.id, coupon!.status != 1, index);
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(getTranslated('statuss', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                                  const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                                  FlutterSwitch(
                                    width: 40.0, height: 20.0, toggleSize: 18.0, padding: 2.0,
                                    value: coupon!.status == 1,
                                    activeColor: Theme.of(context).primaryColor,
                                    onToggle: (bool isActive) {
                                      Navigator.pop(context);
                                      if (adminCoupon) {
                                        showCustomSnackBarWidget(getTranslated('coupon_tooltip', context), context);
                                      } else {
                                        couponProvider.updateCouponStatus(coupon!.id, isActive, index);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Opacity(
                              opacity: adminCoupon ? 0.5 : 1,
                              child: Row(
                                children: [
                                  Image.asset(Images.editCouponIcon, width: 20, height: 20, color: Theme.of(context).primaryColor),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),
                                  Text(getTranslated('edit', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                                ],
                              ),
                            ),
                          ),

                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Opacity(
                              opacity: adminCoupon ? 0.5 : 1,
                              child: Row(
                                children: [
                                  Image.asset(Images.deleteCouponIcon, width: 20, height: 20, color: Theme.of(context).colorScheme.error),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),
                                  Text(getTranslated('delete', context)!, style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Row(
              children: [
                if (!freeDelivery) ...[
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.35),
                    child: Text(coupon!.discountType == 'percentage'
                        ? '${coupon!.discount}% ${getTranslated('off', context)}'
                        : '${PriceConverter.convertPrice(context, coupon!.discount)} ${getTranslated('off', context)}',
                      style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Container(height: 12, width: 1, color: Theme.of(context).textTheme.headlineLarge?.color),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                ],

                Text(getTranslated(freeDelivery ? 'free_delivery' : 'discount_on_purchase', context)!,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color),
                ),

                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Container(height: 12, width: 1, color: Theme.of(context).hintColor),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Expanded(
                  child: Text('${getTranslated('limit_for', context)} ${coupon!.limit} ${getTranslated('user', context)}',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_dateRange(),
                  textDirection: TextDirection.ltr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color),
                ),

                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: coupon!.code ?? ''));
                    showCustomSnackBarWidget(getTranslated('coupon_code_copied', context), context, isError: false);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: Row(
                      children: [
                        Text(coupon!.code ?? '',
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        CustomAssetImageWidget(Images.copyIcon, height: 16, color: Theme.of(context).primaryColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
