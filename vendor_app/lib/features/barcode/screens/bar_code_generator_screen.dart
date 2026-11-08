import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/barcode/controllers/barcode_controller.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/helper/debounce_helper.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_field_with_title_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';

class BarCodeGenerateScreen extends StatefulWidget {
  final Product? product;
  const BarCodeGenerateScreen({super.key, this.product});

  @override
  State<BarCodeGenerateScreen> createState() => _BarCodeGenerateScreenState();
}

class _BarCodeGenerateScreenState extends State<BarCodeGenerateScreen> {
  TextEditingController quantityController = TextEditingController();
  int barCodeQuantity = 4;
  bool _isCompactLayout = false;
  final DebounceHelper _downloadDebounce = DebounceHelper(milliseconds: 500);

  static const double _compactLabelWidth = 150;

  @override
  void initState() {
    super.initState();
    quantityController.text = '4';
  }

  @override
  void dispose() {
    _downloadDebounce.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('bar_code_generator', context)),
      body: Consumer<BarcodeController>(
        builder: (context, barCodeController,_) {
          return Column(children: [
            Column(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                child: Column(children: [

                  Row(children: [
                    Text('${getTranslated('code', context)} : '),
                    Text('${widget.product!.code}', style: robotoRegular.copyWith(color: Theme.of(context).hintColor))],),

                  Row(children: [
                   Text('${getTranslated('product_name', context)} : '),
                   Expanded(
                     child: Text('${widget.product!.name}', maxLines: 2,overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                  )],),
              ],),),

              CustomFieldWithTitleWidget(
                isSKU: true,
                limitSet: true,
                setLimitTitle: getTranslated('maximum_quantity_270', context),
                customTextField: CustomTextFieldWidget(
                    isPhoneNumber: true,
                    controller: quantityController),
                title: '${getTranslated('qty', context)} (1-270)',
                requiredField: true,
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(getTranslated('layout', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),

                  InkWell(
                    onTap: () => setState(() => _isCompactLayout = !_isCompactLayout),
                    child: Row(children: [
                      SizedBox(
                        width: Dimensions.iconSizeLarge,
                        height: Dimensions.iconSizeLarge,
                        child: Checkbox(
                          value: _isCompactLayout,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (value) => setState(() => _isCompactLayout = value ?? false),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Text(getTranslated('compact_label', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                    ]),
                  ),

                  Text(getTranslated('compact_label_hint', context)!,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                ]),
              ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                const SizedBox(width: Dimensions.fontSizeSmall),
                Expanded(child: CustomButtonWidget(btnTxt: getTranslated('generate', context),
                onTap: (){
                  if(int.parse(quantityController.text)>270 || int.parse(quantityController.text) ==0){
                    showCustomSnackBarWidget(getTranslated('please_enter_from_1_to_270', context), context);
                  }else{
                   barCodeController.setBarCodeQuantity(int.parse(quantityController.text));
                  }})),
                const SizedBox(width: Dimensions.fontSizeSmall),

                Expanded(child: CustomButtonWidget(btnTxt: getTranslated('download', context),
                    isLoading: barCodeController.isGetting,
                    onTap : barCodeController.isGetting ? null : () => _downloadDebounce.run(() {
                        barCodeController.barCodeDownload(Get.context!, widget.product!.id,int.parse( quantityController.text), isCompact: _isCompactLayout);
                      }))),

                const SizedBox(width: Dimensions.fontSizeSmall),

                Expanded(child: CustomButtonWidget(isColor: true, fontColor: Theme.of(context).textTheme.bodyLarge?.color, btnTxt: getTranslated('reset', context),onTap: (){
                  quantityController.text = '4';
                  setState(() => _isCompactLayout = false);
                 barCodeController.setBarCodeQuantity(4);
                },
                backgroundColor: Theme.of(context).hintColor.withValues(alpha: .1),
              )),
                const SizedBox(width: Dimensions.fontSizeSmall),

              ],)
            ],),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: _isCompactLayout ? ListView.separated(
                itemCount: barCodeController.barCodeQuantity,
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                separatorBuilder: (_, __) => const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                itemBuilder: (context, index) => Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: _compactLabelWidth,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
                    ),
                    child: BarcodeWidget(
                      data: '${widget.product!.code}',
                      barcode: Barcode.code128(),
                      height: 40,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.black),
                    ),
                  ),
                ),
              ) : GridView.builder(
                itemCount: barCodeController.barCodeQuantity,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1/1.2,
                  ), itemBuilder: (barcode, index){
                    return Column(
                      children: [
                        Text(AppConstants.companyName,
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),),
                        Text('${widget.product!.name}', maxLines: 1,overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
                        Text(PriceConverter.convertPrice(context, widget.product!.unitPrice)),
                        BarcodeWidget(
                          data: 'code : ${widget.product!.code}',style: robotoRegular.copyWith(),
                          barcode: Barcode.code128(),
                        )],);
                }),
            ))
          ],);
        }
      ),
    );
  }
}
