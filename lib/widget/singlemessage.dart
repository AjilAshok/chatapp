import 'package:chatapp/controller/logincontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Single_message extends StatelessWidget {
   Single_message({ Key? key,required this.message,required this.isme, }) : super(key: key);
   String message;
   bool isme;
   final controller=Get.put(Login_controler());
   var name;

  @override
  Widget build(BuildContext context) {
    
    return Row(
      mainAxisAlignment: isme?MainAxisAlignment.end:MainAxisAlignment.start ,
      children: [
         Container(
           
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.80,
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:isme?
                 BorderRadius.only(topRight:Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(10) ): BorderRadius.only(bottomRight:Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10) ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.purple, spreadRadius: 2, blurRadius: 5)
                ]),
            child: Text(
                message),
          ),

      ],
      
    );
  }
}