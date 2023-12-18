import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  final String apiKey = 'AIzaSyAyvsDEmlta0a8fNv2eMyQJyGeSbLWTXwU';

  Future<String> getPlaceId(String address) async {
    String encodedAddress = Uri.encodeQueryComponent(address);
    String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$encodedAddress&key=$apiKey';

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'OK') {
          print(data['results'][0]['place_id']);
          return data['results'][0]['place_id'];
        } else {
          throw Exception('Failed to get place ID');
        }
      } else {
        throw Exception('Failed to connect to the server');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> getPlace(String address) async {
    final placeId = await getPlaceId(address);

    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'OK') {
          print(data['results']);
          return data['results'];
        } else {
          throw Exception('Failed to get place ID');
        }
      } else {
        throw Exception('Failed to connect to the server');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
