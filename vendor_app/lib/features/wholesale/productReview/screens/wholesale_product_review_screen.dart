import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_search_field_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/filter_icon_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_sliver_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/controllers/wholesale_product_review_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/domain/models/wholesale_product_review_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/screens/wholesale_product_review_reply_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/widgets/wholesale_product_review_card_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/widgets/wholesale_product_review_card_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/widgets/wholesale_product_review_filter_bottomsheet_widget.dart';
import 'package:sixvalley_vendor_app/helper/debounce_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';

class WholesaleProductReviewScreen extends StatefulWidget {
  final bool isBackButtonExist;
  final bool fromNotification;
  const WholesaleProductReviewScreen({super.key, this.isBackButtonExist = true, this.fromNotification = false});

  @override
  State<WholesaleProductReviewScreen> createState() => _WholesaleProductReviewScreenState();
}

class _WholesaleProductReviewScreenState extends State<WholesaleProductReviewScreen> {
  final DebounceHelper _debounce = DebounceHelper(milliseconds: 500);
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final WholesaleProductReviewController reviewController = Provider.of<WholesaleProductReviewController>(context, listen: false);
    reviewController.resetForNewVisit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        reviewController.getReviewList(reload: true);
      }
    });
  }

  @override
  void dispose() {
    _debounce.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _goToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashboardScreen()), (route) => false);
  }

  bool _canReplyToReview(BuildContext context) =>
      Provider.of<SplashController>(context, listen: false).configModel?.wholesaleConfig?.vendor?.reviewReply == true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.fromNotification,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goToDashboard();
      },
      child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        title: getTranslated('wholesale_product_review', context),
        isBackButtonExist: widget.isBackButtonExist,
        onBackPressed: widget.fromNotification ? _goToDashboard : null,
      ),
      body: Consumer<WholesaleProductReviewController>(
        builder: (context, reviewController, _) {
          final List<WholesaleProductReviewModel>? reviews = reviewController.reviewList;

          return Column(
            children: [
              Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium, vertical: Dimensions.paddingSizeSmall),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomSearchFieldWidget(
                        controller: _searchController,
                        hint: getTranslated('search_by_product_name', context),
                        prefix: Images.iconsSearch,
                        iconPressed: () => () {},
                        onSubmit: (text) => reviewController.searchReview(text),
                        onChanged: (value) => _debounce.run(() => reviewController.searchReview(value)),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSize),
                    FilterIconWidget(
                      filterCount: reviewController.appliedFilterCount,
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const WholesaleProductReviewFilterBottomSheetWidget(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Expanded(
                child: reviews == null
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: 5,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, __) => const WholesaleProductReviewCardShimmerWidget(),
                      )
                    : reviews.isEmpty
                        ? const NoDataScreen()
                        : RefreshIndicator(
                            onRefresh: () => reviewController.getReviewList(),
                            child: CustomScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                PaginatedSliverListView(
                                  scrollController: _scrollController,
                                  totalSize: reviewController.totalSize,
                                  offset: reviewController.offset,
                                  onPaginate: (int? offset) async => await reviewController.getReviewList(offset: offset ?? 1),
                                  itemView: SliverList.builder(
                                    itemCount: reviews.length,
                                    itemBuilder: (context, index) {
                                      final WholesaleProductReviewModel review = reviews[index];
                                      return InkWell(
                                        onTap: _canReplyToReview(context)
                                            ? () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (_) => WholesaleProductReviewReplyScreen(review: review)),
                                                )
                                            : null,
                                        child: WholesaleProductReviewCardWidget(review: review),
                                      );
                                    },
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
      ),
    );
  }
}
