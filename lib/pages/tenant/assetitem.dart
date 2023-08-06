import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';


class AssetItem extends StatefulWidget {
  AssetItem({super.key});
  @override
  _AssetItem createState() => _AssetItem();
}
class  _AssetItem extends State<AssetItem> {

  @override
  Widget build(BuildContext context) {
    return
      SizedBox(width:330,height:170,child: Column(
            children: [
              Image.asset('assets/images/asset.png',width: 94,height: 94),
              SizedBox(
                  height: 35,
                  width: 150,
                  child:
                  Container(
                      margin:EdgeInsets.only(left:0),
                      child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Asset Type',
                          )
                      )
                  )

              ),
            ],

      ));
  }
}
