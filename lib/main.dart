
import 'package:assetmamanger/pages/admin.dart';
import 'package:assetmamanger/pages/tenantadmin.dart';
import 'package:assetmamanger/pages/customAppBar.dart';
import 'package:assetmamanger/pages/user.dart';
import 'package:assetmamanger/pages/user/assetdetail.dart';
import 'package:flutter/material.dart';


void main() {
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
      appBar: CustomAppBar( title: '' ),
      body:  Column(
        children:[
          Expanded(child: AssetDetailView()),
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
      )
    );
  }
}
