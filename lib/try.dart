import "package:http/http.dart" as http;

void main() async {
  var url = Uri.parse('https://bycicle.herokuapp.com/delete_station');
  var response = await http.delete(url, headers: {"username": "sta1"});
  print(response.body);
}
