import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_sliver_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/order/screens/order_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/controllers/wholesale_coupon_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/screens/wholesale_add_coupon_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/widgets/wholesale_coupon_card_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/widgets/wholesale_coupon_details_dialog_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class WholesaleCouponListScreen extends StatefulWidget {
  const WholesaleCouponListScreen({super.key});

  @override
  State<WholesaleCouponListScreen> createState() => _WholesaleCouponListScreenState();
}

class _WholesaleCouponListScreenState extends State<WholesaleCouponListScreen> {
  final ScrollController scrollController = ScrollController();
  bool isScrolledToEnd = false;

  void _onScroll() {
    if (scrollController.position.atEdge) {
      isScrolledToEnd = scrollController.position.pixels == scrollController.position.maxScrollExtent;
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WholesaleCouponController>(context, listen: false).getCouponList(1);
    });
    scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('coupon_list', context)),
      body: Consumer<WholesaleCouponController>(
        builder: (context, couponProvider, _) {
          final coupons = couponProvider.couponModel?.coupons;
          return couponProvider.couponModel != null ? (coupons != null && coupons.isNotEmpty) ?
          RefreshIndicator(
            onRefresh: () => couponProvider.getCouponList(1),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                PaginatedSliverListView(
                  reverse: false,
                  scrollController: scrollController,
                  totalSize: couponProvider.couponModel!.totalSize,
                  offset: couponProvider.couponModel!.offset,
                  onPaginate: (int? offset) async {
                    await couponProvider.getCouponList(offset!);
                  },
                  itemView: SliverList.builder(
                    itemCount: coupons.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          showAnimatedDialogWidget(context, WholesaleCouponDetailsDialogWidget(coupon: coupons[index]),
                            barrierColor: Provider.of<ThemeController>(context, listen: false).darkTheme ? Colors.black.withValues(alpha: 0.8) : null,
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: (coupons.length == index + 1) ? Dimensions.paddingSizeSmall : 0),
                          child: WholesaleCouponCardWidget(coupon: coupons[index], index: index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ) : const NoDataScreen() : const OrderShimmer();
        }
      ),

      floatingActionButton: isScrolledToEnd ? null : FloatingActionButton(
        backgroundColor: Theme.of(context).cardColor,
        child: Icon(Icons.add, color: Theme.of(context).primaryColor),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const WholesaleAddCouponScreen()));
        },
      ),
    );
  }
}
