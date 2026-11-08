import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_divider_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_search_field_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/controllers/wholesale_coupon_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/domain/models/wholesale_coupon_customer_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleCouponCustomerSearchScreen extends StatefulWidget {
  const WholesaleCouponCustomerSearchScreen({super.key});

  @override
  State<WholesaleCouponCustomerSearchScreen> createState() => _WholesaleCouponCustomerSearchScreenState();
}

class _WholesaleCouponCustomerSearchScreenState extends State<WholesaleCouponCustomerSearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _customerName(BuildContext context, WholesaleCouponCustomer customer) =>
      customer.id == 0 ? (getTranslated('all_customer', context) ?? customer.fullName) : customer.fullName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('search_customer', context)),
      body: Consumer<WholesaleCouponController>(
        builder: (context, couponProvider, _) {
          final List<WholesaleCouponCustomer> customerList = couponProvider.couponCustomerList ?? [];

          return Column(children: [
            SizedBox(height: 85,
              child: Container(
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: CustomSearchFieldWidget(
                    controller: searchController,
                    hint: getTranslated('search', context),
                    prefix: Images.iconsSearch,
                    iconPressed: () => (){},
                    onSubmit: (text) => (){},
                    onChanged: (value) => couponProvider.getCouponCustomerList(value.toString().trim()),
                  ),
                ),
              ),
            ),

            Expanded(
              child: couponProvider.couponCustomerList == null && couponProvider.isCustomerLoading
                ? const Center(child: CircularProgressIndicator())
                : customerList.isNotEmpty ?
              ListView.builder(
                itemCount: customerList.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (ctx, index) {
                  final WholesaleCouponCustomer customer = customerList[index];
                  return InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      couponProvider.setSelectedCustomer(customer.id, _customerName(context, customer));
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_customerName(context, customer),
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                            const SizedBox(height: Dimensions.paddingSizeMedium),
                            CustomDividerWidget(height: .5, color: Theme.of(context).hintColor),
                          ],
                        )),
                    ),
                  );
                }) : const NoDataScreen(),
            ),
          ]);
        }
      ),
    );
  }
}
