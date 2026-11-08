import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CustomSearchFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final String prefix;
  final Function iconPressed;
  final Function(String text)? onSubmit;
  final Function? onChanged;
  final Function? filterAction;
  final bool isFilter;
  final bool showCloseIcon;
  final EdgeInsetsGeometry? contentPadding;
  final double iconSize;

  const CustomSearchFieldWidget({super.key,
    required this.controller, required this.hint, required this.prefix, required this.iconPressed, this.onSubmit, this.onChanged, this.filterAction, this.isFilter = false,
    this.showCloseIcon = false, this.contentPadding, this.iconSize = 20});

  @override
  State<CustomSearchFieldWidget> createState() => _CustomSearchFieldWidgetState();
}

class _CustomSearchFieldWidgetState extends State<CustomSearchFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
          ),
          child: TextField(
            controller: widget.controller,
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
              isDense: true,
              contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
              suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: InkWell(
                onTap: () => widget.iconPressed(),
                child: Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Icon(widget.showCloseIcon ? Icons.close : Icons.search, color: Colors.white, size: widget.iconSize),
                ),
              ),
            ),
            onSubmitted: widget.onSubmit,
            onChanged: widget.onChanged as void Function(String)?,
          ),
        ),
      ),


      widget.isFilter ? Padding(
        padding:  EdgeInsets.only(
          left :  Provider.of<LocalizationController>(context, listen: false).isLtr? Dimensions.paddingSizeSmall : 0,
          right :  Provider.of<LocalizationController>(context, listen: false).isLtr? 0 : Dimensions.paddingSizeSmall
        ),
        child: GestureDetector(
          onTap: widget.filterAction as void Function()?,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Image.asset(Images.filterIcon, color: Colors.white),
          ),
        ),
      ) : const SizedBox(),
    ],);
  }
}