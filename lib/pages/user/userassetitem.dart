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
    final double tile_width = (screenWidth - 625) / 2 > 400 ? 400 : (screenWidth - 625) / 2;
    return
      SizedBox(width:tile_width,height:180,child:TitledContainer(
          titleText: '',
          idden: 10,
          child: Row(
            children: [
              Image.asset('assets/images/asset2.png',width: 120,height: 120),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 25,
                      width: 170,
                      child:
                      Container(
                          margin:EdgeInsets.only(left:20),
                          child: TextFormField(
                             initialValue: widget.asset_name == null? '' : widget.asset_name,
                              decoration: InputDecoration(
                                hintText: 'Asset Name',
                              ),
                            readOnly: true,
                          )
                      )

                  ),
                  SizedBox(height: 7),
                  SizedBox(
                      height: 25,
                      width: 170,
                      child:
                      Container(
                          margin:EdgeInsets.only(left:20),
                          child: TextFormField(
                              initialValue: widget.asset_type == null ? '' : widget.asset_type,
                              decoration: InputDecoration(
                                hintText: 'Asset Type',
                              ),
                            readOnly: true,
                          )
                      )

                  ),
                  SizedBox(height: 7),
                  SizedBox(
                      height: 25,
                      width: 170,
                      child:
                      Container(
                          margin:EdgeInsets.only(left:20),
                          child: TextFormField(
                              initialValue: widget.category == null ? '' : widget.category,
                              decoration: InputDecoration(
                                hintText: 'Asset Category',
                              ),
                            readOnly: true,
                          )
                      )

                  ),
                  SizedBox(
                      height: 35,
                      width: 170,
                      child:
                      Container(
                          margin:EdgeInsets.only(left:20),
                          child: TextFormField(
                              initialValue: widget.last_inspected == null ? '' : widget.last_inspected,
                              decoration: InputDecoration(
                                hintText: 'Last Inspected',
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
