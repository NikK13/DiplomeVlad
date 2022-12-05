class VendorItem{
  String? key;
  String? name;

  VendorItem({this.key, this.name});

  factory VendorItem.fromJson(String key, Map<String, dynamic> json){
    return VendorItem(
      key: key,
      name: json['name'],
    );
  }

  Map<String, Object?> toJson() => {
    'name': name
  };
}