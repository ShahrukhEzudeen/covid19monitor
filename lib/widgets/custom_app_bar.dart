import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_covid_dashboard_ui/screens/login.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:nearby_connections/nearby_connections.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;
  @override

  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.primaryColor,
      elevation: 0.0,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.login_rounded),
          iconSize: 28.0,
          onPressed: () {
            deleteUser(context);
          },
        ),
      ],
    );

  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  deleteUser(BuildContext context) async{
    _locationSubscription?.cancel();
      _locationSubscription = null;
    dynamic id = await SessionManager().get("IC");
    FirebaseFirestore.instance.collection('location').doc(id.toString()).delete().then(
            (doc) async => {
    await SessionManager().destroy(),
              Nearby().stopAdvertising(),
        Nearby().stopDiscovery(),
    Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => LoginScreen())),}
    );

  }

}


