import 'package:sixvalley_vendor_app/features/wholesale/vatReport/domain/repositories/wholesale_vat_report_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatReport/domain/services/wholesale_vat_report_service_interface.dart';

class WholesaleVatReportService implements WholesaleVatReportServiceInterface {
  final WholesaleVatReportRepositoryInterface wholesaleVatReportRepoInterface;
  WholesaleVatReportService({required this.wholesaleVatReportRepoInterface});

  @override
  Future getVatReport(int? limit, int? offset, String? startDate, String? endDate) {
    return wholesaleVatReportRepoInterface.getVatReport(limit, offset, startDate, endDate);
  }
}
