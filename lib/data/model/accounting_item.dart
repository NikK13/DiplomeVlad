class AccountingItem{
  String? key;
  String? date;
  String? stockKey;
  String? materialKey;
  String? employeeKey;
  int? count;

  AccountingItem({
    this.key,
    this.stockKey,
    this.materialKey,
    this.employeeKey,
    this.count,
    this.date,
  });

  factory AccountingItem.fromJson(String key, Map<String, dynamic> json){
    return AccountingItem(
      key: key,
      stockKey: json['stock_id'],
      materialKey: json['material_id'],
      employeeKey: json['employee_id'],
      date: json['date'],
      count: json['count'],
    );
  }

  Map<String, Object?> toJson() => {
    'stock_id': stockKey,
    'material_id': materialKey,
    'employee_id': employeeKey,
    'date': date,
    'count': count
  };
}