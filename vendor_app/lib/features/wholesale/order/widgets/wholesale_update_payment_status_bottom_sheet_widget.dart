import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_drop_down_item_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/controllers/wholesale_order_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleUpdatePaymentStatusBottomSheetWidget extends StatefulWidget {
  final Order order;
  const WholesaleUpdatePaymentStatusBottomSheetWidget({super.key, required this.order});

  @override
  State<WholesaleUpdatePaymentStatusBottomSheetWidget> createState() => _WholesaleUpdatePaymentStatusBottomSheetWidgetState();
}

class _WholesaleUpdatePaymentStatusBottomSheetWidgetState extends State<WholesaleUpdatePaymentStatusBottomSheetWidget> {
  static const List<String> _statusList = ['paid', 'unpaid'];
  late String _selectedStatus = widget.order.paymentStatus ?? 'unpaid';

  Future<void> _onUpdate(WholesaleOrderController wholesaleOrderController) async {
    if (_selectedStatus == widget.order.paymentStatus) {
      showCustomSnackBarWidget(getTranslated('there_is_no_change_to_update', context), context, sanckBarType: SnackBarType.warning);
      return;
    }

    await wholesaleOrderController.markPaid(widget.order);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.cancel_outlined, size: Dimensions.iconSizeMedium, color: Theme.of(context).hintColor),
          ),
        ),

        Text(getTranslated('update_payment_status', context) ?? '',
          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
        const SizedBox(height: Dimensions.paddingSizeMedium),

        CustomDropDownItemWidget(
          title: 'payment_status',
          widget: DropdownButtonFormField<String>(
            initialValue: _selectedStatus,
            isExpanded: true,
            decoration: const InputDecoration(border: InputBorder.none),
            iconSize: 24, elevation: 16, style: robotoRegular,
            onChanged: widget.order.paymentStatus == 'paid' ? null : (value) => setState(() => _selectedStatus = value ?? _selectedStatus),
            items: _statusList.map((value) => DropdownMenuItem<String>(
              value: value,
              child: Text(getTranslated(value, context) ?? value, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
            )).toList(),
          ),
        ),

        Consumer<WholesaleOrderController>(
          builder: (context, wholesaleOrderController, _) => Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: CustomButtonWidget(
              isLoading: wholesaleOrderController.isUpdating,
              btnTxt: getTranslated('update', context),
              backgroundColor: Theme.of(context).primaryColor,
              borderRadius: 8,
              onTap: () => _onUpdate(wholesaleOrderController),
            ),
          ),
        ),
      ]),
    );
  }
}
