import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/controllers/wholesale_restock_request_list_controller.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleRestockCategoryButtonWidget extends StatelessWidget {
  final String? text;
  final int index;
  final int? categoryId;
  const WholesaleRestockCategoryButtonWidget({super.key, required this.text, required this.index, this.categoryId});

  @override
  Widget build(BuildContext context) {
    final displayText = text != null && text!.length > 15 ? '${text!.substring(0, 15)}...' : text;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Provider.of<WholesaleRestockRequestListController>(context, listen: false).setIndex(index, categoryId);
          Provider.of<WholesaleRestockRequestListController>(context, listen: false).getRestockProductList(1);
        },
        child: Consumer<WholesaleRestockRequestListController>(
          builder: (context, restockController, child) {
            return Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: restockController.categoryIndex == index
                    ? Theme.of(context).primaryColor
                    : Provider.of<ThemeController>(context).darkTheme
                        ? ColorHelper.blendColors(Colors.white, Theme.of(context).highlightColor, 0.9)
                        : Theme.of(context).primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeLarge),
              ),
              child: Text(
                displayText ?? '',
                style: restockController.categoryIndex == index
                    ? titilliumBold.copyWith(color: Theme.of(context).colorScheme.secondaryContainer)
                    : robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            );
          },
        ),
      ),
    );
  }
}
