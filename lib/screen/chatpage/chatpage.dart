

import 'dart:convert';

import 'package:chatapp/controller/logincontroller.dart';
import 'package:chatapp/widget/singlemessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'as http;

class Chatpage extends StatelessWidget {
  Chatpage({Key? key,required this.reviceverid,required this.name}) : super(key: key);
  TextEditingController send = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final auth=FirebaseAuth.instance.currentUser!.uid;
  var reviceverid;
  var name;

  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.indigo,
      appBar: appbar(context,name),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child:   GetBuilder<Login_controler>(
                builder: (controller) => 
                 Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("User").doc(auth).collection("messages").doc(reviceverid).collection("chats").orderBy("date",descending: true).snapshots(),
                    builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
              
                      
                      
                      if (snapshot.connectionState==ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        
                      }
                    
                        if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text("Say Hi"),
                          );
                          
                        }
                        return ListView.builder
                        (
                          itemCount: snapshot.data!.docs.length,
              
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                             controller.sendpushnotification("",name);
                            
                            
                            bool isme=snapshot.data!.docs[index]['senderid'] == auth;
                            return Single_message(message:snapshot.data!.docs[index]['message'] , isme: isme);
                          
                        },);
                        
                      
                      
                    }
                  )
                       
                        
                      ),
              ),
            //     child: ListView.builder(
            //   itemBuilder: (context, index) {
            //     return chatbubble(context);
            //   },
            //   itemCount: 5,
            ),
            
            sendmessage(context),
          ],
        ),
      ),
    ));
  }

  Container sendmessage(context) => Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: send,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some meassage';
                }
              },
              decoration: InputDecoration.collapsed(hintText: "Send meassage"),
            ),
          ),
          GetBuilder<Login_controler>(
            builder: (controller) => 
             IconButton(onPressed: ()async {
              if (_formKey.currentState!.validate()) {
                String message=send.text;
                send.clear();
               
                
                await  FirebaseFirestore.instance.collection("User").doc(auth).collection("messages").doc(reviceverid).collection("chats").add({
                  "senderid":auth,
                  "reciverid":reviceverid,
                  "message":message,
                  "date":DateTime.now()
                });
          
                  await  FirebaseFirestore.instance.collection("User").doc(reviceverid).collection("messages").doc(auth).collection("chats").add({
                  "senderid":auth,
                  "reciverid":reviceverid,
                  "message":message,
                  "date":DateTime.now()
                });
                
             
                
              }
             
             
             
            }, icon: Icon(Icons.send)),
          )
        ],
      ));


  Column chatbubble(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.80,
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.purple, spreadRadius: 2, blurRadius: 5)
                ]),
            child: Text(
                "dfslhhhhhgk;ghdsgdh;gdlgdh;gdhlghghghgjkhgjhkgdsjkhjkhgdhjkgdkhjgkhjggdsghkjgkhjdksjhgkjsgdata"),
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.80,
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.purple, spreadRadius: 2, blurRadius: 5)
                ]),
            child: Text(
                "dfslhhhhhgk;ghdsgdh;gdlgdh;gdhlghghghgjkhgjhkgdsjkhjkhgdhjkgdkhjgkhjggdsghkjgkhjdksjhgkjsgdata"),
          ),
        ),
        
      ],
    );
  }
   
     
  

  appbar(context,name) {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios)),
      backgroundColor: Colors.purple,
      title: Text(name,
          style: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

}
