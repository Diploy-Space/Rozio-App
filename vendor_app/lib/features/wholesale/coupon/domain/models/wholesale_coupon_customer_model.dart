class WholesaleCouponCustomer {
  int? id;
  String? fName;
  String? lName;

  WholesaleCouponCustomer({this.id, this.fName, this.lName});

  WholesaleCouponCustomer.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    fName = json['f_name'];
    lName = json['l_name'];
  }

  String get fullName => '${fName ?? ''} ${lName ?? ''}'.trim();
}
