import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/provider/location_provider.dart';
import 'package:flutter_covid_dashboard_ui/screens/google_map_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_covid_dashboard_ui/screens/splashscreen.dart';
Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(
          create:(context)=>LocationProvider(),
          child:GoogleMapPage(),
        )
      ],
      child: MaterialApp(
      title: 'Flutter Covid-19 Dashboard UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:SplashScreen() ,
      ),);
  }
}
