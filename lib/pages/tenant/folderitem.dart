import 'dart:typed_data';

import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:image_picker_web/image_picker_web.dart';


class FolderItem extends StatefulWidget {
  final String? foldername;
  final bool? active;
  final bool? ugroups;
  final String? folderId;
  final String? logo;
  final Function(String id,String name,bool active,bool ugroup,String logo)? onChange;
  final Function(String id)? onDelete;
  FolderItem({super.key,this.logo,this.folderId,this.foldername, this.active, this.ugroups, this.onChange, this.onDelete});
  @override
  _FolderItem createState() => _FolderItem();
}
class  _FolderItem extends State<FolderItem> {
  bool folder_active = false;
  bool group_active = false;
  bool is_focus = false;
  String name = '';
  String logo = '';
  TextEditingController nameEditController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameEditController.text = widget.foldername!;
    setState(() {
      name = widget.foldername!;
      folder_active = widget.active!;
      group_active = widget.ugroups!;
      logo = widget.logo!;
    });
  }
  void update(){
    widget.onChange!(widget.folderId!,name,folder_active,group_active,logo);
  }
  @override
  Widget build(BuildContext context) {
    return
      SizedBox(width:330,height:150,
          child:
              MouseRegion(
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
                    children: [
                      TitledContainer(
                          titleText: '',
                          idden: 10,
                          color : is_focus ? Colors.deepOrange:Colors.grey,
                          child: Row(
                            children: [
                               GestureDetector(
                                onTap: () async{
                                  Uint8List? data =  await ImagePickerWeb.getImageAsBytes();
                                  String url =  await uploadFile(data);
                                  setState(() {
                                    logo = url;
                                  });
                                  update();
                                },
                                child: logo == '' ? Image.asset('assets/images/folder.png',width: 94,height: 94) : Image.network(logo,width: 94,height: 94)
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 50,
                                      width: 150,
                                      child:
                                      Container(
                                          margin:EdgeInsets.only(left:20),
                                          child: TextField(
                                            controller: nameEditController,
                                              decoration: InputDecoration(
                                                labelText: 'Folder Name',
                                              ),
                                            onChanged: (value){
                                              setState(() {
                                                name = value;
                                                update();
                                              });
                                            },
                                          )
                                      )
                                  ),
                                  SizedBox(height:5),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width:15
                                      ),
                                      Checkbox(
                                        value: this.folder_active,
                                        onChanged: (bool? value) {
                                          // setState(() {
                                          //   this.folder_active = value!;
                                          //   update();
                                          // });
                                        },
                                      ),
                                      SizedBox(
                                          width:10
                                      ),
                                      Text('Folder Active')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width:15
                                      ),
                                      Checkbox(
                                        value: this.group_active,
                                        onChanged: (bool? value) {
                                          // setState(() {
                                          //   // this.group_active = value!;
                                          //   // update();
                                          // });
                                        },
                                      ),
                                      SizedBox(
                                          width:10
                                      ),
                                      Text('Unlimited Groups')
                                    ],
                                  ),
                                ],)
                            ],
                          )
                      ),
                      if(is_focus)
                        Container(
                          margin: EdgeInsets.only(top:15,right:5),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Image.asset('assets/images/delete.png'),
                                onPressed: () {
                                  widget.onDelete!(widget.folderId!);
                                  // Add your button functionality here
                                },
                              )
                          )
                      )
                    ]
                )),
              )

          ;
  }
}
