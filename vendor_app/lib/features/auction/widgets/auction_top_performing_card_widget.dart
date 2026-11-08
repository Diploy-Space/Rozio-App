import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/domain/models/auction_home_stats_model.dart';
import 'package:sixvalley_vendor_app/features/auction/screens/auction_details_screen.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AuctionTopPerformingCardWidget extends StatefulWidget {
  final AuctionTopPerformingModel auction;
  const AuctionTopPerformingCardWidget({super.key, required this.auction});

  @override
  State<AuctionTopPerformingCardWidget> createState() => _AuctionTopPerformingCardWidgetState();
}

class _AuctionTopPerformingCardWidgetState extends State<AuctionTopPerformingCardWidget> {
  Timer? _timer;
  late DateTime _targetTime;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void didUpdateWidget(covariant AuctionTopPerformingCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.auction.closesInSeconds != widget.auction.closesInSeconds) {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    _targetTime = DateTime.now().add(Duration(seconds: widget.auction.closesInSeconds));
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  void _updateRemaining() {
    if (!mounted) return;
    final Duration diff = _targetTime.difference(DateTime.now());
    setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
  }

  String _formatDuration(Duration duration) {
    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m ${duration.inSeconds.remainder(60)}s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLive = widget.auction.isLive;

    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AuctionDetailsScreen(auctionId: widget.auction.id))),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).cardColor.withValues(alpha: 0.01)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CustomImageWidget(image: widget.auction.thumbnail ?? '', fit: BoxFit.cover),
                  ),
                ),

                Positioned(
                  top: 0,
                  left: 0,
                  child: _StatusBadgeWidget(
                    text: isLive ? getTranslated('live', context) ?? '' : getTranslated('upcoming', context) ?? '',
                    color: isLive ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorHelper.blendColors(Theme.of(context).cardColor, Theme.of(context).hintColor, 0.35),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(Dimensions.radiusSmall),
                        bottomRight: Radius.circular(Dimensions.radiusSmall),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall,
                        vertical: Dimensions.paddingSizeVeryTiny,
                      ),
                      child: Row(
                        children: [
                          Text(
                            isLive ? getTranslated('closes_in', context) ?? '' : getTranslated('starts_in', context) ?? '',
                            style: titilliumRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeVeryTiny),

                          Icon(
                            Icons.timer_outlined,
                            size: Dimensions.iconSizeExtraSmall + 2,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeVeryTiny),

                          Flexible(
                            child: Text(
                              _formatDuration(_remaining),
                              overflow: TextOverflow.ellipsis,
                              style: titilliumBold.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: Dimensions.paddingSizeSmall),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.auction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Row(
                  children: [
                    Text(
                      isLive ? getTranslated('highest_bid', context) ?? '' : getTranslated('starting_price', context) ?? '',
                      style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeVeryTiny),

                    Flexible(
                      child: Text(
                        PriceConverter.convertPrice(context, widget.auction.highestBid),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: titilliumBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye,
                      size: Dimensions.iconSizeExtraSmall + 2,
                      color: Theme.of(context).hintColor,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeVeryTiny),
                    Text(
                      '${widget.auction.views}',
                      style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),

                    if (isLive) ...[
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      CustomAssetImageWidget(
                        Images.gavelGreyIcon,
                        height: Dimensions.iconSizeExtraSmall + 2,
                        width: Dimensions.iconSizeExtraSmall + 2,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeVeryTiny),
                      Text(
                        '${widget.auction.bidCount}',
                        style: titilliumRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadgeWidget extends StatelessWidget {
  final String text;
  final Color color;
  const _StatusBadgeWidget({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeVeryTiny),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusSmall),
          bottomRight: Radius.circular(Dimensions.radiusSmall),
        ),
      ),
      child: Center(
        child: Text(text,
          style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
