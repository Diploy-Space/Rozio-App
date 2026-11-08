import 'package:sixvalley_vendor_app/features/third_party_deliveryman/controllers/third_party_deliveryman_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/third_party_deliveryman/domain/services/wholesale_third_party_deliveryman_service_interface.dart';

class WholesaleThirdPartyDeliverymanController extends ThirdPartyDeliverymanController {
  WholesaleThirdPartyDeliverymanController({required WholesaleThirdPartyDeliverymanServiceInterface super.serviceInterface});

  @override
  bool isSuccessStatus(int? statusCode) => statusCode == 200 || statusCode == 201;

  @override
  bool isOk(Map<String, dynamic> data) => data['ok'] != false;
}
