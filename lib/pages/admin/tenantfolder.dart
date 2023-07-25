import 'package:flutter/material.dart';
class TenantFolderItem extends StatefulWidget {
  TenantFolderItem({super.key});
  @override
  _TenantFolderItem createState() => _TenantFolderItem();
}

class  _TenantFolderItem extends State<TenantFolderItem> {

  bool active_value = false;
  bool folder_value = false;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Row(
            children: [
              SizedBox(width:10),
              Image.asset('assets/images/home.jpg',width: 80,height: 50,),
              SizedBox(
                  height: 35,
                  width: 250,
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
              SizedBox(
                  height: 35,
                  width: 250,
                  child:
                  Container(
                      margin:EdgeInsets.only(left:20),
                      child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Date registered',
                          )
                      )
                  )
              ),
              Row(
                children: [
                  SizedBox(
                      width:15
                  ),
                  Checkbox(
                    value: this.active_value,
                    onChanged: (bool? value) {
                      setState(() {
                        this.active_value = value!;
                      });
                    },
                  ),
                  SizedBox(
                      width:10
                  ),
                  Text('Active?')

                ],

              ),
              Row(
                children: [
                  SizedBox(
                      width:15
                  ),
                  Checkbox(
                    value: this.folder_value,
                    onChanged: (bool? value) {
                      setState(() {
                        this.folder_value = value!;
                      });
                    },
                  ),
                  SizedBox(
                      width:10
                  ),
                  Text('Unlimited Groups?')

                ],

              )
            ]
        )
    );
  }
}