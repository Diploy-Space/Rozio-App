import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_sliver_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/tab_bar_widget.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/controllers/wholesale_refund_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/enums/wholesale_refund_status.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/screens/wholesale_refund_details_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/widgets/wholesale_refund_card_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/widgets/wholesale_refund_card_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleRefundListScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const WholesaleRefundListScreen({super.key, this.isBackButtonExist = false});

  @override
  State<WholesaleRefundListScreen> createState() => _WholesaleRefundListScreenState();
}

class _WholesaleRefundListScreenState extends State<WholesaleRefundListScreen> {
  final ScrollController _scrollController = ScrollController();

  static const List<String> _dateFilters = ['all_time', 'today', 'this_week', 'this_month', 'this_year', 'custom_date'];

  @override
  void initState() {
    super.initState();
    final WholesaleRefundController wholesaleRefundController = Provider.of<WholesaleRefundController>(context, listen: false);
    if (wholesaleRefundController.refundList == null) {
      wholesaleRefundController.getRefundList();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _tabLabel(int index) {
    final WholesaleRefundStatus? status = WholesaleRefundController.statusTabs[index];
    if (status == null) return getTranslated('all', context) ?? 'All';
    return getTranslated(status.translationKey, context) ?? status.translationKey;
  }

  Future<void> _onDateFilterSelected(WholesaleRefundController wholesaleRefundController, String filter) async {
    if (filter == 'all_time') {
      wholesaleRefundController.setDateFilter(null);
    } else if (filter == 'custom_date') {
      final DateTimeRange? range = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
      );
      if (range != null) {
        wholesaleRefundController.setDateFilter(filter, startDate: range.start, endDate: range.end);
      }
    } else {
      wholesaleRefundController.setDateFilter(filter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: CustomAppBarWidget(
        title: getTranslated('refund', context),
        isBackButtonExist: widget.isBackButtonExist,
        isAction: true,
        isFilter: true,
        widget: Consumer<WholesaleRefundController>(
          builder: (context, wholesaleRefundController, _) {
            final String selectedFilter = wholesaleRefundController.dateType ?? 'all_time';

            return PopupMenuButton<String>(
              offset: const Offset(0, 45),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
              onSelected: (filter) => _onDateFilterSelected(wholesaleRefundController, filter),
              itemBuilder: (_) => _dateFilters.map((filter) => PopupMenuItem<String>(
                value: filter,
                height: 36,
                child: Text(getTranslated(filter, context) ?? filter, style: robotoRegular.copyWith(
                  color: filter == selectedFilter ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color,
                )),
              )).toList(),
              child: Stack(clipBehavior: Clip.none, children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.15)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CustomAssetImageWidget(Images.filterIconSvg, width: 20, height: 20),
                ),

                if (wholesaleRefundController.isFilterActive)
                  Positioned(
                    top: 2, right: 2,
                    child: Container(
                      height: 7, width: 7,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Theme.of(context).colorScheme.error),
                    ),
                  ),
              ]),
            );
          },
        ),
      ),
      body: Consumer<WholesaleRefundController>(
        builder: (context, wholesaleRefundController, _) {
          final List<RefundModel>? refunds = wholesaleRefundController.refundList;

          return Column(
            children: [
              const SizedBox(height: Dimensions.paddingSize),

              Align(
                alignment: Alignment.centerLeft,
                child: TabBarWidget(
                  selectedIndex: wholesaleRefundController.tabIndex,
                  tabs: List.generate(WholesaleRefundController.statusTabs.length, _tabLabel),
                  onTabChanged: wholesaleRefundController.setIndex,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSize),

              Expanded(
                child: refunds == null
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
                      itemCount: 5,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, __) => const WholesaleRefundCardShimmerWidget(),
                    )
                  : refunds.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.assignment_return_outlined, size: 64, color: Theme.of(context).hintColor.withValues(alpha: 0.4)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Text(
                              getTranslated('no_refund_request_found', context) ?? 'No Refund Request Found',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).hintColor),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => wholesaleRefundController.getRefundList(),
                        child: CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            PaginatedSliverListView(
                              scrollController: _scrollController,
                              totalSize: wholesaleRefundController.totalSize,
                              offset: wholesaleRefundController.offset,
                              onPaginate: (int? offset) async {
                                await wholesaleRefundController.getRefundList(offset: offset ?? 1);
                              },
                              itemView: SliverList.builder(
                                itemCount: refunds.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
                                  child: WholesaleRefundCardWidget(
                                    refund: refunds[index],
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => WholesaleRefundDetailsScreen(refund: refunds[index])),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
