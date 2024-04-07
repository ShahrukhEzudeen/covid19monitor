
import 'dart:async';
import 'package:flutter_covid_dashboard_ui/provider/geofence.dart';
import 'package:flutter_covid_dashboard_ui/provider/enums/geofancestatus.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_covid_dashboard_ui/provider/notificationservice.dart';

import 'geofence.dart';

class eng
{

  void initState(){
    tz.initializeTimeZones();
  }
  EasyGeofencing bb = new EasyGeofencing();
  ana(String latitude,String longtitude)async{
   // EasyGeofencing.startGeofenceService(
   //      pointedLatitude: latitude,
   //      pointedLongitude: longtitude,
   //      radiusMeter: "6",
   //      eventPeriodInSeconds: 5
   //  );
   //  StreamSubscription<GeofenceStatus> geofenceStatusStream = EasyGeofencing.getGeofenceStream().listen(
   //          (GeofenceStatus status) {
   //        print(status.toString());
   //        noti(status.toString());
   //        // NotificationService().showNotification(1, "AWAS ADA COVID DEKAT", "JAGA DIRI LAH OI", 5);
   //      });
  }
  noti(String G)
  {
    if(G=="GeofenceStatus.enter")
    {
      NotificationService().showNotification(1, "AWAS TERDAPAT PENYAKIT BERJANKIT BERDEKATAN DGN ANDA", "SILA JAGA DIRI", 3);

    }
  }
}