import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


// This class handles the Page to dispaly the user's info on the "Edit Profile" Screen

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  @override
  Future<int> display() async {
    dynamic id = await SessionManager().get("IC");
    await Future.delayed(Duration(seconds: 2));
    return id;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<int>(
            future: display(),
            builder:(BuildContext context, AsyncSnapshot<int> asyncSnapshot){
              if (asyncSnapshot.hasData) {

                print("berjaya");
                return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('USER').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot = (snapshot.data.docs[index]);
                            if (documentSnapshot['IC'] == asyncSnapshot.data.toString()) {
                              return Column(
                                children: [
                                  AppBar(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    toolbarHeight: 10,
                                  ),
                                  Center(
                                      child: Padding(
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: Text(
                                            'Profile Anda',
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromRGBO(64, 105, 225, 1),
                                            ),
                                          ))),

                                  buildUserInfoDisplay(documentSnapshot['NAMA'], 'Nama'),
                                  buildUserInfoDisplay(documentSnapshot['IC'], 'IC'),
                                  buildUserInfoDisplay(documentSnapshot['UMUR'], 'Umur'),
                                  buildUserInfoDisplay(documentSnapshot['JANTINA'], 'Jantina'),
                                  buildUserInfoDisplay(documentSnapshot['NOTELEFON'], 'No Telefon'),
                                  buildUserInfoDisplay(documentSnapshot['ALAMAT'], 'Alamat'),
                                  buildUserInfoDisplay(documentSnapshot['POSTKOD'], 'Postkod'),
                                  buildUserInfoDisplay(documentSnapshot['NEGERI'], 'Negeri'),
                                  Container(
                                      height: 50,
                                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: ElevatedButton(
                                        child: const Text('Ubah Kata Laluan'),
                                        onPressed: () {
                                          bottomUsername(context,documentSnapshot.id);
                                        },
                                      )
                                  ),
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
    );
  }


  void bottomUsername(BuildContext e,medID){
    final TextEditingController _dateController = TextEditingController();
    showModalBottomSheet(
        isScrollControlled:true,
        context: e,
        builder: (e) => Padding
          (padding: EdgeInsets.only(
            top:15,
            left:15,
            right:15,
            bottom: MediaQuery.of(e).viewInsets.bottom +15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _dateController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Kata laluan baru",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(onPressed: () {
                userUpdatePhone(_dateController.text,medID);
                Fluttertoast.showToast(msg:"Successful");
                Navigator.pop(context);
              }, child: const Text('Submit'))
            ],
          ),
        )
    );
  }
  Future userUpdatePhone(String date, String userID) async{

    final CollectionReference profile = FirebaseFirestore.instance.collection('USER');

    return await profile.doc(userID).update({'PASSWORD':date}  );
  }
}
  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String getValue, String title) =>
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ))),
                  child: Row(children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {

                            },
                            child: Text(
                              getValue,
                              style: TextStyle(fontSize: 16, height: 1.4),
                            ))),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                      size: 10.0,
                    )
                  ]))
            ],
          ));



