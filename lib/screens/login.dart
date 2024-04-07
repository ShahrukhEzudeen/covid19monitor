
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_covid_dashboard_ui/screens/navigation.dart';
import 'package:flutter_covid_dashboard_ui/screens/register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:nearby_connections/nearby_connections.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen ({Key key}) : super (key : key);

  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;
  FirebaseFirestore db = FirebaseFirestore.instance;
  //form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController icController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;
  @override
  void initState(){
    _requestPermission();
  }
  Widget build(BuildContext context) {

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: icController,
        keyboardType: TextInputType.emailAddress,

        //validator


        onSaved: (value){
          icController.text= value;

        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration
          (
          prefixIcon: Icon (Icons.credit_card),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "IC TANPA(-)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,

        //validator


        onSaved: (value)
        {
          passwordController.text= value;

        },

        textInputAction: TextInputAction.done,
        decoration: InputDecoration
          (
          prefixIcon: Icon (Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));


    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(icController.text, passwordController.text);
          },
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: Text ("Infectious Disease Cheacker", style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),), ),

                    SizedBox(height: 45),

                    emailField,
                    SizedBox(height: 25),

                    passwordField,
                    SizedBox(height: 35),

                    loginButton,
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        const Text('kali pertama daftar masuk?'),
                        TextButton(
                          child: const Text(
                            'Daftar Sekarang',
                            style: TextStyle(fontSize: 13),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => RegisterScreen()));
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),

                  ],
                ),

              ),

            ),

          ),
        ),

      ),
    );
  }

  void signIn (String ic, String password) async
  {
    FirebaseFirestore.instance.collection('USER').where('IC', isEqualTo:ic).where('PASSWORD', isEqualTo:password).snapshots().listen(
            (data) async {
          if(data.docs.isNotEmpty)
          {
            await SessionManager().set("IC", ic);
            Fluttertoast.showToast(msg: "Login Successful");
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => PagesNavigate()));
          }
          else
          {
            Fluttertoast.showToast(msg:"sila semak semula");
          }
        }

    );

  }

  _requestPermission() async {
    bool d = await Nearby().checkBluetoothPermission();
// asks for BLUETOOTH_ADVERTISE, BLUETOOTH_CONNECT, BLUETOOTH_SCAN permissions.
    Nearby().askBluetoothPermission();
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
