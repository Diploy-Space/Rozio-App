import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/barcode/domain/services/barcode_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class BarcodeController extends ChangeNotifier{

  final BarcodeServiceInterface barcodeServiceInterface;
  BarcodeController({required this.barcodeServiceInterface});


  int _barCodeQuantity = 0;
  int get barCodeQuantity => _barCodeQuantity;
  bool _isGetting = false;
  bool get isGetting => _isGetting;
  String? _printBarCode = '';
  String? get printBarCode =>_printBarCode;


  void setBarCodeQuantity(int quantity){
    _barCodeQuantity = quantity;
    if (kDebugMode) {
      print('Quantity is ==>$_barCodeQuantity');
    }
    notifyListeners();
  }

  Future<void> barCodeDownload(BuildContext context,int? id, int quantity, {bool isCompact = false}) async {
    _isGetting = true;
    notifyListeners();
    ApiResponse apiResponse = await barcodeServiceInterface.barCodeDownLoad(id, quantity, layout: isCompact ? 'compact' : null);
    if (apiResponse.response?.statusCode == 200) {
      final String? pdfUrl = _pdfUrl(apiResponse.response?.data);
      final ApiResponse? pdfResponse = pdfUrl != null ? await barcodeServiceInterface.downloadBarcodePdf(pdfUrl) : null;
      final dynamic bytes = pdfResponse?.response?.data;
      if (bytes is List<int> && _isPdf(bytes)) {
        try {
          _printBarCode = await _saveBarcodePdf(bytes, id);
          showCustomSnackBarWidget(getTranslated('barcode_downloaded_successfully', Get.context!),Get.context!,isError: false);
          await OpenFile.open(_printBarCode);
        } catch (_) {
          showCustomSnackBarWidget(getTranslated('file_download_failed', Get.context!), Get.context!);
        }
      } else {
        showCustomSnackBarWidget(getTranslated('file_download_failed', Get.context!), Get.context!);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isGetting = false;
    notifyListeners();
  }

  String? _pdfUrl(dynamic data) {
    if (data is Map && data['content'] is Map) {
      final dynamic url = data['content']['data'];
      if (url is String && url.isNotEmpty) {
        return url;
      }
    }
    return null;
  }

  bool _isPdf(List<int> bytes) => bytes.length > 4 && String.fromCharCodes(bytes.take(4)) == '%PDF';

  Future<String> _saveBarcodePdf(List<int> bytes, int? id) async {
    final String fileName = 'barcode_${id ?? ''}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    if (Platform.isAndroid) {
      try {
        final File file = File('/storage/emulated/0/Download/$fileName');
        await file.writeAsBytes(bytes);
        return file.path;
      } catch (_) {}
    }
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

}