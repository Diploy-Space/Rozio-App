import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_search_field_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_sliver_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/tab_bar_widget.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/order_list_filter_bottomsheet_widget.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/customer_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/controllers/wholesale_order_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/enums/wholesale_order_status.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/screens/wholesale_order_details_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_order_card_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/widgets/wholesale_order_card_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';

class WholesaleOrderListScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const WholesaleOrderListScreen({super.key, this.isBackButtonExist = false});

  @override
  State<WholesaleOrderListScreen> createState() => _WholesaleOrderListScreenState();
}

class _WholesaleOrderListScreenState extends State<WholesaleOrderListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  static const List<WholesaleOrderStatus?> _tabFilters = [
    null,
    WholesaleOrderStatus.pending,
    WholesaleOrderStatus.confirmed,
    WholesaleOrderStatus.processing,
    WholesaleOrderStatus.outForDelivery,
    WholesaleOrderStatus.delivered,
    WholesaleOrderStatus.returned,
    WholesaleOrderStatus.failed,
    WholesaleOrderStatus.cancelled,
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<CustomerController>(context, listen: false).resetCustomerId(isUpdate: false, customerId: -1);

    final WholesaleOrderController wholesaleOrderController = Provider.of<WholesaleOrderController>(context, listen: false);
    _searchController.text = wholesaleOrderController.searchQuery;
    _isSearchActive = wholesaleOrderController.searchQuery.isNotEmpty;
    wholesaleOrderController.getOrderList(context, 1, wholesaleOrderController.orderType, wholesaleOrderController.isFilterActive ? wholesaleOrderController.filterModel : null);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _triggerSearch() async {
    final String query = _searchController.text.trim();
    if (query.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    await Provider.of<WholesaleOrderController>(context, listen: false).setSearchQuery(query);

    if (mounted) {
      setState(() => _isSearchActive = true);
    }
  }

  Future<void> _clearSearch() async {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    setState(() => _isSearchActive = false);
    await Provider.of<WholesaleOrderController>(context, listen: false).setSearchQuery('');
  }

  String _tabLabel(int index) {
    final WholesaleOrderStatus? status = _tabFilters[index];
    if (status == null) return getTranslated('all', context) ?? 'All';
    return getTranslated(status.translationKey, context) ?? status.translationKey;
  }

  void _openFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const OrderListFilterBottomSheet<WholesaleOrderController>(showPosOrderFilter: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: CustomAppBarWidget(
        title: getTranslated('my_order', context),
        isBackButtonExist: widget.isBackButtonExist,
        isAction: true,
        isFilter: true,
        widget: Consumer<WholesaleOrderController>(
          builder: (context, wholesaleOrderController, _) {
            return InkWell(
              onTap: _openFilter,
              borderRadius: BorderRadius.circular(10),
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

                if (wholesaleOrderController.isFilterActive)
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
      body: Consumer<WholesaleOrderController>(
        builder: (context, wholesaleOrderController, _) {
          final List<Order>? orders = wholesaleOrderController.orderModel?.orders;

          return Column(
            children: [
              const SizedBox(height: Dimensions.paddingSize),

              Align(
                alignment: Alignment.centerLeft,
                child: TabBarWidget(
                  selectedIndex: wholesaleOrderController.orderTypeIndex,
                  tabs: List.generate(_tabFilters.length, _tabLabel),
                  onTabChanged: (index) => wholesaleOrderController.setIndex(index, _tabFilters[index]?.value ?? 'all'),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSize),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
                child: CustomSearchFieldWidget(
                  controller: _searchController,
                  hint: getTranslated('search_by_order_id_or_customer', context),
                  prefix: Images.iconsSearch,
                  showCloseIcon: _isSearchActive,
                  iconPressed: () => _isSearchActive ? _clearSearch() : _triggerSearch(),
                  onSubmit: (_) => _triggerSearch(),
                  onChanged: (String value) {
                    final String query = value.trim();
                    final bool matchesApplied = query.isNotEmpty && query == wholesaleOrderController.searchQuery;
                    if (_isSearchActive != matchesApplied) {
                      setState(() => _isSearchActive = matchesApplied);
                    }
                  },
                ),
              ),
              const SizedBox(height: Dimensions.paddingSize),

              Expanded(
                child: orders == null
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
                      itemCount: 5,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, __) => const WholesaleOrderCardShimmerWidget(),
                    )
                  : orders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 64, color: Theme.of(context).hintColor.withValues(alpha: 0.4)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Text(
                              getTranslated('no_order_found', context) ?? 'No order found',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).hintColor),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: wholesaleOrderController.refreshOrderList,
                        child: CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            PaginatedSliverListView(
                              scrollController: _scrollController,
                              totalSize: wholesaleOrderController.orderModel?.totalSize,
                              offset: wholesaleOrderController.orderModel?.offset,
                              onPaginate: (int? offset) async {
                                await wholesaleOrderController.getOrderList(
                                  null, offset!, wholesaleOrderController.orderType,
                                  wholesaleOrderController.isFilterActive ? wholesaleOrderController.filterModel : null,
                                  reload: false,
                                );
                              },
                              itemView: SliverList.builder(
                                itemCount: orders.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
                                  child: WholesaleOrderCardWidget(
                                    order: orders[index],
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => WholesaleOrderDetailsScreen(orderId: orders[index].id!)),
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
