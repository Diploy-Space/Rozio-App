class PaginationModel {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  int? from;
  int? to;

  PaginationModel({this.currentPage, this.lastPage, this.perPage, this.total, this.from, this.to});

  PaginationModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    from = json['from'];
    to = json['to'];
  }

  bool get hasNextPage => currentPage != null && lastPage != null && currentPage! < lastPage!;
}
