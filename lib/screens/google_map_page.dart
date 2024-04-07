import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/provider/location_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_covid_dashboard_ui/provider/geofence.dart';
import 'package:flutter_covid_dashboard_ui/provider/notificationservice.dart';
import 'package:flutter_covid_dashboard_ui/provider/enginegeofance.dart';
import 'package:flutter_covid_dashboard_ui/provider/enums/geofancestatus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:search_map_location/search_map_location.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_maps_webservice/places.dart';


class GoogleMapPage extends StatefulWidget {


  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  TextEditingController latitudeController = new TextEditingController();
  TextEditingController longitudeController = new TextEditingController();
  TextEditingController radiusController = new TextEditingController();
  StreamSubscription<GeofenceStatus> geofenceStatusStream;
  Geolocator geolocator = Geolocator();
  String geofenceStatus = '';
  bool isReady = false;
  Position position;
  GoogleMapController _controller;
  int _countOfReload = 0;
  static const kGoogleApiKey = "AIzaSyBhLMrG1Aq3yAc2m-LkLRRjPkitYHqjMc8";

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  @override


  void initState(){
    super.initState();
    tz.initializeTimeZones();
    Provider.of<LocationProvider>(context,listen:false).initalization();

  }










  Map<MarkerId , Marker> markers = <MarkerId , Marker>{};

  getMarkerData() async {
    dynamic id = await SessionManager().get("IC");
    FirebaseFirestore.instance.collection('location').where('IC', isNotEqualTo:id.toString()).get().then((myMarkers) {
      if(myMarkers.docs.isNotEmpty) {
        for(int i = 0; i < myMarkers.docs.length ; i++){
          var markerIdVal = myMarkers.docs[i].id;
          final MarkerId markerId = MarkerId(markerIdVal);
          final Marker marker = Marker(
            markerId: markerId,
            position: LatLng(myMarkers.docs[i]['latitude'] , myMarkers.docs[i]['longitude']),
            infoWindow: InfoWindow(title: 'PENYAKIT BERJANGKIT' , snippet: myMarkers.docs[i]['STATUS']),

          );
          setState(() {
            markers[markerId] = marker;
          });
        }
      }
    });
  }



  noti(String G)
  {
    if(G=="GeofenceStatus.enter")
    {
      NotificationService().showNotification(1, "AWAS TERDAPAT PENYAKIT BERJANKIT BERDEKATAN DGN ANDA", "SILA JAGA DIRI", 3);

    }



  }
  getCurrentPosition() async {
    dynamic id = await SessionManager().get("IC");
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("LOCATION => ${position.toJson()}");
    isReady = (position != null) ? true : false;
    // EasyGeofencing bb = new EasyGeofencing();
    // List<EasyGeofencing> b;
    FirebaseFirestore.instance.collection('location').where('IC', isNotEqualTo:id.toString()).get().then((myMarkers) async{
      for(int i = 0; i < myMarkers.docs.length ; i++){
          //
          //  bb.startGeofenceService(
          //     pointedLatitude: "${myMarkers.docs[i]['latitude']}",
          //     pointedLongitude: "${myMarkers.docs[i]['longitude']}",
          //     radiusMeter: "6",
          //     eventPeriodInSeconds: 5
          // );
          //  b[i]= bb;
      }
      // for(int j = 0; j < myMarkers.docs.length ; j++) {
      //   StreamSubscription<GeofenceStatus> geofenceStatusStream = b[j].getGeofenceStream().listen(
      //           (GeofenceStatus status) {
      //         print(status.toString());
      //         noti(status.toString());
      //         // NotificationService().showNotification(1, "AWAS ADA COVID DEKAT", "JAGA DIRI LAH OI", 5);
      //       });
      // }
    });

  }

  setLocation() async {
    await getCurrentPosition();
    print("POSITION => ${position.toJson()}");
    // latitudeController =
    //     TextEditingController(text: position.latitude.toString());
    // longitudeController =
    //     TextEditingController(text: position.longitude.toString());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hotspot Checker"),
        backgroundColor: Palette.primaryColor,
      ),
      body: Consumer<LocationProvider>(
          builder:(consumerContext,model,child){
            if(model.locationPosition != null)
            {


              return  Column(

                children: [SearchLocation(
                apiKey: "AIzaSyBhLMrG1Aq3yAc2m-LkLRRjPkitYHqjMc8",
                // The language of the autocompletion
                language: 'en',
                //Search only work for this specific country
                country: 'MY',
                onSelected: (Place place) async {
                  displayPrediction(place);
                },
              ),


                  Expanded(

                    child: GoogleMap(

                      mapType:MapType.normal,
                      initialCameraPosition: CameraPosition(

                        target: model.locationPosition,
                        zoom: 18,

                      ),


                      markers: Set<Marker>.of(markers.values),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: (GoogleMapController controller)async{
                        setState(() {
                          _controller=controller;
                          getMarkerData();
                          getCurrentPosition();
                        });
                      },

                    ),

                  ),


                ],

              );

            }
            return Container(

              child: Center(child: CircularProgressIndicator(),),

            );


          }

      ),

    );

  }
  Future<Null> displayPrediction(Place place) async {
    if (place != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(place.placeId);
      var placeId = place.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      print(lat);
      print(lng);
      await _controller
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(lat,lng),
          zoom: 18)));
    }
    else{
      print("error");
    }
  }
}



// Widget googleMapUI(){
//   EasyGeofencing.startGeofenceService(
//       pointedLatitude: "2.206011",
//       pointedLongitude: "102.2244013",
//       radiusMeter: "400",
//       eventPeriodInSeconds: 5
//
//   );
//
//   Set<Circle> mycircles = Set.from([Circle(
//     circleId: CircleId('0'),
//     center: LatLng(2.2060488, 102.2244857),
//     radius: 10,
//     strokeWidth: 1,
//     fillColor:(Colors.red),
//   ),
//     Circle(
//       circleId: CircleId('1'),
//       center: LatLng(2.2065488, 102.2244857),
//       radius: 10,
//       strokeWidth: 1,
//       fillColor:(Colors.yellow),
//     )]);
//   return
//
// }

