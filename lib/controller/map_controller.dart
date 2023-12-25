import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grab/data/mock/polyline.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:grab/utils/constants/key.dart';
import 'dart:io';

class MapController {
  Future<String> getPlaceId(String address) async {
    String encodedAddress = Uri.encodeQueryComponent(address);
    String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$encodedAddress&key=${MyKey.apiMapKey}';

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'OK') {
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
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${MyKey.apiMapKey}';

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return data['result']['geometry']['location'];
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

  Future<List<LatLng>> getPolylinePoints(
      LatLng _currentP, LatLng _destinationP) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        MyKey.apiMapKey,
        PointLatLng(_currentP!.latitude, _currentP!.longitude),
        PointLatLng(_destinationP.latitude, _destinationP.longitude),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(result.errorMessage);
      }
    } catch (e) {
      return PolylineMock.mockRoutePolyline;
    }
    writePolylineCoordinatesToFile(polylineCoordinates);
    return polylineCoordinates;
  }

  Future<Polyline> generatePolylineFromPoint(
      List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId('poly');
    return Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
  }
}

void writePolylineCoordinatesToFile(List<LatLng> polylineCoordinates) {
  File file = File('./file.txt');
  polylineCoordinates.forEach((element) {
    print(element);
  });
  String content = polylineCoordinates.toString();
  print(content);
  file
      .writeAsString(content)
      .then((value) => print('Polyline coordinates written to file'))
      .catchError(
          (error) => print('Failed to write polyline coordinates: $error'));
}
