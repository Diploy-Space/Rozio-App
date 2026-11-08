import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/shipping/domain/models/shipping_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/shipping/controllers/wholesale_shipping_controller.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';

class WholesaleOrderWiseShippingAddScreen extends StatefulWidget {
  final ShippingModel? shipping;
  const WholesaleOrderWiseShippingAddScreen({super.key, this.shipping});
  @override
  WholesaleOrderWiseShippingAddScreenState createState() => WholesaleOrderWiseShippingAddScreenState();
}

class WholesaleOrderWiseShippingAddScreenState extends State<WholesaleOrderWiseShippingAddScreen> {

  TextEditingController? _titleController ;
  TextEditingController? _durationController ;
  TextEditingController? _costController ;

  final FocusNode _titleNode = FocusNode();
  final FocusNode _durationNode = FocusNode();
  final FocusNode _costNode = FocusNode();
  GlobalKey<FormState>? _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _titleController = TextEditingController(text: widget.shipping?.title ?? '');
    _durationController = TextEditingController(text: widget.shipping?.duration ?? '');
    _costController = TextEditingController(
      text: widget.shipping?.cost != null ? PriceConverter.convertAmount(widget.shipping!.cost!, context).toString() : '',
    );
  }

  @override
  void dispose() {
    _titleController!.dispose();
    _durationController!.dispose();
    _costController!.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    String title = _titleController!.text.trim();
    String cost = _costController!.text.trim();
    String duration = _durationController!.text.trim();
    final double? parsedCost = double.tryParse(cost);

    if(title.isEmpty){
      showCustomSnackBarWidget(getTranslated('enter_title', context),context,  sanckBarType: SnackBarType.warning);
    }else if(parsedCost == null){
      showCustomSnackBarWidget(getTranslated('enter_cost', context),context,  sanckBarType: SnackBarType.warning);
    }else if(duration.isEmpty){
      showCustomSnackBarWidget(getTranslated('enter_duration', context),context,  sanckBarType: SnackBarType.warning);
    } else{
      final WholesaleShippingController shippingController = Provider.of<WholesaleShippingController>(context, listen: false);
      final double defaultCost = PriceConverter.systemCurrencyToDefaultCurrency(parsedCost, context);
      final bool isSuccess = widget.shipping == null
          ? await shippingController.addShippingMethod(ShippingModel(title: title, duration: duration, cost: defaultCost))
          : await shippingController.updateShippingMethod(title, duration, defaultCost, widget.shipping!.id);

      if(isSuccess && mounted){
        showCustomSnackBarWidget(getTranslated(widget.shipping == null ? 'shipping_method_added_successfully' : 'shipping_method_update_successfully', context), context, isError: false);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Form(
          key: _formKey,
          child: ListView(shrinkWrap: true, physics: const BouncingScrollPhysics(), children: [

              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(getTranslated('shipping_method_title', context)!,
                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).hintColor,)),

              const SizedBox(height: Dimensions.paddingSizeSmall),

              CustomTextFieldWidget(
                border: true,
                hintText: getTranslated('enter_shipping_method_title', context),
                focusNode: _titleNode,
                nextNode: _durationNode,
                controller: _titleController,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(getTranslated('duration', context)!,
                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).hintColor,)),

              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomTextFieldWidget(
                border: true,
                hintText: 'Ex: 4-6 days',
                focusNode: _durationNode,
                nextNode: _costNode,
                controller: _durationController,
                textInputType: TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 22),
              Text(getTranslated('cost', context)!,
                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).hintColor,)),

              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomTextFieldWidget(
                border: true,
                hintText: 'Ex: \$100',
                controller: _costController,
                focusNode: _costNode,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.number,
                isAmount: true,
              ),

              const SizedBox(height: 50),

              Consumer<WholesaleShippingController>(builder: (context, shippingController, child) {
                return CustomButtonWidget(
                  fontColor: Colors.white,
                  isLoading: shippingController.isLoading,
                  btnTxt: widget.shipping == null?
                  getTranslated('save', context):getTranslated('update', context),
                  onTap: shippingController.isLoading ? null : _onSubmit,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
