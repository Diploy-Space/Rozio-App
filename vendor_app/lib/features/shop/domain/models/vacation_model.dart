import 'package:sixvalley_vendor_app/helper/json_converter.dart';

class VacationModel {
  bool? vacationStatus;
  String? vacationDurationType;
  String? vacationStartDate;
  String? vacationEndDate;
  String? vacationNote;
  List<String>? modules;

  VacationModel(
      {this.vacationStatus,
        this.vacationDurationType,
        this.vacationStartDate,
        this.vacationEndDate,
        this.vacationNote,
        this.modules,
      });

  VacationModel.fromJson(Map<String, dynamic> json) {
    vacationStatus = JsonConverter.toBool(json['vacation_status']);
    vacationDurationType = json['vacation_duration_type'];
    vacationStartDate = json['vacation_start_date'];
    vacationEndDate = json['vacation_end_date'];
    vacationNote = json['vacation_note'];
    modules = json['vacation_modules'] is List
      ? List<String>.from((json['vacation_modules'] as List).map((module) => module.toString()))
      : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'vacation_status': (vacationStatus ?? false) ? '1' : '0',
      'vacation_duration_type': vacationDurationType,
      'modules': modules ?? [],
      if (vacationStartDate != null) 'vacation_start_date': vacationStartDate,
      if (vacationEndDate != null) 'vacation_end_date': vacationEndDate,
      if (vacationNote != null) 'vacation_note': vacationNote,
    };
  }

}
