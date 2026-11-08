import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/dropdown_decorator_widget.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';


class CustomDatePickerWidget extends StatefulWidget {
  final String? title;
  final String? text;
  final String? image;
  final bool requiredField;
  final bool fromClearance;
  final bool fromVacation;
  final Function? selectDate;
  final Color? borderColor;
  final bool? prefixIcon;
  final bool? isTitleTransparent;
  final bool? iconHintColor;
  final String? errorText;
  const CustomDatePickerWidget({super.key, this.title,this.text,this.image, this.fromClearance = false, this.fromVacation = false, this.requiredField = false,this.selectDate, this.borderColor, this.prefixIcon = true, this.isTitleTransparent = false, this.iconHintColor = false, this.errorText});

  @override
  State<CustomDatePickerWidget> createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.only(left: !widget.fromClearance ? Dimensions.paddingSizeDefault : 0,
        right: !widget.fromClearance ?  Dimensions.paddingSizeDefault : 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        DropdownDecoratorWidget(
          title: widget.title,
          isRequired: widget.requiredField,
          isTitleTransparent: widget.isTitleTransparent ?? false,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSize),
            child: InkWell(
              onTap: widget.selectDate as void Function()?,
              child: Row(mainAxisAlignment: widget.prefixIcon! ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceBetween, children: [
                if(widget.prefixIcon!)...[
                  SizedBox(width: 20,height: 20,child: Image.asset(widget.image!, color: widget.fromClearance ? Theme.of(context).primaryColor : Theme.of(context).hintColor)),
                  SizedBox(width: widget.fromVacation ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall),
                ],
                if(widget.fromVacation)
                  Flexible(child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(widget.text!, maxLines: 1, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).textTheme.bodyLarge!.color)),
                  ))
                else
                  Text(widget.text!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).textTheme.bodyLarge!.color)),
            
                if(!widget.prefixIcon!)...[
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  SizedBox(width: 20,height: 20,child: Image.asset(widget.image!, color: widget.fromClearance  ? widget.iconHintColor! ? Theme.of(context).hintColor : Theme.of(context).primaryColor : Theme.of(context).hintColor))
                ],
              ]),
            ),
          ),
        ),

        if (widget.errorText != null)
          Text(widget.errorText!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error)),

      ]),
    );
  }
}
