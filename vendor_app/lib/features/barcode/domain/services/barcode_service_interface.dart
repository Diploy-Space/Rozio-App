
abstract class BarcodeServiceInterface {
  Future<dynamic> barCodeDownLoad(int? id, int quantity, {String? layout});
  Future<dynamic> downloadBarcodePdf(String url);
}