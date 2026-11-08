import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductListTabWidget extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  const WholesaleProductListTabWidget({super.key, required this.tabs, required this.selectedIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final bool isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: InkWell(
              onTap: () => onTabChanged(index),
              borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                ),
                alignment: Alignment.center,
                child: Text(
                  getTranslated(tabs[index], context) ?? tabs[index],
                  style: isSelected
                    ? robotoBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall)
                    : robotoRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
