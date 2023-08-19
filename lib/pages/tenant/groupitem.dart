import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';


class GroupItem extends StatefulWidget {

  String? groupID;
  String? folderName;
  String? folderID;
  String? groupName;
  bool? groupActive;
  Function(String folderID, String groupID,String groupName,bool groupActive)? onChange;
  Function(String folder_id, String id)? onDelete;

  GroupItem({super.key, this.groupID, this.folderName,this.folderID, this.groupName, this.groupActive, this.onChange, this.onDelete});
  @override
  _GroupItem createState() => _GroupItem();
}
class  _GroupItem extends State<GroupItem> {
  bool active = false;

  String group_name = '';
  bool is_focus = false;

  TextEditingController folderNameEditController = TextEditingController();
  TextEditingController groupNameEditController = TextEditingController();

  void update(){
    widget.onChange!(widget.folderID!, widget.groupID!,group_name,active);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      active = widget.groupActive!;

      group_name = widget.groupName!;
      folderNameEditController.text = widget.folderName!;

      groupNameEditController.text = group_name;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  SizedBox(width:300,height:150,
              child: MouseRegion(
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
                                      TitledContainer(
                                            titleText: '',
                                            idden: 10,
                                            child: Row(
                                              children: [
                                                Image.asset('assets/images/group.png',width: 94,height: 94),
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
                                                              readOnly: true,
                                                              controller: folderNameEditController,
                                                                decoration: InputDecoration(
                                                                  hintText: 'Folder Name',
                                                                ),
                                                              onChanged: (value){

                                                              },
                                                            )
                                                        )

                                                    ),
                                                    SizedBox(
                                                        height: 35,
                                                        width: 150,
                                                        child:
                                                        Container(
                                                            margin:EdgeInsets.only(left:20),
                                                            child: TextField(
                                                                controller: groupNameEditController,
                                                                decoration: InputDecoration(
                                                                  hintText: 'Group Name',
                                                                ),
                                                                onChanged: (value){
                                                                  setState(() {
                                                                    group_name = value;
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
                                                          value: this.active,
                                                          onChanged: (bool? value) {
                                                            // setState(() {
                                                            //   this.active = value!;
                                                            //   update();
                                                            // });
                                                          },
                                                        ),
                                                        SizedBox(
                                                            width:10
                                                        ),
                                                        Text('Group Active')
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
                                                          widget.onDelete!(widget.folderID!, widget.groupID!);
                                                        // Add your button functionality here
                                                        },
                                                    )
                                                )
                                      )
                                  ]

                  ))
    );
  }
}
