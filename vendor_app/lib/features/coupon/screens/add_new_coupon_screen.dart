import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/coupon/domain/models/coupon_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:sixvalley_vendor_app/features/coupon/controllers/coupon_controller.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_date_picker_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_drop_down_item_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_field_with_title_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/pos/screens/customer_search_screen.dart';

class AddNewCouponScreen extends StatefulWidget {
  final Coupons? coupons;
  const AddNewCouponScreen({super.key, this.coupons});

  @override
  State<AddNewCouponScreen> createState() => _AddNewCouponScreenState();
}

class _AddNewCouponScreenState extends State<AddNewCouponScreen> {
  TextEditingController couponTitleController = TextEditingController();
  TextEditingController limitController = TextEditingController();
  TextEditingController couponCodeController = TextEditingController();
  TextEditingController discountAmountController = TextEditingController();
  TextEditingController minimumPurchaseController = TextEditingController();
  TextEditingController maximumDiscountController = TextEditingController();

  bool update = false;
  final Map<String, String> _errors = {};

  @override
  void initState() {
    update = widget.coupons != null ? true : false;

    if (update) {
      couponTitleController.text = widget.coupons!.title!;
      couponCodeController.text = widget.coupons!.code!;
      discountAmountController.text = widget.coupons?.discountType == 'amount'
          ? PriceConverter.convertPriceWithoutSymbol(Get.context!, widget.coupons!.discount)
          : widget.coupons!.discount.toString();
      minimumPurchaseController.text = PriceConverter.convertPriceWithoutSymbol(Get.context!, widget.coupons!.minPurchase);
      limitController.text = widget.coupons!.limit?.toString() ?? '';
      maximumDiscountController.text = PriceConverter.convertPriceWithoutSymbol(Get.context!, widget.coupons!.maxDiscount);
      Provider.of<CouponController>(context, listen: false).startDate = DateTime.tryParse(widget.coupons!.startDate ?? '')?.toLocal();
      Provider.of<CouponController>(context, listen: false).endDate = DateTime.tryParse(widget.coupons!.expireDate ?? '')?.toLocal();
      Provider.of<CouponController>(context, listen: false).initCouponTypes(widget.coupons!.couponType, widget.coupons!.discountType);
      Provider.of<CouponController>(context, listen: false).initCouponCustomer(widget.coupons!.customerId);
    } else {
      Provider.of<CouponController>(context, listen: false).clearCouponData();
    }
    Provider.of<CouponController>(context, listen: false).getCouponCustomerList(context, '');
    super.initState();
  }

  String? _errorOf(String field) =>
      _errors[field] != null ? getTranslated(_errors[field], context) : null;

  void _clearError(String field) {
    if (_errors.containsKey(field)) {
      setState(() => _errors.remove(field));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('coupon_setup', context)),
      body: Consumer<CouponController>(builder: (context, coupon, _) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  CustomDropDownItemWidget(
                    title: 'coupon_type',
                    requiredField: true,
                    errorText: coupon.selectedCouponType == null ? _errorOf('coupon_type') : null,
                    widget: DropdownButtonFormField<String>(
                      initialValue: coupon.selectedCouponType,
                      isExpanded: true,
                      hint: Text(
                          getTranslated('select_coupon_type', context) ?? 'Select coupon type',
                          style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                      decoration: const InputDecoration(border: InputBorder.none),
                      iconSize: 24,
                      elevation: 16,
                      style: robotoRegular,
                      onChanged: (value) {
                        coupon.setSelectedCouponType(value);
                      },
                      items: coupon.couponTypeList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getTranslated(value, context)!,
                              style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                        );
                      }).toList(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Dimensions.paddingSizeDefault,
                            Dimensions.paddingSizeSmall,
                            Dimensions.paddingSizeDefault,
                            Dimensions.paddingSizeExtraSmall),
                        child: Text.rich(TextSpan(
                            text: getTranslated('select_customer', context)!,
                            style: robotoRegular.copyWith(
                                color: Theme.of(context).textTheme.bodyLarge?.color),
                            children: [
                              TextSpan(
                                  text: ' *',
                                  style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error))
                            ]))),
                  ),
                  GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerSearchScreen(isCoupon: true))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: .25,
                                    color: Theme.of(context).hintColor.withValues(alpha: .75)),
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeSmall),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                          coupon.searchCustomerController.text.isNotEmpty
                                              ? coupon.searchCustomerController.text
                                              : coupon.selectedCustomerIdForCoupon != null
                                                  ? '${getTranslated('customer', context)} #${coupon.selectedCustomerIdForCoupon}'
                                                  : getTranslated('select_customer', context) ?? '',
                                          style: robotoRegular.copyWith(
                                              color: coupon.selectedCustomerIdForCoupon != null
                                                  ? Theme.of(context).textTheme.bodyLarge?.color
                                                  : Theme.of(context).hintColor))),
                                  Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor)
                                ],
                              ),
                            )),
                      )),
                  if (coupon.selectedCustomerIdForCoupon == null &&
                      _errorOf('customer') != null)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Dimensions.paddingSizeDefault,
                            Dimensions.paddingSizeExtraSmall,
                            Dimensions.paddingSizeDefault,
                            0),
                        child: Text(_errorOf('customer')!,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error)),
                      ),
                    ),
                  const SizedBox(
                    height: Dimensions.paddingSizeMedium,
                  ),
                  CustomFieldWithTitleWidget(
                    isCoupon: true,
                    title: getTranslated('coupon_title', context),
                    requiredField: true,
                    errorText: _errorOf('title'),
                    customTextField: CustomTextFieldWidget(
                      border: true,
                      controller: couponTitleController,
                      onChanged: (_) => _clearError('title'),
                      hintText: getTranslated('coupon_title_hint', context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault,
                        vertical: Dimensions.paddingSizeDefault),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text.rich(TextSpan(
                                text: getTranslated('coupon_code', context)!,
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: Theme.of(context).textTheme.bodyLarge?.color),
                                children: [
                                  TextSpan(
                                      text: ' *',
                                      style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error))
                                ])),
                            const Spacer(),
                            InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                  Random rnd = Random();

                                  String getRandomString(int length) =>
                                      String.fromCharCodes(Iterable.generate(
                                          length,
                                          (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
                                  var code = getRandomString(10);
                                  couponCodeController.text = code.toString();
                                  _clearError('code');
                                },
                                child: Text(
                                    getTranslated('generate_code', context)!,
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor))),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        CustomTextFieldWidget(
                          controller: couponCodeController,
                          onChanged: (_) => _clearError('code'),
                          border: true,
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
                          ],
                          maxSize: 15,
                          hintText: 'Ex: ze5uzkyu0s',
                        ),
                        if (_errorOf('code') != null) ...[
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(_errorOf('code')!,
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).colorScheme.error)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  CustomFieldWithTitleWidget(
                    isCoupon: true,
                    title: getTranslated('limit_for_same_user', context),
                    requiredField: true,
                    errorText: _errorOf('limit'),
                    customTextField: CustomTextFieldWidget(
                      border: true,
                      isFullNumber: true,
                      textInputType: TextInputType.number,
                      controller: limitController,
                      onChanged: (_) => _clearError('limit'),
                      hintText: getTranslated('limit_user_hint', context),
                    ),
                  ),
                  coupon.selectedCouponType == 'discount_on_purchase' ? const SizedBox(height: Dimensions.paddingSizeMedium) : const SizedBox.shrink(),
                  coupon.selectedCouponType == 'discount_on_purchase'
                      ? CustomDropDownItemWidget(
                          title: 'discount_type',
                          widget: DropdownButtonFormField<String>(
                            initialValue: coupon.discountTypeName,
                            isExpanded: true,
                            decoration: const InputDecoration(border: InputBorder.none),
                            iconSize: 24,
                            elevation: 16,
                            style: robotoRegular,
                            onChanged: (value) {
                              coupon.setSelectedDiscountNameType(value);
                            },
                            items: coupon.discountTypeList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(getTranslated(value, context)!,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).textTheme.bodyLarge!.color)),
                              );
                            }).toList(),
                          ),
                        )
                      : const SizedBox.shrink(),
                  coupon.selectedCouponType == 'discount_on_purchase'
                      ? const SizedBox(height: Dimensions.paddingSizeExtraSmall)
                      : const SizedBox.shrink(),
                  coupon.selectedCouponType == 'discount_on_purchase'
                      ? CustomFieldWithTitleWidget(
                          isCoupon: true,
                          title: getTranslated(coupon.discountTypeName == 'percentage' ? 'discount_percentage' : 'discount_amount', context),
                          requiredField: true,
                          errorText: _errorOf('discount'),
                          customTextField: CustomTextFieldWidget(
                            border: true,
                            isAmount: true,
                            controller: discountAmountController,
                            onChanged: (_) => _clearError('discount'),
                            hintText: getTranslated(coupon.discountTypeName == 'percentage' ? 'discount_percentage_hint' : 'discount_amount_hint', context),
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: Dimensions.paddingSizeMedium),
                  CustomFieldWithTitleWidget(
                    isCoupon: true,
                    title: getTranslated('minimum_purchase', context),
                    requiredField: true,
                    errorText: _errorOf('min_purchase'),
                    customTextField: CustomTextFieldWidget(
                      border: true,
                      isAmount: true,
                      textInputAction: TextInputAction.done,
                      controller: minimumPurchaseController,
                      onChanged: (_) => _clearError('min_purchase'),
                      hintText: getTranslated('minimum_purchase_hint', context),
                    ),
                  ),
                  if (coupon.selectedCouponType != 'free_delivery' &&
                      coupon.discountTypeName == 'percentage')
                    const SizedBox(height: Dimensions.paddingSizeMedium),
                  if (coupon.selectedCouponType != 'free_delivery' &&
                      coupon.discountTypeName == 'percentage')
                    CustomFieldWithTitleWidget(
                        isCoupon: true,
                        title: getTranslated('maximum_discount', context),
                        requiredField: true,
                        errorText: _errorOf('max_discount'),
                        customTextField: CustomTextFieldWidget(
                            border: true,
                            isAmount: true,
                            textInputAction: TextInputAction.done,
                            controller: maximumDiscountController,
                            onChanged: (_) => _clearError('max_discount'),
                            hintText: getTranslated(
                                'minimum_purchase_hint', context))),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: CustomDatePickerWidget(
                        title: getTranslated('start_date', context),
                        requiredField: !update,
                        errorText: coupon.startDate == null ? _errorOf('start_date') : null,
                        image: Images.calenderIcon,
                        text: coupon.startDate != null ? coupon.dateFormat.format(coupon.startDate!).toString()
                            : getTranslated('select_date', context),
                        selectDate: () => coupon.selectDate("start", context),
                      )),
                      Expanded(
                          child: CustomDatePickerWidget(
                        title: getTranslated('expire_date', context),
                        requiredField: !update,
                        errorText: coupon.endDate == null ? _errorOf('end_date') : null,
                        image: Images.calenderIcon,
                        text: coupon.endDate != null ? coupon.dateFormat.format(coupon.endDate!).toString() : getTranslated('select_date', context),
                        selectDate: () => coupon.selectDate("end", context),
                      )),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeMedium),
                ],
              ),
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: ThemeShadow.getShadow(context)),
              child: Consumer<CouponController>(builder: (context, coupon, _) {
                return Consumer<CartController>(
                    builder: (context, customer, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault,
                        vertical: Dimensions.paddingSizeExtraLarge),
                    child: coupon.isAdd
                        ? const Center(child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator()))
                        : CustomButtonWidget(btnTxt: update ? getTranslated('update', context) : getTranslated('submit', context), onTap: () => _onSubmit(coupon)),
                  );
                });
              }))
        ]);
      }),
    );
  }

  void _onSubmit(CouponController coupon) {
    String? couponType = coupon.selectedCouponType;
    String couponTitle = couponTitleController.text.trim();
    String couponCode = couponCodeController.text.trim();
    String limitText = limitController.text.trim();
    String discountAmountText = discountAmountController.text.trim();
    String minimumPurchaseText = minimumPurchaseController.text.trim();
    String maxDiscountText = maximumDiscountController.text.trim();
    int? limit = int.tryParse(limitText);
    double? discountAmount = double.tryParse(discountAmountText);
    double? minimumPurchase = double.tryParse(minimumPurchaseText);
    double? maxDiscount = double.tryParse(maxDiscountText);
    bool isDiscountOnPurchase = couponType == 'discount_on_purchase';
    bool isPercentage = couponType != 'free_delivery' && coupon.discountTypeName == 'percentage';

    final Map<String, String> errors = {};
    if (couponType == null) {
      errors['coupon_type'] = 'please_select_coupon_type';
    }
    if (coupon.selectedCustomerIdForCoupon == null) {
      errors['customer'] = 'please_select_customer';
    }
    if (couponTitle.isEmpty) {
      errors['title'] = 'coupon_title_is_required';
    }
    if (couponCode.isEmpty) {
      errors['code'] = 'coupon_code_is_required';
    }
    if (limitText.isEmpty) {
      errors['limit'] = 'limit_is_required';
    } else if (limit == null || limit < 1) {
      errors['limit'] = 'invalid_limit';
    }
    if (isDiscountOnPurchase) {
      if (discountAmountText.isEmpty) {
        errors['discount'] = 'amount_is_required';
      } else if (discountAmount == null) {
        errors['discount'] = 'enter_a_valid_amount';
      } else if (isPercentage && discountAmount > 100) {
        errors['discount'] = 'discount_amount_should_be_less_then';
      }
    }
    if (minimumPurchaseText.isEmpty) {
      errors['min_purchase'] = 'minimum_purchase_is_required';
    } else if (minimumPurchase == null) {
      errors['min_purchase'] = 'enter_a_valid_amount';
    } else if (isDiscountOnPurchase &&
        coupon.discountTypeName == 'amount' &&
        discountAmount != null &&
        discountAmount > minimumPurchase) {
      errors['min_purchase'] =
          'minimum_purchase_amount_should_be_greater_than_the_discount_amount';
    }
    if (isPercentage) {
      if (maxDiscountText.isEmpty) {
        errors['max_discount'] = 'max_discount_is_required';
      } else if (maxDiscount == null) {
        errors['max_discount'] = 'enter_a_valid_amount';
      }
    }
    if (coupon.startDate == null && !update) {
      errors['start_date'] = 'start_date_is_required';
    }
    if (coupon.endDate == null && !update) {
      errors['end_date'] = 'end_date_is_required';
    }

    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
    });
    if (errors.isNotEmpty) {
      return;
    }

    Coupons coupons = Coupons(
        id: update ? widget.coupons!.id : null,
        title: couponTitle,
        couponType: couponType,
        customerId: coupon.selectedCustomerIdForCoupon,
        code: couponCode,
        limit: limit,
        discountType: coupon.discountTypeName,
        discount: isDiscountOnPurchase ? discountAmount : 0,
        minPurchase: minimumPurchase,
        maxDiscount: maxDiscount ?? 0,
        startDate: coupon.dateFormat.format(coupon.startDate ?? DateTime.now()).toString(),
        expireDate: coupon.dateFormat.format(coupon.endDate ?? DateTime.now()).toString());
    coupon.addNewCoupon(context, coupons, update);
  }
}
