import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';


class FolderItem extends StatefulWidget {
  FolderItem({super.key});
  @override
  _FolderItem createState() => _FolderItem();
}
class  _FolderItem extends State<FolderItem> {
  bool folder_active = false;
  bool group_active = false;
  @override
  Widget build(BuildContext context) {
    return
      SizedBox(width:330,height:150,child:TitledContainer(
          titleText: '',
          idden: 10,
          child: Row(
            children: [
              Image.asset('assets/images/home.jpg',width: 130,height: 100),
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
                              hintText: 'Folder Name',
                            )
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
                        setState(() {
                          this.folder_active = value!;
                        });
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
                        setState(() {
                          this.group_active = value!;
                        });
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
      ));
  }
}
