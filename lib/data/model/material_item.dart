class MaterialItem{
  String? key;
  String? name;
  String? type;
  String? desc;
  String? vendor;
  int? allCount;
  int? leftCount;
  double? pricePerItem;

  MaterialItem({
    this.key,
    this.name,
    this.desc,
    this.type,
    this.vendor,
    this.allCount,
    this.leftCount,
    this.pricePerItem
  });

  factory MaterialItem.fromJson(String key, Map<String, dynamic> json){
    return MaterialItem(
      key: key,
      name: json['name'],
      desc: json['desc'],
      type: json['type'],
      vendor: json['vendor'],
      allCount: json['all_count'],
      leftCount: json['left_count'],
      pricePerItem: json['price']
    );
  }

  Map<String, Object?> toJson() => {
    'name': name,
    'desc': desc,
    'type': type,
    'vendor': vendor,
    'all_count': allCount,
    'price': pricePerItem
  };
}