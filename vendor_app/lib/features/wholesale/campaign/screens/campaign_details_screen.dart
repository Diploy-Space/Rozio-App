import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/controllers/campaign_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/models/campaign_item_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/models/campaign_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/enums/campaign_status.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/widgets/add_items_bottom_sheet.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/widgets/campaign_item_list_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CampaignDetailsScreen extends StatefulWidget {
  final CampaignModel campaign;
  final bool fromNotification;
  const CampaignDetailsScreen({super.key, required this.campaign, this.fromNotification = false});

  @override
  State<CampaignDetailsScreen> createState() => _CampaignDetailsScreenState();
}

class _CampaignDetailsScreenState extends State<CampaignDetailsScreen> {

  @override
  void initState() {
    super.initState();
    final int? id = widget.campaign.id;
    if (id != null) {
      Provider.of<CampaignController>(context, listen: false).getCampaignDetails(id, isUpdate: false);
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
      child: Consumer<CampaignController>(
      builder: (context, campaignController, _) {
        final CampaignModel campaign = campaignController.campaignDetails ?? widget.campaign;
        final bool isDetailsLoading = campaignController.isDetailsLoading;
        final List<CampaignItemModel> items = campaign.items ?? [];

        return Scaffold(
          appBar: CustomAppBarWidget(
            title: getTranslated('campaign_details', context) ?? 'Campaign Details',
            centerTitle: true,
            onBackPressed: widget.fromNotification ? _goToDashboard : null,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BannerCard(campaign: campaign),
                if (campaign.status == CampaignStatus.denied && (campaign.denyNote?.isNotEmpty ?? false)) ...[
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  _DenyNoteCard(note: campaign.denyNote!),
                ],
                const SizedBox(height: Dimensions.paddingSizeDefault),
                _DurationCard(campaign: campaign),
                if (isDetailsLoading && campaign.isJoined) ...[
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  CampaignItemListShimmerWidget(itemCount: (campaign.itemCount ?? 1).clamp(1, 3)),
                ] else if (items.isNotEmpty) ...[
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  _ItemListCard(items: items),
                ],
              ],
            ),
          ),
          bottomNavigationBar: !_hasActions(campaign)
              ? null
              : SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.fontSizeLarge),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Color(0x33000000),
                      //     offset: Offset(0, 10),
                      //     blurRadius: 20,
                      //     spreadRadius: -3,
                      //   ),
                      // ],
                    ),
                    child: campaign.isJoined ? _buildJoinedActions(context, campaign, isDetailsLoading) : _buildJoinAction(context, campaign),
                  ),
                ),
        );
      },
      ),
    );
  }

  Widget _buildJoinAction(BuildContext context, CampaignModel campaign) {
    return CustomButtonWidget(
      borderRadius: Dimensions.fontSizeExtraSmall,
      btnTxt: getTranslated('add_item_and_join', context) ?? 'Add Item & Join',
      buttonHeight: 40,
      onTap: campaign.isJoinable ? () => _openItemSheet(campaign) : null,
    );
  }

  bool _hasActions(CampaignModel campaign) {
    if (campaign.scheduleStatus == 'expired') return false;
    return campaign.isJoined || campaign.isJoinable;
  }

  Widget _buildJoinedActions(BuildContext context, CampaignModel campaign, bool isDetailsLoading) {
    final CampaignController campaignController = Provider.of<CampaignController>(context, listen: false);
    final bool canEdit = campaign.acceptsItemChanges && !isDetailsLoading;

    final String leaveText;
    final String editText;
    switch (campaign.status) {
      case CampaignStatus.pending:
        leaveText = getTranslated('cancel_request', context) ?? 'Cancel Request';
        editText = getTranslated('edit', context) ?? 'Edit';
        break;
      case CampaignStatus.denied:
        leaveText = getTranslated('delete', context) ?? 'Delete';
        editText = getTranslated('edit_and_rejoin', context) ?? 'Edit & Re-join';
        break;
      default:
        leaveText = getTranslated('leave_campaign', context) ?? 'Leave Campaign';
        editText = getTranslated('edit', context) ?? 'Edit';
    }

    return Row(
      children: [
        Expanded(
          child: CustomButtonWidget(
            isColor: true,
            backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.15),
            fontColor: Theme.of(context).textTheme.bodyLarge?.color,
            borderRadius: Dimensions.fontSizeExtraSmall,
            btnTxt: leaveText,
            buttonHeight: 40,
            onTap: campaignController.isLeaving ? null : () => _confirmLeave(campaign),
            textStyle : robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeMedium),
        Expanded(
          child: CustomButtonWidget(
            isColor: !canEdit,
            backgroundColor: canEdit ? null : Theme.of(context).hintColor.withValues(alpha: 0.4),
            borderRadius: Dimensions.fontSizeExtraSmall,
            btnTxt: editText,
            buttonHeight: 40,
            onTap: canEdit ? () => _openItemSheet(campaign) : isDetailsLoading ? null : () => showCustomSnackBarWidget(
              getTranslated('campaign_items_can_no_longer_be_changed', context) ?? 'This campaign has already started, so its items can no longer be changed.',
              context,
              sanckBarType: SnackBarType.warning,
            ),
          ),
        ),
      ],
    );
  }

  void _openItemSheet(CampaignModel campaign) {
    final int? id = campaign.id;
    if (id == null) return;

    showAddItemsBottomSheet(
      context,
      campaignId: id,
      minDiscount: campaign.minDiscount ?? 0,
      maxDiscount: campaign.maxDiscount ?? 0,
      joinedItems: campaign.isJoined ? (campaign.items ?? []) : const [],
      status: campaign.status,
    );
  }

  void _confirmLeave(CampaignModel campaign) {
    final int? id = campaign.id;
    if (id == null) return;

    final String title;
    final String description;
    switch (campaign.status) {
      case CampaignStatus.pending:
        title = getTranslated('cancel_request', context) ?? 'Cancel Request';
        description = getTranslated('are_you_sure_to_cancel_campaign_request', context) ??
            'Are you sure you want to cancel your request to join this campaign?';
        break;
      case CampaignStatus.denied:
        title = getTranslated('delete', context) ?? 'Delete';
        description = getTranslated('are_you_sure_to_delete_campaign_request', context) ??
            'Are you sure you want to delete this campaign request?';
        break;
      default:
        title = getTranslated('leave_campaign', context) ?? 'Leave Campaign';
        description = getTranslated('are_you_sure_to_leave_campaign', context) ??
            'Are you sure you want to leave this campaign?';
    }

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
}

class _BannerCard extends StatefulWidget {
  final CampaignModel campaign;
  const _BannerCard({required this.campaign});

  @override
  State<_BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<_BannerCard> {
  static const int _collapsedLines = 2;
  bool _isExpanded = false;

  bool _isOverflowing(String description, TextStyle style, double maxWidth) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: description, style: style),
      maxLines: _collapsedLines,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: maxWidth);
    return painter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final CampaignModel campaign = widget.campaign;

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: CustomImageWidget(
              image: campaign.bannerImage ?? '',
              width: double.infinity,
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeMedium),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(campaign.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              if (campaign.isJoined || campaign.scheduleStatus == 'expired' || campaign.isJoinable)
                _StatusBadge(status: campaign.status, isExpired: campaign.scheduleStatus == 'expired'),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Builder(
            builder: (context) {
              final String description = campaign.description ?? '';
              final TextStyle style = robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).textTheme.headlineLarge?.color,
              );

              return LayoutBuilder(
                builder: (context, constraints) {
                  final bool isOverflowing = _isOverflowing(description, style, constraints.maxWidth);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(description,
                        maxLines: _isExpanded ? null : _collapsedLines,
                        overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                        style: style,
                      ),

                      if (isOverflowing) ...[
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        InkWell(
                          onTap: () => setState(() => _isExpanded = !_isExpanded),
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: Text(
                            _isExpanded ? getTranslated('see_less', context) ?? 'See Less' : getTranslated('see_more', context) ?? 'See More',
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

}

class _DurationCard extends StatelessWidget {
  final CampaignModel campaign;
  const _DurationCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomAssetImageWidget(
                Images.campaignDurationIcon, width: 16, height: 16,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text(
                getTranslated('campaign_duration', context) ?? 'Campaign Duration',
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          _InfoRow(
            label: getTranslated('active_time', context) ?? 'Active Time',
            value: campaign.activeTime ?? '',
          ),
          _InfoRow(
            label: getTranslated('duration', context) ?? 'Duration',
            value: campaign.duration ?? '',
            valueFontWeight: FontWeight.w400,
          ),
          _InfoRow(
            label: getTranslated('created_at', context) ?? 'Created At',
            value: DateConverter.utcStringToAuctionDateTime(campaign.createdAt),
            valueFontWeight: FontWeight.w400,
          ),
          _InfoRow(
            label: getTranslated('discount_limit_percent', context) ?? 'Discount Limit(%)',
            value: '${_format(campaign.minDiscount)}% - ${_format(campaign.maxDiscount)}%',
            isLast: true,
          ),
        ],
      ),
    );
  }

  String _format(double? value) {
    if (value == null) return '0';
    return value == value.roundToDouble() ? value.toInt().toString() : value.toString();
  }
}

class _StatusBadge extends StatelessWidget {
  final CampaignStatus status;
  final bool isExpired;
  const _StatusBadge({required this.status, this.isExpired = false});

  bool get _showExpired => isExpired && status == CampaignStatus.notJoined;

  Color _color(BuildContext context) {
    if (_showExpired) return Theme.of(context).colorScheme.error;
    switch (status) {
      case CampaignStatus.approved:
        return Theme.of(context).colorScheme.onTertiaryContainer;
      case CampaignStatus.denied:
        return Theme.of(context).colorScheme.error;
      case CampaignStatus.pending:
      case CampaignStatus.notJoined:
        return Theme.of(context).colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = _color(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeOrder),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
      ),
      child: Text(
        _showExpired ? getTranslated('expired', context) ?? 'Expired' : getTranslated(status.translationKey, context) ?? '',
        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: color),
      ),
    );
  }
}

class _DenyNoteCard extends StatelessWidget {
  final String note;
  const _DenyNoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated('deny_note', context) ?? 'Deny Note',
            style: robotoBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(
            note,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.headlineLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemListCard extends StatelessWidget {
  final List<CampaignItemModel> items;
  const _ItemListCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: getTranslated('item_list', context) ?? 'Item List',
                style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              TextSpan(
                text: ' (${items.length})',
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: items.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
            itemBuilder: (context, index) => _JoinedItemRow(item: items[index], serial: index + 1),
          ),
        ),
      ],
    );
  }
}

class _JoinedItemRow extends StatelessWidget {
  final CampaignItemModel item;
  final int serial;
  const _JoinedItemRow({required this.item, required this.serial});

  String _format(double? value) {
    if (value == null) return '0';
    return value == value.roundToDouble() ? value.toInt().toString() : value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                image: item.image ?? '',
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: Text(
              item.name,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Container(
            width: 70,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              '${_format(item.discount)}%',
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final FontWeight? valueFontWeight;
  const _InfoRow({required this.label, required this.value, this.isLast = false, this.valueFontWeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : Dimensions.paddingSizeExtraSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Text(
            ': ',
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          
          Expanded(
            child: Text(
              value,
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: valueFontWeight ?? FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }
}
