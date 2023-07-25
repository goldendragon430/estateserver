import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';


class UserAssetItem extends StatefulWidget {
  UserAssetItem({super.key});
  @override
  _UserAssetItem createState() => _UserAssetItem();
}
class  _UserAssetItem extends State<UserAssetItem> {
  bool folder_active = false;
  bool group_active = false;
  @override
  Widget build(BuildContext context) {
    return
      SizedBox(width:450,height:220,child:TitledContainer(
          titleText: '',
          idden: 10,
          child: Row(
            children: [
              Image.asset('assets/images/home.jpg',width: 250,height: 180),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 35,
                      width: 150,
                      child:
                      Container(
                          margin:EdgeInsets.only(left:20),
                          child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Asset Name',
                              )
                          )
                      )

                  ),
                  SizedBox(height: 7),
                  SizedBox(
                      height: 35,
                      width: 150,
                      child:
                      Container(
                          margin:EdgeInsets.only(left:20),
                          child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Asset Type',
                              )
                          )
                      )

                  ),
                  SizedBox(height: 7),
                  SizedBox(
                      height: 35,
                      width: 150,
                      child:
                      Container(
                          margin:EdgeInsets.only(left:20),
                          child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Asset Category',
                              )
                          )
                      )

                  ),
                  SizedBox(height: 7),
                  SizedBox(
                      height: 35,
                      width: 150,
                      child:
                      Container(
                          margin:EdgeInsets.only(left:20),
                          child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Last Inspected',
                              )
                          )
                      )

                  ),
                ],)
            ],
          )
      ));
  }
}
