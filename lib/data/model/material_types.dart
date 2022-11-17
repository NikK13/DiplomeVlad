class MaterialsTypes{
  String? key;
  String? name;

  MaterialsTypes({this.key, this.name});

  factory MaterialsTypes.fromJson(String key, Map<String, dynamic> json){
    return MaterialsTypes(
      key: key,
      name: json['name'],
    );
  }

  Map<String, Object?> toJson() => {
    'name': name
  };
}