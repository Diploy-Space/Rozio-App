import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/helper/json_converter.dart';

class ConfigModel {
  int? _systemDefaultCurrency;
  BaseUrls? _baseUrls;
  StaticUrls? _staticUrls;
  List<CurrencyList>? _currencyList;
  List<Language>? _languageList;
  List<ColorList>? _colors;
  List<String>? _unit;
  String? _aboutUs;
  String? _privacyPolicy;
  List<Faq>? _faq;
  String? _termsConditions;
  RefundPolicy? _refundPolicy;
  RefundPolicy? _returnPolicy;
  RefundPolicy? _cancellationPolicy;
  String? _currencyModel;
  String? _shippingMethod;
  String? _version;
  String? _forgotPasswordVerification;
  String? _countryCode;
  int? _decimalPointSettings;
  String? _brandSetting;
  String? _digitalProductSetting;
  bool? _digitalPayment;
  bool? _cashOnDelivery;
  String? _sellerRegistration;
  String? _companyPhone;
  String? _companyEmail;
  String? _companyName;
  int? _decimalPointSetting;
  String? _companyLogo;
  ImageFullUrl? _companyLogoImage;
  int? _posActive;
  String? activeTheme;
  int? minimumOrderAmountStatus;
  int? freeDeliveryStatus;
  int? orderVerification;
  String? freeDeliveryResponsibility;
  int? _mapApiStatus;
  int? minimumOrderAmountStatusBySeller;
  bool? reviewReplyStatus;
  MaintenanceMode? maintenanceModeData;
  bool? maintenanceMode;
  String? currencySymbolPosition;
  bool? walletStatus;
  double? productMaxPriceRange;
  String? serverUploadMaxFileSize;
  SellerAppVersionControl? _sellerAppVersionControl;
  String? systemTaxType;
  int? systemTaxIncludeStatus;
  int? isAiFeatureActive;
  String? vendorForgotPasswordSmsMethod;
  int? systemImageFileUploadMaxSize;
  int? systemGeneralFileUploadMaxSize;
  int? canVendorEditOrder;
  int? _otpResendTime;
  List<PaymentMethods>? paymentMethods;
  OfflinePayment? offlinePayment;
  bool? deliveryPartnerSetupStatus;
  bool? vendorVerifiedBadge;
  AuctionConfig? auctionConfig;
  WholesaleConfig? wholesaleConfig;
  ConfigModules? modules;

  ConfigModel({
    int? systemDefaultCurrency,
    BaseUrls? baseUrls,
    StaticUrls? staticUrls,
    List<CurrencyList>? currencyList,
    List<Language>? languageList,
    List<ColorList>? colors,
    List<String>? unit,
    String? aboutUs,
    String? privacyPolicy,
    List<Faq>? faq,
    String? termsConditions,
    RefundPolicy? refundPolicy,
    RefundPolicy? returnPolicy,
    RefundPolicy? cancellationPolicy,
    String? currencyModel,
    String? shippingMethod,
    String? version,
    String? forgotPasswordVerification,
    String? countryCode,
    int? decimalPointSettings,
    String? brandSetting,
    String? digitalProductSetting,
    bool? digitalPayment,
    bool? cashOnDelivery,
    String? sellerRegistration,
    String? companyPhone,
    String? companyEmail,
    int? decimalPointSetting,
    String? companyLogo,
    ImageFullUrl? companyLogoImage,
    int? posActive,
    String? activeTheme,
    int? minimumOrderAmountStatus,
    int? freeDeliveryStatus,
    int? orderVerification,
    String? freeDeliveryResponsibility,
    int? mapApiStatus,
    double? productMaxPriceRange,
    SellerAppVersionControl? sellerAppVersionControl,
    String? companyName,
  }) {
    _systemDefaultCurrency = systemDefaultCurrency;
    _baseUrls = baseUrls;
    _staticUrls = staticUrls;
    _currencyList = currencyList;
    _languageList = languageList;
    _colors = colors;
    _unit = unit;
    _aboutUs = aboutUs;
    _privacyPolicy = privacyPolicy;
    _faq = faq;
    _termsConditions = termsConditions;
    if (refundPolicy != null) {
      _refundPolicy = refundPolicy;
    }
    if (returnPolicy != null) {
      _returnPolicy = returnPolicy;
    }
    if (cancellationPolicy != null) {
      _cancellationPolicy = cancellationPolicy;
    }
    _currencyModel = currencyModel;
    _shippingMethod = shippingMethod;
    _version = version;
    _forgotPasswordVerification = forgotPasswordVerification;
    _countryCode = countryCode;
    _decimalPointSettings = decimalPointSettings;
    if (brandSetting != null) {
      _brandSetting = brandSetting;
    }
    if (digitalProductSetting != null) {
      _digitalProductSetting = digitalProductSetting;
    }

    if (digitalPayment != null) {
      _digitalPayment = digitalPayment;
    }
    if (cashOnDelivery != null) {
      _cashOnDelivery = cashOnDelivery;
    }
    if (sellerRegistration != null) {
      _sellerRegistration = sellerRegistration;
    }
    if (companyPhone != null) {
      _companyPhone = companyPhone;
    }
    if (companyEmail != null) {
      _companyEmail = companyEmail;
    }
    _decimalPointSetting = decimalPointSetting;
    _companyLogo = companyLogo;
    _companyLogoImage = companyLogoImage;
    _posActive = posActive;
    _mapApiStatus = mapApiStatus;
    this.activeTheme;
    this.freeDeliveryStatus;
    this.minimumOrderAmountStatus;
    this.orderVerification;
    this.freeDeliveryResponsibility;
    minimumOrderAmountStatusBySeller;
    reviewReplyStatus;
    maintenanceModeData;
    maintenanceMode;
    currencySymbolPosition;
    walletStatus;
    serverUploadMaxFileSize;
    this.productMaxPriceRange;
    _sellerAppVersionControl = sellerAppVersionControl;

    systemTaxType;
    systemTaxIncludeStatus;
    isAiFeatureActive;
    vendorForgotPasswordSmsMethod;
    systemImageFileUploadMaxSize;
    systemGeneralFileUploadMaxSize;
    canVendorEditOrder;
    _companyName = companyName;
    paymentMethods;
    offlinePayment;
    isWholesaleFeatureEnabled;
  }

  int? get systemDefaultCurrency => _systemDefaultCurrency;
  BaseUrls? get baseUrls => _baseUrls;
  StaticUrls? get staticUrls => _staticUrls;
  List<CurrencyList>? get currencyList => _currencyList;
  List<Language>? get languageList => _languageList;
  List<ColorList>? get colors => _colors;
  List<String>? get unit => _unit;
  String? get aboutUs => _aboutUs;
  String? get privacyPolicy => _privacyPolicy;
  List<Faq>? get faq => _faq;
  String? get termsConditions => _termsConditions;
  RefundPolicy? get refundPolicy => _refundPolicy;
  RefundPolicy? get returnPolicy => _returnPolicy;
  RefundPolicy? get cancellationPolicy => _cancellationPolicy;
  String? get currencyModel => _currencyModel;
  String? get shippingMethod => _shippingMethod;
  String? get version => _version;
  String? get forgotPasswordVerification => _forgotPasswordVerification;
  String? get countryCode =>_countryCode;
  int? get decimalPointSettings => _decimalPointSettings;
  String? get brandSetting => _brandSetting;
  String? get digitalProductSetting => _digitalProductSetting;
  bool? get digitalPayment => _digitalPayment;
  bool? get cashOnDelivery => _cashOnDelivery;
  String? get sellerRegistration => _sellerRegistration;
  String? get companyPhone => _companyPhone;
  String? get companyEmail => _companyEmail;
  int? get decimalPointSetting => _decimalPointSetting;
  String? get companyLogo => _companyLogo;
  ImageFullUrl? get companyLogoImage => _companyLogoImage;
  int? get posActive => _posActive;
  int? get mapApiStatus => _mapApiStatus;
  SellerAppVersionControl? get sellerAppVersionControl => _sellerAppVersionControl;
  int? get otpResendTime => _otpResendTime;
  String? get companyName => _companyName;

  bool? get isAuctionFeatureEnabled => modules?.auction == true;
  bool? get activeAuctionForVendor => auctionConfig?.activeForVendor;
  double? get auctionEntryFeeAmount => auctionConfig?.entryFee?.status == true ? auctionConfig?.entryFee?.amount : 0;
  bool? get isWholesaleFeatureEnabled => modules?.wholesale == true;
  bool? get wholesaleDeliveryPartnerSetupStatus => wholesaleConfig?.vendor?.deliveryPartnerSetup;



  ConfigModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> content = _map(json['content'] ?? json);
    final Map<String, dynamic> company = _map(content['company']);
    final Map<String, dynamic> theme = _map(content['theme']);
    final Map<String, dynamic> business = _map(content['business']);
    final Map<String, dynamic> currency = _map(content['currency']);
    final Map<String, dynamic> vendor = _map(content['vendor']);
    final Map<String, dynamic> order = _map(content['order']);
    final Map<String, dynamic> shipping = _map(content['shipping']);
    final Map<String, dynamic> payment = _map(content['payment']);
    final Map<String, dynamic> authentication = _map(content['authentication']);
    final Map<String, dynamic> vendorAuthentication = _map(authentication['vendor']);
    final Map<String, dynamic> maintenance = _map(content['maintenance']);
    final Map<String, dynamic> media = _map(content['media']);
    final Map<String, dynamic> tax = _map(content['tax']);

    _companyName = company['name']?.toString();
    _companyPhone = company['phone']?.toString();
    _companyEmail = company['email']?.toString();
    _countryCode = company['country_code'];
    _companyLogoImage = company['logo_full_url'] != null ? ImageFullUrl.fromJson(company['logo_full_url']) : null;

    activeTheme = theme['active'];

    _version = business['software_version']?.toString();
    _brandSetting = _isOn(business['brand_enabled']) ? '1' : '0';
    _digitalProductSetting = _isOn(business['digital_product_enabled']) ? '1' : '0';
    _decimalPointSettings = int.tryParse('${business['decimal_point']}');
    _decimalPointSetting = _decimalPointSettings;
    _unit = List<String>.from((business['units'] ?? []).map((unit) => unit.toString()));
    _colors = List<ColorList>.from((business['colors'] ?? []).map((color) => ColorList.fromJson(color)));
    productMaxPriceRange = double.tryParse('${_map(business['product_unit_price_range'])['max']}');

    _systemDefaultCurrency = int.tryParse('${currency['default_id']}');
    _currencyModel = currency['model'];
    currencySymbolPosition = currency['symbol_position'];
    _currencyList = List<CurrencyList>.from((currency['list'] ?? []).map((item) => CurrencyList.fromJson(item)));
    _languageList = List<Language>.from((content['languages'] ?? []).map((item) => Language.fromJson(item)));

    _sellerRegistration = _isOn(vendor['registration']) ? '1' : '0';
    _posActive = _flag(vendor['pos']);
    reviewReplyStatus = _isOn(vendor['review_reply']);
    canVendorEditOrder = _flag(vendor['can_edit_order_status']);
    deliveryPartnerSetupStatus = _isOn(vendor['delivery_partner_setup']);
    vendorVerifiedBadge = _isOn(vendor['verified_badge']);

    final Map<String, dynamic> minimumOrderAmount = _map(order['minimum_order_amount']);
    minimumOrderAmountStatus = _flag(minimumOrderAmount['status']);
    minimumOrderAmountStatusBySeller = _flag(minimumOrderAmount['set_by_vendor']);
    orderVerification = _flag(order['order_verification']);

    final Map<String, dynamic> freeDelivery = _map(shipping['free_delivery']);
    _shippingMethod = shipping['method'];
    freeDeliveryStatus = _flag(freeDelivery['status']);
    freeDeliveryResponsibility = freeDelivery['responsibility'];
    _mapApiStatus = _flag(_map(shipping['map'])['status']);

    final Map<String, dynamic> offline = _map(payment['offline_payment']);
    _digitalPayment = _isOn(payment['digital_payment']);
    _cashOnDelivery = _isOn(payment['cash_on_delivery']);
    offlinePayment = _isOn(offline['status']) ? OfflinePayment(image: offline['image_url']) : null;
    paymentMethods = List<PaymentMethods>.from((payment['methods'] ?? []).map((method) => PaymentMethods(
      keyName: method['key_name'],
      additionalDatas: AdditionalDatas(gatewayTitle: method['title'], gatewayImage: method['image_url']),
    )));
    walletStatus = _isOn(_map(content['wallet'])['status']);

    _forgotPasswordVerification = vendorAuthentication['forgot_password_method'];
    vendorForgotPasswordSmsMethod = vendorAuthentication['forgot_password_sms_method'];
    _otpResendTime = int.tryParse('${authentication['otp_resend_seconds']}');

    final Map<String, dynamic> maintenanceSystems = _map(maintenance['systems']);
    final Map<String, dynamic> maintenanceMessage = _map(maintenance['message']);
    final Map<String, dynamic> maintenanceDuration = _map(maintenance['duration']);
    maintenanceModeData = MaintenanceMode(
      maintenanceStatus: _flag(maintenance['status']),
      selectedMaintenanceSystem: SelectedMaintenanceSystem(
        vendorApp: _flag(maintenanceSystems['vendor_app']),
        customerApp: _flag(maintenanceSystems['user_app']),
        webApp: _flag(maintenanceSystems['user_website']),
        deliverymanApp: _flag(maintenanceSystems['deliveryman_app']),
      ),
      maintenanceMessages: MaintenanceMessages(
        businessNumber: _flag(maintenanceMessage['show_business_number']),
        businessEmail: _flag(maintenanceMessage['show_business_email']),
        maintenanceMessage: maintenanceMessage['title'],
        messageBody: maintenanceMessage['body'],
      ),
      maintenanceTypeAndDuration: MaintenanceTypeAndDuration(
        maintenanceDuration: maintenanceDuration['type'],
        startDate: maintenanceDuration['start_date'],
        endDate: maintenanceDuration['end_date'],
      ),
    );

    final Map<String, dynamic> vendorAppVersions = _map(_map(content['app_versions'])['vendor']);
    _sellerAppVersionControl = SellerAppVersionControl(
      forAndroid: _platformVersion(vendorAppVersions['android']),
      forIos: _platformVersion(vendorAppVersions['ios']),
    );

    final Map<String, dynamic> baseUrls = _map(media['base_urls']);
    final Map<String, dynamic> uploadLimits = _map(media['upload_limits']);
    _baseUrls = BaseUrls(
      productImageUrl: baseUrls['product'],
      productThumbnailUrl: baseUrls['product_thumbnail'],
      brandImageUrl: baseUrls['brand'],
      customerImageUrl: baseUrls['customer'],
      bannerImageUrl: baseUrls['banner'],
      categoryImageUrl: baseUrls['category'],
      reviewImageUrl: baseUrls['review'],
      sellerImageUrl: baseUrls['vendor'],
      shopImageUrl: baseUrls['shop'],
      notificationImageUrl: baseUrls['notification'],
      digitalProductUrl: baseUrls['digital_product'],
      deliveryManImageUrl: baseUrls['deliveryman'],
    );
    serverUploadMaxFileSize = uploadLimits['server_upload_max_filesize']?.toString();
    systemImageFileUploadMaxSize = int.tryParse('${uploadLimits['image_max_size_mb']}');
    systemGeneralFileUploadMaxSize = int.tryParse('${uploadLimits['file_max_size_mb']}');

    final Map<String, dynamic> urls = _map(content['urls']);
    _staticUrls = StaticUrls(
      contactUs: urls['contact_us'],
      brands: urls['brands'],
      categories: urls['categories'],
      customerAccount: urls['customer_account'],
    );

    systemTaxType = tax['type'];
    systemTaxIncludeStatus = _flag(tax['is_included']);
    isAiFeatureActive = _flag(_map(content['ai'])['enabled']);

    auctionConfig = AuctionConfig.fromJson(_map(content['auction']));
    wholesaleConfig = WholesaleConfig.fromJson(_map(content['wholesale']));
    modules = ConfigModules.fromJson(_map(content['modules']));
  }

  static Map<String, dynamic> _map(dynamic value) => value is Map<String, dynamic> ? value : <String, dynamic>{};

  static bool _isOn(dynamic value) => JsonConverter.toBool(value) ?? false;

  static int _flag(dynamic value) => _isOn(value) ? 1 : 0;

  static PlatformVersion? _platformVersion(dynamic value) {
    if (value is! Map<String, dynamic>) return null;
    return PlatformVersion(status: _flag(value['status']), version: value['version']?.toString(), link: value['link']);
  }
}

class BaseUrls {
  String? _productImageUrl;
  String? _productThumbnailUrl;
  String? _brandImageUrl;
  String? _customerImageUrl;
  String? _bannerImageUrl;
  String? _categoryImageUrl;
  String? _reviewImageUrl;
  String? _sellerImageUrl;
  String? _shopImageUrl;
  String? _notificationImageUrl;
  String? _digitalProductUrl;
  String? _deliveryManImageUrl;

  BaseUrls({String? productImageUrl,
    String? productThumbnailUrl,
    String? brandImageUrl,
    String? customerImageUrl,
    String? bannerImageUrl,
    String? categoryImageUrl,
    String? reviewImageUrl,
    String? sellerImageUrl,
    String? shopImageUrl,
    String? notificationImageUrl,
    String? digitalProductUrl,
    String? deliveryManImageUrl,
  }) {
    _productImageUrl = productImageUrl;
    _productThumbnailUrl = productThumbnailUrl;
    _brandImageUrl = brandImageUrl;
    _customerImageUrl = customerImageUrl;
    _bannerImageUrl = bannerImageUrl;
    _categoryImageUrl = categoryImageUrl;
    _reviewImageUrl = reviewImageUrl;
    _sellerImageUrl = sellerImageUrl;
    _shopImageUrl = shopImageUrl;
    _notificationImageUrl = notificationImageUrl;
    if (digitalProductUrl != null) {
      _digitalProductUrl = digitalProductUrl;
    }
    _deliveryManImageUrl = deliveryManImageUrl;
  }

  String? get productImageUrl => _productImageUrl;
  String? get productThumbnailUrl => _productThumbnailUrl;
  String? get brandImageUrl => _brandImageUrl;
  String? get customerImageUrl => _customerImageUrl;
  String? get bannerImageUrl => _bannerImageUrl;
  String? get categoryImageUrl => _categoryImageUrl;
  String? get reviewImageUrl => _reviewImageUrl;
  String? get sellerImageUrl => _sellerImageUrl;
  String? get shopImageUrl => _shopImageUrl;
  String? get notificationImageUrl => _notificationImageUrl;
  String? get digitalProductUrl => _digitalProductUrl;
  String? get deliveryManImageUrl => _deliveryManImageUrl;

  BaseUrls.fromJson(Map<String, dynamic> json) {
    _productImageUrl = json['product_image_url'];
    _productThumbnailUrl = json['product_thumbnail_url'];
    _brandImageUrl = json['brand_image_url'];
    _customerImageUrl = json['customer_image_url'];
    _bannerImageUrl = json['banner_image_url'];
    _categoryImageUrl = json['category_image_url'];
    _reviewImageUrl = json['review_image_url'];
    _sellerImageUrl = json['seller_image_url'];
    _shopImageUrl = json['shop_image_url'];
    _notificationImageUrl = json['notification_image_url'];
    _digitalProductUrl = json['digital_product_url'];
    _deliveryManImageUrl = json['delivery_man_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_image_url'] = _productImageUrl;
    data['product_thumbnail_url'] = _productThumbnailUrl;
    data['brand_image_url'] = _brandImageUrl;
    data['customer_image_url'] = _customerImageUrl;
    data['banner_image_url'] = _bannerImageUrl;
    data['category_image_url'] = _categoryImageUrl;
    data['review_image_url'] = _reviewImageUrl;
    data['seller_image_url'] = _sellerImageUrl;
    data['shop_image_url'] = _shopImageUrl;
    data['notification_image_url'] = _notificationImageUrl;
    data['digital_product_url'] = _digitalProductUrl;
    data['delivery_man_image_url'] = _deliveryManImageUrl;
    return data;
  }
}

class StaticUrls {
  String? _aboutUs;
  String? _faq;
  String? _termsConditions;
  String? _contactUs;
  String? _brands;
  String? _categories;
  String? _customerAccount;

  StaticUrls({String? aboutUs, String? faq, String? termsConditions, String? contactUs, String? brands, String? categories, String? customerAccount}) {
    _aboutUs = aboutUs;
    _faq = faq;
    _termsConditions = termsConditions;
    _contactUs = contactUs;
    _brands = brands;
    _categories = categories;
    _customerAccount = customerAccount;
  }

  String? get aboutUs => _aboutUs;
  String? get faq => _faq;
  String? get termsConditions => _termsConditions;
  String? get contactUs => _contactUs;
  String? get brands => _brands;
  String? get categories => _categories;
  String? get customerAccount => _customerAccount;

  StaticUrls.fromJson(Map<String, dynamic> json) {
    _aboutUs = json['about_us'];
    _faq = json['faq'];
    _termsConditions = json['terms_&_conditions'];
    _contactUs = json['contact_us'];
    _brands = json['brands'];
    _categories = json['categories'];
    _customerAccount = json['customer_account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['about_us'] = _aboutUs;
    data['faq'] = _faq;
    data['terms_&_conditions'] = _termsConditions;
    data['contact_us'] = _contactUs;
    data['brands'] = _brands;
    data['categories'] = _categories;
    data['customer_account'] = _customerAccount;
    return data;
  }
}
class Faq {
  int? _id;
  String? _question;
  String? _answer;
  int? _ranking;
  int? _status;
  String? _createdAt;
  String? _updatedAt;

  Faq(
      {int? id,
        String? question,
        String? answer,
        int? ranking,
        int? status,
        String? createdAt,
        String? updatedAt}) {
    _id = id;
    _question = question;
    _answer = answer;
    _ranking = ranking;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  String? get question => _question;
  String? get answer => _answer;
  int? get ranking => _ranking;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;


  Faq.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _question = json['question'];
    _answer = json['answer'];
    _ranking = json['ranking'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['question'] = _question;
    data['answer'] = _answer;
    data['ranking'] = _ranking;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}



class ColorList {
  int? _id;
  String? _name;
  String? _code;

  ColorList({int? id, String? name, String? code}){

    _id = id;
    _name = name;
    _code = code;

  }

  int? get id => _id;
  String? get name => _name;
  String? get code => _code;


  ColorList.fromJson(Map<String, dynamic> json) {
    _id = json ['id'];
    _name = json ['name'];
    _code = json ['code'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['code'] = _code;
    return data;
  }

  @override
  String toString() {
    return '$name';
  }
}


class CurrencyList {
  int? _id;
  String? _name;
  String? _symbol;
  String? _code;
  double? _exchangeRate;
  String? _createdAt;
  String? _updatedAt;
  bool? status;

  CurrencyList({int? id, String? name, String? symbol, String? code, double? exchangeRate, int? status, String? createdAt, String? updatedAt, }) {
    _id = id;
    _name = name;
    _symbol = symbol;
    _code = code;
    _exchangeRate = exchangeRate;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    this.status;
  }

  int? get id => _id;
  String? get name => _name;
  String? get symbol => _symbol;
  String? get code => _code;
  double? get exchangeRate => _exchangeRate;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;


  CurrencyList.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _symbol = json['symbol'];
    _code = json['code'];
    if(json['exchange_rate'] != null){
      try{
        _exchangeRate = json['exchange_rate'].toDouble();
      }catch(e){
        _exchangeRate = double.parse(json['exchange_rate'].toString());
      }
    }

    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    status = json['status'];
  }

}

class Language {
  String? code;
  String? name;

  Language({this.code, this.name});

  Language.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}


class LanguageList {
  String? _bn;
  String? _en;

  LanguageList({String? bn, String? en}) {
    _bn = bn;
    _en = en;
  }

  String? get bn => _bn;
  String? get en => _en;

  LanguageList.fromJson(Map<String, dynamic> json) {
    _bn = json['bn'];
    _en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bn'] = _bn;
    data['en'] = _en;
    return data;
  }
}

class Data {
  Bn? _bn;
  En? _en;

  Data({Bn? bn, En? en}) {
    _bn = bn;
    _en = en;
  }

  Bn? get bn => _bn;
  En? get en => _en;

  Data.fromJson(Map<String, dynamic> json) {
    _bn = json['bn'] != null ? Bn.fromJson(json['bn']) : null;
    _en = json['en'] != null ? En.fromJson(json['en']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_bn != null) {
      data['bn'] = _bn!.toJson();
    }
    if (_en != null) {
      data['en'] = _en!.toJson();
    }
    return data;
  }
}

class Bn {
  String? _home;

  Bn({String? home}) {
    _home = home;
  }

  String? get home => _home;

  Bn.fromJson(Map<String, dynamic> json) {
    _home = json['Home'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Home'] = _home;
    return data;
  }
}

class En {
  String? _home;
  String? _signIn;
  String? _myCart;
  String? _shippingMethod;
  String? _banner;
  String? _addMainBanner;
  String? _addFooterBanner;
  String? _mainBannerForm;
  String? _bannerUrl;
  String? _bannerType;
  String? _published;
  String? _mainBannerImage;
  String? _footerBannerForm;
  String? _footerBannerImage;
  String? _bannerTable;
  String? _bannerPhoto;
  String? _categories;
  String? _allCategories;
  String? _latestProducts;
  String? _moreProducts;
  String? _brands;
  String? _brandUpdate;
  String? _viewAll;
  String? _brand;
  String? _brandForm;
  String? _name;
  String? _brandLogo;
  String? _brandTable;
  String? _sl;
  String? _image;
  String? _action;
  String? _save;
  String? _update;
  String? _category;
  String? _icon;
  String? _categoryForm;
  String? _categoryTable;
  String? _slug;
  String? _subCategory;
  String? _subCategoryForm;
  String? _subCategoryTable;
  String? _selectCategoryName;
  String? _cashOnDelivery;
  String? _sslCommerzPayment;
  String? _paypal;
  String? _stripe;
  String? _paytm;

  En({String? home, String? signIn, String? myCart, String? shippingMethod, String? banner, String? addMainBanner, String? addFooterBanner, String? mainBannerForm, String? bannerUrl, String? bannerType, String? published, String? mainBannerImage, String? footerBannerForm, String? footerBannerImage, String? bannerTable, String? bannerPhoto, String? categories, String? allCategories, String? latestProducts, String? moreProducts, String? brands, String? brandUpdate, String? viewAll, String? brand, String? brandForm, String? name, String? brandLogo, String? brandTable, String? sl, String? image, String? action, String? save, String? update, String? category, String? icon, String? categoryForm, String? categoryTable, String? slug, String? subCategory, String? subCategoryForm, String? subCategoryTable, String? selectCategoryName, String? cashOnDelivery, String? sslCommerzPayment, String? paypal, String? stripe, String? paytm}) {
    _home = home;
    _signIn = signIn;
    _myCart = myCart;
    _shippingMethod = shippingMethod;
    _banner = banner;
    _addMainBanner = addMainBanner;
    _addFooterBanner = addFooterBanner;
    _mainBannerForm = mainBannerForm;
    _bannerUrl = bannerUrl;
    _bannerType = bannerType;
    _published = published;
    _mainBannerImage = mainBannerImage;
    _footerBannerForm = footerBannerForm;
    _footerBannerImage = footerBannerImage;
    _bannerTable = bannerTable;
    _bannerPhoto = bannerPhoto;
    _categories = categories;
    _allCategories = allCategories;
    _latestProducts = latestProducts;
    _moreProducts = moreProducts;
    _brands = brands;
    _brandUpdate = brandUpdate;
    _viewAll = viewAll;
    _brand = brand;
    _brandForm = brandForm;
    _name = name;
    _brandLogo = brandLogo;
    _brandTable = brandTable;
    _sl = sl;
    _image = image;
    _action = action;
    _save = save;
    _update = update;
    _category = category;
    _icon = icon;
    _categoryForm = categoryForm;
    _categoryTable = categoryTable;
    _slug = slug;
    _subCategory = subCategory;
    _subCategoryForm = subCategoryForm;
    _subCategoryTable = subCategoryTable;
    _selectCategoryName = selectCategoryName;
    _cashOnDelivery = cashOnDelivery;
    _sslCommerzPayment = sslCommerzPayment;
    _paypal = paypal;
    _stripe = stripe;
    _paytm = paytm;
  }

  String? get home => _home;
  String? get signIn => _signIn;
  String? get myCart => _myCart;
  String? get shippingMethod => _shippingMethod;
  String? get banner => _banner;
  String? get addMainBanner => _addMainBanner;
  String? get addFooterBanner => _addFooterBanner;
  String? get mainBannerForm => _mainBannerForm;
  String? get bannerUrl => _bannerUrl;
  String? get bannerType => _bannerType;
  String? get published => _published;
  String? get mainBannerImage => _mainBannerImage;
  String? get footerBannerForm => _footerBannerForm;
  String? get footerBannerImage => _footerBannerImage;
  String? get bannerTable => _bannerTable;
  String? get bannerPhoto => _bannerPhoto;
  String? get categories => _categories;
  String? get allCategories => _allCategories;
  String? get latestProducts => _latestProducts;
  String? get moreProducts => _moreProducts;
  String? get brands => _brands;
  String? get brandUpdate => _brandUpdate;
  String? get viewAll => _viewAll;
  String? get brand => _brand;
  String? get brandForm => _brandForm;
  String? get name => _name;
  String? get brandLogo => _brandLogo;
  String? get brandTable => _brandTable;
  String? get sl => _sl;
  String? get image => _image;
  String? get action => _action;
  String? get save => _save;
  String? get update => _update;
  String? get category => _category;
  String? get icon => _icon;
  String? get categoryForm => _categoryForm;
  String? get categoryTable => _categoryTable;
  String? get slug => _slug;
  String? get subCategory => _subCategory;
  String? get subCategoryForm => _subCategoryForm;
  String? get subCategoryTable => _subCategoryTable;
  String? get selectCategoryName => _selectCategoryName;
  String? get cashOnDelivery => _cashOnDelivery;
  String? get sslCommerzPayment => _sslCommerzPayment;
  String? get paypal => _paypal;
  String? get stripe => _stripe;
  String? get paytm => _paytm;

  En.fromJson(Map<String, dynamic> json) {
    _home = json['Home'];
    _signIn = json['sign_in'];
    _myCart = json['my_cart'];
    _shippingMethod = json['shipping_method'];
    _banner = json['Banner'];
    _addMainBanner = json['add_main_banner'];
    _addFooterBanner = json['add_footer_banner'];
    _mainBannerForm = json['main_banner _form'];
    _bannerUrl = json['banner_url'];
    _bannerType = json['banner_type'];
    _published = json['published'];
    _mainBannerImage = json['main_banner_image'];
    _footerBannerForm = json['footer_banner_form'];
    _footerBannerImage = json['footer_banner_image'];
    _bannerTable = json['banner_table'];
    _bannerPhoto = json['banner_photo'];
    _categories = json['categories'];
    _allCategories = json['all_categories'];
    _latestProducts = json['latest_products'];
    _moreProducts = json['more_products'];
    _brands = json['brands'];
    _brandUpdate = json['brand_update'];
    _viewAll = json['view_all'];
    _brand = json['brand'];
    _brandForm = json['brand_form'];
    _name = json['name'];
    _brandLogo = json['brand_logo'];
    _brandTable = json['brand_table'];
    _sl = json['sl'];
    _image = json['image'];
    _action = json['action'];
    _save = json['save'];
    _update = json['update'];
    _category = json['category'];
    _icon = json['icon'];
    _categoryForm = json['category_form'];
    _categoryTable = json['category_table'];
    _slug = json['slug'];
    _subCategory = json['sub_category'];
    _subCategoryForm = json['sub_category_form'];
    _subCategoryTable = json['sub_category_table'];
    _selectCategoryName = json['select_category_name'];
    _cashOnDelivery = json['cash_on_delivery'];
    _sslCommerzPayment = json['ssl_commerz_payment'];
    _paypal = json['paypal'];
    _stripe = json['stripe'];
    _paytm = json['paytm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Home'] = _home;
    data['sign_in'] = _signIn;
    data['my_cart'] = _myCart;
    data['shipping_method'] = _shippingMethod;
    data['Banner'] = _banner;
    data['add_main_banner'] = _addMainBanner;
    data['add_footer_banner'] = _addFooterBanner;
    data['main_banner _form'] = _mainBannerForm;
    data['banner_url'] = _bannerUrl;
    data['banner_type'] = _bannerType;
    data['published'] = _published;
    data['main_banner_image'] = _mainBannerImage;
    data['footer_banner_form'] = _footerBannerForm;
    data['footer_banner_image'] = _footerBannerImage;
    data['banner_table'] = _bannerTable;
    data['banner_photo'] = _bannerPhoto;
    data['categories'] = _categories;
    data['all_categories'] = _allCategories;
    data['latest_products'] = _latestProducts;
    data['more_products'] = _moreProducts;
    data['brands'] = _brands;
    data['brand_update'] = _brandUpdate;
    data['view_all'] = _viewAll;
    data['brand'] = _brand;
    data['brand_form'] = _brandForm;
    data['name'] = _name;
    data['brand_logo'] = _brandLogo;
    data['brand_table'] = _brandTable;
    data['sl'] = _sl;
    data['image'] = _image;
    data['action'] = _action;
    data['save'] = _save;
    data['update'] = _update;
    data['category'] = _category;
    data['icon'] = _icon;
    data['category_form'] = _categoryForm;
    data['category_table'] = _categoryTable;
    data['slug'] = _slug;
    data['sub_category'] = _subCategory;
    data['sub_category_form'] = _subCategoryForm;
    data['sub_category_table'] = _subCategoryTable;
    data['select_category_name'] = _selectCategoryName;
    data['cash_on_delivery'] = _cashOnDelivery;
    data['ssl_commerz_payment'] = _sslCommerzPayment;
    data['paypal'] = _paypal;
    data['stripe'] = _stripe;
    data['paytm'] = _paytm;
    return data;
  }
}

class RefundPolicy {
  int? _status;
  String? _content;

  RefundPolicy({int? status, String? content}) {
    if (status != null) {
      _status = status;
    }
    if (content != null) {
      _content = content;
    }
  }

  int? get status => _status;
  String? get content => _content;


  RefundPolicy.fromJson(Map<String, dynamic> json) {
    _status = int.parse(json['status'].toString());
    _content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['content'] = _content;
    return data;
  }
}


class MaintenanceMode {
  int? maintenanceStatus;
  SelectedMaintenanceSystem? selectedMaintenanceSystem;
  MaintenanceMessages? maintenanceMessages;
  MaintenanceTypeAndDuration? maintenanceTypeAndDuration;

  MaintenanceMode(
      {this.maintenanceStatus,
        this.selectedMaintenanceSystem,
        this.maintenanceMessages, this.maintenanceTypeAndDuration});

  MaintenanceMode.fromJson(Map<String, dynamic> json) {
    maintenanceStatus = int.tryParse(json['maintenance_status'].toString());
    selectedMaintenanceSystem = (json['selected_maintenance_system'] != null && json['selected_maintenance_system'] is !List)
        ? SelectedMaintenanceSystem.fromJson(
        json['selected_maintenance_system'])
        : null;
    maintenanceMessages = json['maintenance_messages'] != null
        ? MaintenanceMessages.fromJson(json['maintenance_messages'])
        : null;

    maintenanceTypeAndDuration = json['maintenance_type_and_duration'] != null
        ? MaintenanceTypeAndDuration.fromJson(
        json['maintenance_type_and_duration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenance_status'] = maintenanceStatus;
    if (selectedMaintenanceSystem != null) {
      data['selected_maintenance_system'] =
          selectedMaintenanceSystem!.toJson();
    }
    if (maintenanceMessages != null) {
      data['maintenance_messages'] = maintenanceMessages!.toJson();
    }
    if (maintenanceTypeAndDuration != null) {
      data['maintenance_type_and_duration'] =
          maintenanceTypeAndDuration!.toJson();
    }
    return data;
  }
}

class SelectedMaintenanceSystem {
  int? vendorApp;
  int? customerApp;
  int? webApp;
  int? deliverymanApp;

  SelectedMaintenanceSystem({this.vendorApp, this.customerApp, this.webApp, this.deliverymanApp});

  SelectedMaintenanceSystem.fromJson(Map<String, dynamic> json) {
    vendorApp = int.tryParse(json['vendor_app'].toString());
    customerApp = int.tryParse(json['user_app'].toString());
    deliverymanApp = int.tryParse(json['deliveryman_app'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendor_app'] = vendorApp;
    data['customer_app'] = customerApp;
    data['web_app'] = webApp;
    data['deliveryman_app'] = deliverymanApp;
    return data;
  }
}

class MaintenanceMessages {
  int? businessNumber;
  int? businessEmail;
  String? maintenanceMessage;
  String? messageBody;

  MaintenanceMessages(
      {this.businessNumber,
        this.businessEmail,
        this.maintenanceMessage,
        this.messageBody});

  MaintenanceMessages.fromJson(Map<String, dynamic> json) {
    businessNumber = json['business_number'];
    businessEmail = json['business_email'];
    maintenanceMessage = json['maintenance_message'];
    messageBody = json['message_body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_number'] = businessNumber;
    data['business_email'] = businessEmail;
    data['maintenance_message'] = maintenanceMessage;
    data['message_body'] = messageBody;
    return data;
  }
}

class MaintenanceTypeAndDuration {
  String? maintenanceDuration;
  String? startDate;
  String? endDate;

  MaintenanceTypeAndDuration(
      {String? maintenanceDuration, String? startDate, String? endDate}) {
    if (maintenanceDuration != null) {
      this.maintenanceDuration = maintenanceDuration;
    }
    if (startDate != null) {
      this.startDate = startDate;
    }
    if (endDate != null) {
      this.endDate = endDate;
    }
  }
  // String? get startDate => _startDate;
  // set startDate(String? startDate) => _startDate = startDate;
  // String? get endDate => _endDate;
  // set endDate(String? endDate) => _endDate = endDate;

  MaintenanceTypeAndDuration.fromJson(Map<String, dynamic> json) {
    maintenanceDuration = json['maintenance_duration'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenance_duration'] = maintenanceDuration;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    return data;
  }
}


class SellerAppVersionControl {
  final PlatformVersion? forAndroid;
  final PlatformVersion? forIos;

  SellerAppVersionControl({this.forAndroid, this.forIos});

  factory SellerAppVersionControl.fromJson(Map<String, dynamic> json) {
    return SellerAppVersionControl(
      forAndroid: json['for_android'] != null
          ? PlatformVersion.fromJson(json['for_android'])
          : null,
      forIos: json['for_ios'] != null
          ? PlatformVersion.fromJson(json['for_ios'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (forAndroid != null) 'for_android': forAndroid!.toJson(),
      if (forIos != null) 'for_ios': forIos!.toJson(),
    };
  }
}

class PlatformVersion {
  final int? status;
  final String? version;
  final String? link;

  PlatformVersion({
    required this.status,
    required this.version,
    required this.link,
  });

  factory PlatformVersion.fromJson(Map<String, dynamic> json) {
    return PlatformVersion(
      status: int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      version: json['version'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'version': version,
      'link': link,
    };
  }
}



class PaymentMethods {
  String? keyName;
  AdditionalDatas? additionalDatas;

  PaymentMethods({this.keyName, this.additionalDatas});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    keyName = json['key_name'];
    additionalDatas = json['additional_datas'] != null ? AdditionalDatas.fromJson(json['additional_datas']) : null;
  }
}

class AdditionalDatas {
  String? gatewayTitle;
  String? gatewayImage;

  AdditionalDatas({this.gatewayTitle, this.gatewayImage});

  AdditionalDatas.fromJson(Map<String, dynamic> json) {
    gatewayTitle = json['gateway_title'];
    gatewayImage = json['gateway_image'];
  }
}

class OfflinePayment {
  String? name;
  String? image;

  OfflinePayment({this.name, this.image});

  OfflinePayment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }
}

class AuctionConfig {
  bool? status;
  bool? activeForVendor;
  bool? activeForCustomer;
  double? commissionPercentage;
  AuctionEntryFee? entryFee;
  ConfigDuration? expiredVisibilityDuration;
  ConfigDuration? upcomingVisibilityDuration;
  ConfigDuration? winnerClaimTimeLimit;

  AuctionConfig({
    this.status,
    this.activeForVendor,
    this.activeForCustomer,
    this.commissionPercentage,
    this.entryFee,
    this.expiredVisibilityDuration,
    this.upcomingVisibilityDuration,
    this.winnerClaimTimeLimit,
  });

  AuctionConfig.fromJson(Map<String, dynamic> json) {
    status = ConfigModel._isOn(json['status']);
    activeForVendor = ConfigModel._isOn(json['active_for_vendor']);
    activeForCustomer = ConfigModel._isOn(json['active_for_customer']);
    commissionPercentage = double.tryParse(json['commission_percentage'].toString());
    entryFee = AuctionEntryFee.fromJson(ConfigModel._map(json['entry_fee']));
    expiredVisibilityDuration = ConfigDuration.fromJson(ConfigModel._map(json['expired_visibility_duration']));
    upcomingVisibilityDuration = ConfigDuration.fromJson(ConfigModel._map(json['upcoming_visibility_duration']));
    winnerClaimTimeLimit = ConfigDuration.fromJson(ConfigModel._map(json['winner_claim_time_limit']));
  }
}

class AuctionEntryFee {
  bool? status;
  double? amount;

  AuctionEntryFee({this.status, this.amount});

  AuctionEntryFee.fromJson(Map<String, dynamic> json) {
    status = ConfigModel._isOn(json['status']);
    amount = double.tryParse(json['amount'].toString());
  }
}

class ConfigDuration {
  bool? status;
  int? value;
  String? unit;

  ConfigDuration({this.status, this.value, this.unit});

  ConfigDuration.fromJson(Map<String, dynamic> json) {
    status = ConfigModel._isOn(json['status']);
    value = int.tryParse(json['value'].toString());
    unit = json['unit']?.toString();
  }
}

class WholesaleConfig {
  bool? status;
  WholesaleCommissionConfig? commission;
  WholesaleVendorConfig? vendor;
  WholesaleProductConfig? product;
  WholesaleOrderConfig? order;
  WholesaleRefundConfig? refund;
  WholesaleShippingConfig? shipping;
  WholesaleTaxConfig? tax;
  WholesaleAnnouncementConfig? announcement;
  WholesaleAiConfig? ai;

  WholesaleConfig({
    this.status,
    this.commission,
    this.vendor,
    this.product,
    this.order,
    this.refund,
    this.shipping,
    this.tax,
    this.announcement,
    this.ai,
  });

  WholesaleConfig.fromJson(Map<String, dynamic> json) {
    status = ConfigModel._isOn(json['status']);
    commission = WholesaleCommissionConfig.fromJson(ConfigModel._map(json['commission']));
    vendor = WholesaleVendorConfig.fromJson(ConfigModel._map(json['vendor']));
    product = WholesaleProductConfig.fromJson(ConfigModel._map(json['product']));
    order = WholesaleOrderConfig.fromJson(ConfigModel._map(json['order']));
    refund = WholesaleRefundConfig.fromJson(ConfigModel._map(json['refund']));
    shipping = WholesaleShippingConfig.fromJson(ConfigModel._map(json['shipping']));
    tax = WholesaleTaxConfig.fromJson(ConfigModel._map(json['tax']));
    announcement = WholesaleAnnouncementConfig.fromJson(ConfigModel._map(json['announcement']));
    ai = WholesaleAiConfig.fromJson(ConfigModel._map(json['ai']));
  }
}

class WholesaleCommissionConfig {
  double? percentage;
  bool? vendorWise;

  WholesaleCommissionConfig({this.percentage, this.vendorWise});

  WholesaleCommissionConfig.fromJson(Map<String, dynamic> json) {
    percentage = double.tryParse(json['percentage'].toString());
    vendorWise = ConfigModel._isOn(json['vendor_wise']);
  }
}

class WholesaleVendorConfig {
  bool? reviewReply;
  bool? canEditOrder;
  bool? deliveryPartnerSetup;

  WholesaleVendorConfig({this.reviewReply, this.canEditOrder, this.deliveryPartnerSetup});

  WholesaleVendorConfig.fromJson(Map<String, dynamic> json) {
    reviewReply = ConfigModel._isOn(json['review_reply']);
    canEditOrder = ConfigModel._isOn(json['can_edit_order']);
    deliveryPartnerSetup = ConfigModel._isOn(json['delivery_partner_setup']);
  }
}

class WholesaleProductConfig {
  bool? brandEnabled;
  bool? newProductApproval;
  bool? shippingCostApproval;

  WholesaleProductConfig({this.brandEnabled, this.newProductApproval, this.shippingCostApproval});

  WholesaleProductConfig.fromJson(Map<String, dynamic> json) {
    brandEnabled = ConfigModel._isOn(json['brand_enabled']);
    newProductApproval = ConfigModel._isOn(json['new_product_approval']);
    shippingCostApproval = ConfigModel._isOn(json['shipping_cost_approval']);
  }
}

class WholesaleOrderConfig {
  bool? deliveryVerification;
  bool? billingAddress;
  WholesaleMinimumOrderAmount? minimumOrderAmount;

  WholesaleOrderConfig({this.deliveryVerification, this.billingAddress, this.minimumOrderAmount});

  WholesaleOrderConfig.fromJson(Map<String, dynamic> json) {
    deliveryVerification = ConfigModel._isOn(json['delivery_verification']);
    billingAddress = ConfigModel._isOn(json['billing_address']);
    minimumOrderAmount = WholesaleMinimumOrderAmount.fromJson(ConfigModel._map(json['minimum_order_amount']));
  }
}

class WholesaleMinimumOrderAmount {
  bool? status;
  bool? setByVendor;
  double? inHouseAmount;

  WholesaleMinimumOrderAmount({this.status, this.setByVendor, this.inHouseAmount});

  WholesaleMinimumOrderAmount.fromJson(Map<String, dynamic> json) {
    status = ConfigModel._isOn(json['status']);
    setByVendor = ConfigModel._isOn(json['set_by_vendor']);
    inHouseAmount = double.tryParse(json['in_house_amount'].toString());
  }
}

class WholesaleRefundConfig {
  int? dayLimit;
  bool? addToWallet;

  WholesaleRefundConfig({this.dayLimit, this.addToWallet});

  WholesaleRefundConfig.fromJson(Map<String, dynamic> json) {
    dayLimit = int.tryParse(json['day_limit'].toString());
    addToWallet = ConfigModel._isOn(json['add_to_wallet']);
  }
}

class WholesaleShippingConfig {
  String? method;
  String? inHouseShippingType;
  List<WholesaleShippingMethodConfig>? inHouseMethods;
  WholesaleFreeDeliveryConfig? freeDelivery;

  WholesaleShippingConfig({this.method, this.inHouseShippingType, this.inHouseMethods, this.freeDelivery});

  WholesaleShippingConfig.fromJson(Map<String, dynamic> json) {
    method = json['method']?.toString();
    inHouseShippingType = json['in_house_shipping_type']?.toString();
    inHouseMethods = List<WholesaleShippingMethodConfig>.from(
      (json['in_house_methods'] ?? []).map((method) => WholesaleShippingMethodConfig.fromJson(ConfigModel._map(method))),
    );
    freeDelivery = WholesaleFreeDeliveryConfig.fromJson(ConfigModel._map(json['free_delivery']));
  }
}

class WholesaleShippingMethodConfig {
  int? id;
  String? title;
  String? duration;
  double? cost;

  WholesaleShippingMethodConfig({this.id, this.title, this.duration, this.cost});

  WholesaleShippingMethodConfig.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    title = json['title']?.toString();
    duration = json['duration']?.toString();
    cost = double.tryParse(json['cost'].toString());
  }
}

class WholesaleFreeDeliveryConfig {
  bool? status;
  String? responsibility;
  double? overAmountVendor;
  WholesaleInHouseFreeDeliveryConfig? inHouse;

  WholesaleFreeDeliveryConfig({this.status, this.responsibility, this.overAmountVendor, this.inHouse});

  WholesaleFreeDeliveryConfig.fromJson(Map<String, dynamic> json) {
    status = ConfigModel._isOn(json['status']);
    responsibility = json['responsibility']?.toString();
    overAmountVendor = double.tryParse(json['over_amount_vendor'].toString());
    inHouse = WholesaleInHouseFreeDeliveryConfig.fromJson(ConfigModel._map(json['in_house']));
  }
}

class WholesaleInHouseFreeDeliveryConfig {
  bool? status;
  double? overAmount;

  WholesaleInHouseFreeDeliveryConfig({this.status, this.overAmount});

  WholesaleInHouseFreeDeliveryConfig.fromJson(Map<String, dynamic> json) {
    status = ConfigModel._isOn(json['status']);
    overAmount = double.tryParse(json['over_amount'].toString());
  }
}

class WholesaleTaxConfig {
  String? type;
  bool? isIncluded;

  WholesaleTaxConfig({this.type, this.isIncluded});

  WholesaleTaxConfig.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();
    isIncluded = ConfigModel._isOn(json['is_included']);
  }
}

class WholesaleAnnouncementConfig {
  bool? status;
  String? color;
  String? textColor;
  String? text;

  WholesaleAnnouncementConfig({this.status, this.color, this.textColor, this.text});

  WholesaleAnnouncementConfig.fromJson(Map<String, dynamic> json) {
    status = ConfigModel._isOn(json['status']);
    color = json['color']?.toString();
    textColor = json['text_color']?.toString();
    text = json['text']?.toString();
  }
}

class WholesaleAiConfig {
  bool? shoppingAssistant;

  WholesaleAiConfig({this.shoppingAssistant});

  WholesaleAiConfig.fromJson(Map<String, dynamic> json) {
    shoppingAssistant = ConfigModel._isOn(json['shopping_assistant']);
  }
}

class ConfigModules {
  bool? ai;
  bool? auction;
  bool? blog;
  bool? builder;
  bool? courier;
  bool? taxModule;
  bool? wholesale;

  ConfigModules({this.ai, this.auction, this.blog, this.builder, this.courier, this.taxModule, this.wholesale});

  ConfigModules.fromJson(Map<String, dynamic> json) {
    ai = ConfigModel._isOn(json['ai']);
    auction = ConfigModel._isOn(json['auction']);
    blog = ConfigModel._isOn(json['blog']);
    builder = ConfigModel._isOn(json['builder']);
    courier = ConfigModel._isOn(json['courier']);
    taxModule = ConfigModel._isOn(json['tax_module']);
    wholesale = ConfigModel._isOn(json['wholesale']);
  }
}
