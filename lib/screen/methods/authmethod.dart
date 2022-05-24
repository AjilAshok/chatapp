import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

Future createAccount(
    String name, String email, String password, BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    User? user = (await auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
     
      // await FirebaseFirestore.instance
      //     .collection("User")
      //     .doc(auth.currentUser!.uid)
      //     .set({"name": name, "email": email}).then((value) {
      //   print("valuesadd");
      // });
      return user;
    } else {
      print("Sucflus");
      return user!;
    }
  } on FirebaseAuthException catch (e) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(e.code),
            ));
  }
}

Future login(String email, String password, BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    User? user = (await auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("logib suceful");

      return user;
    } else {
      print("lognot");
      return user;
    }
  } on FirebaseAuthException catch (e) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(e.code),
            ));
  }
}

Future logout() async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    auth.signOut();
  } on FirebaseAuthException catch (e) {
    return;
  }
}
createchatroom(String chatRoomId,ChatroomMap){
  FirebaseFirestore.instance.collection("Chatroom").doc(chatRoomId).set(ChatroomMap).catchError((e){
    print(e);
  });

}