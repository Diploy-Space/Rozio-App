import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_search_field_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/filter_icon_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/screens/add_wholesale_product_tab_view_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/controllers/wholesale_product_list_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/domain/models/wholesale_product_list_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/enums/wholesale_product_menu_action.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/widgets/wholesale_product_card_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/widgets/wholesale_product_card_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/widgets/wholesale_product_filter_bottomsheet_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/widgets/wholesale_product_list_tab_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/screens/wholesale_limited_stock_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/brand/controllers/wholesale_brand_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/category/controllers/wholesale_category_controller.dart';
import 'package:sixvalley_vendor_app/features/shop/widgets/animated_floating_button_widget.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/screens/wholesale_product_details_screen.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductListScreen extends StatefulWidget {
  final bool isBackButtonExist;
  final bool fromNotification;
  const WholesaleProductListScreen({super.key, this.isBackButtonExist = true, this.fromNotification = false});

  @override
  State<WholesaleProductListScreen> createState() => _WholesaleProductListScreenState();
}

class _WholesaleProductListScreenState extends State<WholesaleProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _selectedTab = 0;

  bool _isSearchActive = false;

  static const List<String> _tabs = ['all', 'approved', 'denied', 'new_product'];
  static const List<String> _tabStates = ['all', 'approved', 'denied', 'new'];

  @override
  void initState() {
    super.initState();

    Provider.of<WholesaleBrandController>(context, listen: false).getBrandList(isUpdate: false);
    Provider.of<WholesaleCategoryController>(context, listen: false).getCategoryList(isUpdate: false);

    final WholesaleProductListController controller = Provider.of<WholesaleProductListController>(context, listen: false);

    controller.resetForNewVisit();

    controller.getProductList(offset: 1, reload: true, isUpdate: false);

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      Provider.of<WholesaleProductListController>(context, listen: false).loadNextPage();
    }
  }

  void _onTabChanged(int index) {
    setState(() => _selectedTab = index);
    Provider.of<WholesaleProductListController>(context, listen: false).setTabState(_tabStates[index]);
  }

  Future<void> _triggerSearch() async {
    final String query = _searchController.text.trim();
    if (query.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    await Provider.of<WholesaleProductListController>(context, listen: false).setSearchQuery(query);

    if (mounted) {
      setState(() => _isSearchActive = true);
    }
  }

  Future<void> _clearSearch() async {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    setState(() => _isSearchActive = false);
    await Provider.of<WholesaleProductListController>(context, listen: false).setSearchQuery('');
  }

  void _onMenuSelected(BuildContext context, WholesaleProductListModel product, WholesaleProductMenuAction action) {
    switch (action) {
      case WholesaleProductMenuAction.view:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => WholesaleProductDetailsScreen(productId: product.id ?? 0)));
        break;
      case WholesaleProductMenuAction.edit:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddWholesaleProductTabView(productId: product.id)));
        break;
      case WholesaleProductMenuAction.toggleStatus:
        Provider.of<WholesaleProductListController>(context, listen: false).toggleProductStatus(context, product);
        break;
      case WholesaleProductMenuAction.delete:
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) => ConfirmationDialogWidget(
            icon: Images.deleteProduct,
            description: getTranslated('are_you_sure_want_to_delete_this_product', context),
            onYesPressed: () {
              Navigator.of(dialogContext).pop();
              Provider.of<WholesaleProductListController>(context, listen: false).deleteProduct(context, product.id);
            },
          ),
        );
        break;
    }
  }

  void _goToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashboardScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.fromNotification,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goToDashboard();
      },
      child: Scaffold(
      appBar: CustomAppBarWidget(
        title: getTranslated('wholesale_product_list', context),
        isBackButtonExist: widget.isBackButtonExist,
        onBackPressed: widget.fromNotification ? _goToDashboard : null,
      ),
      body: Consumer<WholesaleProductListController>(builder: (context, wholesaleProductListController, _) {
        final List<WholesaleProductListModel>? products = wholesaleProductListController.products;

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                  child: WholesaleProductListTabWidget(
                    tabs: _tabs,
                    selectedIndex: _selectedTab,
                    onTabChanged: _onTabChanged,
                  ),
                ),
                SizedBox(height: Dimensions.paddingSizeDefault),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium, vertical: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomSearchFieldWidget(
                          controller: _searchController,
                          hint: getTranslated('search_by_product_info', context),
                          prefix: Images.iconsSearch,
                          showCloseIcon: _isSearchActive,
                          iconPressed: () => _isSearchActive ? _clearSearch() : _triggerSearch(),
                          onSubmit: (_) => _triggerSearch(),
                          onChanged: (String value) {
                            final String query = value.trim();
                            final bool matchesApplied = query.isNotEmpty && query == wholesaleProductListController.searchQuery;
                            if (_isSearchActive != matchesApplied) {
                              setState(() => _isSearchActive = matchesApplied);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSize),

                      FilterIconWidget(
                        filterCount: wholesaleProductListController.appliedFilterCount,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (builder) => const WholesaleProductFilterBottomSheet(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSize),

                Expanded(
                  child: products == null || wholesaleProductListController.isLoading
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          itemBuilder: (_, __) => const WholesaleProductCardShimmerWidget(),
                        )
                      : products.isEmpty
                          ? const NoDataScreen()
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              itemCount: products.length + (wholesaleProductListController.isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= products.length) {
                                  return const WholesaleProductCardShimmerWidget();
                                }

                                final WholesaleProductListModel product = products[index];

                                final bool isBusy = wholesaleProductListController.isDeleting(product.id) ||
                                    wholesaleProductListController.isUpdatingStatus(product.id);

                                return IgnorePointer(
                                  ignoring: isBusy,
                                  child: Opacity(
                                    opacity: isBusy ? 0.4 : 1,
                                    child: WholesaleProductCardWidget(
                                      product: product,
                                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => WholesaleProductDetailsScreen(productId: product.id ?? 0))),
                                      onMenuSelected: (action) => _onMenuSelected(context, product, action),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),

            Positioned(
              bottom: 20,
              right: Provider.of<LocalizationController>(context, listen: false).isLtr ? 20 : null,
              left: Provider.of<LocalizationController>(context, listen: false).isLtr ? null : 20,
              child: ScrollingFabAnimated(
                width: 150,
                color: Theme.of(context).cardColor,
                icon: SizedBox(width: Dimensions.iconSizeExtraLarge, child: Image.asset(Images.addIcon)),
                text: Text(getTranslated('add_new', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddWholesaleProductTabView()));
                },
                animateIcon: true,
                inverted: false,
                scrollController: _scrollController,
                radius: 10.0,
              ),
            ),

            Positioned(
              bottom: 100,
              right: Provider.of<LocalizationController>(context, listen: false).isLtr ? 22 : null,
              left: Provider.of<LocalizationController>(context, listen: false).isLtr ? null : 22,
              child: ScrollingFabAnimated(
                width: 200,
                color: Theme.of(context).cardColor,
                icon: SizedBox(width: Dimensions.iconSizeExtraLarge, child: Image.asset(Images.limitedStockIcon)),
                text: Text(getTranslated('limited_stocks', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WholesaleLimitedStockScreen()));
                },
                animateIcon: true,
                inverted: false,
                scrollController: _scrollController,
                radius: 10.0,
              ),
            ),
          ],
        );
      }),
    ),
    );
  }
}
