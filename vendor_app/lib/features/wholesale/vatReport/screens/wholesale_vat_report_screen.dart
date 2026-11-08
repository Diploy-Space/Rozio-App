import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_sliver_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/vat_management/screens/vat_report_screen.dart';
import 'package:sixvalley_vendor_app/features/vat_management/widgets/order_info_card_widget.dart';
import 'package:sixvalley_vendor_app/features/vat_management/widgets/order_list_card_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/vat_management/widgets/order_list_card_widget.dart';
import 'package:sixvalley_vendor_app/features/vat_management/widgets/tax_info_card.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatReport/controllers/wholesale_vat_report_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatReport/widgets/wholesale_vat_filter_bottom_sheet.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleVatReportScreen extends StatefulWidget {
  const WholesaleVatReportScreen({super.key});

  @override
  State<WholesaleVatReportScreen> createState() => _WholesaleVatReportScreenState();
}

class _WholesaleVatReportScreenState extends State<WholesaleVatReportScreen> {

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final vatController = Provider.of<WholesaleVatReportController>(context, listen: false);
    vatController.resetReviewData(isUpdate: false);
    vatController.setInitialDateRange();
    vatController.getVatReportList(1, startDate: vatController.startDate.toString(), endDate: vatController.endDate.toString());
  }


  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('vat_report', context),
         isAction: true, isFilter: true,
         widget: Consumer<WholesaleVatReportController>(
           builder: (context, vatController, child) {
             return (vatController.vatReportModel?.typeWiseTaxesList != null &&  vatController.vatReportModel!.typeWiseTaxesList!.isNotEmpty || (vatController.vatReportModel?.typeWiseTaxesList != null &&  vatController.vatReportModel!.typeWiseTaxesList!.isEmpty)) ? InkWell(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Theme.of(context).cardColor,
                  useSafeArea: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return WholesaleVatFilterBottomSheet();
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomAssetImageWidget(Images.filterIconSvg, width: 20, height: 20),
              ),
             ) : SizedBox();
           }
         )
      ),
      body: Consumer<WholesaleVatReportController>(
        builder: (context, vatController, child) {
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium, vertical: Dimensions.paddingSizeLarge),
                sliver: SliverMainAxisGroup(slivers: [
                  SliverToBoxAdapter(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                vatController.vatReportModel != null   ?
                vatController.vatReportModel!.typeWiseTaxesList!.isNotEmpty ?
                Column(
                  children: [
                    Row(children: [
                      Expanded(
                        child: OrderInfoCardWidget(
                          image: Images.totalOrderIcon,
                          amount: vatController.vatReportModel?.totalOrders.toString(),
                          infoName: getTranslated('total_orders', context)!,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(
                        child: OrderInfoCardWidget(
                          image: Images.totalAmountIcon,
                          amount: PriceConverter.convertPrice(context,  double.tryParse(vatController.vatReportModel?.totalOrderAmount.toString() ?? '') ?? 0,),
                          infoName: getTranslated('total_order_amount', context)!,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ]),
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      padding: EdgeInsets.all(Dimensions.paddingSizeSmall).copyWith(right: 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start,children: [

                        Row(mainAxisAlignment: MainAxisAlignment.start,children: [
                          CustomAssetImageWidget(
                            Images.vatReportIcon,
                            color: Theme.of(context).colorScheme.onTertiaryContainer,
                            height: Dimensions.topSpace,
                            width: Dimensions.topSpace,
                          ),
                          SizedBox(width: Dimensions.paddingSizeSmall),

                          Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                            Text(PriceConverter.convertPrice(context,  double.tryParse(vatController.vatReportModel?.totalTax.toString() ?? '') ?? 0 ), style: robotoBold.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).colorScheme.onTertiaryContainer,
                            )),

                            Text(getTranslated('total_vat_amount', context)!, style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                            )),
                          ]),
                        ]),
                        SizedBox(height: Dimensions.paddingSizeLarge),

                        if(vatController.vatReportModel?.typeWiseTaxesList != null)
                        Container(
                          height: 66,
                          padding: EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: (vatController.vatReportModel?.typeWiseTaxesList?.length) ?? 0,
                            itemBuilder: (context, index) {
                              return TaxInfoCard(taxModel: vatController.vatReportModel!.typeWiseTaxesList![index]);
                            },
                            separatorBuilder: (context, index) => SizedBox(width: Dimensions.paddingEye),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ) : (vatController.vatReportModel?.orderTransactions?.isEmpty ?? false) ?
                SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: NoDataScreen(
                      title: 'no_tax_report_found',
                    ),
                  ),
                ) : SizedBox()
                : VatReportShimmerWidget(isEnabled: true),


                if(vatController.vatReportModel?.orderTransactions?.isNotEmpty ?? false) ...[
                  SizedBox(height: Dimensions.paddingSizeLarge),
                  Text(getTranslated('order_list', context)!, style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  )),
                  SizedBox(height: Dimensions.paddingSizeSmall),
                ],

                    ]),
                  ),

                  vatController.vatReportModel != null ? (vatController.vatReportModel?.orderTransactions?.isNotEmpty ?? false) ?
                  PaginatedSliverListView(
                    scrollController: scrollController,
                    totalSize: vatController.vatReportModel?.totalSize ?? vatController.vatReportModel?.totalOrders,
                    offset: vatController.vatReportModel?.offset,
                    onPaginate: (int? offset) async {
                      await vatController.getVatReportList(
                        offset ?? 1,
                        startDate: (vatController.isFilterActive ?? false) ? vatController.startDate.toString() : null,
                        endDate: (vatController.isFilterActive ?? false) ? vatController.endDate.toString() : null
                      );
                    },
                    itemView: SliverList.separated(
                      itemCount:vatController.vatReportModel?.orderTransactions?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return OrderListCardWidget(orderModel:  vatController.vatReportModel?.orderTransactions?[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) => SizedBox(height: Dimensions.paddingSizeSmall),
                    ),
                  ) : const SliverToBoxAdapter(child: SizedBox()) : const SliverToBoxAdapter(child: OrderListCardShimmer()),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
