import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file_manager/open_file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/features/clearance_sale/widgets/show_custom_time_picker.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/product_controller.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/payment_information_model.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/shop_model.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/vacation_model.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/withdrawal_method_model.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/services/shop_service_interface.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/models/config_model.dart' hide Data;
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:http/http.dart' as http;
import 'package:sixvalley_vendor_app/helper/image_size_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class ShopController extends ChangeNotifier {
  final ShopServiceInterface shopServiceInterface;

  ShopController({required this.shopServiceInterface});


  int _selectedIndex = 0;
  int get selectedIndex =>_selectedIndex;
  String countryDialCode = '+880';

  String ? _vacationDurationType = 'one_day';
  String ? get vacationDurationType => _vacationDurationType;

  final DateFormat _dateFormat = DateFormat('d MMM yy, h:mm a');
  DateFormat get dateFormat => _dateFormat;

  DateTime? _startDateTime;
  DateTime? get startDateTime => _startDateTime;

  DateTime? _endDateTime;
  DateTime? get endDateTime => _endDateTime;

  DateTime? _tinExpireDate;
  DateTime? get tinExpireDate => _tinExpireDate;

  XFile ? _tinCertificateFile;
  XFile? get tinCertificateFile => _tinCertificateFile;

  DateTime? _wholesaleTinExpireDate;
  DateTime? get wholesaleTinExpireDate => _wholesaleTinExpireDate;

  XFile ? _wholesaleTinCertificateFile;
  XFile? get wholesaleTinCertificateFile => _wholesaleTinCertificateFile;

  DateTime? _auctionTinExpireDate;
  DateTime? get auctionTinExpireDate => _auctionTinExpireDate;

  XFile ? _auctionTinCertificateFile;
  XFile? get auctionTinCertificateFile => _auctionTinCertificateFile;

  int _myShopPageIndex = 0;
  int get myShopPageIndex => _myShopPageIndex;

  VacationModel? _vacationModel;
  VacationModel? get vacationModel => _vacationModel;

  WithdrawalMethodModel? _withdrawalMethodModel;
  WithdrawalMethodModel? get withdrawalMethodModel => _withdrawalMethodModel;

  String ? _selectedPaymentMethod = '';
  String ? get selectedPaymentMethod => _selectedPaymentMethod;

  bool ? _selectedPaymentStatus = true;
  bool ? get selectedPaymentStatus => _selectedPaymentStatus;

  PaymentInformationModel ? _paymentInformationModel;
  PaymentInformationModel ? get paymentInformationModel => _paymentInformationModel;

  List<MethodFields> paymentMethodFields = [];

  bool _showAddProductWarning = true;
  bool get showAddProductWarning => _showAddProductWarning;

  bool _isDownloadLoading = false;
  bool get isDownloadLoading => _isDownloadLoading;


  void updateSelectedIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }


  void setCountryCode( String countryCode, {bool notify = true}) {
    countryDialCode  = countryCode;
    if(notify){
      notifyListeners();
    }
  }


  ShopModel? _shopModel;
  ShopModel? get shopModel => _shopModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  File? _file;

  File? get file => _file;
  final picker = ImagePicker();

  void choosePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: AppConstants.imageQuality, maxHeight: 500, maxWidth: 500);
    if (pickedFile != null) {
      _file = File(pickedFile.path);
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
    notifyListeners();
  }

  bool vacationIsOn = false;

  void checkVacation(String vacationEndDate) {
    DateTime vacationDate = DateTime.parse(vacationEndDate);
    final today = DateTime.now();
    final difference = vacationDate.difference(today).inDays;
    if(difference >=0 ){
      vacationIsOn = true;
    }else{
      vacationIsOn = false;
    }
  }


  Future<ResponseModel> getShopInfo() async {
    ResponseModel responseModel;
    ApiResponse apiResponse = await shopServiceInterface.getShop();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final Map content = ApiEnvelope.content(apiResponse.response!.data);
      _shopModel = ShopModel.fromJson(Map<String, dynamic>.from(content['data'] is Map ? content['data'] : content));
      responseModel = ResponseModel(true, 'successful');
      if(shopModel!.vacationEndDate != null){
        checkVacation(shopModel!.vacationEndDate!);
      }
      setVacationData(_shopModel);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      if (kDebugMode) {
        print(errorMessage);
      }
      responseModel = ResponseModel(false, errorMessage);
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return responseModel;
  }


  void setVacationData(ShopModel? shopModel, {bool isUpdate = false}) {
    if(shopModel != null) {
      _vacationModel = VacationModel(
      vacationStatus: shopModel.vacationStatus,
      vacationDurationType: shopModel.vacationDurationType,
      vacationStartDate: shopModel.vacationStartDate,
      vacationEndDate: shopModel.vacationEndDate,
      vacationNote: shopModel.vacationNote,
      modules: List<String>.from(shopModel.vacationModules ?? []),
    );
    }

    if(isUpdate) {
      _startDateTime = null;
      _endDateTime = null;
      _vacationDurationType = shopModel?.vacationDurationType;

      notifyListeners();
    }
  }

  Future<void> updateShopInfo({ShopModel? updateShopModel, File? file,String? minimumOrderAmount,
    String? freeDeliveryStatus,
    String? freeDeliveryOverAmount, String? wholesaleFreeDeliveryStatus, String? wholesaleFreeDeliveryOverAmount, String? taxIdentificationNumber, String? tinExpireDate, XFile? tinCertificate, String? stockLimit, bool fromOnOff = false,
    String? wholesaleTaxIdentificationNumber, String? wholesaleTinExpireDate, XFile? wholesaleTinCertificate,
    String? auctionTaxIdentificationNumber, String? auctionTinExpireDate, XFile? auctionTinCertificate}) async {
    _isLoading = true;
    notifyListeners();

    http.StreamedResponse response = await shopServiceInterface.updateShop(shopModel!, file,
      Provider.of<AuthController>(Get.context!, listen: false).shopBanner,
      Provider.of<AuthController>(Get.context!, listen: false).secondaryBanner,
      Provider.of<AuthController>(Get.context!, listen: false).offerBanner,minimumOrderAmount: minimumOrderAmount,
      freeDeliveryOverAmount: freeDeliveryOverAmount, freeDeliveryStatus: freeDeliveryStatus,
      wholesaleFreeDeliveryOverAmount: wholesaleFreeDeliveryOverAmount, wholesaleFreeDeliveryStatus: wholesaleFreeDeliveryStatus,
      taxIdentificationNumber: taxIdentificationNumber, tinExpireDate: tinExpireDate, tinCertificate: tinCertificate,
      stockLimit: stockLimit,
      wholesaleTaxIdentificationNumber: wholesaleTaxIdentificationNumber, wholesaleTinExpireDate: wholesaleTinExpireDate, wholesaleTinCertificate: wholesaleTinCertificate,
      auctionTaxIdentificationNumber: auctionTaxIdentificationNumber, auctionTinExpireDate: auctionTinExpireDate, auctionTinCertificate: auctionTinCertificate,
    );

    if (response.statusCode == 200) {
      if(fromOnOff){
        Provider.of<ProfileController>(Get.context!, listen: false).setFreeDeliveryStatus(freeDeliveryStatus!);
      }
      showCustomSnackBarWidget(getTranslated('shop_info_updated_successfully', Get.context!), Get.context!, isError: false, sanckBarType: SnackBarType.success);
      _tinCertificateFile = null;
      _wholesaleTinCertificateFile = null;
      _auctionTinCertificateFile = null;
      if(_shopModel?.reorderLevel != int.tryParse(stockLimit ?? '0')) {
        Provider.of<ProductController>(Get.context!, listen: false).getStockOutProductList(1, 'en');
      }
      getShopInfo();
      Provider.of<ProfileController>(Get.context!, listen: false).getSellerInfo();
    } else {
      String? errorMessage;
      try {
        errorMessage = ApiEnvelope.errorMessage(jsonDecode((await http.Response.fromStream(response)).body));
      } catch (_) {}
      showCustomSnackBarWidget(errorMessage ?? getTranslated('something_went_wrong', Get.context!), Get.context!, sanckBarType: SnackBarType.error);
    }

    _isLoading = false;
    notifyListeners();
  }



  final List<String> _availableModules = [];
  List<String> get availableModules => _availableModules;

  void setAvailableModules({bool isUpdate = true}) {
    _availableModules.clear();
    if (_shopModel?.temporaryClose ?? true) _availableModules.add('retail');
    if (_shopModel?.wholesaleTemporaryClose ?? true) _availableModules.add('wholesale');
    if (_shopModel?.auctionTemporaryClose ?? true) _availableModules.add('auction');
    if (isUpdate) {
      notifyListeners();
    }
  }

  void toggleAvailableModule(String module) {
    if (_availableModules.contains(module)) {
      _availableModules.remove(module);
    } else {
      _availableModules.add(module);
    }
    notifyListeners();
  }

  Future<void> resetAvailableModules(BuildContext context, List<String> activeModules) async {
    if (activeModules.every(_availableModules.contains)) {
      showCustomSnackBarWidget(getTranslated('all_modules_are_already_on', context), context, isToaster: true, sanckBarType: SnackBarType.warning);
      return;
    }

    for (final String module in activeModules) {
      if (!_availableModules.contains(module)) {
        _availableModules.add(module);
      }
    }
    await shopTemporaryClose(context, List<String>.from(_availableModules), popOnSuccess: false);
  }

  Future<void> shopTemporaryClose(BuildContext context, List<String> status, {bool popOnSuccess = true}) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await shopServiceInterface.temporaryClose(status);

    if (apiResponse.response?.statusCode == 200) {
      _isLoading = false;

      showCustomSnackBarWidget(getTranslated('status_updated_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
      if (popOnSuccess && context.mounted) {
        Navigator.of(context).pop();
      }
      getShopInfo();

    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }


  Future<void> shopVacation(BuildContext context, VacationModel vacationModel) async {

    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await shopServiceInterface.vacation(vacationModel);

    if (apiResponse.response?.statusCode == 200) {
      _isLoading = false;
      showCustomSnackBarWidget(getTranslated('status_updated_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
      getShopInfo();

    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  final int _selectedItem = 0;
  int get selectedItem => _selectedItem;
  String _startDate = 'Start Date';
  String get startDate => _startDate;
  String _endDate = 'End Date';
  String get endDate => _endDate;


  Future <void> selectDate(BuildContext context,String startDate, String endDate) async {
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
  }






  void setVacationDurationType(String index, {bool isUpdate = true}) {
    _vacationDurationType = index;
    _vacationModel?.vacationDurationType = index;
    if(isUpdate) {
      notifyListeners();
    }
  }

  void selectDateTime(String type, bool is24Hour,BuildContext context, {DateTime? dateTime}) async {
    TimeOfDay? time;
    final bool isEnd = type == 'end';
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime firstDate = isEnd && _startDateTime != null
        ? DateTime(_startDateTime!.year, _startDateTime!.month, _startDateTime!.day)
        : today;
    final DateTime initialDate = isEnd && _startDateTime != null
        ? (_endDateTime != null && !_endDateTime!.isBefore(_startDateTime!) ? _endDateTime! : _startDateTime!)
        : (dateTime ?? (type == 'start' && _startDateTime != null ? _startDateTime! : now));

    showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2030),
    ).then((date) async {
      if (date == null) return;

      time = await showCustomTimePicker(dateTime: dateTime);
      if (time == null) return;

      final combinedDateTime = DateTime(date.year, date.month, date.day, time!.hour, time!.minute);

      if(is24Hour) {
        setVacationDurationType('custom');
      }
      if (type == 'start') {
        _startDateTime = combinedDateTime;
        _vacationModel?.vacationStartDate = _startDateTime.toString();
        if (_endDateTime != null && !_endDateTime!.isAfter(_startDateTime!)) {
          _endDateTime = null;
          _vacationModel?.vacationEndDate = null;
        }
      } else {
        _endDateTime = combinedDateTime;
        _vacationModel?.vacationEndDate = _endDateTime.toString();
      }
      notifyListeners();
    });
  }

  void set24HourVacation({bool isUpdate = false}) {
    _startDateTime = DateTime.now();
    _endDateTime = _startDateTime?.add(const Duration(hours: 24));

    _vacationModel?.vacationStartDate = _startDateTime.toString();
    _vacationModel?.vacationEndDate = _endDateTime.toString();
    if(isUpdate) {
      notifyListeners();
    }
  }

  void setShopPageIndex(int index, {bool isUpdate = true}) {
    _myShopPageIndex = index;
    if(isUpdate) {
      notifyListeners();
    }
  }


  void setVacationStatus() {
    _vacationModel?.vacationStatus = !(_vacationModel?.vacationStatus ?? false);
    notifyListeners();
  }

  void toggleVacationModule(String module) {
    final List<String> modules = _vacationModel?.modules ?? [];
    if (modules.contains(module)) {
      modules.remove(module);
    } else {
      modules.add(module);
    }
    _vacationModel?.modules = modules;
    notifyListeners();
  }



  Future<ResponseModel> getPaymentWithdrawalMethodList() async {
    ResponseModel responseModel;
    ApiResponse apiResponse = await shopServiceInterface.getPaymentWithdrawalMethodList();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _withdrawalMethodModel = null;
      _withdrawalMethodModel = WithdrawalMethodModel.fromJson(apiResponse.response!.data);
      responseModel = ResponseModel(true, 'successful');
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      if (kDebugMode) {
        print(errorMessage);
      }
      responseModel = ResponseModel(false, errorMessage);
      ApiChecker.checkApi(apiResponse);
    }

    return responseModel;
  }


  void setSelectedPaymentMethod (String method) {
    _selectedPaymentMethod = method;
    setMethodFields(method);
    notifyListeners();
  }




  void setMethodFields(String paymentMethod) {
    paymentMethodFields = [];
    for(Data method in  (_withdrawalMethodModel?.data ?? [])) {

      if(method.methodName == paymentMethod) {

        for(MethodFields methodField in (method.methodFields ?? []) ) {
          methodField.textEditingController = TextEditingController();
          paymentMethodFields.add(methodField);
        }
        break;
      }
    }
  }


  int? getPaymentMethodId (String paymentMethod) {
    int? id;
    for(Data method in  (_withdrawalMethodModel?.data ?? [])) {
      if(method.methodName == paymentMethod) {
        id = method.id;
        break;
      }
    }
    return id;
  }

  void setPaymentStatus(bool value, {bool isUpdate = true}) {
    _selectedPaymentStatus = value;
    if(isUpdate) {
      notifyListeners();
    }
  }


  void setMethodCountryCode(int index, String code) async {
    paymentMethodFields[index].countryCode = code;
    notifyListeners();
  }

  Future<DateTime?> pickDate(BuildContext context, index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );

    paymentMethodFields[index].dateTime = picked;
    notifyListeners();
    return picked;
  }



  Future<ApiResponse> addPaymentInfo(BuildContext context, WithdrawAddModel vacationModel, {bool isUpdate = false}) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await shopServiceInterface.addPaymentInfo(vacationModel, isUpdate);
    if (apiResponse.response != null && (apiResponse.response!.statusCode == 200 || apiResponse.response!.statusCode == 201)) {
      _isLoading = false;
      if(!isUpdate) {
        showCustomSnackBarWidget(getTranslated('payment_method_added_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
      } else {
        showCustomSnackBarWidget(getTranslated('status_updated_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
      }
      getPaymentInfoList(1);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();

    return apiResponse;
  }


  Future<void> getPaymentInfoList(int? offset) async {
    ApiResponse apiResponse = await shopServiceInterface.getPaymentInfoList(offset);
    if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final PaymentInformationModel result = PaymentInformationModel.fromJson(apiResponse.response!.data);

      if(offset == 1) {
        _paymentInformationModel = result;
      }else {
        _paymentInformationModel!.data!.addAll(result.data ?? []);
        _paymentInformationModel!.offset = result.offset;
        _paymentInformationModel!.totalSize = result.totalSize;
        _paymentInformationModel!.limit = result.limit;
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }



  Future<void> updatePaymentMethodStatus(bool status, int index, int id,) async {
    ApiResponse apiResponse  = await shopServiceInterface.updateConfigStatus(status, id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBarWidget(getTranslated('status_updated_successfully', Get.context!), Get.context!, isError: false, sanckBarType: SnackBarType.success);
      _paymentInformationModel?.data?[index].isActive = status;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> deletePaymentMethodStatus(int id, int index) async {
    ApiResponse apiResponse  = await shopServiceInterface.deletePaymentMethod(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBarWidget(getTranslated('payment_method_deleted_successfully', Get.context!), Get.context!, isError: false, sanckBarType: SnackBarType.success);
      if(_paymentInformationModel?.data != null && index < _paymentInformationModel!.data!.length) {
        _paymentInformationModel!.data!.removeAt(index);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }


  Future<void> setDefaultPaymentMethod(int id) async {
    ApiResponse apiResponse  = await shopServiceInterface.setDefaultPaymentMethod(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBarWidget(getTranslated('status_updated_successfully', Get.context!), Get.context!, isError: false, sanckBarType: SnackBarType.success);
      getPaymentInfoList(1);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }


  Future<DateTime?> pickTinExpireDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    _tinExpireDate = picked;
    notifyListeners();
    return picked;
  }


  void pickTinCertificateFile() async {
    PlatformFile? result = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', "doc", 'docx'],
    );

    bool hasInvalidFile = false;
    if(result != null) {
      if (['pdf', 'jpg', 'jpeg', "doc", 'docx'].contains(result.extension?.toLowerCase())) {
      } else {
        hasInvalidFile = true;
        result = null;
      }
    }

    if(hasInvalidFile) {
      showCustomSnackBarWidget('${getTranslated('invalid_file_type', Get.context!)} ', Get.context!, sanckBarType: SnackBarType.error);
    }

    if(result != null){
      Uint8List imageBytes = await result.readAsBytes();
      File? file = await File(result.path!).writeAsBytes(imageBytes);

      XFile xFile =  XFile(file.path);

      double fileSizeInMB = await ImageValidationHelper.getImageSizeFromXFile(xFile);

      ConfigModel? configModel = Provider.of<SplashController>(Get.context!, listen: false).configModel;

      if(fileSizeInMB > (configModel?.systemGeneralFileUploadMaxSize ?? AppConstants.fileImageMaxLimit)) {
        showCustomSnackBarWidget('${getTranslated('maximum_image_size', Get.context!)} ${(configModel?.systemGeneralFileUploadMaxSize ?? AppConstants.fileImageMaxLimit)}MB', Get.context!, sanckBarType: SnackBarType.warning);
      } else {
        _tinCertificateFile = xFile;
      }
    }
    notifyListeners();
  }

  void removeTinCertificateFile() {
    _tinCertificateFile = null;
    notifyListeners();
  }

  void setExpireDate(DateTime? date) {
    _tinExpireDate = date;
  }


  Future<DateTime?> pickWholesaleTinExpireDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    _wholesaleTinExpireDate = picked;
    notifyListeners();
    return picked;
  }


  void pickWholesaleTinCertificateFile() async {
    PlatformFile? result = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', "doc", 'docx'],
    );

    bool hasInvalidFile = false;
    if(result != null) {
      if (['pdf', 'jpg', 'jpeg', "doc", 'docx'].contains(result.extension?.toLowerCase())) {
      } else {
        hasInvalidFile = true;
        result = null;
      }
    }

    if(hasInvalidFile) {
      showCustomSnackBarWidget('${getTranslated('invalid_file_type', Get.context!)} ', Get.context!, sanckBarType: SnackBarType.error);
    }

    if(result != null){
      Uint8List imageBytes = await result.readAsBytes();
      File? file = await File(result.path!).writeAsBytes(imageBytes);

      XFile xFile =  XFile(file.path);

      double fileSizeInMB = await ImageValidationHelper.getImageSizeFromXFile(xFile);

      ConfigModel? configModel = Provider.of<SplashController>(Get.context!, listen: false).configModel;

      if(fileSizeInMB > (configModel?.systemGeneralFileUploadMaxSize ?? AppConstants.fileImageMaxLimit)) {
        showCustomSnackBarWidget('${getTranslated('maximum_image_size', Get.context!)} ${(configModel?.systemGeneralFileUploadMaxSize ?? AppConstants.fileImageMaxLimit)}MB', Get.context!, sanckBarType: SnackBarType.warning);
      } else {
        _wholesaleTinCertificateFile = xFile;
      }
    }
    notifyListeners();
  }

  void removeWholesaleTinCertificateFile() {
    _wholesaleTinCertificateFile = null;
    notifyListeners();
  }

  void setWholesaleExpireDate(DateTime? date) {
    _wholesaleTinExpireDate = date;
  }


  Future<DateTime?> pickAuctionTinExpireDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    _auctionTinExpireDate = picked;
    notifyListeners();
    return picked;
  }


  void pickAuctionTinCertificateFile() async {
    PlatformFile? result = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', "doc", 'docx'],
    );

    bool hasInvalidFile = false;
    if(result != null) {
      if (['pdf', 'jpg', 'jpeg', "doc", 'docx'].contains(result.extension?.toLowerCase())) {
      } else {
        hasInvalidFile = true;
        result = null;
      }
    }

    if(hasInvalidFile) {
      showCustomSnackBarWidget('${getTranslated('invalid_file_type', Get.context!)} ', Get.context!, sanckBarType: SnackBarType.error);
    }

    if(result != null){
      Uint8List imageBytes = await result.readAsBytes();
      File? file = await File(result.path!).writeAsBytes(imageBytes);

      XFile xFile =  XFile(file.path);

      double fileSizeInMB = await ImageValidationHelper.getImageSizeFromXFile(xFile);

      ConfigModel? configModel = Provider.of<SplashController>(Get.context!, listen: false).configModel;

      if(fileSizeInMB > (configModel?.systemGeneralFileUploadMaxSize ?? AppConstants.fileImageMaxLimit)) {
        showCustomSnackBarWidget('${getTranslated('maximum_image_size', Get.context!)} ${(configModel?.systemGeneralFileUploadMaxSize ?? AppConstants.fileImageMaxLimit)}MB', Get.context!, sanckBarType: SnackBarType.warning);
      } else {
        _auctionTinCertificateFile = xFile;
      }
    }
    notifyListeners();
  }

  void removeAuctionTinCertificateFile() {
    _auctionTinCertificateFile = null;
    notifyListeners();
  }

  void setAuctionExpireDate(DateTime? date) {
    _auctionTinExpireDate = date;
  }


  Future<void> updateSetupGuideApp(String key, int value) async {
    ApiResponse apiResponse  = await shopServiceInterface.updateSetupGuideApp(key, value);
    if (apiResponse.response?.statusCode == 200) {
      final dynamic data = ApiEnvelope.content(apiResponse.response!.data)['data'];
      final dynamic setupGuideApp = data is Map ? data['setup_guide_app'] : null;
      if (setupGuideApp is Map) {
        _shopModel?.setupGuideApp = Map<String, dynamic>.from(setupGuideApp);
      }
    }
    notifyListeners();
  }


  void setShowAddProductWarning (bool value) {
    _showAddProductWarning = value;
    notifyListeners();
  }


  void resetPaymentInfoData() {
    _selectedPaymentMethod = '';
    paymentMethodFields = [];
  }



  void previewDownload({required String url, required String fileName, bool isIos = false}) async {
    _isDownloadLoading = true;
    notifyListeners();

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    var selectedFolderType = AndroidFolderType.download;
    final subFolderPathCtrl = TextEditingController();

    if (true) {
      HttpClientResponse apiResponse = await  shopServiceInterface.downloadTinCertificate(url);
      if (apiResponse.statusCode == 200) {

        List<int> downloadData = [];
        Directory downloadDirectory;

        if (Platform.isIOS) {
          downloadDirectory = await getApplicationDocumentsDirectory();
        } else {
          downloadDirectory = Directory('/storage/emulated/0/Download');
          if (!await downloadDirectory.exists()) {
            downloadDirectory = (await getExternalStorageDirectory())!;
          }
        }

        String filePathName = "${downloadDirectory.path}/$fileName";

          List<String> parts = fileName.split('.');
          String filename = parts[0];
          String extention = parts[1];


          int fileCounter = 1;

          while (await File(filePathName).exists()) {
            fileName = '${filename+fileCounter.toString()}.$extention';
            filePathName = "${downloadDirectory.path}/$fileName";
            fileCounter++;
          }

          File savedFile = File(filePathName);

          apiResponse.listen((d) => downloadData.addAll(d), onDone: () {
            savedFile.writeAsBytes(downloadData);
          });
          showCustomSnackBarWidget( getTranslated('file_downloaded_successfully', Get.context!),
            Get.context!, isError: false);

          await openFileManager(
            androidConfig: AndroidConfig(
              folderType: selectedFolderType,
            ),
            iosConfig: IosConfig(
              folderPath: subFolderPathCtrl.text.trim(),
            ),
          );

          _isDownloadLoading = false;
          notifyListeners();
      } else {
        _isDownloadLoading = false;

        showCustomSnackBarWidget(getTranslated('file_download_failed', Get.context!), Get.context!);
        Navigator.of(Get.context!).pop();
      }
    }
  }


  void clearShopModel({bool isUpdate = true}) {
    _tinCertificateFile = null;
    _tinExpireDate = null;
    _wholesaleTinCertificateFile = null;
    _wholesaleTinExpireDate = null;
    _auctionTinCertificateFile = null;
    _auctionTinExpireDate = null;
    _shopModel = null;
    if(isUpdate) {
      notifyListeners();
    }
  }

  void updateTutorialFlow(String key) {
    _shopModel?.setupGuideApp?[key] = 1;
    notifyListeners();
  }


}


