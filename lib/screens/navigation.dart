
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_covid_dashboard_ui/screens/screens.dart';
import 'package:flutter_covid_dashboard_ui/screens/google_map_page.dart';
import 'package:flutter_covid_dashboard_ui/screens/profile.dart';



class PagesNavigate extends StatefulWidget {
  const PagesNavigate({Key key}) : super(key: key);

  @override
  _PagesNavigate createState() => _PagesNavigate();
}

class _PagesNavigate extends State<PagesNavigate> {

  // late StreamSubscription<GeofenceStatus> geofenceStatusStream;
  // Geolocator geolocator = Geolocator();
  // String geofenceStatus = '';
  // bool isReady = false;
  // late Position position;

  final List _options=[
    HomeScreen(),GoogleMapPage(),ProfilePage(),
  ];
  int _currentIndex=0;

  static const IconData map = IconData(0xe3c8, fontFamily: 'MaterialIcons');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: (_options[_currentIndex])),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue,
        height: 55.0,
        buttonBackgroundColor: Colors.blueAccent,
        backgroundColor: Colors.white,
        animationCurve: Curves.bounceOut,
        items: const <Widget>[
          Icon(FlutterIcons.home_outline_mco,color: Colors.white, size: 25),
          Icon(map,color: Colors.white, size: 25),
          Icon(FlutterIcons.account_outline_mco,color: Colors.white, size: 25),
        ],
        onTap: (index){
          setState(() {
            _currentIndex=index;
          });
        },
      ),
    );
  }
}