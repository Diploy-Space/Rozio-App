import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/rating_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/controllers/wholesale_product_review_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/domain/models/wholesale_product_review_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/widgets/wholesale_review_attachments_widget.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductReviewReplyScreen extends StatefulWidget {
  final WholesaleProductReviewModel review;
  const WholesaleProductReviewReplyScreen({super.key, required this.review});

  @override
  State<WholesaleProductReviewReplyScreen> createState() => _WholesaleProductReviewReplyScreenState();
}

class _WholesaleProductReviewReplyScreenState extends State<WholesaleProductReviewReplyScreen> {

  @override
  void initState() {
    super.initState();
    final controller = Provider.of<WholesaleProductReviewController>(context, listen: false);
    controller.emptyReplyText();
    if (widget.review.reply != null) {
      controller.replyController.text = widget.review.reply!.replyText ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: getTranslated('review_reply', context),
        isAction: true,
        isFilter: true,
        widget: Consumer<WholesaleProductReviewController>(
          builder: (context, reviewController, _) {
            return FlutterSwitch(
              width: 40, height: 22, toggleSize: 18, padding: 2,
              activeColor: Theme.of(context).primaryColor,
              value: widget.review.status == 1,
              disabled: reviewController.isStatusUpdating(widget.review.id),
              onToggle: (_) => reviewController.toggleReviewStatus(widget.review),
            );
          },
        ),
      ),
      body: Consumer<WholesaleProductReviewController>(
        builder: (context, reviewController, _) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.review.orderId != null)
                        Text(
                          '${getTranslated('order_id', context)!} # ${widget.review.orderId}',
                          style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                        ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Text(widget.review.productName ?? '', style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Row(
                        children: [
                          FittedBox(child: RatingBar(rating: widget.review.rating, size: 15)),
                          Padding(
                            padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                            child: Text(
                              (widget.review.rating ?? 0).toString(),
                              style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Text(
                        widget.review.customerName ?? '',
                        style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      if (widget.review.createdAt != null)
                        Text(
                          DateConverter.localDateToIsoStringAMPM(DateTime.parse(widget.review.createdAt!)),
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                        ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Text(
                        widget.review.comment ?? '',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                        textAlign: TextAlign.justify,
                      ),
                      WholesaleReviewAttachmentsWidget(attachments: widget.review.attachments),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      CustomTextFieldWidget(
                        isDescription: true,
                        controller: reviewController.replyController,
                        textInputType: TextInputType.multiline,
                        maxLine: 4,
                        border: true,
                        hintText: getTranslated('write_your_reply_here', context),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: .125), spreadRadius: 2, blurRadius: 5, offset: Offset.fromDirection(1, 2))],
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
                width: MediaQuery.of(context).size.width,
                child: !reviewController.isReplyLoading
                    ? CustomButtonWidget(
                        borderRadius: 10,
                        backgroundColor: Theme.of(context).primaryColor,
                        onTap: () => reviewController.sendReply(context, widget.review),
                        btnTxt: widget.review.reply != null ? getTranslated('update_reply', context) : getTranslated('submit', context),
                      )
                    : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
              ),
            ],
          );
        },
      ),
    );
  }
}
