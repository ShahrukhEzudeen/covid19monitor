import 'dart:async';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/screens/login.dart';
import 'package:flutter_covid_dashboard_ui/screens/navigation.dart';
class SplashScreen extends StatefulWidget{

  @override
  _SplashScreenState createState()=> _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState(){
    super.initState();
    tm();
  }
  tm() async {
    dynamic id = await SessionManager().get("IC");
    if(id.toString()==null){
      Timer(Duration(seconds: 3), ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>PagesNavigate())));
    }
    else{
      Timer(Duration(seconds: 3), ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>LoginScreen())));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xffffffff),Color(0xffffffff)],
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icon.png",
                height: 300,
                width: 300,
              ),
              const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );

  }

}