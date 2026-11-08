import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class RetailWholesaleTabWidget extends StatelessWidget {
  final TabController controller;
  final bool showDivider;
  const RetailWholesaleTabWidget({super.key, required this.controller, this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
          child: TabBar(
            controller: controller,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            dividerColor: Colors.black,
            dividerHeight: showDivider ? 1 : 0,
            labelStyle: titilliumRegular.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: Dimensions.fontSizeLarge,
            ),
            unselectedLabelStyle: titilliumRegular.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: Dimensions.fontSizeDefault,
            ),
            tabs: [
              Tab(text: getTranslated('retail', context) ?? 'Retail'),
              Tab(text: getTranslated('wholesale', context) ?? 'Wholesale'),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
      ],
    );
  }
}
