import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/main.dart';

List<Tab> _addWholesaleProductTabs = <Tab>[
  Tab(text: getTranslated('general_setup', Get.context!) ?? 'General Setup'),
  Tab(text: getTranslated('stock_and_price', Get.context!) ?? 'Stock and Price'),
  Tab(text: getTranslated('image_and_media', Get.context!) ?? 'Image & Media'),
  Tab(text: getTranslated('faq_and_seo', Get.context!) ?? 'FAQ & SEO'),
];

class AddWholesaleProductTitleBar extends StatelessWidget {
  final TabController tabController;
  const AddWholesaleProductTitleBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelPadding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          controller: tabController,
          tabs: _addWholesaleProductTabs,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.zero,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            border: Border.all(color: Theme.of(context).primaryColor),
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
