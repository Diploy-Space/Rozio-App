import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_drop_down_item_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/models/order_details_model.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/third_party_deliveryman/controllers/third_party_deliveryman_controller.dart';
import 'package:sixvalley_vendor_app/features/third_party_deliveryman/widgets/courier_provider_selection_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/controllers/wholesale_order_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/enums/wholesale_order_setup_step.dart';
import 'package:sixvalley_vendor_app/features/wholesale/third_party_deliveryman/controllers/wholesale_third_party_deliveryman_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleOrderSetupBottomSheet extends StatefulWidget {
  final Order order;
  final bool onlyDigital;
  final CourierShipmentModel? courierShipment;
  const WholesaleOrderSetupBottomSheet({super.key, required this.order, required this.onlyDigital, this.courierShipment});

  @override
  State<WholesaleOrderSetupBottomSheet> createState() => _WholesaleOrderSetupBottomSheetState();
}

class _WholesaleOrderSetupBottomSheetState extends State<WholesaleOrderSetupBottomSheet> {
  static const List<String> _paymentStatusList = ['paid', 'unpaid'];

  late String? _orderStatus = widget.order.orderStatus;
  late String? _paymentStatus = widget.order.paymentStatus;

  bool get _isInHouseShipping => widget.order.shippingResponsibility == 'inhouse_shipping';

  bool get _isStatusLocked => _isInHouseShipping && ['out_for_delivery', 'delivered', 'returned', 'failed', 'canceled'].contains(widget.order.orderStatus);

  bool get _deliverySetUpExist => widget.order.shippingResponsibility == 'sellerwise_shipping' && !widget.onlyDigital && widget.order.orderType != 'POS';

  int get _deliveryTypeIndex {
    final String? type = widget.order.deliveryType;
    if (type == 'third_party_delivery') return 2;
    if (type == 'self_delivery' || type == 'by_self_delivery_man' || widget.order.deliveryManId != null) return 1;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    if (_deliverySetUpExist) {
      final DeliveryManController deliveryManController = Provider.of<DeliveryManController>(context, listen: false);
      deliveryManController.setDeliveryTypeIndex(_deliveryTypeIndex, false);
      deliveryManController.getDeliveryManList(widget.order);
      deliveryManController.deliveryManChargeTextEditingController.text = widget.order.deliverymanCharge?.toString() ?? '';
      deliveryManController.expectedDeliveryDateTextEditingController.text = widget.order.expectedDeliveryDate ?? '';
      deliveryManController.thirdPartyShippingNameTextEditingController.text = widget.order.thirdPartyServiceName ?? '';
      deliveryManController.thirdPartyShippingTrackingIdTextEditingController.text = widget.order.thirdPartyTrackingId ?? '';
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: Dimensions.fontSizeDefault,
    );
  }

  Future<void> _selectExpectedDate(DeliveryManController deliveryManController) async {
    final WholesaleOrderController wholesaleOrderController = Provider.of<WholesaleOrderController>(context, listen: false);
    final String currentText = deliveryManController.expectedDeliveryDateTextEditingController.text;

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(currentText) ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      deliveryManController.expectedDeliveryDateTextEditingController.text = wholesaleOrderController.dateFormat.format(date);
    }
  }

  Future<void> _onUpdate(WholesaleOrderController wholesaleOrderController) async {
    final DeliveryManController deliveryManController = Provider.of<DeliveryManController>(context, listen: false);
    final int deliveryTypeIndex = deliveryManController.selectedDeliveryTypeIndex;
    final int selectedIndex = deliveryManController.deliveryManIndex ?? 0;
    final int deliveryManIndex = (selectedIndex > 0 && selectedIndex < deliveryManController.deliveryManIds.length) ? selectedIndex : 0;

    final bool isOwnDelivery = _deliverySetUpExist && deliveryTypeIndex == 1;
    final bool hasDeliveryMan = isOwnDelivery && deliveryManIndex != 0;

    final int? deliveryManId = hasDeliveryMan ? deliveryManController.deliveryManIds[deliveryManIndex] : null;
    final String chargeText = deliveryManController.deliveryManChargeTextEditingController.text.trim();
    final double? deliverymanCharge = hasDeliveryMan ? double.tryParse(chargeText) : null;
    final String? expectedDeliveryDate = hasDeliveryMan ? deliveryManController.expectedDeliveryDateTextEditingController.text.trim() : null;

    final List<WholesaleOrderSetupStep> steps = WholesaleOrderController.changedSetupSteps(
      order: widget.order,
      orderStatus: _orderStatus,
      paymentStatus: _paymentStatus,
      deliveryManId: deliveryManId,
      deliverymanCharge: deliverymanCharge,
      expectedDeliveryDate: expectedDeliveryDate,
    );

    if (steps.isEmpty) {
      if (isOwnDelivery && deliveryManIndex == 0) {
        _showToast(getTranslated('please_select_delivery_man', context)!);
      } else if (hasDeliveryMan && chargeText.isEmpty) {
        _showToast(getTranslated('please_enter_delivery_incentive', context)!);
      } else {
        _showToast(getTranslated('there_is_no_change_to_update', context)!);
      }
      return;
    }

    await wholesaleOrderController.setUpOrder(
      order: widget.order,
      steps: steps,
      orderStatus: _orderStatus,
      deliveryManId: deliveryManId,
      deliverymanCharge: deliverymanCharge,
      expectedDeliveryDate: expectedDeliveryDate,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyBoardHeight),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.cancel_outlined, size: Dimensions.iconSizeMedium, color: Theme.of(context).hintColor),
            ),
          ),

          Text(getTranslated('order_setup', context)!,
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
          const SizedBox(height: Dimensions.paddingSizeMedium),

          Consumer<WholesaleOrderController>(builder: (context, wholesaleOrderController, _) {
            return Flexible(
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _isStatusLocked
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(width: .5, color: Theme.of(context).hintColor.withValues(alpha: .125)),
                            color: Theme.of(context).hintColor.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSize),
                            child: Text(getTranslated(widget.order.orderStatus, context) ?? ''),
                          ),
                        ),
                      )
                    : CustomDropDownItemWidget(
                        title: 'order_status',
                        widget: DropdownButtonFormField<String>(
                          initialValue: wholesaleOrderController.orderStatusList.contains(_orderStatus) ? _orderStatus : null,
                          isExpanded: true,
                          decoration: const InputDecoration(border: InputBorder.none),
                          iconSize: 24,
                          elevation: 16,
                          style: robotoRegular,
                          onChanged: widget.order.orderStatus == 'delivered' ? null : (value) => _orderStatus = value,
                          items: wholesaleOrderController.orderStatusList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(getTranslated(value, context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                            );
                          }).toList(),
                        ),
                      ),

                  CustomDropDownItemWidget(
                    title: 'payment_status',
                    widget: DropdownButtonFormField<String>(
                      initialValue: _paymentStatus,
                      isExpanded: true,
                      decoration: const InputDecoration(border: InputBorder.none),
                      iconSize: 24,
                      elevation: 16,
                      style: robotoRegular,
                      onChanged: widget.order.paymentStatus == 'paid' ? null : (value) => _paymentStatus = value,
                      items: _paymentStatusList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getTranslated(value, context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                        );
                      }).toList(),
                    ),
                  ),

                  if (_isInHouseShipping) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(children: [
                        CustomAssetImageWidget(Images.infoIcon, height: 15, width: 15),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          child: Text(getTranslated('this_order_was_placed_with_the_inhouse_shipping', context)!,
                            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                        ),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ],

                  if (_deliverySetUpExist)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: _DeliverySetupSection(
                        order: widget.order,
                        courierShipment: widget.courierShipment,
                        onDispatchSuccess: () => wholesaleOrderController.getOrderDetails(widget.order.id!, reload: false),
                        isDelivered: widget.order.orderStatus == 'delivered',
                        onSelectDate: _selectExpectedDate,
                      ),
                    ),
                ]),
              ),
            );
          }),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -2)),
              ],
            ),
            child: Consumer<WholesaleOrderController>(
              builder: (_, wholesaleOrderController, __) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
                child: CustomButtonWidget(
                  isLoading: wholesaleOrderController.isUpdating,
                  btnTxt: getTranslated('update', context),
                  backgroundColor: Theme.of(context).primaryColor,
                  borderRadius: 8,
                  onTap: () => _onUpdate(wholesaleOrderController),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _DeliverySetupSection extends StatelessWidget {
  final Order order;
  final CourierShipmentModel? courierShipment;
  final Future<void> Function()? onDispatchSuccess;
  final bool isDelivered;
  final Future<void> Function(DeliveryManController deliveryManController) onSelectDate;
  const _DeliverySetupSection({
    required this.order,
    required this.courierShipment,
    required this.onDispatchSuccess,
    required this.isDelivered,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    final bool deliveryPartnerSetupEnabled =
        Provider.of<SplashController>(context, listen: false).configModel?.wholesaleDeliveryPartnerSetupStatus == true;
    final bool alreadyThirdParty = order.deliveryType == 'third_party_delivery';
    final bool showThirdPartyOption = deliveryPartnerSetupEnabled || alreadyThirdParty;

    return Consumer<DeliveryManController>(builder: (context, deliveryManController, _) {
      final int deliveryTypeIndex = deliveryManController.selectedDeliveryTypeIndex;
      final List<String> deliveryTypeList = deliveryManController.deliveryTypeList.where((value) => value != 'by_third_party_delivery_service' || showThirdPartyOption).toList();

      return Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(getTranslated('delivery_type', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              border: Border.all(width: .5, color: Theme.of(context).hintColor.withValues(alpha: .5)),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            ),
            alignment: Alignment.center,
            child: DropdownButtonFormField<String>(
              initialValue: deliveryTypeIndex == 0 ? 'select_delivery_type' : deliveryTypeIndex == 1 ? 'by_self_delivery_man' : 'by_third_party_delivery_service',
              isExpanded: true,
              decoration: const InputDecoration(border: InputBorder.none),
              iconSize: 24,
              elevation: 16,
              style: titilliumRegular,
              items: deliveryTypeList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(getTranslated(value, context)!, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                );
              }).toList(),
              onChanged: isDelivered ? null
                  : (String? value) => deliveryManController.setDeliveryTypeIndex(value == 'select_delivery_type' ? 0 : value == 'by_self_delivery_man' ? 1 : 2, true),
            ),
          ),

          if (deliveryTypeIndex == 2) ...[
            const SizedBox(height: Dimensions.paddingSizeDefault),
            ChangeNotifierProvider<ThirdPartyDeliverymanController>.value(
              value: Provider.of<WholesaleThirdPartyDeliverymanController>(context, listen: false),
              child: CourierProviderSelectionWidget(
                orderModel: order,
                courierShipment: courierShipment,
                onDispatchSuccess: onDispatchSuccess,
                deliveryPartnerSetupEnabled: deliveryPartnerSetupEnabled,
              ),
            ),
          ],

          if (deliveryTypeIndex == 1) ...[
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Text(getTranslated('deliveryman', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              border: Border.all(width: .5, color: Theme.of(context).hintColor.withValues(alpha: .5)),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            ),
            alignment: Alignment.center,
            child: DropdownButtonFormField<int>(
              initialValue: deliveryManController.deliveryManIndex,
              isExpanded: true,
              decoration: const InputDecoration(border: InputBorder.none),
              iconSize: 24,
              elevation: 16,
              style: titilliumRegular,
              items: List.generate(deliveryManController.deliveryManIds.length, (index) {
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(
                    index != 0
                      ? '${deliveryManController.deliveryManList![index - 1].fName} ${deliveryManController.deliveryManList![index - 1].lName}'
                      : getTranslated('select_delivery_man', context)!,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                );
              }),
              onChanged: isDelivered ? null : (int? value) => deliveryManController.setDeliverymanIndex(value, true),
            ),
          ),

          if ((deliveryManController.deliveryManIndex ?? 0) != 0) ...[
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Text(getTranslated('additional_delivery_man_fee', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: CustomTextFieldWidget(
                hintText: getTranslated('delivery_man_charge', context),
                idDate: isDelivered,
                border: true,
                controller: deliveryManController.deliveryManChargeTextEditingController,
                isAmount: true,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(getTranslated('expected_delivery_date', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            GestureDetector(
              onTap: isDelivered ? null : () => onSelectDate(deliveryManController),
              child: AbsorbPointer(
                child: CustomTextFieldWidget(
                  hintText: getTranslated('expected_delivery_date', context),
                  border: true,
                  controller: deliveryManController.expectedDeliveryDateTextEditingController,
                  idDate: false,
                  suffixIconImage: Images.calenderIcon,
                  readOnly: true,
                ),
              ),
            ),
          ],
          ],
        ]),
      );
    });
  }
}
