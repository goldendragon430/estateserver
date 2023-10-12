import 'dart:convert';

import 'package:assetmamanger/apis/auth.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert'; // for the utf8.encode method
import '../../apis/tenants.dart';
import '../../models/tenants.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});
  @override
  _LoginView createState() => _LoginView();
}
class  _LoginView extends State<LoginView> {
  String password = '';
  String email = '';
  @override
  void initState() {
    super.initState();
  }

  void onLogin() async{
    if(password == '') {
      showError('User Name is empty.');
    return;
    }
    if(email == '' || isEmailValid(email) == false){
      showError('Email is invalid.');
    return;
    }
    var bytes = utf8.encode(password); // data being hashed
    var digest = sha256.convert(bytes);
    Map<String,dynamic>? result = await LoginService().login(email,digest.toString());
    Map<String, dynamic>? result_2 = await LoginService().loginByUser(email,digest.toString());


    if(result == null && result_2 == null) {
        showError("User doesn't exist.");
        return;
    }else{
      if(result != null) {
        if(result['role'] == 1) {
          String user_id = result['id'];
          Tenant? tenant =  await TenantService().getTenantDetails(user_id);

          if(tenant!.active == false) {
            showError('We have received your account registration and in the process of establishing your trial account. You can follow up on your account by emailing geoAssetManager@gmail.com.');
            return;
          }

        }
      }
     else {
        saveStorage('user', jsonEncode(result_2));
        showSuccess('success');
        Navigator.pushNamed(
           context,
           'user',
         );
        return;
      }
      saveStorage('user', jsonEncode(result));
      showSuccess('success');
      switch(result!['role']){
        case 0: //admin
          Navigator.pushNamed(
            context,
            'admin',
          );
          break;
        case 1: //tenant
          Navigator.pushNamed(
            context,
            'tenant',
          );
          break;
        default:
          break;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
        children: [
          screenWidth > 1200 ? Image.asset("assets/images/rect.png", width: screenWidth,fit: BoxFit.fitWidth) : Image.asset("assets/images/rect.png", height: screenHeight,fit: BoxFit.fitHeight),
          Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset("assets/images/ellipse.svg", width: screenWidth,fit: BoxFit.cover)
          ),
          Center(child:Container(
              width: 350,
              height : 400,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]

              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    const Text('Sign in to Your Tenant Account',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        )),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: Column(children: [
                              SizedBox(width: 300,child: Text('Email',style: TextStyle(fontWeight: FontWeight.w500))),
                              Row(children: [
                                Container(
                                    margin: EdgeInsets.only(top: 10,bottom:10),
                                    child: SizedBox(
                                        height: 45,
                                        width: 300,
                                        child:
                                        Container(
                                          child: TextField(
                                            onChanged: (value) {
                                              setState(() {
                                                this.email = value;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                hintText: 'Enter Email',
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    borderSide: BorderSide(color: Color.fromRGBO(0, 0, 36, 0.12), width: 1.0)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    borderSide: BorderSide(color: Color.fromRGBO(0, 0, 36, 0.12), width: 1.0)),
                                                focusedBorder:OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    borderSide: BorderSide(color: Color.fromRGBO(0, 0, 36, 0.3), width: 1.0)) ,
                                                fillColor: Colors.white,
                                                filled: true
                                            ),
                                          ),
                                        )

                                    )
                                ),
                              ]),
                              SizedBox(width: 300,child: Text('Password',style: TextStyle(fontWeight: FontWeight.w500))),
                              Row(children: [
                                Container(
                                    margin: EdgeInsets.only(top: 10,bottom:10),
                                    child: SizedBox(
                                        height: 45,
                                        width: 300,
                                        child:
                                        Container(
                                          child: TextField(
                                            obscureText: true,
                                            onChanged: (value) {
                                              setState(() {
                                                this.password = value;
                                              });
                                            },
                                              decoration: InputDecoration(
                                                  hintText: 'Enter Password',
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                      borderSide: BorderSide(color: Color.fromRGBO(0, 0, 36, 0.12), width: 1.0)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                      borderSide: BorderSide(color: Color.fromRGBO(0, 0, 36, 0.12), width: 1.0)),
                                                  focusedBorder:OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                      borderSide: BorderSide(color: Color.fromRGBO(0, 0, 36, 0.3), width: 1.0)) ,
                                                  fillColor: Colors.white,
                                                  filled: true
                                              )

                                          ),
                                        )

                                    )
                                ),
                              ]),

                              SizedBox(height: 20),
                              Container(
                                  width: 300, // Set the desired width here
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Color.fromRGBO(60, 121, 245, 1)),
                                          padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                                          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                                      onPressed: onLogin,
                                      child: const Text('Sign in'))
                              ),
                              SizedBox(height : 30),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      'register',
                                    );
                                  },
                                  child:  Container(
                                      alignment: Alignment.centerRight,
                                      width:300,
                                      child: Row(children:[
                                        SizedBox(width : 20),
                                        Text("Don't  Have An Account?"),
                                        SizedBox(width : 5),
                                        Text(
                                          'Register Now',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue,
                                            decoration: TextDecoration.none,
                                          ),
                                        )
                                      ])

                                  ),
                                ) ,
                              ),

                            ])
                        )
                      ],
                    ),

                  ])
          ))


        ],

    );
  }
}
