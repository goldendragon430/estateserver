
import 'package:assetmamanger/pages/admin.dart';
import 'package:assetmamanger/pages/auth/login.dart';
import 'package:assetmamanger/pages/auth/register.dart';
import 'package:assetmamanger/pages/tenantadmin.dart';
import 'package:assetmamanger/pages/customAppBar.dart';

import 'package:assetmamanger/provider/app_properties_bloc.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';


Future main() async{

    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCJ8bsqT6b2gk3nME7GhLoSLSOQwECeGsw",
        appId: "1:47315598483:web:09c4164ed0747d54ad2166",
        messagingSenderId: "47315598483",
        projectId: "assetmanager-3e6ce",
        storageBucket: "assetmanager-3e6ce.appspot.com",
      ),
    );

  runApp(MaterialApp(
      home:  MyApp(),
      debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  @override
  State<StatefulWidget> createState(){
    return _MyApp();
  }
}
class  _MyApp extends State<MyApp>{
  String title2 = 'Settings';
  void setTitle(String v){
    setState(() {
      title2 = v;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Stack(
          children: [
            Column(
              children:[
                Expanded(child:
                MaterialApp(
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: (settings) {
                    switch(settings.name){
                      case '/':
                        return MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                  appBar: CustomAppBar(title: '',title2 : '', context : context),
                                  body:TenantAdminView(onTitleSelect : (String val){
                                    setTitle(val);
                                  }),
                                  backgroundColor: Colors.white,
                              );
                            });
                      case 'admin':
                        return MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                  appBar: CustomAppBar(title2 : '', title: 'Welcome ' + getUserName(), context : context),
                                  body:AdminView(),
                                backgroundColor: Colors.white,

                              );
                            });
                      case 'tenant':
                        return MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                  appBar: CustomAppBar(title2 : title2, title: 'Welcome ' +  getUserName(), context : context),
                                  body:TenantAdminView(onTitleSelect : (String val){
                                     setTitle(val);
                                  }),
                                backgroundColor: Colors.white,
                              );
                            });
                      case 'user':
                        return MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                  appBar: CustomAppBar(title2 : '',title: 'Welcome ' +  getUserName(), context : context),
                                  body:Text('user'),
                                backgroundColor: Colors.white,

                              );
                            });
                      case 'userdetail':
                        final args = settings.arguments as Map<String, dynamic>;
                        return MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                  appBar: CustomAppBar(title2 : '',title: 'Welcome ' +  getUserName(), context : context),
                                  body:Text('detail'),
                                backgroundColor: Colors.white,

                              );
                            });
                      case 'register':
                        return MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                  appBar: CustomAppBar(title2 : '',title: '', context : context),
                                  body:RegisterView(),
                                backgroundColor: Colors.white,

                              );
                            });
                      default:
                        return MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                  appBar: CustomAppBar(title2 : '',title: '', context : context),
                                  body:Text('Not Found')
                              );
                            });
                    }
                  },
                )),
                Container(
                  // color:Colors.orange.withOpacity(0.3),
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 8.0,
                            offset: Offset(0.0, 0.75)
                        )
                      ],
                      color: Colors.orange.withOpacity(0.8)
                  ),
                  height: 25,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Version : 1.0',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white
                            )),
                        Text(
                            'Date : 2023-7-18',
                            style : TextStyle(
                                fontSize: 14,
                                color: Colors.white
                            )
                        ),
                        Text(
                            'Dataset : Folder/Group',
                            style : TextStyle(
                                fontSize: 14,
                                color: Colors.white
                            )
                        )
                      ]),
                )
              ],
            ),
            DropdownAlert()
          ],
        )
    );
  }
}
