
import 'package:assetmamanger/pages/admin.dart';
import 'package:assetmamanger/pages/auth/login.dart';
import 'package:assetmamanger/pages/auth/register.dart';
import 'package:assetmamanger/pages/tenantadmin.dart';
import 'package:assetmamanger/pages/customAppBar.dart';
import 'package:assetmamanger/pages/user.dart';
import 'package:assetmamanger/pages/user/assetdetail.dart';
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

  runApp(const MaterialApp(
      home:  MyApp(),
      debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', context : context),
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
                                return Scaffold(body:LoginView());
                            });
                    case 'admin':
                      return MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(body:AdminView());
                          });
                      case 'tenant':
                      return MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(body:TenantAdminView());
                          });
                    case 'user':
                      return MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(body:UserView());
                          });
                    case 'userdetail':
                      final args = settings.arguments as Map<String, dynamic>;
                      return MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(body:AssetDetailView(data: args));
                          });
                    case 'register':
                      return MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(body:RegisterView());
                          });
                    default:
                      return MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(body:Text('Not Found'));
                          });
                  }
                },

              )),
              Container(
                color:Color.fromRGBO(0, 113, 255, 1),
                height: 40,
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
