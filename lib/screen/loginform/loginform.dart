import 'package:chatapp/controller/logincontroller.dart';
import 'package:chatapp/screen/homescreen/homescreen.dart';
import 'package:chatapp/screen/methods/authmethod.dart';
import 'package:chatapp/screen/registration/registration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';

class Login_page extends StatelessWidget {
  Login_page({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  // bool ishiden = true;

  @override
  Widget build(BuildContext context) {
    Get.put(Login_controler());
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
                  
                  Let's Chat""",
                    style: GoogleFonts.montserrat(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
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
                  // Expanded(child: Icon(Icons.email))
                ),
                SizedBox(
                  height: 15,
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
                            onTap:() {
                              FocusScope.of(context).unfocus();
                              controller.toogle(context);

                            },
                            child: Icon(
                            
                              controller.ishidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                          ),
                          hintStyle: TextStyle(color: Colors.black)),
                      obscureText: controller.ishidden,
                    ),
                  ),
                  // IconButton(onPressed: () {}, icon: Icon(Icons.visibility))
                  // Expanded(child: Icon(Icons.email))
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.purple[700]),
                      ),
                      onPressed: () async{
                        if (_formKey.currentState!.validate()) {

                           login(name.text, password.text, context).then((value){
                             if (value !=null) {
                             Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Homescreem(),));
                               
                             }

                           });
                          
                          
                        }
                       
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Registrationpage(),
                          ));
                    },
                    child: Text("Not Registered ? Sign In",
                        style: GoogleFonts.montserrat(
                            fontSize: 15, color: Colors.white)))

                // Text("--------------------OR----------------------------",style: GoogleFonts.montserrat(fontSize:15,color: Colors.white )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
