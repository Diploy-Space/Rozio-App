import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_details_model.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/refund/controllers/refund_controller.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/helper/debounce_helper.dart';

class ApprovedAndRejectWidget extends StatefulWidget {
  final RefundModel? refundModel;
  final int? orderDetailsId;
  const ApprovedAndRejectWidget({super.key, this.refundModel, this.orderDetailsId});

  @override
  State<ApprovedAndRejectWidget> createState() => _ApprovedAndRejectWidgetState();
}

class _ApprovedAndRejectWidgetState extends State<ApprovedAndRejectWidget> {
  bool approved = false;
  bool reject = false;
  final TextEditingController noteController = TextEditingController();
  final DebounceHelper _rejectDebounce = DebounceHelper(milliseconds: 500);
  final DebounceHelper _approveDebounce = DebounceHelper(milliseconds: 500);

  @override
  void dispose() {
    _rejectDebounce.dispose();
    _approveDebounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RefundController>(
        builder: (context,refundReq,_) {
          if(refundReq.refundDetailsModel != null){
            List<RefundStatus>? status =[];

            if(refundReq.refundDetailsModel?.refundRequest != null && refundReq.refundDetailsModel!.refundRequest!.isNotEmpty){
              status = refundReq.refundDetailsModel?.refundRequest![0].refundStatus;
            }

            if(status!.isNotEmpty){
              if(status[status.length-1].status == 'approved'){
                approved = true;
                reject = false;
              }else if(status[status.length-1].status == 'rejected'){
                approved = false;
                reject = true;
              }
            }
          }
          return Container(
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: ThemeShadow.getShadow(context),
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeSmall, vertical: Dimensions.paddingSizeSmall),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                if(!reject)
                Expanded(
                  child: CustomButtonWidget(
                    buttonHeight: 50,
                    borderRadius: Dimensions.paddingSizeSmall,
                    btnTxt: getTranslated('reject', context),
                    fontColor: Colors.red,
                    backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.125),
                    onTap: (){
                      if(widget.refundModel!.customer == null){
                        showCustomSnackBarWidget(getTranslated('customer_account_was_deleted_you_cant_update_status', context), context);
                      }else{
                       //  Navigator.pop(context);
                        showDialog(context: context, builder: (BuildContext context){
                          return StatefulBuilder(
                            builder: (context, setDialogState) {
                              return ConfirmationDialogWidget(icon:  Images.cross,
                                  description: getTranslated('are_you_sure_want_to_reject', context),
                                  note: noteController,
                                  refund: true,
                                  isLoading: refundReq.isLoading,
                                  onYesPressed: () => _rejectDebounce.run(() async {
                                    if(refundReq.isLoading) return;
                                    if(noteController.text.trim().isEmpty) {
                                      showCustomToast(isSuccess: false, message: getTranslated('note_required', context) ?? '', context: context);
                                      return;
                                    }
                                    final future = refundReq.updateRefundStatus(context, widget.refundModel!.id, 'rejected', noteController.text.trim());
                                    setDialogState(() {});
                                    final value = await future;
                                    if(value.response?.statusCode ==200) {
                                      Provider.of<RefundController>(Get.context!, listen: false).getRefundReqInfo(Get.context!, widget.refundModel!.id);
                                      Provider.of<RefundController>(Get.context!, listen: false).getRefundList(Get.context!);
                                      Navigator.pop(Get.context!);
                                      noteController.clear();
                                    } else {
                                      setDialogState(() {});
                                    }
                                  })
                              );
                            },
                          );
                        });
                      }
                    },
                  ),
                ),

                if(!reject && !approved)
                const SizedBox(width: Dimensions.paddingSizeDefault),

                if(!approved)
                  Expanded(
                    child: CustomButtonWidget(
                      buttonHeight: 50,
                      borderRadius: Dimensions.paddingSizeSmall,
                      btnTxt: getTranslated('approve', context),
                      backgroundColor: Theme.of(context).primaryColor,
                      onTap: (){
                        if(widget.refundModel!.customer == null){
                          showCustomSnackBarWidget(getTranslated('customer_account_was_deleted_you_cant_update_status', context), context);
                        }else{
                          // Navigator.pop(context);
                          showDialog(context: context,barrierDismissible: false, builder: (BuildContext context){
                            return StatefulBuilder(
                              builder: (context, setDialogState) {
                                return ConfirmationDialogWidget(
                                  icon:  Images.okIcon,
                                  description: getTranslated('are_you_sure_want_to_approve', context),
                                  note: noteController,
                                  refund: true,
                                  isLoading: refundReq.isLoading,
                                  onYesPressed: () => _approveDebounce.run(() async {
                                    if(refundReq.isLoading) return;
                                    final future = refundReq.updateRefundStatus(context, widget.refundModel!.id, 'approved',noteController.text.trim());
                                    setDialogState(() {});
                                    final value = await future;
                                    if(value.response!.statusCode == 200) {
                                      Provider.of<RefundController>(Get.context!, listen: false).getRefundReqInfo(Get.context!, widget.refundModel!.id);
                                      Provider.of<RefundController>(Get.context!, listen: false).getRefundList(Get.context!);
                                      Navigator.pop(Get.context!);
                                      noteController.clear();
                                    } else {
                                      setDialogState(() {});
                                    }
                                  }),
                                );
                              },
                            );
                          });
                        }},
                    ),
                  ),
              ],
            ),
          );
        }
    );
  }
}
