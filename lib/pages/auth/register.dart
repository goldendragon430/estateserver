import 'dart:math';
import 'package:assetmamanger/apis/countries.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method
import 'package:assetmamanger/apis/auth.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
class RegisterView extends StatefulWidget {
  RegisterView({super.key});
  @override
  _RegisterView createState() => _RegisterView();
}
class  _RegisterView extends State<RegisterView> {
  final dio = Dio();
  String firstname = '';
  String lastname = '';
  String username = '';
  String email = '';
  String mobile = '';
  String landline = '';
  String code = '';
  bool state = false;
  String sent_code = '';
  String password = '';
  String password_confirm = '';
  List<Map<String, dynamic>> m_countries = [];
  List<String> country_list = [];
  String selected_country_id = '';
  bool hasOffice = false;
  void fetchData() async{

    List<Map<String, dynamic>> data =  await CountryService().getCountries();
    setState(() {
      m_countries = data;
    });
    country_list = [];
    for (Map<String, dynamic> item in data){
      setState(() {
        country_list.add(item['id']);
      });
    }
    if(country_list.length > 0)
        selected_country_id = country_list[0];
  }
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  String getCountryName(String id){
    for (Map<String, dynamic> item in m_countries){
      if(item['id'] == id) return item['text'];
    }
    return '';
  }
  void onRegister() async{
    if(sent_code == code) {
      var bytes = utf8.encode(password); // data being hashed
      var digest = sha256.convert(bytes);
      bool ok = await LoginService().create(email, username, landline, mobile, digest.toString(),firstname,lastname,hasOffice,selected_country_id);
      if(ok){
        showSuccess('Congratulations ${username}.You will be notified by email once your account has been approved.');
        final dio = Dio();
        String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 30)));

        final response = await dio.post('https://mailserver-p4vx.onrender.com/mail/active', data : {
          'to'   : email ,
          'title' : '$username Account Registered',
          'body'  :
          '<html> '
              '<body>'
              '<p>'
              'Thank you <b>$firstname $lastname </b> for registering $username with Geo Asset Manager. We confirm receiving your registration and upon setting up your trial account will advise you by email.'
              ' </p>'
              '<p>We will be providing your account details shortly.</p>'
              '<p>Thank you, System Admin</p>'
              '<p>Geo Asset Manager</p>'
              '</body>'
              '</html>'
        });
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
    if(firstname == '') {
      showError('First Name is empty.');
      return;
    }
    if(lastname == '') {
      showError('Last Name is empty.');
      return;
    }
    if(username == '') {
      showError('Account Name is empty.');
      return;
    }
    if(email == '' || isEmailValid(email) == false){
      showError('Email is invalid.');
      return;
    }
    if(password != password_confirm) {
      showError("Password doesn't match");
      return;
    }
    if(password == ''){
      showError('Passsword is invalid.');
      return;
    }
    if(selected_country_id == '') {
      showError('Country is empty.');
      return;
    }
    Random  rng = new Random();
    int varcode = rng. nextInt(900000) + 100000;
    setState(() {
      state = true;
      sent_code = varcode.toString();
    });
    print(sent_code);
    final dio = Dio();
    final response = await dio.post('https://mailserver-p4vx.onrender.com/mail/active', data : {
      'to'   : email ,
      'title' : 'Geo Asset Manager Account Registeration',
      'body'  :
      '<html> '
          '<body>'
          '<p>'
            'Thank you <b>$firstname $lastname </b> for registering your organization or company <b> $username </b> with Geo Asset Manager. To confirm your ownership, enter the following activation code in the registration process. '
          ' </p>'
          '<center>Activation Code:  <h3> $varcode </h3></center>'
          '<p>Thank you, System Admin</p>'
          '</body>'
          '</html>'
    });
    setState(() {
      state = true;
      sent_code = varcode.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
                    child:  SizedBox(
                        height: screenHeight - 200 > 700 ? 700 : screenHeight - 200 ,
                        width : 520,
                        child: ListView(
                            children: [
                              Row(children: [
                                Text('First Name',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                    )
                                ),
                                SizedBox(width : 30),
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
                                                this.firstname = value;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                hintText: 'John',
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
                                Text('Last Name',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                    )
                                ),
                                SizedBox(width : 32),
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
                                                this.lastname = value;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                hintText: 'Doe',
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
                                Text('Account Name',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                    )
                                ),
                                SizedBox(width : 2),
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
                                Text('Email                ',
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
                                Text('Password         ',
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
                                Text('Confirm           ',
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
                                                this.password_confirm = value;
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
                                Text('Mobile             ',
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
                                Text('Landline           ',
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
                              Row(children: [
                                Text('Country                ',
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
                                        width: 380,
                                        child:
                                        DropdownButton<String>(
                                          value: selected_country_id,
                                          isExpanded: true,
                                          onChanged: (String? newValue) {
                                             setState(() {
                                               selected_country_id = newValue!;
                                             });
                                          },
                                          items: country_list.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(getCountryName(value)),
                                            );
                                          }).toList(),
                                        )

                                    )
                                ),
                              ]),
                              Row(children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: hasOffice,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          hasOffice = value!;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                        width:3
                                    )
                                  ],
                                ),
                                Text('Have one or more office branch in different parts of the country?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                    )

                                ),
                              ]),
                              SizedBox(height: 20),
                              Container(
                                  margin: EdgeInsets.only(left:128,right: 10),
                                  width:  100, // Set the desired width here
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green),
                                          padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                                          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                                      onPressed: onNext,
                                      child: const Text('Sign up'))
                              )
                            ]) )
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
