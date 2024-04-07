import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_covid_dashboard_ui/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_covid_dashboard_ui/screens/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) :super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var category = ['MELAKA','JOHOR','PAHANG','TERENGGANU','KEDAH',"KELANTAN",'KUALA LUMPUR','LABUAN','NEGERI SEMBILAN','PAHANG','PULAU PINANG','PERAK','PERLIS','PUTRAJAYA','SELANGOR','SABAH','SARAWAK'];
  String dropdownvalue = 'MELAKA';
  var category2 = ['LELAKI','PEREMPUAN'];
  String dropdownvalue2 = 'LELAKI';
  //form key
  final _formKey = GlobalKey<FormState>();

  //edit controlller
  final nameEditController = new TextEditingController();
  final identityCardEditController = new TextEditingController();
  final addressEditController = new TextEditingController();
  final phoneEditController = new TextEditingController();
  final passwordEditController = new TextEditingController();
  final genderController = new TextEditingController();
  final stateController = new TextEditingController();
  final postcodeController = new TextEditingController();
  final ageController = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    //name field
    final namelField = TextFormField(
        autofocus: false,
        controller: nameEditController,
        keyboardType: TextInputType.name,

        //validator
        validator: (value){
          RegExp regex = new RegExp (r'^.{3,}$');
          if(value.isEmpty)
          {
            return ("FORM TIDAK BOLEH KOSONG");
          }
          if(!regex.hasMatch(value))
          {
            return ("SILA MASUK NAMA DENGAN BETUL");
          }
          return null;
        },

        onSaved: (value){
          nameEditController.text= value;

        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration
          (
          prefixIcon: Icon (Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),

          hintText: "Nama",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //ic field
    final iclField = TextFormField(
        autofocus: false,
        controller: identityCardEditController,
        keyboardType: TextInputType.number,

        //validator
        validator: (value)
        {
          if(value.isEmpty){
            return ("SILA MASUK KAN NO IC ANDA");
          }
          //reg expression for email
          if(!RegExp(r'^.{12,12}$').hasMatch(value))
          {
            return ("SILA MASUKAN IC DENGAN BETUL");
          }
          return null;
        },

        onSaved: (value){
          identityCardEditController.text= value;

        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration
          (
          prefixIcon: Icon (Icons.badge),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "IC No: XXXXXXXXXXXX",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //phone field
    final phonelField = TextFormField(
        autofocus: false,
        controller: phoneEditController,
        keyboardType: TextInputType.phone,

        //validator
        validator: (value)
        {
          if(value.isEmpty){
            return ("SILA MASUK KAN NO TELEFON");
          }
          if(!RegExp(r'^.{8,11}$').hasMatch(value))
          {
            return ("SILA MASUKAN No TELEFON DENGAN BETUL");
          }

          return null;
        },

        onSaved: (value){
          phoneEditController.text= value;

        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration
          (
          prefixIcon: Icon (Icons.phone),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "NO TELEFON TANPA(-)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final ageField = TextFormField(
        autofocus: false,
        controller: ageController,
        keyboardType: TextInputType.phone,

        //validator
        validator: (value)
        {
          if(value.isEmpty){
            return ("SILA MASUK UMUR");
          }
          if(!RegExp(r'^.{2,3}$').hasMatch(value))
          {
            return ("SILA MASUKAN UMUR DENGAN BETUL");
          }
          return null;
        },

        onSaved: (value){
          ageController.text= value;

        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration
          (
          prefixIcon: Icon (Icons.supervised_user_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "UMUR",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final genderField= DropdownButtonFormField(
        decoration: const InputDecoration(
          labelText: "JANTINA",
          border: OutlineInputBorder(),
        ),
        value: dropdownvalue2,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        items: category2.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        onChanged: (String newValue) {
          setState(() {
            dropdownvalue2 = newValue;
          });
        }
    );
    final addressField = TextFormField(
        autofocus: false,
        controller: addressEditController,
        keyboardType: TextInputType.name,

        //validator
        validator: (value){
          RegExp regex = new RegExp (r'^.{3,}$');
          if(value.isEmpty)
          {
            return ("TIDAK BOLEH KOSONG");
          }
          if(!regex.hasMatch(value))
          {
            return ("SILA MASUK ALAMAT DENGAN BETUL");
          }
          return null;
        },

        onSaved: (value){
          addressEditController.text= value;

        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration
          (
          prefixIcon: Icon (Icons.ac_unit),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),

          hintText: "ALAMAT",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final poskodField = TextFormField(
        autofocus: false,
        controller: postcodeController,
        keyboardType: TextInputType.phone,

        //validator
        validator: (value)
        {
          if(value.isEmpty){
            return ("SILA MASUK POSKOD");
          }
          if(!RegExp(r'^.{5,5}$').hasMatch(value))
          {
            return ("SILA MASUKAN POSKOD DENGAN BETUL");
          }
          return null;
        },

        onSaved: (value){
          postcodeController.text= value;

        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration
          (
          prefixIcon: Icon (Icons.maps_home_work_outlined ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Poskod",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final stateField = DropdownButtonFormField(
        decoration: const InputDecoration(
          labelText: "NEGERI",
          border: OutlineInputBorder(),
        ),
        value: dropdownvalue,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        items: category.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        onChanged: (String newValue) {
          setState(() {
            dropdownvalue = newValue;
          });
        }
    );


    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditController,
        obscureText: true,

        //validator
        validator: (value){
          RegExp regex = new RegExp (r'^.{6,}$');
          if(value.isEmpty)
          {
            return ("Password is required for login");
          }
          if(!regex.hasMatch(value))
          {
            return ("Please enter a valid password (Min. 6 Character)");
          }
        },

        onSaved: (value)
        {
          passwordEditController.text= value;

        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration
          (
          prefixIcon: Icon (Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "KATA LALUAN",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));


    //signup button
    final registerButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
        singup(nameEditController.text, identityCardEditController.text ,addressEditController.text, dropdownvalue2, dropdownvalue, phoneEditController.text, postcodeController.text, ageController.text, passwordEditController.text);
          },
          child: Text(
            "DAFTAR",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,

      //app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
      ),

      //body
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
                    namelField,
                    SizedBox(height: 20),

                    iclField,
                    SizedBox(height: 20),

                    ageField,
                    SizedBox(height: 20),

                    phonelField,
                    SizedBox(height: 20),

                    genderField,
                    SizedBox(height: 20),

                    addressField,
                    SizedBox(height: 20),

                    poskodField,
                    SizedBox(height: 20),

                    stateField,
                    SizedBox(height: 20),

                    passwordField,
                    SizedBox(height: 20),

                    // userTypelField,
                    // SizedBox(height: 20),

                    registerButton,
                    SizedBox(height: 15,),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  singup(String name,String IC,String address,String gender,String stae,String phone,String postc,String age,String pass){

    if(_formKey.currentState.validate()) {
      FirebaseFirestore.instance.collection('USER').doc().set({
        'IC':IC,
        'NAMA':name,
        'JANTINA':gender,
        'STATUS':"RISIKO RENDAH",
        'UMUR':age,
        'NOTELEFON':phone,
        'ALAMAT':address,
        'POSTKOD':postc,
        'NEGERI': stae,
        'PASSWORD':pass,
      }, SetOptions(merge: true));
      Fluttertoast.showToast(msg: "DATA BERJAYA DI SIMPAN");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
