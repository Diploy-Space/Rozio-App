import 'package:sixvalley_vendor_app/localization/models/language_model.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import '../features/shop/domain/models/guideline_model.dart';

class AppConstants {
  static const String appName = 'Vendor App'; ///Flutter SDK 3.47.7
  static const String appVersion = '16.6';
  static const String companyName = '6Valley';
  static const bool demo = false;
  static const int imageQuality = 100;


  static const String baseUrl = 'https://admin.drozio.shop';

  static const String loginUri = '/api/v6/seller/auth/login';
  static const String configUri = '/api/v6/config';
  static const String sellerUri = '/api/v6/seller/profile';
  static const String sellerAndBankUpdate = '/api/v6/seller/profile';
  static const String verificationCriteriaUri = '/api/v6/seller/shop/verification-criteria';
  static const String shopUri = '/api/v6/seller/shop';

  static const String shopUpdate = '/api/v6/seller/shop';
  static const String chatListUri = '/api/v6/seller/chats';
  static const String messageUri = '/api/v6/seller/chats';
  static const String sendMessageUri = '/api/v6/seller/chats';
  static const String seenMessageUri = '/api/v6/seller/chats';
  static const String orderListUri = '/api/v6/seller/orders';
  static const String orderDetails = '/api/v6/seller/orders/';
  static const String balanceWithdraw = '/api/v6/seller/withdraws';
  static const String balanceWithdrawUpdate = '/api/v6/seller/withdraws';
  static const String cancelBalanceRequest = '/api/v6/seller/withdraws';
  static const String transactionUri = '/api/v6/seller/withdraws';
  static const String sellerProductUri = '/api/v6/seller/products';
  static const String stockOutProductUri = '/api/v6/seller/products/stock-out';
  static const String productReviewUri = '/api/v6/seller/reviews';
  static const String productReviewStatusOnOff = '/api/v6/seller/reviews';
  static const String attributeUri = '/api/v6/attributes';
  static const String brandUri = '/api/v6/seller/brands';
  static const String categoryUri = '/api/v6/seller/categories';
  static const String addProductUri = '/api/v6/seller/products';
  static const String uploadProductImageUri = '/api/v6/seller/products/images';
  static const String editProductUri = '/api/v6/seller/products';
  static const String addShippingUri = '/api/v6/seller/shipping/methods';
  static const String updateShippingUri = '/api/v6/seller/shipping/methods';
  static const String editShippingUri = '/api/v6/seller/shipping/methods';
  static const String deleteShippingUri = '/api/v6/seller/shipping/methods';
  static const String getShippingUri = '/api/v6/seller/shipping/methods';
  static const String getDeliveryManUri = '/api/v6/seller/delivery-men/options';
  static const String tokenUri = '/api/v6/seller/fcm-token';
  static const String refundListUri = '/api/v6/seller/refunds';
  static const String refundItemDetails = '/api/v6/seller/refunds';
  static const String refundReqStatusUpdate = '/api/v6/seller/refunds';
  static const String showShippingCostUri = '/api/v6/seller/shipping/category-costs';
  static const String setCategoryWiseShippingCost = '/api/v6/seller/shipping/category-costs';
  static const String setShippingMethodTypeUri = '/api/v6/seller/shipping/type';
  static const String getShippingMethodTypeUri = '/api/v6/seller/shipping/type';
  static const String forgotPasswordUri = '/api/v6/seller/auth/password/forgot';
  static const String verifyOtpUri = '/api/v6/seller/auth/password/verify-otp';
  static const String resetPasswordUri = '/api/v6/seller/auth/password/reset';
  static const String barCodeGenerateUri = '/api/v6/seller/products';
  static const String digitalProductUpload = '/api/v6/seller/products/digital-files';
  static const String digitalProductUploadAfterSell = '/api/v6/seller/orders';
  static const String registration = '/api/v6/seller/auth/register';
  static const String deleteAccount = '/api/v6/seller/account';
  static const String digitalAuthorList = '/api/v6/seller/digital-authors';
  static const String digitalPublishingHouse = '/api/v6/seller/digital-publishing-houses';

  static const String getCouponDiscount = '/api/v6/seller/coupons/check';
  static const String placeOrderUri = '/api/v6/seller/pos/orders';
  static const String getProductFromProductCode = '/api/v6/seller/pos/products/barcode';
  static const String customerSearchUri = '/api/v6/seller/pos/customers';
  static const String invoice = '/api/v6/seller/pos/orders';
  static const String topSellingProduct = '/api/v6/seller/products/top-selling';
  static const String mostPopularProduct = '/api/v6/seller/products/most-popular';
  static const String topDeliveryMan = '/api/v6/seller/delivery-men/top';
  static const String deliveryManListUri = '/api/v6/seller/delivery-men';
  static const String deliveryManDetails = '/api/v6/seller/delivery-men/';
  static const String posProductList = '/api/v6/seller/pos/products';
  static const String searchPosProductList = '/api/v6/seller/pos/products';
  static const String shippingMethodOnOff = '/api/v6/seller/shipping/methods';
  static const String updateProductQuantity = '/api/v6/seller/products';
  static const String productWiseReviewList = '/api/v6/seller/products';
  static const String addDeliveryMan = '/api/v6/seller/delivery-men';
  static const String updateDeliveryMan = '/api/v6/seller/delivery-men';
  static const String deleteDeliveryman = '/api/v6/seller/delivery-men/';
  static const String deliveryManOrderHistory = '/api/v6/seller/delivery-men';
  static const String deliveryManEarning = '/api/v6/seller/delivery-men';
  static const String collectCashFromDeliveryMan = '/api/v6/seller/delivery-men';
  static const String emergencyContactAdd = '/api/v6/seller/emergency-contacts';
  static const String emergencyContactUpdate = '/api/v6/seller/emergency-contacts';
  static const String getEmergencyContactList = '/api/v6/seller/emergency-contacts';
  static const String emergencyContactStatusOnOff = '/api/v6/seller/emergency-contacts';
  static const String emergencyContactDelete = '/api/v6/seller/emergency-contacts';
  static const String deliveryManWithdrawList = '/api/v6/seller/delivery-men/withdraws';
  static const String deliveryManReviewList = '/api/v6/seller/delivery-men';
  static const String deliveryManWithdrawDetails = '/api/v6/seller/delivery-men/withdraws/';
  static const String deliveryManWithdrawApprovedRejected = '/api/v6/seller/delivery-men/withdraws';
  static const String addNewCustomer = '/api/v6/seller/pos/customers';
  static const String deliveryManStatusOnOff = '/api/v6/seller/delivery-men/';
  static const String businessAnalytics = '/api/v6/seller/dashboard/order-statistics';
  static const String deliveryManOrderChangeLog = '/api/v6/seller/delivery-men/order-status-history/';
  static const String chartFilterData = '/api/v6/seller/dashboard/retail/earning-statistics';
  static const String addNewCoupon = '/api/v6/seller/coupons';
  static const String getCouponList = '/api/v6/seller/coupons';
  static const String updateCoupon = '/api/v6/seller/coupons/';
  static const String deleteCoupon = '/api/v6/seller/coupons/';
  static const String couponStatusUpdate = '/api/v6/seller/coupons/';
  static const String deliveryManCollectedCashList = '/api/v6/seller/delivery-men';
  static const String couponCustomerList = '/api/v6/seller/coupons/customers?name=';
  static const String temporaryClose = '/api/v6/seller/shop/temporary-close';
  static const String vacation = '/api/v6/seller/shop/vacation';
  static const String dynamicWithdrawMethod = '/api/v6/seller/withdraws/methods';
  static const String orderAddressEdit = '/api/v6/seller/orders';
  static const String getNotificationList = '/api/v6/seller/notifications';
  static const String seenNotification = '/api/v6/seller/notifications/';
  static const String stockLimitStatus = '/api/v6/seller/products/stock-limit-status';
  static const String reviewReply = '/api/v6/seller/reviews';
  static const String deleteDigitalProductVariationFile = '/api/v6/seller/products';
  static const String getSingleRefundModel = '/api/v6/seller/refunds';
  static const String restockRequests = '/api/v6/seller/restock-requests';
  static const String restockRequestBrands = '/api/v6/seller/restock-requests/brands';
  static const String clearanceSaleProductList = '/api/v6/seller/clearance-sale/products';

  // Wholesale Campaign
  static const String campaignList = '/api/v6/wholesale/seller/campaigns';
  static const String campaignDetails = '/api/v6/wholesale/seller/campaigns/';
  static const String campaignJoin = '/api/v6/wholesale/seller/campaigns/{campaign}/join';
  static const String campaignLeave = '/api/v6/wholesale/seller/campaigns/{campaign}/leave';
  static const String campaignEligibleProducts = '/api/v6/wholesale/seller/campaigns/{campaign}/eligible-products';

  static const String wholesaleOrders = '/api/v6/wholesale/seller/orders';
  static const String wholesaleOrderStatusCounts = '/api/v6/wholesale/seller/orders/status-counts';
  static const String wholesaleRefunds = '/api/v6/wholesale/seller/refunds';
  static const String wholesaleRestockRequests = '';
  static const String wholesaleRestockRequestBrands = '';
  static const String wholesaleTopSellingProducts = '/api/v6/wholesale/seller/products/top-selling';
  static const String wholesaleMostPopularProducts = '/api/v6/wholesale/seller/products/most-popular';
  static const String wholesaleEarningStatistics = '/api/v6/seller/dashboard/wholesale/earning-statistics';
  static const String wholesaleReviews = '/api/v6/wholesale/seller/reviews';
  static const String wholesaleShippingMethods = '/api/v6/wholesale/seller/shipping/methods';
  static const String wholesaleShippingCategoryCosts = '/api/v6/wholesale/seller/shipping/category-costs';
  static const String wholesaleShippingType = '/api/v6/wholesale/seller/shipping/type';
  static const String wholesaleStockOutProducts = '/api/v6/wholesale/seller/products/stock-out';
  static const String wholesaleCoupons = '/api/v6/wholesale/seller/coupons';
  static const String wholesaleCouponSetup = '/api/v6/wholesale/seller/coupons/setup';
  static const String wholesaleCouponCustomers = '/api/v6/wholesale/seller/coupons/customers';
  static const String wholesaleTransactionUri = '/api/v6/seller/wholesale/transactions';

  static const String clearanceSaleDeleteProduct = '/api/v6/seller/clearance-sale/products/';
  static const String clearanceSaleDeleteAllProduct = '/api/v6/seller/clearance-sale/products';
  static const String clearanceSaleProductStatusUpdate = '/api/v6/seller/clearance-sale/products/status';
  static const String clearanceSaleProductDiscountUpdate = '/api/v6/seller/clearance-sale/products/discount';
  static const String clearanceSaleConfigStatusUpdate = '/api/v6/seller/clearance-sale/status';
  static const String clearanceSaleConfigData = '/api/v6/seller/clearance-sale';
  static const String clearanceSaleConfigDataUpdate = '/api/v6/seller/clearance-sale';
  static const String clearanceSaleProductAdd = '/api/v6/seller/clearance-sale/products';
  static const String clearanceSaleAvailableProducts = '/api/v6/seller/clearance-sale/products/available';
  static const String setUpOrder = '/api/v6/seller/orders';
  static const String businessPagesUri = '/api/v6/business-pages?type=';
  static const String paymentWithdrawalMethodList = '/api/v6/seller/withdraws/methods';
  static const String paymentInformationAdd = '/api/v6/seller/payment-methods';
  static const String paymentInformationList = '/api/v6/seller/payment-methods';
  static const String paymentInformationStatusUpdate = '/api/v6/seller/payment-methods';
  static const String paymentInformationDelete = '/api/v6/seller/payment-methods';
  static const String paymentInformationDefault = '/api/v6/seller/payment-methods';
  static const String paymentInformationUpdate = '/api/v6/seller/payment-methods';
  static const String updateSetupGuideApp = '/api/v6/seller/setup-guide';
  static const String getTaxVatList = '/api/v6/seller/vat-tax/setup';
  static const String sellerVatTaxListUri = '/api/v6/seller/vat-tax/list';
  static const String getTaxAmount = '/api/v6/seller/pos/tax-amount';
  static const String getVatTaxReportList = '/api/v6/seller/vat-tax/retail-report';
  static const String wholesaleVatTaxReportList = '/api/v6/seller/vat-tax/wholesale-report';
  static const String auctionVatTaxReportList = '/api/v6/auction/seller/vat-report';
  static const String firebaseAuthTokenStore = '/api/v6/seller/auth/firebase/session';
  static const String firebaseAuthVerify = '/api/v6/seller/auth/firebase/verify';
  static const String checkVendorExistInfoPhone = '/api/v6/seller/auth/availability/phone';
  static const String generateInvoice = '/api/v6/seller/orders';
  static const String editOrderSubmit = '/api/v6/seller/orders';

  static const String editOrderValidation = '/api/v6/seller/orders';
  static const String switchToCod = '/api/v6/seller/orders';
  static const String editOrderAllProducts = '/api/v6/seller/orders';

  static const String addAuctionProductUri = '/api/v6/auction/seller/products';
  static const String auctionBrandList = '/api/v6/auction/brands';
  static const String auctionCategoryList = '/api/v6/auction/categories';
  static const String auctionProductListUri = '/api/v6/auction/seller/products';
  static const String auctionPendingApprovalListUri = '/api/v6/auction/seller/products/pending-approval';
  static const String deleteAuctionProductUri = '/api/v6/auction/seller/products/';
  static const String auctionProductDetailsV6Uri = '/api/v6/auction/seller/products/';
  static const String vendorAuctionStatusToggle = '/api/v6/auction/seller/products/';
  static const String vendorAuctionBidsList = '/api/v6/auction/seller/products/';
  static const String auctionWithdrawRequest = '/api/v6/auction/seller/withdraws';
  static const String auctionPayCommissionV6Uri = '/api/v6/auction/seller/products/';


  static const String auctionUploadTrackingUri = '/api/v6/auction/seller/products/';
  static const String auctionAddressUpdateUri = '/api/v6/auction/seller/products/address';
  static const String auctionPaymentStatusUri = '/api/v6/auction/seller/products/';
  static const String auctionDeliveryStatusUpdateUri = '/api/v6/auction/seller/products/';
  static const String auctionGenerateInvoiceV6Uri = '/api/v6/auction/seller/products/';
  static const String auctionCancelUri = '/api/v6/auction/seller/products/';
  static const String auctionSalesReportUri = '/api/v6/auction/seller/sales-report';
  static const String auctionTransactionHistoryUri = '/api/v6/auction/seller/transactions';
  static const String auctionDashboardStatistics = '/api/v6/auction/seller/dashboard/auction-statistics';
  static const String auctionBidStatistics = '/api/v6/auction/seller/dashboard/bid-statistics';
  static const String auctionEarningStatistics = '/api/v6/auction/seller/dashboard/earning-statistics';
  static const String auctionTopPerformingProducts = '/api/v6/auction/seller/products/top-performing';
  static const String auctionRecentlyEndedProducts = '/api/v6/auction/seller/products/recently-ended';

  static const String courierConfigUri = '/api/v6/seller/courier/config';
  static const String courierProvidersUri = '/api/v6/seller/courier/providers';
  static const String courierDispatchUri = '/api/v6/seller/courier/dispatch';
  static const String courierReviseUri = '/api/v6/seller/courier/revise';
  static const String courierEstimateUri = '/api/v6/seller/courier/estimate';
  static const String courierTrackUri = '/api/v6/seller/courier/track/';
  static const String courierLocationStoresUri = '/api/v6/seller/courier/locations/stores';
  static const String courierLocationCitiesUri = '/api/v6/seller/courier/locations/cities';
  static const String courierLocationZonesUri = '/api/v6/seller/courier/locations/zones/';
  static const String courierLocationAreasUri = '/api/v6/seller/courier/locations/areas/';

  static const String wholesaleCourierConfigUri = '/api/v6/wholesale/seller/courier/config';
  static const String wholesaleCourierProvidersUri = '/api/v6/wholesale/seller/courier/providers';
  static const String wholesaleCourierDispatchUri = '/api/v6/wholesale/seller/courier/dispatch';
  static const String wholesaleCourierReviseUri = '/api/v6/wholesale/seller/courier/revise';
  static const String wholesaleCourierEstimateUri = '/api/v6/wholesale/seller/courier/estimate';
  static const String wholesaleCourierTrackUri = '/api/v6/wholesale/seller/courier/track/';
  static const String wholesaleCourierLocationStoresUri = '/api/v6/wholesale/seller/courier/locations/stores';
  static const String wholesaleCourierLocationCitiesUri = '/api/v6/wholesale/seller/courier/locations/cities';
  static const String wholesaleCourierLocationZonesUri = '/api/v6/wholesale/seller/courier/locations/zones/';
  static const String wholesaleCourierLocationAreasUri = '/api/v6/wholesale/seller/courier/locations/areas/';



  static const String auctionNotificationList = '/api/v6/auction/seller/notifications';
  static const String auctionMarkNotificationSeen = '/api/v6/auction/seller/notifications/seen';
  static const String wholesaleNotificationList = '/api/v6/wholesale/seller/notifications';
  static const String wholesaleMarkNotificationSeen = '/api/v6/wholesale/seller/notifications/';

  static const String wholesaleProducts = '/api/v6/wholesale/seller/products';
  static const String wholesaleProductDetails = '/api/v6/wholesale/seller/products/';
  static const String wholesaleProductStatus = '/api/v6/wholesale/seller/products/';
  static const String wholesaleProductFaqs = '/api/v6/wholesale/seller/products/faqs/';

  static const String wholesaleGenerateLimitCheck = '/api/v6/wholesale/seller/product/generate-limit-check';

  static const String wholesaleTitleAutoFill = '/api/v6/wholesale/seller/product/title-auto-fill';
  static const String wholesaleDescriptionAutoFill = '/api/v6/wholesale/seller/product/description-auto-fill';
  static const String wholesaleGeneralSetupAutoFill = '/api/v6/wholesale/seller/product/general-setup-auto-fill';

  static const String wholesalePricingSetupAutoFill = '/api/v6/wholesale/seller/product/pricing-setup-auto-fill';

  static const String wholesaleVariationSetupAutoFill = '/api/v6/wholesale/seller/product/variation-setup-auto-fill';
  static const String wholesaleSeoSectionAutoFill = '/api/v6/wholesale/seller/product/seo-section-auto-fill';
  static const String wholesaleFaqAutoFill = '/api/v6/wholesale/seller/product/faq-auto-fill';

  static const String wholesaleAnalyzeImageAutoFill = '/api/v6/wholesale/seller/product/analyze-image-auto-fill';

  static const String wholesaleBrandList = '/api/v6/wholesale/brands';
  static const String wholesaleCategoryList = '/api/v6/wholesale/categories';
  static const String wholesaleSubCategoryList = '/api/v6/wholesale/categories/sub-categories/';
  static const String wholesaleSubSubCategoryList = '/api/v6/wholesale/categories/sub-sub-categories/';

  static const String wholesaleAttributeList = '/api/v6/wholesale/attributes';

  static const String wholesaleVatTaxSetup = '/api/v6/wholesale/seller/vat-tax/setup';
  static const String wholesaleVatTaxListUri = '/api/v6/wholesale/seller/vat-tax/list';

  static const String auctionVatTaxSetup = '/api/v6/auction/seller/vat-tax/setup';
  static const String auctionVatTaxListUri = '/api/v6/auction/seller/vat-tax/list';


  static const String productTitleGenerate = '/api/v6/seller/product/title-auto-fill';
  static const String productDescriptionGenerate = '/api/v6/seller/product/description-auto-fill';
  static const String productGeneralSetupGenerate = '/api/v6/seller/product/general-setup-auto-fill';
  static const String productPricingGenerate = '/api/v6/seller/product/price-others-auto-fill';
  static const String productVariationSetupGenerate = '/api/v6/seller/product/variation-setup-auto-fill';
  static const String productSeoSectionGenerate = '/api/v6/seller/product/seo-section-auto-fill';
  static const String productGenerateTitleGenerate = '/api/v6/seller/product/generate-title-suggestions';
  static const String productAnalyzeImageAutoGenerate = '/api/v6/seller/product/analyze-image-auto-fill';
  static const String generateLimitCheck = '/api/v6/seller/product/generate-limit-check';


  static const String auctionTitleAutoFill = '/api/v6/auction/seller/product/title-auto-fill';
  static const String auctionDescriptionAutoFill = '/api/v6/auction/seller/product/description-auto-fill';
  static const String auctionGeneralSetupAutoFill = '/api/v6/auction/seller/product/general-setup-auto-fill';
  static const String auctionShippingPolicyAutoFill = '/api/v6/auction/seller/product/shipping-policy-auto-fill';
  static const String auctionInfoAutoFill = '/api/v6/auction/seller/product/auction-info-auto-fill';
  static const String auctionSeoSectionAutoFill = '/api/v6/auction/seller/product/seo-section-auto-fill';
  static const String auctionAnalyzeImageAutoFill = '/api/v6/auction/seller/product/analyze-image-auto-fill';
  static const String auctionGenerateTitleSuggestions = '/api/v6/auction/seller/product/generate-title-suggestions';
  static const String auctionGenerateLimitCheck = '/api/v6/auction/seller/product/generate-limit-check';




  static const String geocodeUri = '/api/v6/maps/geocode';
  static const String searchLocationUri = '/api/v6/maps/places';
  static const String placeDetailsUri = '/api/v6/maps/places';
  static const String setCurrentLanguageUri = '/api/v6/seller/language';

  static const String deleteProductImage = '/api/v6/seller/products';
  static const String getProductImage = '/api/v6/seller/products';
  static const String deleteProductPreview = '/api/v6/seller/products';


  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String processing = 'processing';
  static const String processed = 'processed';
  static const String delivered = 'delivered';
  static const String failed = 'failed';
  static const String returned = 'returned';
  static const String cancelled = 'canceled';
  static const String outForDelivery = 'out_for_delivery';
  static const String approved = 'approved';
  static const String rejected = 'rejected';
  static const String done = 'refunded';



  static const String orderWise = 'order_wise';
  static const String productWise = 'product_wise';
  static const String categoryWise = 'category_wise';



  static const String theme = 'theme';
  static const String appMode = 'app_mode';
  static const String appModeTutorialModules = 'app_mode_tutorial_modules';
  static const String appModeWelcomedModules = 'app_mode_welcomed_modules';
  static const String currency = 'currency';
  static const String shippingType = 'shipping_type';
  static const String token = 'token';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String cartList = 'cart_list';
  static const String userAddress = 'user_address';
  static const String userPassword = 'user_password';
  static const String userNumber = 'user_number';
  static const String searchAddress = 'search_address';
  static const String topic = 'six_valley_seller';
  static const String maintenanceModeTopic = 'maintenance_mode_start_vendor';
  static const String userEmail = 'user_email';
  static const String langKey = 'lang';
  static const String showCookies = 'cookies';
  static const String bluetoothMacAddress = 'bluetooth_mac_address';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.unitedKingdom, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.arabic, languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
    LanguageModel(imageUrl: Images.hindi, languageName: 'Hindi', countryCode: 'IN', languageCode: 'hi'),
    LanguageModel(imageUrl: Images.bd, languageName: 'Bangla', countryCode: 'BD', languageCode: 'bn'),
    LanguageModel(imageUrl: Images.spanish, languageName: 'Spanish', countryCode: 'ES', languageCode: 'es'),
  ];

  static const double maxSizeOfASingleFile = 10;
  static const double maxLimitOfTotalFileSent = 5;
  static const double maxLimitOfFileSentINConversation = 25;
  static const int fileImageMaxLimit = 2;


  static const List<String> videoExtensions = [
    'mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv', 'webm', 'mpeg', 'mpg', 'm4v', '3gp', 'ogv'
  ];

  static const List<String> imageExtensions = [
    'png',
    'jpg',
    'jpeg',
    'gif',
    'webp',
  ];

  static const List<String> documentExtensions = [
    'doc', 'docx', 'txt', 'csv', 'xls', 'xlsx', 'pdf',
  ];

  static const List<String> disallowedExtensions = [
    'php','php3','php4','php5','php7','php8','phtml','phar',
    'asp','aspx','jsp','cgi','pl','py','rb',
    'js','mjs','html','htm','xhtml',
    'sh','bash','bat','cmd','ps1','zsh','ksh',
    'exe','dll','so','bin','msi','app',
    'java','class','jar',
    '7z','gz','bz2','xz',
    'env','ini','conf','config','yml','yaml','log',
    'sql','db','bak','old','swp','tmp'
  ];

  static const List<GuidelineModel> inHouseShopGuidelineList = [
    GuidelineModel('store_availability', 'store_availability_description'),
    GuidelineModel('shop_details', 'shop_details_description'),
    GuidelineModel('visit_website', 'visit_website_description'),
    GuidelineModel('edit_shop', 'edit_shop_description'),
  ];

  static const List<GuidelineModel> paymentInfoGuidelineList = [
    GuidelineModel('benefit', 'benefit_description'),
  ];

  static const List<GuidelineModel> otherSetupGuidelineList = [
    GuidelineModel('order_setup', 'order_setup_description'),
    GuidelineModel('business_tin', 'business_tin_description'),
  ];


}
