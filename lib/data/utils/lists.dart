
class ListItem{
  String title;
  String value;

  ListItem(this.title, this.value);
}

List<ListItem> get languages => List.from([
  ListItem("English", 'en'),
  ListItem("Русский", 'ru'),
]);

List<ListItem> get destinations => List.from([
  ListItem("Minsk", 'minsk'),
  ListItem("Moscow", 'moscow'),
  ListItem("St.Petersburg", 'st.petersburg'),
  ListItem("Riga", 'riga'),
  ListItem("Vilnius", 'vilnius'),
  ListItem("Antalya", 'antalya'),
  ListItem("Kyiv", 'kyiv'),
  ListItem("Madrid", 'madrid'),
  ListItem("Warsaw", 'warsaw'),
  ListItem("Berlin", 'berlin'),
  ListItem("Milan", 'milan'),
  ListItem("Paris", 'paris'),
]);