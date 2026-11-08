import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/order_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_sliver_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/top_delivery_man.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/widgets/earning_card_widget.dart';


class DeliverymanEarningListViewWidget extends StatefulWidget {
  final DeliveryMan? deliveryMan;
  final ScrollController? scrollController;
  const DeliverymanEarningListViewWidget({super.key, this.deliveryMan, this.scrollController});

  @override
  State<DeliverymanEarningListViewWidget> createState() => _DeliverymanEarningListViewWidgetState();
}

class _DeliverymanEarningListViewWidgetState extends State<DeliverymanEarningListViewWidget> {

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryManController>(
        builder: (context, earningProvider, child) {

          return earningProvider.deliveryManEarning != null ? earningProvider.deliveryManEarning!.orders!.isNotEmpty ?
          PaginatedSliverListView(
            reverse: false,
            scrollController: widget.scrollController,
            onPaginate: (int? offset) => earningProvider.getDeliveryManEarningList(context,offset!,widget.deliveryMan!.id ,reload: false),
            totalSize: earningProvider.deliveryManEarning!.totalSize,
            offset: int.parse(earningProvider.deliveryManEarning!.offset!),
            enabledPagination: earningProvider.deliveryManEarning != null,
            itemView: SliverList.builder(
              itemCount: earningProvider.deliveryManEarning!.orders!.length,
              itemBuilder: (context, index) {
                return  EarningCardWidget(earning: earningProvider.deliveryManEarning!.orders![index]);
              },
            ),
          ) : const SliverToBoxAdapter(child: NoDataScreen(title: 'no_order_found',)) : const SliverToBoxAdapter(child: OrderShimmerWidget(isEnabled: true));
        }
    );
  }
}
