import 'dart:math';

import 'package:assetmamanger/apis/auth.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
class RegisterView extends StatefulWidget {
  RegisterView({super.key});
  @override
  _RegisterView createState() => _RegisterView();
}
class  _RegisterView extends State<RegisterView> {
  final dio = Dio();
  String username = '';
  String email = '';
  String mobile = '';
  String landline = '';
  String code = '';
  bool state = false;
  String sent_code = '';
  @override
  void initState() {
    super.initState();
  }

  void onRegister() async{
    if(sent_code == code) {
      bool ok = await LoginService().create(email, username, landline, mobile);
      if(ok){
        showSuccess('Congratulations ${username}. Your account has been successfully registered with Cloud Asset. You will be notified by email once your account has been verified and activated by Cloud Asset Administrator. \nIn the meantime, you can read some of our resources in this link to familiarize yourself on how to use the system. \nThank you.');
        Future.delayed(const Duration(milliseconds: 3000), () {
          Navigator.pop(context);
        });
      }else{
        showError('Register Error');
      }
    }else{
      showError('Not Matches Digits');
    }
  }
  void onNext() async{
    if(username == '') {
      showError('User Name is empty.');
      return;
    }
    if(email == '' || isEmailValid(email) == false){
      showError('Email is invalid.');
      return;
    }
    // setState(() {
    //   state = true;
    // });
    Random  rng = new Random();
    int varcode = rng. nextInt(900000) + 100000;

    final response = await dio.post('http://154.38.161.183:5000/mail/send', data : {
      'to'   : email ,
      'code' : varcode
    });
    if(response.data['result'] == 'success'){
      setState(() {
        state = true;
        sent_code = varcode.toString();
      });
    }else{
      showError('Mail server is error.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text( state == false ? 'Sign Up' : 'Access Code Confirmation',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                )),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               state == false ? Container(
                    child: Column(
                        children: [
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
                            Row(children: [
                              Text('Mobile        ',
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
                                              this.mobile = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              hintText: '',
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
                              Text('Landline     ',
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
                                              this.landline = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              hintText: '',
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

                            SizedBox(height: 20),
                            Container(
                          width: 490, // Set the desired width here
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.green),
                                  padding:MaterialStateProperty.all(const EdgeInsets.all(20)),

                                  textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                              onPressed: onNext,
                              child: const Text('Sign up'))
                      )
                    ])
                ) : Container(
                   child: Column(
                       children: [
                         Container(
                             width:490,
                             child: Text(
                               'Your User Access Code has been supplied to the email address  ${email}.\nPlease enter this user access code below to confirm.',
                               style: TextStyle(fontSize: 16),
                               textAlign: TextAlign.center,
                             )),
                         SizedBox(height: 20),
                         Row(children: [
                           Container(
                               margin: EdgeInsets.only(top: 10,bottom:10),
                               child: SizedBox(
                                   height: 45,
                                   width: 490,
                                   child:
                                   Container(
                                     margin:EdgeInsets.only(left:0),
                                     child: TextFormField(
                                       initialValue: '',
                                       onChanged: (value) {
                                         setState(() {
                                           this.code = value;
                                         });
                                       },
                                       decoration: InputDecoration(
                                           hintText: '6-digits',
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

                         SizedBox(height: 20),
                         Container(
                             width: 490, // Set the desired width here
                             child: ElevatedButton(
                                 style: ButtonStyle(
                                     backgroundColor: MaterialStateProperty.all(Colors.green),
                                     padding:MaterialStateProperty.all(const EdgeInsets.all(20)),

                                     textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                                 onPressed: onRegister,
                                 child: const Text('Confirm'))
                         )
                       ])
               )

              ],
            ),
            SizedBox(height: 70),

          ]);
  }
}
