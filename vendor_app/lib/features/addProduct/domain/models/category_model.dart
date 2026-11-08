class CategoryModel {
  int? _id;
  String? _name;
  String? _slug;
  String? _icon;
  int? _parentId;
  int? _position;
  String? _createdAt;
  String? _updatedAt;
  List<SubCategory>? _subCategories;
  int? _categoryProductsCount;
  bool? _checked;

  CategoryModel(
      {int? id,
        String? name,
        String? slug,
        String? icon,
        int? parentId,
        int? position,
        String? createdAt,
        String? updatedAt,
        List<SubCategory>? subCategories,
        int? categoryProductsCount,
        bool checked = false,
      }) {
    _id = id;
    _name = name;
    _slug = slug;
    _icon = icon;
    _parentId = parentId;
    _position = position;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _subCategories = subCategories;
    _checked = checked;
    _categoryProductsCount = categoryProductsCount;

  }

  int? get id => _id;
  String? get name => _name;
  String? get slug => _slug;
  String? get icon => _icon;
  int? get parentId => _parentId;
  int? get position => _position;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<SubCategory>? get subCategories => _subCategories;
  int? get categoryProductsCount => _categoryProductsCount;



  bool? get checked => _checked;
  void toggleChecked(){
    _checked = !_checked!;
  }



  CategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _icon = json['icon'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['childes'] != null) {
      _subCategories = [];
      json['childes'].forEach((v) {
        _subCategories!.add(SubCategory.fromJson(v));
      });
    }

    _categoryProductsCount = json['category_products_count'];
    _checked = false;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['slug'] = _slug;
    data['icon'] = _icon;
    data['parent_id'] = _parentId;
    data['position'] = _position;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    if (_subCategories != null) {
      data['childes'] = _subCategories!.map((v) => v.toJson()).toList();
    }
    data['category_products_count'] = _categoryProductsCount;
    return data;
  }
}

class SubCategory {
  int? _id;
  String? _name;
  String? _slug;
  String? _icon;
  int? _parentId;
  int? _position;
  String? _createdAt;
  String? _updatedAt;
  List<SubSubCategory>? _subSubCategories;
  bool? _checked;
  int? _totalProductCount;

  SubCategory(
      {int? id,
        String? name,
        String? slug,
        String? icon,
        int? parentId,
        int? position,
        String? createdAt,
        String? updatedAt,
        List<SubSubCategory>? subSubCategories,
        bool checked = false,
        int? totalProductCount,
      }) {
    _id = id;
    _name = name;
    _slug = slug;
    _icon = icon;
    _parentId = parentId;
    _position = position;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _subSubCategories = subSubCategories;
    _checked = checked;
    _totalProductCount = totalProductCount;
  }

  int? get id => _id;
  String? get name => _name;
  String? get slug => _slug;
  String? get icon => _icon;
  int? get parentId => _parentId;
  int? get position => _position;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<SubSubCategory>? get subSubCategories => _subSubCategories;
  int? get totalProductCount => _totalProductCount;

  bool? get checked => _checked;
  void toggleChecked(){
    _checked = !_checked!;
  }

  SubCategory.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _icon = json['icon'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['childes'] != null) {
      _subSubCategories = [];
      json['childes'].forEach((v) {
        _subSubCategories!.add(SubSubCategory.fromJson(v));
      });
    }
    _totalProductCount = json['total_product_count'];
    _checked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['slug'] = _slug;
    data['icon'] = _icon;
    data['parent_id'] = _parentId;
    data['position'] = _position;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    if (_subSubCategories != null) {
      data['childes'] = _subSubCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubSubCategory {
  int? _id;
  String? _name;
  String? _slug;
  String? _icon;
  int? _parentId;
  int? _position;
  String? _createdAt;
  String? _updatedAt;
  bool? _checked;
  int? _totalProductCount;

  SubSubCategory(
    {int? id,
      String? name,
      String? slug,
      String? icon,
      int? parentId,
      int? position,
      String? createdAt,
      String? updatedAt,
      bool checked = false,
      int? totalProductCount,
    }) {
    _id = id;
    _name = name;
    _slug = slug;
    _icon = icon;
    _parentId = parentId;
    _position = position;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _checked = checked;
    _totalProductCount = totalProductCount;
  }

  int? get id => _id;
  String? get name => _name;
  String? get slug => _slug;
  String? get icon => _icon;
  int? get parentId => _parentId;
  int? get position => _position;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  bool? get checked => _checked;
  int? get totalProductCount => _totalProductCount;
  void toggleChecked(){
    _checked = !_checked!;
  }


  SubSubCategory.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _icon = json['icon'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _totalProductCount = json['total_product_count'];
    _checked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['slug'] = _slug;
    data['icon'] = _icon;
    data['parent_id'] = _parentId;
    data['position'] = _position;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['total_product_count'] = _totalProductCount;
    return data;
  }
}
