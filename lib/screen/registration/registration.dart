import 'package:chatapp/controller/logincontroller.dart';
import 'package:chatapp/screen/methods/authmethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';

import '../homescreen/homescreen.dart';

class Registrationpage extends StatelessWidget {
  Registrationpage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.indigo,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(25),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: Text(
                  """Welcome 
                    
                    Sign Up""",
                  style: GoogleFonts.montserrat(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              GetBuilder<Login_controler>(
                builder: (controller) => GestureDetector(
                  onTap: () {
                    controller.getimage(context);
                  },
                  child: controller.images == null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                          radius: 60,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(controller.images!),
                          radius: 60,
                        ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                // height: 40,
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),

                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  controller: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                  },
                  style: GoogleFonts.montserrat(color: Colors.black),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      hintText: "Enter the name",
                      hintStyle: TextStyle(color: Colors.black)),
                ),
                // Expanded(child: Icon(Icons.email))
              ),
              Container(
                // height: 40,
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),

                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  controller: email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                  },
                  style: GoogleFonts.montserrat(color: Colors.black),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.black)),
                ),
              ),
              Container(
                // height: 40,
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),

                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: GetBuilder<Login_controler>(
                  builder: (controller) => TextFormField(
                    controller: password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                    },
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.black),
                        border: InputBorder.none,
                        hintText: "Password",
                        suffixIcon: InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            controller.toogleregistaion();
                          },
                          child: Icon(
                            controller.ishiddenreg
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                        hintStyle: TextStyle(color: Colors.black)),
                    obscureText: controller.ishiddenreg,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 10, right: 10),
                child: GetBuilder<Login_controler>(
                  builder: (controller) => ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.purple[700]),
                      ),
                      onPressed: () async {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        if (_formKey.currentState!.validate()) {
                          
                          String imageUrl = await controller.updloadfile();
                        

                          createAccount(
                                  name.text, email.text, password.text, context)
                              .then((value) async {
                            if (value != null) {
                              await FirebaseFirestore.instance
                                  .collection("User")
                                  .doc(auth.currentUser!.uid)
                                  .set({
                                "name": name.text,
                                "email": email.text,
                                "userid": auth.currentUser!.uid,
                                'imageUrl': imageUrl,
                              }).then((value) {
                                print("valuesadd");
                              });

                              print("sux");
                              controller.images = null;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Homescreem(),
                                  ));
                            } else {
                              print("not");
                            }
                          });
                        }
                        //
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
