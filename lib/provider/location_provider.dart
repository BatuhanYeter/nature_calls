import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  late Location _location;

  Location get location => _location;
  LatLng? _locationPosition;

  LatLng get locationPosition => _locationPosition!;

  bool locationServiceActive = true;

  LocationProvider() {
    _location = new Location();
  }

  initialization() async {
    await getUserLocation();
  }

  getUserLocation() async {
    // TODO: SharedPreferences -> set/get the service
    bool _serviceEnabled = false;
    PermissionStatus _permissionGranted;
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      _locationPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
    });

    print("Currrent location: {$_locationPosition}" );
    notifyListeners();
  }
}