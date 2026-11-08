import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_sliver_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/controllers/wholesale_limited_stock_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/domain/models/wholesale_limited_stock_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/screens/wholesale_limited_stock_variation_update_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/widgets/wholesale_limited_stock_card_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/widgets/wholesale_limited_stock_product_card_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/widgets/wholesale_limited_stock_update_dialog_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class WholesaleLimitedStockScreen extends StatefulWidget {
  const WholesaleLimitedStockScreen({super.key});

  @override
  State<WholesaleLimitedStockScreen> createState() => _WholesaleLimitedStockScreenState();
}

class _WholesaleLimitedStockScreenState extends State<WholesaleLimitedStockScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleLimitedStockController>(context, listen: false).getStockOutProductList(reload: true, isUpdate: false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onUpdateTap(WholesaleLimitedStockProductModel product) async {
    final WholesaleLimitedStockProductModel? productWithStock =
        await Provider.of<WholesaleLimitedStockController>(context, listen: false).getProductStock(product);
    if (productWithStock == null || !mounted) return;

    if (productWithStock.variation.isEmpty) {
      showDialog(context: context, builder: (_) => WholesaleLimitedStockUpdateDialogWidget(product: productWithStock));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => WholesaleLimitedStockVariationUpdateScreen(product: productWithStock)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('limited_stocks', context)),
      body: Consumer<WholesaleLimitedStockController>(
        builder: (context, limitedStockController, _) {
          final List<WholesaleLimitedStockProductModel>? products = limitedStockController.productList;

          return products == null
              ? ListView.builder(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  itemCount: 6,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, __) => const WholesaleLimitedStockCardShimmerWidget(),
                )
              : products.isEmpty
                  ? const NoDataScreen()
                  : RefreshIndicator(
                      onRefresh: () => limitedStockController.getStockOutProductList(),
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            sliver: PaginatedSliverListView(
                              scrollController: _scrollController,
                              totalSize: limitedStockController.totalSize,
                              offset: limitedStockController.offset,
                              onPaginate: (int? offset) async => await limitedStockController.getStockOutProductList(offset: offset ?? 1),
                              itemView: SliverList.builder(
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final WholesaleLimitedStockProductModel product = products[index];
                                  return WholesaleLimitedStockProductCardWidget(
                                    product: product,
                                    isLoading: limitedStockController.isStockLoading(product.id),
                                    onUpdateTap: () => _onUpdateTap(product),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
