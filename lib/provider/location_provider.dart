import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class LocationProvider with ChangeNotifier
{
  Location _location;
  Location get location => _location;
  LatLng _locationPosition;
  LatLng get locationPosition => _locationPosition;

  bool locationServiceActive = true;

  LocationProvider()
  {
    _location = new Location();
  }
  initalization() async
  {
 await getUserLocation();
  }
  getUserLocation() async
  {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();

    if(!_serviceEnabled )
    {
      _serviceEnabled = await location.requestService();
      if(!_serviceEnabled)
      {
        return;
      }
    }
    _permissionGranted= await location.hasPermission();
    if(_permissionGranted==PermissionStatus.denied)
    {
      _permissionGranted= await location.requestPermission();
      if(_permissionGranted !=PermissionStatus.granted)
      {
        return;
      }

    }
    location.onLocationChanged.listen((LocationData currentLocation) {
      _locationPosition=LatLng(currentLocation.latitude, currentLocation.longitude,);
      print(_locationPosition);
      notifyListeners();

    });

  }
}