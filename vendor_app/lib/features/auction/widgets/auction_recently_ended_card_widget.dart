import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/domain/models/auction_home_stats_model.dart';
import 'package:sixvalley_vendor_app/features/auction/screens/auction_details_screen.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AuctionRecentlyEndedCardWidget extends StatefulWidget {
  final AuctionRecentlyEndedModel auction;
  const AuctionRecentlyEndedCardWidget({super.key, required this.auction});

  @override
  State<AuctionRecentlyEndedCardWidget> createState() => _AuctionRecentlyEndedCardWidgetState();
}

class _AuctionRecentlyEndedCardWidgetState extends State<AuctionRecentlyEndedCardWidget> {
  Timer? _timer;
  DateTime? _targetTime;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void didUpdateWidget(covariant AuctionRecentlyEndedCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.auction.remainingClaimSeconds != widget.auction.remainingClaimSeconds) {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    final int? seconds = widget.auction.remainingClaimSeconds;
    if (seconds == null) {
      _targetTime = null;
      _remaining = Duration.zero;
      return;
    }
    _targetTime = DateTime.now().add(Duration(seconds: seconds));
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  void _updateRemaining() {
    if (!mounted || _targetTime == null) return;
    final Duration diff = _targetTime!.difference(DateTime.now());
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
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AuctionDetailsScreen(auctionId: widget.auction.id))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: .075),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: .15)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: CustomImageWidget(
                        image: widget.auction.thumbnail ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _remaining > Duration.zero
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: ColorHelper.blendColors(Theme.of(context).cardColor, Theme.of(context).hintColor, 0.35),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(Dimensions.radiusDefault),
                                bottomRight: Radius.circular(Dimensions.radiusDefault),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  size: Dimensions.iconSizeExtraSmall + 2,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: Dimensions.paddingSizeVeryTiny),
                                Flexible(
                                  child: Text(_formatDuration(_remaining),
                                    overflow: TextOverflow.ellipsis,
                                    style: titilliumBold.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ) : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${getTranslated('auction_id', context) ?? 'Auction id'} #${widget.auction.id}',
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),

                  Text(widget.auction.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: titilliumBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeVeryTiny),

                  _DetailRow(
                    label: getTranslated('final_bid_price', context) ?? 'Final Bid Price',
                    value: PriceConverter.convertPrice(context, widget.auction.finalBidPrice),
                    valueStyle: titilliumBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Row(
                    children: [
                      ClipOval(child: CustomImageWidget(image: widget.auction.winnerAvatar ?? '', height: 24, width: 24, fit: BoxFit.cover)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Expanded(
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: widget.auction.winnerName,
                              style: titilliumSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                            TextSpan(
                              text: ' (${getTranslated(widget.auction.statusKey, context) ?? widget.auction.statusKey})',
                              style: titilliumRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;
  const _DetailRow({required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label  ',
          style: titilliumRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        Expanded(
          child: Text(value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: valueStyle ??
                titilliumBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
          ),
        ),
      ],
    );
  }
}
