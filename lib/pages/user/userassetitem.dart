import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';


class UserAssetItem extends StatefulWidget {
  String? asset_name;
  String? asset_type;
  String? category;
  String? last_inspected;
  UserAssetItem({super.key,this.asset_name,this.asset_type,this.category,this.last_inspected});
  @override
  _UserAssetItem createState() => _UserAssetItem();
}
class  _UserAssetItem extends State<UserAssetItem> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double tile_width = (screenWidth - 625) / 2 > 400 ? 400 : (screenWidth - 625) / 2;
    if(screenWidth < 1260)
      tile_width = (screenWidth - 250) / 2 > 400 ? 400 : (screenWidth - 250) / 2;
    if(screenWidth < 900)
      tile_width = 320;
    return
      SizedBox(width:tile_width,height:230,child:TitledContainer(
          titleText: '',
          idden: 10,
          child: Row(
            children: [
              Image.asset('assets/images/asset2.png',width: 120,height: 120),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 50,
                      width: 170,
                      child:
                      Container(
                          margin:EdgeInsets.only(left:20),
                          child: TextFormField(
                             initialValue: widget.asset_name == null? '' : widget.asset_name,
                              decoration: InputDecoration(
                                labelText: 'Asset Name',
                              ),
                            readOnly: true,
                          )
                      )

                  ),
                  SizedBox(
                      height: 50,
                      width: 170,
                      child:
                      Container(
                          margin:EdgeInsets.only(left:20),
                          child: TextFormField(
                              initialValue: widget.asset_type == null ? '' : widget.asset_type,
                              decoration: InputDecoration(
                                labelText: 'Asset Type',
                              ),
                            readOnly: true,
                          )
                      )

                  ),
                  SizedBox(
                      height: 50,
                      width: 170,
                      child:
                      Container(
                          margin:EdgeInsets.only(left:20),
                          child: TextFormField(
                              initialValue: widget.category == null ? '' : widget.category,
                              decoration: InputDecoration(
                                labelText: 'Asset Category',
                              ),
                            readOnly: true,
                          )
                      )

                  ),
                  SizedBox(
                      height: 50,
                      width: 170,
                      child:
                      Container(
                          margin:EdgeInsets.only(left:20),
                          child: TextFormField(
                              initialValue: widget.last_inspected == null ? '' : widget.last_inspected,
                              decoration: InputDecoration(
                                labelText: 'Last Inspected',
                              ),
                            readOnly: true,
                          )
                      )

                  ),
                ],)
            ],
          )
      ));
  }
}
