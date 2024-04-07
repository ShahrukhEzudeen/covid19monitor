import 'dart:async';
import "package:flutter/material.dart";
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/widgets/widgets.dart';
import 'package:flutter_covid_dashboard_ui/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_covid_dashboard_ui/provider/notificationservice.dart';
import 'package:location/location.dart' as loc;
import 'package:timezone/data/latest.dart' as tz;
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;
  final Strategy strategy = Strategy.P2P_STAR;
  Future<int> display() async {
    dynamic id = await SessionManager().get("IC");
    await Future.delayed(Duration(seconds: 2));
    return id;
  }
  void initState(){
    _requestPermission();
    tz.initializeTimeZones();
    super.initState();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);

  }

  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  _deleteUser(BuildContext context) async{
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
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


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Palette.primaryColor,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.login_rounded),
            iconSize: 28.0,
            onPressed: () {
              _deleteUser(context);
            },
          ),
        ],
      ),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
                height: 180,
                width: 50,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
                child:FutureBuilder<int>(
                    future: display(),
                    builder:(BuildContext context, AsyncSnapshot<int> asyncSnapshot){
                      if (asyncSnapshot.hasData) {
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('USER').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    final DocumentSnapshot documentSnapshot = (snapshot.data.docs[index]);
                                    if (documentSnapshot['IC'] == asyncSnapshot.data.toString()&&documentSnapshot['STATUS'] =="TUBERCULOSIS(TB)") {
                                      _listenLocation2(documentSnapshot['IC'],documentSnapshot['STATUS']);
                                      _getLocation2(documentSnapshot['IC'],documentSnapshot['STATUS']);
                                      _neaby(documentSnapshot['STATUS']);
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                '${documentSnapshot['NAMA']}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),


                                            ],

                                          ),
                                          SizedBox(height: screenHeight * 0.03),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${documentSnapshot['IC']}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                '${documentSnapshot['STATUS']}',
                                                style: const TextStyle(
                                                  color: Colors.yellow,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: screenHeight * 0.01),
                                              Text(
                                                'SILA AMALKAN SOP',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              SizedBox(height: screenHeight * 0.03),

                                            ],
                                          )
                                        ],
                                      );



                                    }else if(documentSnapshot['IC'] == asyncSnapshot.data.toString()&&documentSnapshot['STATUS'] =="RISIKO RENDAH")
                                    {

                                      discovery();
                                      _locationSubscription?.cancel();
                                        _locationSubscription = null;

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                '${documentSnapshot['NAMA']}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),


                                            ],

                                          ),
                                          SizedBox(height: screenHeight * 0.03),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${documentSnapshot['IC']}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                '${documentSnapshot['STATUS']}',
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: screenHeight * 0.01),
                                              Text(
                                                'SILA AMALKAN SOP',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              SizedBox(height: screenHeight * 0.03),

                                            ],
                                          )
                                        ],
                                      );

                                    }
                                    else if(documentSnapshot['IC'] == asyncSnapshot.data.toString()&&(documentSnapshot['STATUS'] =="POSITIF COVID19")){
                                      _listenLocation(documentSnapshot['IC'],documentSnapshot['STATUS']);
                                      _getLocation(documentSnapshot['IC'],documentSnapshot['STATUS']);
                                      _neaby(documentSnapshot['STATUS']);
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                '${documentSnapshot['NAMA']}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),


                                            ],

                                          ),
                                          SizedBox(height: screenHeight * 0.03),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${documentSnapshot['IC']}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                '${documentSnapshot['STATUS']}',
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: screenHeight * 0.01),
                                              Text(
                                                'SILA AMALKAN SOP',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              SizedBox(height: screenHeight * 0.03),

                                            ],
                                          )
                                        ],
                                      );
                                    }
                                    return const Center();
                                  }
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                      }
                      else if(asyncSnapshot.hasError){
                        print(asyncSnapshot.error);
                      }
                      return const Center(
                        child: CircularProgressIndicator(),

                      );
                    }
                )
            ),

          ),
          SliverToBoxAdapter(
            child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                padding: const EdgeInsets.all(10.0),
                height: screenHeight * 0.15,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFAD9FE4), Palette.primaryColor],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: FutureBuilder<int>(
                    future: display(),
                    builder:(BuildContext context, AsyncSnapshot<int> asyncSnapshot){
                      if (asyncSnapshot.hasData) {
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('USER').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    final DocumentSnapshot documentSnapshot = (snapshot.data.docs[index]);
                                    if (documentSnapshot['IC'] == asyncSnapshot.data.toString()) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[

                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Sentiasa Jaga Jarak',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: screenHeight * 0.01),
                                              Text(
                                                'Sila Pergi Ke Hospital Atau Klinik \n Jika Tidak Sihat',
                                                style: const TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 16.0,
                                                ),
                                                maxLines: 2,
                                              ),

                                            ],
                                          )
                                        ],
                                      );
                                    }
                                    return const Center();
                                  }
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                      }
                      else if(asyncSnapshot.hasError){
                        print(asyncSnapshot.error);
                      }
                      return const Center(
                        child: CircularProgressIndicator(),

                      );
                    }
                )
            ),
          ),
        ],
      ),
    );
  }
  _getLocation(String i,String s) async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc('${i}').set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'IC':i,
        'STATUS': s
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation(String i,String s) async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc('${i}').set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'IC':i,
        'STATUS': s
      }, SetOptions(merge: true));
    });
  }

  _getLocation2(String i,String s) async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc('${i}').set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'IC':i,
        'STATUS': s
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation2(String i,String s) async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc('${i}').set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'IC':i,
        'STATUS': s
      }, SetOptions(merge: true));
    });
  }

  _neaby(String s) async {
    dynamic id = await SessionManager().get("IC");
    final userName=s;
    try {
      bool a = await Nearby().startAdvertising(
        userName,
        strategy,
        onConnectionInitiated: null,
        onConnectionResult: (id, status) {
          print(status);
        },
        onDisconnected: (id) {
          print('Disconnected $id');
        },
      );

      print('ADVERTISING ${a.toString()}');
    } catch (e) {
      print(e);
    }
    Nearby().stopDiscovery();
  }
  void discovery() async {
    try {
      dynamic idss = await SessionManager().get("IC");
      final Strategy strategy = Strategy.P2P_STAR;
      final userName= idss.toString();
      bool a = await Nearby().startDiscovery(userName, strategy,
          onEndpointFound: (id, name, serviceId) async {
            NotificationService().showNotification(1, "AWAS TERDAPAT PENYAKIT BERJANKIT BERDEKATAN DGN ANDA", "$name", 3);
            await FirebaseFirestore.instance.collection('TRACING').doc('${id.toString()}').set({
              'IC':idss.toString(),
              'PENYAKIT': name,
              'MASA': DateTime.now(),
            });
            ; // the name here is an email

          }, onEndpointLost: (id) {
            print(id);
          });
      print('DISCOVERING: ${a.toString()}');
    } catch (e) {
      print(e);
    }
    Nearby().stopAdvertising();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.bluetooth
    ].request();
    print(statuses[Permission.location]);
    if (statuses.isNotEmpty) {
      print('done');
    } else if (statuses.isEmpty) {
      _requestPermission();
    }

  }

}
