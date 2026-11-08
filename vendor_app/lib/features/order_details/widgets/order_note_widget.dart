import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class OrderNoteWidget extends StatelessWidget {
  final String note;
  const OrderNoteWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:.25),spreadRadius: .11,blurRadius: .11, offset: const Offset(0,2))],
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeSmall),
        bottomRight: Radius.circular(Dimensions.paddingSizeSmall))),
      child: Container(decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha:.07),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeSmall),
            bottomRight: Radius.circular(Dimensions.paddingSizeSmall)),),
        padding: const EdgeInsets.fromLTRB( Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,
          Dimensions.paddingSizeDefault),

        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Row(children: [
            Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
              child: Image.asset(Images.orderNote,color: Theme.of(context).textTheme.bodyLarge?.color, width: Dimensions.iconSizeSmall ),),
            Text(getTranslated('order_note', context)!, style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge,
              color: ColorHelper.blendColors(Colors.white, Theme.of(context).textTheme.bodyLarge!.color!, 0.7),)),
          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(note, style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
        ]),
      ),
    );
  }
}
