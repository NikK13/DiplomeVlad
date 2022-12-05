class StockItem{
  String? key;
  String? name;
  String? address;

  StockItem({this.key, this.name, this.address});

  factory StockItem.fromJson(String key, Map<String, dynamic> json){
    return StockItem(
      key: key,
      name: json['name'],
      address: json['address']
    );
  }

  Map<String, Object?> toJson() => {
    'name': name,
    'address': address
  };
}