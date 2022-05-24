import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:http/http.dart'as http;


class Login_controler extends GetxController {
  
  bool ishidden = true;
  bool ishiddenreg = true;
  File? images;
  String? imageUrl;
  String? tokens;
  

  toogle(context) {
    ishidden = !ishidden;
    // FocusScope.of(context).unfocus();
  }

  toogleregistaion() {
    ishiddenreg = !ishiddenreg;
  }

  getimage(context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return  ;
      //  showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //         title: Text("Please upload image"),
      //       ));
    }

    images = File(image.path);
    update();
  }

  updloadfile() async {
    if (images == null) return;
    final filename = images!.path;
    final destination = 'files/$filename';
// final ref=FirebaseStorage.instance.ref(destination);
    try {
      Reference reference =
          FirebaseStorage.instance.ref().child('profileImage/${images!.path}');
      UploadTask uploadTask = reference.putFile(images!);
      TaskSnapshot snapshot = await uploadTask;
     String image1 = await snapshot.ref.getDownloadURL();
      return image1;
      update();
    } catch (e) {
      print('+++++++++++++++++++++++++++++++++++');
      print(e);
    }
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    gettoke();
  }
   void gettoke() async {
    await FirebaseMessaging.instance.getToken().then((token) {
    
        tokens=token;
        // print(tokens);
        
      
      print(token);
    });
  }
  
  sendpushnotification(String title,String name) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type':'application/json',
          'Authorization':'key=AAAAJaxb8Tg:APA91bFQIpuOhwvTKIh5V3lshWyB5kyFV5TmiWzlggAGhZ7Smd1xLQqwO3kGz3ID_0Gzf68Sf_vGsZxHCqQZm_1DZTz-JphvQANAJQZ9TenBsBzWU7panlazGuA1aelCO-PB3bhAS7At',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': title,
              'title':"Message from $name : ",
              
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to":"$tokens",
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }
   
 

}
