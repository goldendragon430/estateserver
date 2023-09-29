import 'dart:convert';

import 'package:assetmamanger/apis/auth.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
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
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Sign in',
            style: TextStyle(
                fontSize: 32,
                color: Colors.black,
                decoration: TextDecoration.none,
            )),
          SizedBox(height: 20),
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Column(children: [

                  Row(children: [
                    Text('Email          ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        )

                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10,bottom:10),
                        child: SizedBox(
                            height: 45,
                            width: 400,
                            child:
                            Container(
                              margin:EdgeInsets.only(left:20),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    this.email = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: 'example@gmail.com',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true
                                ),
                              ),
                            )

                        )
                    ),
                  ]),
                  Row(children: [
                    Text('Password    ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10,bottom:10),
                        child: SizedBox(
                            height: 45,
                            width: 400,
                            child:
                            Container(
                              margin:EdgeInsets.only(left:20),
                              child: TextField(
                                obscureText: true,
                                onChanged: (value) {
                                  setState(() {
                                    this.password = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: '******',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true
                                ),
                              ),
                            )

                        )
                    ),
                  ]),
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
                          width:470,
                          child: Text(
                            'Register Me?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.none,
                            ),
                          )
                      ),
                    ) ,
                  ),
                  SizedBox(height: 20),
                  Container(
                      margin: EdgeInsets.only(left:105),
                      width: 380, // Set the desired width here
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green),
                              padding:MaterialStateProperty.all(const EdgeInsets.all(20)),

                              textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                          onPressed: onLogin,
                          child: const Text('Sign in'))
                  )

                ])
            )
          ],
      ),
          SizedBox(height: 70),

        ]);
  }
}
