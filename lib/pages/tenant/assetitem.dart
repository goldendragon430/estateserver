import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';


class AssetItem extends StatefulWidget {

  String? folderID;
  String? groupID;
  String? assetTypeID;
  String? assetTypeName;
  Function(String folderID, String groupID,String assetTypeID, String assetTypeName)? onChange;
  Function(String folder_id, String group_id, String asset_type_id)? onDelete;

  AssetItem({super.key, this.folderID, this.groupID,this.assetTypeID, this.assetTypeName, this.onChange, this.onDelete});
  @override
  _AssetItem createState() => _AssetItem();
}
class  _AssetItem extends State<AssetItem> {
  String assetTypeName = '';
  bool is_focus = false;
  TextEditingController assetTypeEditController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      assetTypeName = widget.assetTypeName!;
      assetTypeEditController.text = widget.assetTypeName!;
    });
  }
  void update(){
    widget.onChange!(widget.folderID!, widget.groupID!,widget.assetTypeID!,assetTypeName);
  }
  @override
  Widget build(BuildContext context) {
    return   SizedBox(width:180,height:170,child: MouseRegion(
              onEnter: (event){
                setState(() {
                  is_focus = true;
                });
              },
              onExit: (eve){
                setState(() {
                  is_focus = false;
                });
              },
              child: Stack(
                  children:
                    [
                        Column(
                              children: [
                                Image.asset('assets/images/asset.png',width: 94,height: 94),
                                SizedBox(
                                    height: 35,
                                    width: 150,
                                    child:  Container(
                                        margin:EdgeInsets.only(left:0),
                                        child: TextField(
                                            controller: assetTypeEditController,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              hintText: 'Asset Type',
                                            ),
                                          onChanged: (val){
                                              setState(() {
                                                assetTypeName = val;
                                              });
                                              update();
                                          },
                                        )
                                    )

                                ),
                              ],
                        ),
                        if(is_focus)
                        Container(
                            margin: EdgeInsets.only(top:0,right:5),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Image.asset('assets/images/delete.png'),
                                  onPressed: () {
                                    widget.onDelete!(widget.folderID!, widget.groupID!, widget.assetTypeID!);
                                  },
                                )
                            )
                        )
                    ]
              ))
            );
  }
}
