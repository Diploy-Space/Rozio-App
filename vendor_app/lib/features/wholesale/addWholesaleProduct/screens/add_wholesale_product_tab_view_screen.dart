import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/ai/widgets/genertate_count_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/controllers/wholesale_ai_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/widgets/wholesale_ai_generator_bottom_sheet.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/enums/add_wholesale_product_tab.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/screens/add_wholesale_product_faq_seo_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/screens/add_wholesale_product_general_setup_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/screens/add_wholesale_product_image_media_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/screens/add_wholesale_product_stock_price_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_form_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_tabbar_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/screens/wholesale_product_list_screen.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/models/config_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';

class AddWholesaleProductTabView extends StatefulWidget {
  final int? productId;

  const AddWholesaleProductTabView({super.key, this.productId});

  @override
  State<AddWholesaleProductTabView> createState() => _AddWholesaleProductTabViewState();
}

class _AddWholesaleProductTabViewState extends State<AddWholesaleProductTabView> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final WholesaleAiController _aiController;

  final GlobalKey<AddWholesaleProductGeneralSetupScreenState> _generalSetupKey = GlobalKey<AddWholesaleProductGeneralSetupScreenState>();

  bool get _isUpdate => widget.productId != null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: AddWholesaleProductTab.values.length, vsync: this);

    _tabController.addListener(_onTabChanged);

    _aiController = Provider.of<WholesaleAiController>(context, listen: false);
    _aiController.clearImageAutoFill();
    _aiController.clearGeneratedFaqQuestions();

    if (Provider.of<SplashController>(context, listen: false).configModel?.isAiFeatureActive == 1) {
      _aiController.getGenerateLimit();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final AddWholesaleProductController controller = Provider.of<AddWholesaleProductController>(context, listen: false);

      controller.resetForm(context);
      if (_isUpdate) {
        controller.loadProductForEdit(context, widget.productId!);
      }
    });
  }

  @override
  void dispose() {
    _aiController.clearImageAutoFill();
    _aiController.clearGeneratedFaqQuestions();
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool _isScrolledToEnd = false;

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical || _tabController.index != AddWholesaleProductTab.generalSetup.index) {
      return false;
    }

    final bool isScrolledToEnd = notification.metrics.maxScrollExtent > 0 && notification.metrics.extentAfter < 50;
    if (isScrolledToEnd != _isScrolledToEnd) {
      setState(() => _isScrolledToEnd = isScrolledToEnd);
    }
    return false;
  }

  void _openAiGenerator() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      builder: (_) => WholesaleAiGeneratorBottomSheet(
        onImageNameGenerated: (String name) => _generalSetupKey.currentState?.runImageAutoFill(name),
      ),
    );
  }

  void _navigateToTab(int index) {
    for (int tab = _tabController.index; tab < index; tab++) {
      if (!_validateTab(tab)) {
        if (tab != _tabController.index) {
          _tabController.animateTo(tab);
        }
        return;
      }
    }
    _tabController.animateTo(index);
  }

  bool _validateTab(int index) {
    final AddWholesaleProductController controller = Provider.of<AddWholesaleProductController>(context, listen: false);

    switch (AddWholesaleProductTab.values[index]) {
      case AddWholesaleProductTab.generalSetup:
        return controller.validateGeneralSetup(context);
      case AddWholesaleProductTab.stockAndPrice:
        return controller.validateStockAndPrice(context);
      case AddWholesaleProductTab.imageAndMedia:
        return controller.validateImageAndMedia(context);
      case AddWholesaleProductTab.faqAndSeo:
        return true;
    }
  }

  Future<void> _submit() async {
    final AddWholesaleProductController controller = Provider.of<AddWholesaleProductController>(context, listen: false);
    if (controller.isLoading) {
      return;
    }

    if (_isUpdate && !controller.isFullyHydrated) {
      showCustomSnackBarWidget(
        getTranslated('could_not_load_product_to_edit', context),
        context,
        sanckBarType: SnackBarType.warning,
      );
      return;
    }

    for (int index = 0; index < AddWholesaleProductTab.values.length; index++) {
      if (!_validateTab(index)) {
        _tabController.animateTo(index);
        return;
      }
    }

    final List<Language> languageList = Provider.of<SplashController>(context, listen: false).configModel?.languageList ?? [];

    final ApiResponse? response = await controller.addWholesaleProduct(
      context,
      languageList: languageList,
      update: _isUpdate,
      productId: widget.productId,

      existingImages: controller.existingGalleryKeys,
    );

    final int? statusCode = response?.response?.statusCode;
    if (statusCode == 200 || statusCode == 201) {
      Navigator.pushAndRemoveUntil(
        Get.context!,
        MaterialPageRoute(builder: (_) => const WholesaleProductListScreen(fromNotification: true)),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showAiButton = Provider.of<SplashController>(context, listen: false).configModel?.isAiFeatureActive == 1
        && !_isUpdate && _tabController.index == AddWholesaleProductTab.generalSetup.index && !_isScrolledToEnd
        && !context.select<WholesaleAiController, bool>((controller) => controller.imageAutoFillRunning);

    return DefaultTabController(
      length: AddWholesaleProductTab.values.length,
      child: Scaffold(
        floatingActionButton: showAiButton
            ? Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  shape: const CircleBorder(),
                  onPressed: _openAiGenerator,
                  child: CustomAssetImageWidget(Images.useAi, height: 56, width: 56),
                ),
              )
            : null,
        appBar: CustomAppBarWidget(
          centerTitle: false,
          title: _isUpdate
              ? (getTranslated('update_wholesale_product', context) ?? 'Update Product')
              : (getTranslated('add_wholesale_product', context) ?? 'Add New Product'),
          widget: GeneratesLeftCount(isWholesale: true),
          isFilter: true,
          isAction: true,
          onBackPressed: () => Navigator.of(context).pop(),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium, vertical: Dimensions.paddingSizeSmall),
                  height: 60,
                  child: AddWholesaleProductTitleBar(tabController: _tabController),
                ),
                Flexible(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _onScroll,
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        AddWholesaleProductGeneralSetupScreen(key: _generalSetupKey, onTabChanged: _navigateToTab),
                        AddWholesaleProductStockPriceScreen(onTabChanged: _navigateToTab),
                        AddWholesaleProductImageMediaScreen(onTabChanged: _navigateToTab),
                        AddWholesaleProductFaqSeoScreen(onTabChanged: _navigateToTab, onSubmit: _submit, isUpdate: _isUpdate),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            if (context.select<AddWholesaleProductController, bool>((controller) => controller.isDetailLoading))
              Positioned.fill(
                child: AbsorbPointer(
                  child: ColoredBox(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: const AddWholesaleProductFormShimmerWidget(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
