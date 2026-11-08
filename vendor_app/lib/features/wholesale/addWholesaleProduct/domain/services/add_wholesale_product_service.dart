import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/add_wholesale_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_attribute_image_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_faq_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_meta_seo_info_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/repositories/add_wholesale_product_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/services/add_wholesale_product_service_interface.dart';

class AddWholesaleProductService implements AddWholesaleProductServiceInterface {
  final AddWholesaleProductRepositoryInterface addWholesaleProductRepoInterface;
  AddWholesaleProductService({required this.addWholesaleProductRepoInterface});

  @override
  Future<ApiResponse> addWholesaleProduct({
    required AddWholesaleProductModel addWholesaleProduct,
    required int categoryId,
    int? subCategoryId,
    int? subSubCategoryId,
    int? brandId,
    required String code,
    required String unit,
    int? reorderLevel,
    required double shippingCost,
    bool multiplyQty = false,
    String? tags,
    bool colorsActive = false,
    List<String?>? colors,
    List<int>? choiceAttributeIds,
    List<String?>? choiceAttributeNames,
    Map<int, List<String?>>? choiceOptions,
    Map<String, int>? variantQuantities,
    Map<String, String>? variantSkus,
    int? currentStock,
    required int minimumOrderQty,
    double? discount,
    required String discountType,
    List<int>? taxIds,
    bool variationBasedPrice = false,
    bool quantityBasedPrice = false,
    String? variationType,
    Map<String, String>? variationPrice,
    Map<String, String>? variationDiscount,
    List<String>? tierMinQty,
    List<String>? tierMaxQty,
    List<String>? tierUnitPrice,
    Map<String, Map<int, String>>? variationTierPrice,
    Map<String, Map<int, String>>? variationTierDiscount,
    XFile? thumbnail,
    List<XFile>? images,
    String? videoProvider,
    String? youtubeVideoUrl,
    XFile? customVideo,
    List<WholesaleAttributeImageModel>? attributeImages,
    List<WholesaleFaqModel>? faqList,
    String? metaTitle,
    String? metaDescription,
    XFile? metaImage,
    WholesaleMetaSeoInfo? metaSeoInfo,
    bool update = false,
    int? productId,
    List<String>? existingImages,
  }) async {
    return await addWholesaleProductRepoInterface.addWholesaleProduct(
      addWholesaleProduct: addWholesaleProduct,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      subSubCategoryId: subSubCategoryId,
      brandId: brandId,
      code: code,
      unit: unit,
      reorderLevel: reorderLevel,
      shippingCost: shippingCost,
      multiplyQty: multiplyQty,
      tags: tags,
      colorsActive: colorsActive,
      colors: colors,
      choiceAttributeIds: choiceAttributeIds,
      choiceAttributeNames: choiceAttributeNames,
      choiceOptions: choiceOptions,
      variantQuantities: variantQuantities,
      variantSkus: variantSkus,
      currentStock: currentStock,
      minimumOrderQty: minimumOrderQty,
      discount: discount,
      discountType: discountType,
      taxIds: taxIds,
      variationBasedPrice: variationBasedPrice,
      quantityBasedPrice: quantityBasedPrice,
      variationType: variationType,
      variationPrice: variationPrice,
      variationDiscount: variationDiscount,
      tierMinQty: tierMinQty,
      tierMaxQty: tierMaxQty,
      tierUnitPrice: tierUnitPrice,
      variationTierPrice: variationTierPrice,
      variationTierDiscount: variationTierDiscount,
      thumbnail: thumbnail,
      images: images,
      videoProvider: videoProvider,
      youtubeVideoUrl: youtubeVideoUrl,
      customVideo: customVideo,
      attributeImages: attributeImages,
      faqList: faqList,
      metaTitle: metaTitle,
      metaDescription: metaDescription,
      metaImage: metaImage,
      metaSeoInfo: metaSeoInfo,
      update: update,
      productId: productId,
      existingImages: existingImages,
    );
  }

  @override
  Future<ApiResponse> getProductDetail(int productId) async {
    return await addWholesaleProductRepoInterface.getProductDetail(productId);
  }
}
