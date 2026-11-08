import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_search_field_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/controllers/campaign_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/models/campaign_eligible_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/models/campaign_item_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/enums/campaign_status.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/widgets/campaign_item_list_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

Future<bool?> showAddItemsBottomSheet(
  BuildContext context, {
  required int campaignId,
  required double minDiscount,
  required double maxDiscount,
  List<CampaignItemModel> joinedItems = const [],
  CampaignStatus status = CampaignStatus.notJoined,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddItemsBottomSheet(
      campaignId: campaignId,
      minDiscount: minDiscount,
      maxDiscount: maxDiscount,
      joinedItems: joinedItems,
      status: status,
    ),
  );
}

class AddItemsBottomSheet extends StatefulWidget {
  final int campaignId;
  final double minDiscount;
  final double maxDiscount;
  final List<CampaignItemModel> joinedItems;
  final CampaignStatus status;
  const AddItemsBottomSheet({
    super.key,
    required this.campaignId,
    required this.minDiscount,
    required this.maxDiscount,
    this.joinedItems = const [],
    this.status = CampaignStatus.notJoined,
  });

  @override
  State<AddItemsBottomSheet> createState() => _AddItemsBottomSheetState();
}

class _AddItemsBottomSheetState extends State<AddItemsBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<int, double> _selected = {};

  @override
  void initState() {
    super.initState();
    for (final CampaignItemModel item in widget.joinedItems) {
      if (item.id != 0) {
        _selected[item.id] = item.discount ?? widget.minDiscount;
      }
    }
    final CampaignController campaignController = Provider.of<CampaignController>(context, listen: false);
    campaignController.getEligibleProducts(widget.campaignId, 1, reload: true, isUpdate: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _format(double? value) {
    if (value == null) return '0';
    return value == value.roundToDouble() ? value.toInt().toString() : value.toString();
  }

  List<CampaignEligibleProductModel> _selectableOf(List<CampaignEligibleProductModel> products) =>
      products.where((product) => product.isSelectable && product.id != null).toList();

  bool? _selectAllState(List<CampaignEligibleProductModel> products) {
    final List<CampaignEligibleProductModel> selectable = _selectableOf(products);
    if (selectable.isNotEmpty && selectable.every((product) => _selected.containsKey(product.id))) return true;
    return _selected.isEmpty ? false : null;
  }

  void _toggleSelectAll(List<CampaignEligibleProductModel> products, bool isSearchActive) {
    final List<CampaignEligibleProductModel> selectable = _selectableOf(products);
    setState(() {
      if (_selectAllState(products) == true) {
        if (isSearchActive) {
          for (final CampaignEligibleProductModel product in selectable) {
            _selected.remove(product.id);
          }
        } else {
          _selected.clear();
        }
      } else {
        for (final CampaignEligibleProductModel product in selectable) {
          _selected.putIfAbsent(product.id!, () => product.discount ?? widget.minDiscount);
        }
      }
    });
  }

  String _submitText(BuildContext context) {
    switch (widget.status) {
      case CampaignStatus.notJoined:
        return getTranslated('join', context) ?? 'Join';
      case CampaignStatus.denied:
        return getTranslated('rejoin', context) ?? 'Re-join';
      case CampaignStatus.pending:
      case CampaignStatus.approved:
        return getTranslated('update_items', context) ?? 'Update Items';
    }
  }

  Future<void> _join(CampaignController campaignController) async {
    if (_selected.isEmpty) return;

    final List<int> productIds = _selected.keys.toList();
    final bool isSuccess = await campaignController.joinCampaign(
      widget.campaignId,
      productIds: productIds,
      discounts: productIds.map((id) => _selected[id]!).toList(),
    );

    if (isSuccess && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Consumer<CampaignController>(
            builder: (context, campaignController, _) {
              final List<CampaignEligibleProductModel> products = campaignController.eligibleProducts;

              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
                ),
                child: Column(
                  children: [
                    _buildHeader(context),
                    Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),

                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    _buildSearch(context, campaignController),
                    const SizedBox(height: Dimensions.paddingSizeMedium),

                    _buildListHeader(context, products, campaignController.isEligibleSearchActive),
                    Expanded(child: _buildList(context, campaignController, products, scrollController)),
                    _buildFooter(context, campaignController),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.paddingSizeDefault,
        Dimensions.paddingSizeMedium,
        Dimensions.paddingSize,
        Dimensions.paddingSizeMedium,
      ),
      child: Row(
        children: [
          const SizedBox(width: 32),
          Expanded(
            child: Center(
              child: Text(
                widget.joinedItems.isEmpty
                    ? getTranslated('add_items_and_join_campaign', context) ?? 'Add Items and Join Campaign'
                    : getTranslated('edit_campaign_items', context) ?? 'Edit Campaign Items',
                textAlign: TextAlign.center,
                style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ),

          InkWell(
            onTap: () => Navigator.pop(context),
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: Dimensions.iconSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(BuildContext context, CampaignController campaignController) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
        child: CustomSearchFieldWidget(
          controller: _searchController,
          hint: getTranslated('search', context) ?? 'Search',
          prefix: Images.iconsSearch,
          contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 8),
          iconSize: Dimensions.paddingSizeDefault,
          showCloseIcon: campaignController.isEligibleSearchActive,
          iconPressed: () {
            if (campaignController.isEligibleSearchActive) {
              _searchController.clear();
              campaignController.clearEligibleProductSearch(widget.campaignId);
            } else {
              campaignController.searchEligibleProducts(widget.campaignId, _searchController.text);
            }
          },
          onSubmit: (value) => campaignController.searchEligibleProducts(widget.campaignId, value),
        ),
      ),
    );
  }

  Widget _buildListHeader(BuildContext context, List<CampaignEligibleProductModel> products, bool isSearchActive) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.paddingSizeMedium,
        0,
        Dimensions.paddingSizeMedium,
        Dimensions.paddingSizeSmall,
      ),
      child: Row(
        children: [
          Text(
            getTranslated('item_list', context) ?? 'Item List',
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const Spacer(),
          Text(
            getTranslated('select_all', context) ?? 'Select All',
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          _CheckBox(
            value: _selectAllState(products),
            tristate: true,
            onChanged: _selectableOf(products).isEmpty ? null : (_) => _toggleSelectAll(products, isSearchActive),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    CampaignController campaignController,
    List<CampaignEligibleProductModel> products,
    ScrollController sheetScrollController,
  ) {
    if (campaignController.isEligibleProductsLoading) {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: const CampaignItemListShimmerWidget(itemCount: 6, showTitle: false),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Text(
          getTranslated('no_product_found', context) ?? 'No product found',
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).hintColor,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: PaginatedListViewWidget(
          scrollController: _scrollController,
          totalSize: campaignController.eligibleProductListModel?.totalSize,
          offset: campaignController.eligibleProductListModel?.offset,
          onPaginate: (int? offset) async =>
              await campaignController.getEligibleProducts(widget.campaignId, offset ?? 1),
          itemView: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: products.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
            itemBuilder: (context, index) => _buildRow(context, products[index], index + 1),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, CampaignEligibleProductModel product, int serial) {
    final bool isSelectable = product.isSelectable && product.id != null;
    final bool isSelected = _selected.containsKey(product.id);

    return Opacity(
      opacity: isSelectable ? 1 : 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Row(
          children: [
            Text(
              '$serial',
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: CustomImageWidget(
                  image: product.thumbnail ?? '',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  if (product.isEnrolled)
                    Text(
                      getTranslated('already_enrolled', context) ?? 'Already enrolled',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            _DiscountField(value: _format(isSelected ? _selected[product.id] : product.discount)),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            _CheckBox(
              value: isSelected,
              onChanged: !isSelectable
                  ? null
                  : (value) => setState(() {
                        if (value ?? false) {
                          _selected[product.id!] = product.discount ?? widget.minDiscount;
                        } else {
                          _selected.remove(product.id);
                        }
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, CampaignController campaignController) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), offset: Offset(0, -4), blurRadius: 12),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${_selected.length} ',
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    TextSpan(
                      text: getTranslated('item_selected', context) ?? 'Item Selected',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),
            Expanded(
              child: campaignController.isJoining
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButtonWidget(
                      btnTxt: _submitText(context),
                      buttonHeight: 40,
                      borderRadius: Dimensions.radiusDefault,
                      isColor: _selected.isEmpty,
                      backgroundColor: _selected.isEmpty ? Theme.of(context).hintColor.withValues(alpha: .1) : null,
                      fontColor: _selected.isEmpty ? Theme.of(context).textTheme.bodyLarge?.color : null,
                      onTap: _selected.isEmpty ? null : () => _join(campaignController),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscountField extends StatelessWidget {
  final String value;
  const _DiscountField({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70, height: 36,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        '$value%',
        style: robotoMedium.copyWith(
          fontSize: Dimensions.fontSizeDefault,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  final bool? value;
  final bool tristate;
  final ValueChanged<bool?>? onChanged;
  const _CheckBox({required this.value, required this.onChanged, this.tristate = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Checkbox(
        value: value,
        tristate: tristate,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
        side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
