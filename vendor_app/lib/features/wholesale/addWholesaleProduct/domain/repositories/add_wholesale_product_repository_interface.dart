import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/add_wholesale_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_attribute_image_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_faq_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_meta_seo_info_model.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class AddWholesaleProductRepositoryInterface implements RepositoryInterface {
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
    bool multiplyQty,
    String? tags,
    bool colorsActive,
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
    bool variationBasedPrice,
    bool quantityBasedPrice,
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
    bool update,
    int? productId,
    List<String>? existingImages,
  });

  Future<ApiResponse> getProductDetail(int productId);
}
