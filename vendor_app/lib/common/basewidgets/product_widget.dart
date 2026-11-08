import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/screens/add_product_tab_view_screen.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/filter_model.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/features/product/widgets/top_most_product_card_widget.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/product_controller.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/features/product_details/screens/product_details_screen.dart';

class ProductWidget extends StatefulWidget {
  final Product productModel;
  const ProductWidget({super.key, required this.productModel});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var mini = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.left;
  var buttonSize = const Size(35.0, 35.0);
  var childrenButtonSize = const Size(45.0, 45.0);

  bool hasDiscount() => (widget.productModel.discount != null && widget.productModel.discount! > 0) ||
      (widget.productModel.clearanceSale?.discountAmount ?? 0) > 0;

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width/2.5;
    double totalRatting = 0;
    double averageProductRatting = 0;
    final List<Reviews> reviews = widget.productModel.reviews ?? [];
    if(reviews.isNotEmpty){
      for(int i =0; i< reviews.length; i++ ){
        totalRatting += reviews[i].rating ?? 0;
      }
      averageProductRatting = totalRatting/reviews.length;
    }
    final bool isStockOut = widget.productModel.currentStock == 0;

    return SizedBox(width: imageSize+20,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeExtraSmall, 0,
            Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeExtraSmall),
        child: GestureDetector(
          onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> ProductDetailsScreen(productModel: widget.productModel))),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              boxShadow: [BoxShadow(color: Provider.of<ThemeController>(context, listen: false).darkTheme?Theme.of(context).primaryColor.withValues(alpha:0):
              Theme.of(context).primaryColor.withValues(alpha:.125), blurRadius: 1, spreadRadius: 1, offset: const Offset(1,2))],
            ),
            child: Column(children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha:.10),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),),
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.paddingSizeExtraSmall),
                          topRight: Radius.circular(Dimensions.paddingSizeExtraSmall),
                        ),
                        child: SizedBox.expand(
                          child: CustomImageWidget(image: '${widget.productModel.thumbnailFullUrl?.path}'),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 0, right: 0, bottom: 10,
                      child: Center(child: Container(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: isStockOut ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSecondary,
                          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                        ),
                        child: Text('${widget.productModel.currentStock.toString()} ${getTranslated(isStockOut ? 'stock_out' : 'in_stock', context)}',
                          style: robotoMedium.copyWith(color: Colors.white),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      )),
                    ),

                    if(hasDiscount())
                      DiscountTagWidget(positionedTop: 5, positionedLeft: 0, positionedRight: 0, productModel: widget.productModel),

                    Positioned(top: 0,right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SpeedDial(
                          animationDuration: const Duration(milliseconds: 300),
                          overlayOpacity: 0,
                          icon: Icons.more_horiz,
                          activeIcon: Icons.close,
                          spacing: 3,
                          mini: mini,
                          openCloseDial: isDialOpen,
                          childPadding: const EdgeInsets.all(5),
                          spaceBetweenChildren: 4,
                          buttonSize: buttonSize,
                          childrenButtonSize: childrenButtonSize,
                          visible: visible,
                          direction: speedDialDirection,
                          switchLabelPosition: switchLabelPosition,
                          closeManually: true,
                          renderOverlay: renderOverlay,
                          useRotationAnimation: useRAnimation,
                          backgroundColor: Theme.of(context).cardColor,
                          foregroundColor: Theme.of(context).disabledColor,
                          elevation: extend? 0: 8.0,
                          animationCurve: Curves.elasticInOut,
                          isOpenOnStart: false,
                          shape: customDialRoot ? const RoundedRectangleBorder() : const StadiumBorder(),
                          onOpen: () {
                            setState(() {
                              extend = true;
                            });
                          },
                          onClose: () {
                            setState(() {
                              extend = false;
                            });
                          },
                          children: [
                            SpeedDialChild(elevation: 0,
                              child: Padding(padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(Images.editIcon)),

                              onTap:() async {
                              setState(() {
                              isDialOpen.value = false;
                              extend = false;
                              });

                              await Future.delayed(const Duration(milliseconds : 350));
                                Navigator.of(Get.context!).push(MaterialPageRoute(builder: (_) => AddProductTabView(product: widget.productModel, fromHome: false)));
                              },
                            ),
                            SpeedDialChild( elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(Images.delete),
                              ),
                              onTap: () async {
                                setState(() {
                                  isDialOpen.value = false;
                                  extend = false;
                                });

                                await Future.delayed(const Duration(milliseconds : 350));
                                showDialog(context: Get.context!, builder: (BuildContext context){
                                  return ConfirmationDialogWidget(icon: Images.deleteProduct,
                                    refund: false,
                                    description: getTranslated('are_you_sure_want_to_delete_this_product', context),
                                    onYesPressed: () async {
                                      final bool isDeleted = await Provider.of<ProductController>(context, listen:false)
                                          .deleteProduct(context, widget.productModel.id);

                                      if(context.mounted) Navigator.pop(context);

                                      if(isDeleted) {
                                        Provider.of<ProductController>(Get.context!,listen: false).getStockOutProductList(1, 'en');
                                        Provider.of<ProductController>(Get.context!, listen: false).getSellerProductList(
                                          Provider.of<ProfileController>(Get.context!, listen: false).userInfoModel!.id.toString(), 1, 'en','',
                                            filterSearchModel: FilterModel(
                                            reload: true
                                          )
                                        );
                                      }
                                    },
                                  );});
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeExtraSmall, 0,
                  Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeExtraSmall,),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Text(widget.productModel.name ?? '', textAlign: TextAlign.center, style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ), maxLines: 1, overflow: TextOverflow.ellipsis),

                  if(hasDiscount())
                    Text(PriceConverter.convertPrice(context, widget.productModel.unitPrice), style: robotoRegular.copyWith(
                      color: Theme.of(context).hintColor,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Theme.of(context).hintColor,
                      fontSize: Dimensions.fontSizeSmall,
                    ), maxLines: 1, overflow: TextOverflow.ellipsis),

                  Text(
                    PriceConverter.convertPrice(
                      context, widget.productModel.unitPrice,
                      discountType: (widget.productModel.clearanceSale?.discountAmount ?? 0) > 0
                        ? widget.productModel.clearanceSale?.discountType : widget.productModel.discountType,
                      discount: (widget.productModel.clearanceSale?.discountAmount ?? 0) > 0
                        ? widget.productModel.clearanceSale?.discountAmount : widget.productModel.discount
                    ),
                    style: robotoBold.copyWith(color:  Provider.of<ThemeController>(context).darkTheme ?
                    Theme.of(context).textTheme.bodyLarge?.color :
                    Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),

                  if(averageProductRatting > 0) Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.star_rate_rounded, color: Colors.orange, size: Dimensions.paddingSizeDefault),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(averageProductRatting.toStringAsFixed(1), style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      )),
                    ),

                    Text('(${PriceConverter.longToShortPrice(widget.productModel.reviewsCount?.toDouble() ?? 0, withDecimalPoint: false)})',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                  ]),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
