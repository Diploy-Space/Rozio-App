import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_details_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/enums/wholesale_refund_status.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/widgets/wholesale_refund_card_widget.dart' show wholesaleRefundStatusColor;
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleRefundChangeLogWidget extends StatelessWidget {
  final List<RefundStatus> statusLogs;
  final String? paidBy;
  const WholesaleRefundChangeLogWidget({super.key, required this.statusLogs, this.paidBy});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(getTranslated('refund_status_change_log', context) ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
                InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.close)),
              ],
            ),
            if (paidBy != null) ...[
              const SizedBox(height: Dimensions.paddingSizeSmall),
              _ItemWidget(label: getTranslated('paid_by', context) ?? 'Paid by', value: getTranslated(paidBy!, context) ?? paidBy!.replaceAll('_', ' ')),
            ],
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(statusLogs.length, (index) {
                    final RefundStatus log = statusLogs[index];
                    final WholesaleRefundStatus status = WholesaleRefundStatus.fromString(log.status);
                    final bool isLast = index == statusLogs.length - 1;
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(children: [
                            Icon(Icons.circle, size: 10, color: wholesaleRefundStatusColor(context, status)),
                            if (!isLast) Expanded(child: Container(width: 1, color: Theme.of(context).hintColor.withValues(alpha: .3))),
                          ]),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _ItemWidget(label: getTranslated('status', context) ?? 'Status', value: getTranslated(status.translationKey, context) ?? status.translationKey),
                                  _ItemWidget(label: getTranslated('updated_by', context) ?? 'Updated by', value: log.changeBy ?? ''),
                                  if (log.message != null && log.message!.isNotEmpty)
                                    _ItemWidget(label: getTranslated('reason', context) ?? 'Reason', value: log.message!),
                                  if (log.createdAt != null)
                                    Text(DateConverter.isoStringToLocalDateAndTime(log.createdAt!), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final String label;
  final String value;
  const _ItemWidget({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text.rich(TextSpan(children: [
        TextSpan(text: '$label: ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color)),
        TextSpan(text: value, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
      ])),
    );
  }
}
