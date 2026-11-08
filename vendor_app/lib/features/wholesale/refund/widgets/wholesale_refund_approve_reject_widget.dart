import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/controllers/wholesale_refund_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/enums/wholesale_refund_status.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleRefundApproveRejectWidget extends StatefulWidget {
  final RefundModel refund;
  final WholesaleRefundStatus status;
  const WholesaleRefundApproveRejectWidget({super.key, required this.refund, required this.status});

  @override
  State<WholesaleRefundApproveRejectWidget> createState() => _WholesaleRefundApproveRejectWidgetState();
}

class _WholesaleRefundApproveRejectWidgetState extends State<WholesaleRefundApproveRejectWidget> {
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void _openDialog(WholesaleRefundStatus status) {
    if (widget.refund.customer == null) {
      showCustomSnackBarWidget(getTranslated('customer_account_was_deleted_you_cant_update_status', context), context);
      return;
    }

    noteController.clear();
    final bool isReject = status == WholesaleRefundStatus.rejected;

    showDialog(
      context: context,
      barrierDismissible: !isReject,
      builder: (dialogContext) => Consumer<WholesaleRefundController>(
        builder: (_, wholesaleRefundController, __) => ConfirmationDialogWidget(
          icon: isReject ? Images.cross : Images.okIcon,
          description: getTranslated(isReject ? 'are_you_sure_want_to_reject' : 'are_you_sure_want_to_approve', context),
          note: noteController,
          refund: true,
          isLoading: wholesaleRefundController.isUpdating,
          onYesPressed: () async {
            if (wholesaleRefundController.isUpdating) return;
            if (isReject && noteController.text.trim().isEmpty) {
              showCustomToast(isSuccess: false, message: getTranslated('note_required', context) ?? '', context: context);
              return;
            }

            final bool isSuccess = await wholesaleRefundController.updateRefundStatus(widget.refund, status, noteController.text.trim());
            if (isSuccess && dialogContext.mounted) {
              Navigator.pop(dialogContext);
              noteController.clear();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool approved = widget.status == WholesaleRefundStatus.approved;
    final bool rejected = widget.status == WholesaleRefundStatus.rejected;

    return Container(
      height: 80,
      decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: ThemeShadow.getShadow(context)),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeSmall, vertical: Dimensions.paddingSizeSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        if (!rejected)
          Expanded(
            child: CustomButtonWidget(
              buttonHeight: 50,
              borderRadius: Dimensions.paddingSizeSmall,
              btnTxt: getTranslated('reject', context),
              fontColor: Colors.red,
              backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.125),
              onTap: () => _openDialog(WholesaleRefundStatus.rejected),
            ),
          ),

        if (!rejected && !approved) const SizedBox(width: Dimensions.paddingSizeDefault),

        if (!approved)
          Expanded(
            child: CustomButtonWidget(
              buttonHeight: 50,
              borderRadius: Dimensions.paddingSizeSmall,
              btnTxt: getTranslated('approve', context),
              backgroundColor: Theme.of(context).primaryColor,
              onTap: () => _openDialog(WholesaleRefundStatus.approved),
            ),
          ),
      ]),
    );
  }
}
