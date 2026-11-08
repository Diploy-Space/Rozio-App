import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_product_detail_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/controllers/wholesale_product_details_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_faq_edit_bottom_sheet_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductFaqTabWidget extends StatelessWidget {
  final List<WholesaleFaq> faqs;
  const WholesaleProductFaqTabWidget({super.key, required this.faqs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (faqs.isEmpty)
            const NoDataScreen(title: 'no_faq_found')
          else ...[
            Text(
              getTranslated('faq_list', context) ?? 'FAQ List',
              style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Consumer<WholesaleProductDetailsController>(
              builder: (context, controller, _) => Column(
                children: [
                  for (int index = 0; index < faqs.length; index++)
                    _FaqCard(
                      faq: faqs[index],
                      isExpanded: controller.expandedFaqIndex == index,
                      onTap: () => controller.toggleFaq(index),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  final WholesaleFaq faq;
  final bool isExpanded;
  final VoidCallback onTap;
  const _FaqCard({required this.faq, required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: ThemeShadow.getShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  faq.question ?? '',
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              _FaqActionMenu(faq: faq),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeOrder,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${getTranslated('priority', context) ?? 'Priority'} ',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      TextSpan(
                        text: '${faq.priority ?? 0}',
                        style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: Dimensions.iconSizeMedium,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),

          if (isExpanded) ...[
            const SizedBox(height: Dimensions.paddingSizeMedium),
            Text(
              faq.answer ?? '',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _FaqAction { edit, delete }

class _FaqActionMenu extends StatelessWidget {
  final WholesaleFaq faq;
  const _FaqActionMenu({required this.faq});

  void _openEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WholesaleProductFaqEditBottomSheetWidget(faq: faq),
    );
  }

  void _confirmDelete(BuildContext context) {
    showAnimatedDialogWidget(
      context,
      Consumer<WholesaleProductDetailsController>(
        builder: (dialogContext, controller, _) => CustomConfirmationDialogWidget(
          iconWidget: Icon(Icons.delete_outline, size: 50, color: Theme.of(context).colorScheme.error),
          title: getTranslated('delete_faq', context) ?? 'Delete FAQ',
          description: getTranslated('are_you_sure_you_want_to_delete_this_faq', context) ?? '',
          yesButtonText: getTranslated('delete', context) ?? 'Delete',
          noButtonText: getTranslated('cancel', context) ?? 'Cancel',
          isLoading: controller.isFaqUpdating,
          onYesPressed: () async {
            final bool isSuccess = await controller.deleteFaq(faq);
            if (isSuccess && dialogContext.mounted) Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = robotoRegular.copyWith(
      fontSize: Dimensions.fontSizeDefault,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );

    return PopupMenuButton<_FaqAction>(
      padding: EdgeInsets.zero,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      onSelected: (action) {
        if (action == _FaqAction.edit) {
          _openEditSheet(context);
        } else {
          _confirmDelete(context);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem<_FaqAction>(
          enabled: false,
          child: Consumer<WholesaleProductDetailsController>(
            builder: (context, controller, _) {
              final WholesaleFaq current = controller.faqs.firstWhere((item) => item.id == faq.id, orElse: () => faq);
              return Row(children: [
                Expanded(child: Text(getTranslated('statuss', context) ?? 'Status', style: labelStyle)),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                FlutterSwitch(
                  width: 50.0, height: 26.0, toggleSize: 22.0, padding: 2.0,
                  value: current.status,
                  activeColor: Theme.of(context).primaryColor,
                  disabled: controller.isFaqStatusUpdating(faq.id),
                  onToggle: (_) => controller.toggleFaqStatus(current),
                ),
              ]);
            },
          ),
        ),
        PopupMenuItem<_FaqAction>(
          value: _FaqAction.edit,
          child: Row(children: [
            const CustomAssetImageWidget(Images.editIconSvg, height: Dimensions.iconSizeMedium, width: Dimensions.iconSizeMedium),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Text(getTranslated('edit', context) ?? 'Edit', style: labelStyle),
          ]),
        ),
        PopupMenuItem<_FaqAction>(
          value: _FaqAction.delete,
          child: Row(children: [
            const CustomAssetImageWidget(Images.deleteIconSvg, height: Dimensions.iconSizeMedium, width: Dimensions.iconSizeMedium),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Text(getTranslated('delete', context) ?? 'Delete', style: labelStyle),
          ]),
        ),
      ],
      child: Icon(Icons.more_vert, size: Dimensions.iconSizeMedium, color: Theme.of(context).hintColor),
    );
  }
}
