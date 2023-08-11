import 'dart:convert';

import 'package:assetmamanger/apis/auth.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';

import '../../apis/tenants.dart';
import '../../models/tenants.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});
  @override
  _LoginView createState() => _LoginView();
}
class  _LoginView extends State<LoginView> {
  String username = '';
  String email = '';
  @override
  void initState() {
    super.initState();
  }

  void onLogin() async{
    if(username == '') {
      showError('User Name is empty.');
    return;
    }
    if(email == '' || isEmailValid(email) == false){
      showError('Email is invalid.');
    return;
    }
    Map<String,dynamic>? result = await LoginService().login(email,username);
    if(result == null) {
      showError("User doesn't exist.");
    }else{

      if(result['role'] == 1) {
        String user_id = result['id'];
        Tenant? tenant =  await TenantService().getTenantDetails(user_id);
        if(tenant!.active == false) {
          showError('Please wait until admin allow you.');
          return;
        }
      }

      saveStorage('user', jsonEncode(result));
      showSuccess('success');
      switch(result['role']){
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
        case 2: //user
          Navigator.pushNamed(
            context,
            'user',
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
                    Text('User Name',
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
                                    this.username = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: 'John Doe',
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
                            'Not Registered?',
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
                      width: 490, // Set the desired width here
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green),
                              padding:MaterialStateProperty.all(const EdgeInsets.all(20)),

                              textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                          onPressed: onLogin,
                          child: const Text('Log in'))
                  )

                ])
            )
          ],
      ),
          SizedBox(height: 70),

        ]);
  }
}
