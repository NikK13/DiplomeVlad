
class ListItem{
  String title;
  String value;

  ListItem(this.title, this.value);
}

List<ListItem> get languages => List.from([
  ListItem("English", 'en'),
  ListItem("Русский", 'ru'),
]);
