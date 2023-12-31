import 'package:flutter/material.dart';
import 'package:grab/data/model/search_place_model.dart';

class AppState extends ChangeNotifier {
  late SearchPlaceModel _pickupAddress;
  late SearchPlaceModel _destinationAddress;
  AppState() {}

  SearchPlaceModel get pickupAddress => _pickupAddress;
  SearchPlaceModel get destinationAddress => _destinationAddress;

  void setPickupAddress(SearchPlaceModel address) {
    _pickupAddress = address;
    notifyListeners();
  }

  void setDestinationAddress(SearchPlaceModel address) {
    _destinationAddress = address;
    notifyListeners();
  }
}
