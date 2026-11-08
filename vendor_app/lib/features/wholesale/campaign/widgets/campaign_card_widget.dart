import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/models/campaign_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/enums/campaign_menu_action.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/enums/campaign_status.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CampaignCardWidget extends StatelessWidget {
  final CampaignModel campaign;
  final ValueChanged<CampaignMenuAction>? onMenuSelected;
  final VoidCallback? onTap;
  const CampaignCardWidget({super.key, required this.campaign, this.onMenuSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isLtr = Provider.of<LocalizationController>(context, listen: false).isLtr;

    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child: Container(
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: ThemeShadow.getShadow(context),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAssetImageWidget(Images.campaignIcon, width: Dimensions.fontSizeLarge, height: Dimensions.fontSizeLarge),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Text(
                        campaign.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),

                    const SizedBox(width: Dimensions.iconSizeMedium + Dimensions.paddingSizeSmall),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(
                  children: [
                    Text(
                      '${getTranslated('discount_limit', context) ?? ''} : ',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                      ),
                    ),
                    Text(
                      '${_formatDiscount(campaign.minDiscount)}% - ${_formatDiscount(campaign.maxDiscount)}%',
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: Container(width: 1, height: 14, color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
                    ),
                    Text(
                      '${campaign.itemCount ?? 0} ',
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      getTranslated('items', context) ?? '',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            '${getTranslated('active_time', context) ?? ''} : ',
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.headlineLarge?.color,
                            ),
                          ),
                          Text(
                            campaign.activeTime ?? '',
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (campaign.status != CampaignStatus.notJoined)
                      _StatusBadge(status: campaign.status)
                    else if (campaign.isJoinable)
                      _JoinButton(onTap: () => onMenuSelected?.call(CampaignMenuAction.join))
                    else if (campaign.scheduleStatus == 'expired')
                      _StatusBadge(status: campaign.status, label: getTranslated('expired', context) ?? 'Expired'),
                  ],
                ),
              ],
            ),
          ),
        ),

          Positioned(
            top: 10,
            right: isLtr ? 10 : null,
            left: isLtr ? null : 10,
            child: _CampaignMenu(campaign: campaign, onSelected: onMenuSelected),
          ),
        ],
    );
  }

  String _formatDiscount(double? value) {
    if (value == null) return '0';
    return value == value.roundToDouble() ? value.toInt().toString() : value.toString();
  }
}

class _CampaignMenu extends StatelessWidget {
  final CampaignModel campaign;
  final ValueChanged<CampaignMenuAction>? onSelected;
  const _CampaignMenu({required this.campaign, this.onSelected});

  @override
  Widget build(BuildContext context) {
    final bool isExpired = campaign.scheduleStatus == 'expired';

    return PopupMenuButton<CampaignMenuAction>(
      padding: EdgeInsets.zero,
      offset: const Offset(0, 30),
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      onSelected: (action) => onSelected?.call(action),
      itemBuilder: (context) => [
        _buildItem(
          context,
          value: CampaignMenuAction.view,
          icon: Icons.remove_red_eye_outlined,
          label: getTranslated('view', context) ?? 'View',
        ),
        if (campaign.status == CampaignStatus.notJoined && campaign.isJoinable)
          _buildItem(
            context,
            value: CampaignMenuAction.join,
            icon: Icons.add_circle_outline,
            label: getTranslated('join', context) ?? 'Join',
          ),
        if (!isExpired && campaign.status == CampaignStatus.pending)
          _buildItem(
            context,
            value: CampaignMenuAction.cancelRequest,
            icon: Icons.cancel_outlined,
            label: getTranslated('cancel_request', context) ?? 'Cancel Request',
          ),
        if (!isExpired && campaign.status == CampaignStatus.approved)
          _buildItem(
            context,
            value: CampaignMenuAction.leave,
            icon: Icons.logout,
            label: getTranslated('leave_campaign', context) ?? 'Leave Campaign',
          ),
        if ((campaign.status == CampaignStatus.pending || campaign.status == CampaignStatus.approved) && campaign.acceptsItemChanges)
          _buildItem(
            context,
            value: CampaignMenuAction.edit,
            icon: Icons.edit_outlined,
            label: getTranslated('edit', context) ?? 'Edit',
          ),
        if (!isExpired && campaign.status == CampaignStatus.denied)
          _buildItem(
            context,
            value: CampaignMenuAction.delete,
            icon: Icons.delete_outline,
            label: getTranslated('delete', context) ?? 'Delete',
          ),
        if (campaign.status == CampaignStatus.denied && campaign.acceptsItemChanges)
          _buildItem(
            context,
            value: CampaignMenuAction.reJoin,
            icon: Icons.refresh,
            label: getTranslated('edit_and_rejoin', context) ?? 'Edit & Re-join',
          ),
      ],
      child: Icon(Icons.more_vert, size: Dimensions.iconSizeMedium, color: Theme.of(context).hintColor),
    );
  }

  PopupMenuItem<CampaignMenuAction> _buildItem(
    BuildContext context, {
    required CampaignMenuAction value,
    required IconData icon,
    required String label,
  }) {
    return PopupMenuItem<CampaignMenuAction>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: Dimensions.iconSizeDefault, color: Theme.of(context).primaryColor),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Text(
            label,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _JoinButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _JoinButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeOrder),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: Text(
          getTranslated('join', context) ?? '',
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final CampaignStatus status;
  final String? label;
  const _StatusBadge({required this.status, this.label});

  Color _color(BuildContext context) {
    if (label != null) return Theme.of(context).colorScheme.error;
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
        label ?? getTranslated(status.translationKey, context) ?? '',
        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: color),
      ),
    );
  }
}
