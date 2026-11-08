import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';

class ImageResponseModel {
  String? message;
  ImageResponseData? data;

  ImageResponseModel({this.message, this.data});

  ImageResponseModel.fromJson(dynamic json) {
    final Map content = ApiEnvelope.content(json);

    message = ApiEnvelope.message(json);

    final dynamic payload = content['data'];
    final int? remainingCount = ApiEnvelope.remainingCount(json);

    if (payload is Map) {
      data = ImageResponseData(
        data: payload['data']?.toString(),
        remainingCount: remainingCount,
      );
    } else if (payload != null) {
      data = ImageResponseData(data: payload.toString(), remainingCount: remainingCount);
    } else {
      data = null;
    }
  }
}

class ImageResponseData {
  String? data;
  int? remainingCount;

  ImageResponseData({this.data, this.remainingCount});
}
