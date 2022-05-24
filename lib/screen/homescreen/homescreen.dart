import 'dart:convert';

import 'package:chatapp/screen/chatpage/chatpage.dart';
import 'package:chatapp/screen/loginform/loginform.dart';
import 'package:chatapp/screen/methods/authmethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Homescreem extends StatefulWidget {
  Homescreem({Key? key}) : super(key: key);

  @override
  State<Homescreem> createState() => _HomescreemState();
}

class _HomescreemState extends State<Homescreem> {
  final auth = FirebaseAuth.instance.currentUser!.uid;
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // String? tokens='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadfcm();
    listenfcm();
    // gettoke();
    // FirebaseMessaging.instance.subscribeToTopic("animal");
  }

 

 

  void listenfcm() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadfcm() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title

        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.indigo,
      appBar: appbar(context),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("User")
            .where("userid", isNotEqualTo: auth)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Chats",
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 5,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              print(snapshot.data!.docs.length);
              // final name=snapshot.data!.docs[index];
              var firendid = snapshot.data!.docs[index].id;
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("User")
                    .doc(firendid)
                    .get(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    var friend = snapshot.data;
                     
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Ink(
                        color: Colors.white,
                        child: ListTile(
                          focusColor: Colors.white,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chatpage(
                                    name: friend['name'],
                                    reviceverid: friend['userid'],
                                  ),
                                ));
                          },
                          leading: CircleAvatar(
                              backgroundImage: friend['imageUrl'] == null
                                  ? NetworkImage(
                                      "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                                    )
                                  : NetworkImage(friend['imageUrl'])),
                          title: Text(friend['name'],
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ),
                    );
                  }
                  return LinearProgressIndicator();
                },
              );
            },
          );
        },
      ),
    ));
  }

  appbar(context) {
    return AppBar(
      actions: [
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Are you sure"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                logout().then((value) {
                                  if (value == null) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Login_page(),
                                        ),
                                        (route) => false);
                                  }
                                });
                              },
                              child: Text("Yes",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.purple))),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.purple)))
                        ],
                      ));
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            )),
        // IconButton(onPressed: ()async{
        //   final x =await FirebaseFirestore.instance.collection("User").get();
        //   print(x.docs.length);
         
        // }, icon:Icon(Icons.abc))
      ],
      backgroundColor: Colors.purple,
      title: Text("Let's Chat",
          style: GoogleFonts.montserrat(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}
