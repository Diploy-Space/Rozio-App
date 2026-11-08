import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_search_field_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/tab_bar_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/controllers/campaign_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/models/campaign_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/enums/campaign_menu_action.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/enums/campaign_status.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/screens/campaign_details_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/widgets/add_items_bottom_sheet.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/widgets/campaign_card_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/widgets/campaign_card_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CampaignList extends StatefulWidget {
  const CampaignList({super.key});

  @override
  State<CampaignList> createState() => _CampaignListState();
}

class _CampaignListState extends State<CampaignList> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final CampaignController campaignController = Provider.of<CampaignController>(context, listen: false);
    campaignController.resetForNewVisit();
    campaignController.getCampaignList(1, reload: true, isUpdate: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openDetails(CampaignModel campaign) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CampaignDetailsScreen(campaign: campaign)),
    );
  }

  void _openJoinSheet(CampaignModel campaign) {
    final int? id = campaign.id;
    if (id == null) return;

    showAddItemsBottomSheet(
      context,
      campaignId: id,
      minDiscount: campaign.minDiscount ?? 0,
      maxDiscount: campaign.maxDiscount ?? 0,
    );
  }

  void _confirmLeave(CampaignModel campaign, {required String title, required String description}) {
    final int? id = campaign.id;
    if (id == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationDialogWidget(
        icon: Images.delete,
        title: title,
        description: description,
        onYesPressed: () {
          Navigator.pop(dialogContext);
          Provider.of<CampaignController>(context, listen: false).leaveCampaign(id);
        },
      ),
    );
  }

  String _emptyMessage(CampaignStatus? status) {
    switch (status) {
      case CampaignStatus.pending:
        return getTranslated('no_pending_campaign_found', context) ?? 'No pending campaign found';
      case CampaignStatus.approved:
        return getTranslated('no_approved_campaign_found', context) ?? 'No approved campaign found';
      case CampaignStatus.denied:
        return getTranslated('no_denied_campaign_found', context) ?? 'No denied campaign found';
      default:
        return getTranslated('no_campaign_found', context) ?? 'No campaign found';
    }
  }

  String _tabLabel(int index) {
    switch (index) {
      case 0:
        return getTranslated('all', context) ?? 'All';
      case 1:
        return getTranslated('pending', context) ?? 'Pending';
      case 2:
        return getTranslated('approved', context) ?? 'Approved';
      case 3:
        return getTranslated('denied', context) ?? 'Denied';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: getTranslated('campaign_list', context) ?? 'Campaign List',
      ),
      body: Consumer<CampaignController>(
        builder: (context, campaignController, _) {
          final List<CampaignModel> campaigns = campaignController.campaignList;

          return Column(
            children: [
              const SizedBox(height: Dimensions.paddingSize),

              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TabBarWidget(
                  selectedIndex: campaignController.selectedTabIndex,
                  tabs: List.generate(CampaignController.tabFilters.length, _tabLabel),
                  onTabChanged: (index) {
                    _searchController.clear();
                    campaignController.onChangeTab(index);
                  },
                ),
              ),
              const SizedBox(height: Dimensions.paddingSize),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
                child: CustomSearchFieldWidget(
                  controller: _searchController,
                  hint: getTranslated('search', context) ?? 'Search',
                  prefix: Images.iconsSearch,
                  showCloseIcon: campaignController.isSearchActive,
                  iconPressed: () {
                    if (campaignController.isSearchActive) {
                      _searchController.clear();
                      campaignController.clearSearch();
                    } else {
                      campaignController.searchCampaign(_searchController.text);
                    }
                  },
                  onSubmit: (text) => campaignController.searchCampaign(text),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSize),

              Expanded(
                child: campaignController.isLoading
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
                        itemCount: 5,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, __) => const CampaignCardShimmerWidget(),
                      )
                    : campaigns.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.campaign_outlined, size: 64, color: Theme.of(context).hintColor.withValues(alpha: 0.4)),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                                Text(
                                  _emptyMessage(campaignController.selectedStatus),
                                  style: titilliumRegular.copyWith(
                                    color: Theme.of(context).hintColor,
                                    fontSize: Dimensions.fontSizeLarge,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => campaignController.getCampaignList(1, reload: true),
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
                              child: PaginatedListViewWidget(
                                scrollController: _scrollController,
                                totalSize: campaignController.campaignListModel?.totalSize,
                                offset: campaignController.campaignListModel?.offset,
                                onPaginate: (int? offset) async =>
                                    await campaignController.getCampaignList(offset ?? 1),
                                itemView: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: campaigns.length,
                                  itemBuilder: (context, index) {
                                    final CampaignModel campaign = campaigns[index];
                                    return CampaignCardWidget(
                                      campaign: campaign,
                                      onTap: () => _openDetails(campaign),
                                      onMenuSelected: (action) {
                                        switch (action) {
                                          case CampaignMenuAction.view:
                                          case CampaignMenuAction.edit:
                                          case CampaignMenuAction.reJoin:
                                            _openDetails(campaign);
                                            break;
                                          case CampaignMenuAction.join:
                                            _openJoinSheet(campaign);
                                            break;
                                          case CampaignMenuAction.cancelRequest:
                                            _confirmLeave(
                                              campaign,
                                              title: getTranslated('cancel_request', context) ?? 'Cancel Request',
                                              description: getTranslated('are_you_sure_to_cancel_campaign_request', context) ??
                                                  'Are you sure you want to cancel your request to join this campaign?',
                                            );
                                            break;
                                          case CampaignMenuAction.leave:
                                            _confirmLeave(
                                              campaign,
                                              title: getTranslated('leave_campaign', context) ?? 'Leave Campaign',
                                              description: getTranslated('are_you_sure_to_leave_campaign', context) ??
                                                  'Are you sure you want to leave this campaign?',
                                            );
                                            break;
                                          case CampaignMenuAction.delete:
                                            _confirmLeave(
                                              campaign,
                                              title: getTranslated('delete', context) ?? 'Delete',
                                              description: getTranslated('are_you_sure_to_delete_campaign_request', context) ??
                                                  'Are you sure you want to delete this campaign request?',
                                            );
                                            break;
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
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
