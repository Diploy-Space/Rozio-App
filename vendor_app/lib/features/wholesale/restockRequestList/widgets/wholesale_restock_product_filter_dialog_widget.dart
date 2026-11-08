import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_loader_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/controllers/wholesale_restock_request_list_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/widgets/wholesale_restock_calender_widget.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleRestockProductFilterDialogWidget extends StatefulWidget {
  const WholesaleRestockProductFilterDialogWidget({super.key});

  @override
  State<WholesaleRestockProductFilterDialogWidget> createState() => _WholesaleRestockProductFilterDialogWidgetState();
}

class _WholesaleRestockProductFilterDialogWidgetState extends State<WholesaleRestockProductFilterDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Dismissible(
      key: const Key('wholesale_restock_filter_dialog'),
      direction: DismissDirection.down,
      onDismissed: (_) => Navigator.pop(context),
      child: Consumer<WholesaleRestockRequestListController>(builder: (context, restockProvider, child) {
        return Container(
          constraints: BoxConstraints(maxHeight: size.height * 0.8, minHeight: 150),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 30),
                    Text(getTranslated('filter_data', context)!, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 30, height: 30,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                        child: Icon(Icons.close, size: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeMedium),
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeExtraSmall),
                        child: Text(getTranslated('restoke_request_date', context)!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                      ),
                      Container(
                        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), border: Border.all(color: Theme.of(context).hintColor)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      restockProvider.startDate != null ? DateConverter.localDateToIsoStringDate(DateTime.parse(restockProvider.startDate!)) : getTranslated('start_date', context)!,
                                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                                    ),
                                    const Text(' - '),
                                    Text(
                                      restockProvider.endDate != null ? DateConverter.localDateToIsoStringDate(DateTime.parse(restockProvider.endDate!)) : getTranslated('end_date', context)!,
                                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => showDialog(context: context, builder: (_) => const WholesaleRestockCalenderWidget()),
                                child: SizedBox(height: 25, width: 25, child: Image.asset(Images.calender)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              if (restockProvider.brands != null && (restockProvider.brands?.isNotEmpty ?? false))
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeMedium),
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeExtraSmall),
                              child: Text(getTranslated('brand', context)!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeMedium),
                              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minHeight: 40.0, maxHeight: 350.0),
                                child: ListView.builder(
                                  itemCount: restockProvider.brands?.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return WholesaleRestockCategoryFilterItem(
                                      title: restockProvider.brands![index].name,
                                      count: restockProvider.brands![index].productCount.toString(),
                                      checked: restockProvider.brands![index].checked ?? false,
                                      onTap: () => restockProvider.checkedToggleBrand(index),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButtonWidget(
                        isColor: true,
                        btnTxt: getTranslated('clear_filter', context),
                        backgroundColor: Theme.of(context).hintColor.withValues(alpha: .1),
                        fontColor: Theme.of(context).textTheme.bodyLarge?.color,
                        onTap: () async {
                          showDialog(context: context, builder: (ctx) => const CustomLoaderWidget());
                          await restockProvider.resetChecked();
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        },),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(
                      child: CustomButtonWidget(
                        btnTxt: getTranslated('apply', context),
                        backgroundColor: (restockProvider.startDate == null && restockProvider.selectedBrandIds.isEmpty) ? Theme.of(context).hintColor : null,
                        onTap: () async {
                          restockProvider.getRestockProductList(1);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class WholesaleRestockCategoryFilterItem extends StatelessWidget {
  final String? title;
  final String? count;
  final bool checked;
  final VoidCallback? onTap;
  const WholesaleRestockCategoryFilterItem({super.key, required this.title, required this.checked, this.onTap, this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
              child: Icon(
                checked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                color: (checked && !Provider.of<ThemeController>(context, listen: false).darkTheme)
                    ? Theme.of(context).primaryColor
                    : (checked && Provider.of<ThemeController>(context, listen: false).darkTheme)
                        ? Colors.white
                        : Theme.of(context).hintColor.withValues(alpha: .5),
              ),
            ),
            Expanded(child: Text(title ?? '', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color), maxLines: 1, overflow: TextOverflow.ellipsis)),
            Text(count ?? '', style: robotoMedium.copyWith(color: Theme.of(context).hintColor)),
          ]),
        ),
      ),
    );
  }
}
