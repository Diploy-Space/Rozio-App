import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_date_picker_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_drop_down_item_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_field_with_title_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/controllers/wholesale_coupon_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/domain/models/wholesale_coupon_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/screens/wholesale_coupon_customer_search_screen.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleAddCouponScreen extends StatefulWidget {
  final WholesaleCoupon? coupon;
  const WholesaleAddCouponScreen({super.key, this.coupon});

  @override
  State<WholesaleAddCouponScreen> createState() => _WholesaleAddCouponScreenState();
}

class _WholesaleAddCouponScreenState extends State<WholesaleAddCouponScreen> {

  final TextEditingController couponTitleController = TextEditingController();
  final TextEditingController limitController = TextEditingController();
  final TextEditingController couponCodeController = TextEditingController();
  final TextEditingController discountAmountController = TextEditingController();
  final TextEditingController minimumPurchaseController = TextEditingController();
  final TextEditingController maximumDiscountController = TextEditingController();

  bool update = false;
  final Map<String, String> _errors = {};

  @override
  void initState() {
    update = widget.coupon != null;
    final WholesaleCouponController couponController = Provider.of<WholesaleCouponController>(context, listen: false);
    couponController.initCouponForm(widget.coupon);

    if (update) {
      final WholesaleCoupon coupon = widget.coupon!;
      couponTitleController.text = coupon.title ?? '';
      couponCodeController.text = coupon.code ?? '';
      limitController.text = coupon.limit?.toString() ?? '';
      discountAmountController.text = _formatNumber(coupon.discount);
      minimumPurchaseController.text = _formatNumber(coupon.minPurchase);
      maximumDiscountController.text = _formatNumber(coupon.maxDiscount);
      couponController.startDate = DateTime.tryParse(coupon.startDate ?? '')?.toLocal();
      couponController.endDate = DateTime.tryParse(coupon.expireDate ?? '')?.toLocal();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      couponController.getCouponSetup();
      couponController.getCouponCustomerList('');
    });
    super.initState();
  }

  @override
  void dispose() {
    couponTitleController.dispose();
    limitController.dispose();
    couponCodeController.dispose();
    discountAmountController.dispose();
    minimumPurchaseController.dispose();
    maximumDiscountController.dispose();
    super.dispose();
  }

  String _formatNumber(double? value) {
    if (value == null) return '';
    return value == value.truncateToDouble() ? value.toInt().toString() : value.toString();
  }

  String? _errorOf(String field) => _errors[field] != null ? getTranslated(_errors[field], context) : null;

  void _clearError(String field) {
    if (_errors.containsKey(field)) {
      setState(() => _errors.remove(field));
    }
  }

  Widget _errorTextWidget(String message) => Text(message, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('coupon_setup', context)),
      body: Consumer<WholesaleCouponController>(
        builder: (context, coupon, _) {
          final bool showTargeting = coupon.fieldVisibility.targeting;
          final bool showDiscount = coupon.fieldVisibility.discount;
          final bool isPercentage = coupon.discountTypeName == 'percentage';
          final bool hasCustomer = coupon.selectedCustomerId != null;
          final String customerName = coupon.selectedCustomerName.isNotEmpty
              ? coupon.selectedCustomerName
              : hasCustomer ? '${getTranslated('customer', context)} #${coupon.selectedCustomerId}'
              : getTranslated('select_customer', context) ?? '';

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
                        key: ValueKey('coupon_type_${coupon.selectedCouponType}_${coupon.couponTypeList.length}'),
                        initialValue: coupon.couponTypeList.contains(coupon.selectedCouponType) ? coupon.selectedCouponType : null,
                        isExpanded: true,
                        hint: Text(getTranslated('select_coupon_type', context) ?? 'Select coupon type',
                            style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                        decoration: const InputDecoration(border: InputBorder.none),
                        iconSize: 24, elevation: 16, style: robotoRegular,
                        onChanged: (value) {
                          coupon.setSelectedCouponType(value);
                        },
                        items: coupon.couponTypeList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(coupon.setupModel.couponTypes[value] ?? getTranslated(value, context)!,
                                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                          );
                        }).toList(),
                      ),
                    ),

                    if (showTargeting) ...[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall),
                          child: Text.rich(TextSpan(text: getTranslated('select_customer', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color), children: [
                            TextSpan(text: ' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                          ]))
                        ),
                      ),

                      GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WholesaleCouponCustomerSearchScreen())),
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: Container(width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(border: Border.all(width: .25, color: Theme.of(context).hintColor.withValues(alpha: .75)),
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                            child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              child: Row(children: [
                                Expanded(child: Text(customerName, style: robotoRegular.copyWith(color: hasCustomer ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).hintColor))),
                                Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor)
                              ]),
                            )),
                        )
                      ),

                      if (!hasCustomer && _errorOf('customer') != null)
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeDefault, 0),
                            child: _errorTextWidget(_errorOf('customer')!),
                          ),
                        ),
                    ],

                    const SizedBox(height: Dimensions.paddingSizeMedium),
                    CustomFieldWithTitleWidget(
                      isCoupon: true,
                      title: getTranslated('coupon_title', context),
                      requiredField: true,
                      errorText: _errorOf('title'),
                      customTextField: CustomTextFieldWidget(
                        border: true,
                        controller: couponTitleController,
                        onChanged: (_) => _clearError('title'),
                        inputFormatters: [LengthLimitingTextInputFormatter(80)],
                        hintText: getTranslated('coupon_title_hint', context),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                      child: Column(children: [
                        Row(children: [
                          Text.rich(TextSpan(text: getTranslated('coupon_code', context)!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color), children: [
                            TextSpan(text: ' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                          ])),

                          const Spacer(),
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                              Random rnd = Random();

                              String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
                                  length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
                              couponCodeController.text = getRandomString(10);
                              _clearError('code');
                            },
                            child: Text(getTranslated('generate_code', context)!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor))),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        CustomTextFieldWidget(
                          controller: couponCodeController,
                          onChanged: (_) => _clearError('code'),
                          border: true,
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.text,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
                          hintText: 'Ex: ze5uzkyu0s',
                        ),

                        if (_errorOf('code') != null) ...[
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Align(alignment: Alignment.topLeft, child: _errorTextWidget(_errorOf('code')!)),
                        ],
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    if (showTargeting)
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

                    if (showDiscount) ...[
                      const SizedBox(height: Dimensions.paddingSizeMedium),
                      CustomDropDownItemWidget(
                        title: 'discount_type',
                        widget: DropdownButtonFormField<String>(
                          key: ValueKey('discount_type_${coupon.discountTypeName}_${coupon.discountTypeList.length}'),
                          initialValue: coupon.discountTypeList.contains(coupon.discountTypeName) ? coupon.discountTypeName : null,
                          isExpanded: true,
                          decoration: const InputDecoration(border: InputBorder.none),
                          iconSize: 24, elevation: 16, style: robotoRegular,
                          onChanged: (value) {
                            coupon.setSelectedDiscountNameType(value);
                          },
                          items: coupon.discountTypeList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(coupon.setupModel.discountTypes[value] ?? getTranslated(value, context)!,
                                  style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      CustomFieldWithTitleWidget(
                        isCoupon: true,
                        title: getTranslated(isPercentage ? 'discount_percentage' : 'discount_amount', context),
                        requiredField: true,
                        errorText: _errorOf('discount'),
                        customTextField: CustomTextFieldWidget(
                          border: true,
                          isAmount: true,
                          controller: discountAmountController,
                          onChanged: (_) => _clearError('discount'),
                          hintText: getTranslated(isPercentage ? 'discount_percentage_hint' : 'discount_amount_hint', context),
                        ),
                      ),
                    ],
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

                    if (showDiscount && isPercentage) ...[
                      const SizedBox(height: Dimensions.paddingSizeMedium),
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
                          hintText: getTranslated('minimum_purchase_hint', context),
                        ),
                      ),
                    ],

                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: CustomDatePickerWidget(
                        title: getTranslated('start_date', context),
                        requiredField: true,
                        errorText: coupon.startDate == null ? _errorOf('start_date') : null,
                        image: Images.calenderIcon,
                        text: coupon.startDate != null ?
                        coupon.dateFormat.format(coupon.startDate!) : getTranslated('select_date', context),
                        selectDate: () => coupon.selectDate('start', context),
                      )),

                      Expanded(child: CustomDatePickerWidget(
                        title: getTranslated('expire_date', context),
                        requiredField: true,
                        errorText: coupon.endDate == null ? _errorOf('end_date') : null,
                        image: Images.calenderIcon,
                        text: coupon.endDate != null ?
                        coupon.dateFormat.format(coupon.endDate!) : getTranslated('select_date', context),
                        selectDate: () => coupon.selectDate('end', context),
                      )),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeMedium),
                  ],
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: ThemeShadow.getShadow(context),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraLarge),
                child: coupon.isAdd ?
                const Center(child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator())) :
                CustomButtonWidget(
                  btnTxt: update ? getTranslated('update', context) : getTranslated('submit', context),
                  onTap: () => _onSubmit(coupon, showTargeting, showDiscount, isPercentage),
                ),
              ),
            ),
          ]);
        }
      ),
    );
  }

  void _onSubmit(WholesaleCouponController coupon, bool showTargeting, bool showDiscount, bool isPercentage) {
    final String couponTitle = couponTitleController.text.trim();
    final String couponCode = couponCodeController.text.trim();
    final String limitText = limitController.text.trim();
    final String discountText = discountAmountController.text.trim();
    final String minimumPurchaseText = minimumPurchaseController.text.trim();
    final String maxDiscountText = maximumDiscountController.text.trim();
    final int? limit = int.tryParse(limitText);
    final double? discount = double.tryParse(discountText);
    final double? minimumPurchase = double.tryParse(minimumPurchaseText);
    final double? maxDiscount = double.tryParse(maxDiscountText);

    final Map<String, String> errors = {};
    if (coupon.selectedCouponType == null) {
      errors['coupon_type'] = 'please_select_coupon_type';
    }
    if (showTargeting && coupon.selectedCustomerId == null) {
      errors['customer'] = 'please_select_customer';
    }
    if (couponTitle.isEmpty) {
      errors['title'] = 'coupon_title_is_required';
    }
    if (couponCode.isEmpty) {
      errors['code'] = 'coupon_code_is_required';
    }
    if (showTargeting) {
      if (limitText.isEmpty) {
        errors['limit'] = 'limit_is_required';
      } else if (limit == null || limit < 1) {
        errors['limit'] = 'invalid_limit';
      }
    }
    if (showDiscount) {
      if (discountText.isEmpty) {
        errors['discount'] = 'amount_is_required';
      } else if (discount == null) {
        errors['discount'] = 'enter_a_valid_amount';
      } else if (isPercentage && discount >= 100) {
        errors['discount'] = 'discount_amount_should_be_less_then';
      }
    }
    if (minimumPurchaseText.isEmpty) {
      errors['min_purchase'] = 'minimum_purchase_is_required';
    } else if (minimumPurchase == null) {
      errors['min_purchase'] = 'enter_a_valid_amount';
    } else if (showDiscount && !isPercentage && discount != null && discount > minimumPurchase) {
      errors['min_purchase'] = 'minimum_purchase_amount_should_be_greater_than_the_discount_amount';
    }
    if (showDiscount && isPercentage) {
      if (maxDiscountText.isEmpty) {
        errors['max_discount'] = 'max_discount_is_required';
      } else if (maxDiscount == null) {
        errors['max_discount'] = 'enter_a_valid_amount';
      }
    }
    if (coupon.startDate == null) {
      errors['start_date'] = 'start_date_is_required';
    }
    if (coupon.endDate == null) {
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

    coupon.saveCoupon(WholesaleCoupon(
      id: widget.coupon?.id,
      couponType: coupon.selectedCouponType,
      title: couponTitle,
      code: couponCode,
      minPurchase: minimumPurchase,
      startDate: coupon.dateFormat.format(coupon.startDate!),
      expireDate: coupon.dateFormat.format(coupon.endDate!),
      customerId: coupon.selectedCustomerId,
      limit: limit,
      discountType: coupon.discountTypeName,
      discount: discount,
      maxDiscount: maxDiscount,
    ), update);
  }
}
