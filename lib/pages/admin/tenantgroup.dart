import 'package:flutter/material.dart';
import 'package:assetmamanger/utils/global.dart';

class TenantGroupItem extends StatefulWidget {
  String? folderID = '';
  String? groupID = '';
  String? folderName = '';
  String? groupName = '';
  String? registeredDate = '';
  bool? active = false;
  String? tenantEmail = '';
  final Function(String folder_id,String group_id,bool active)? onChange;
  TenantGroupItem({super.key,this.folderID,this.groupID,this.folderName,this.tenantEmail,this.groupName,this.registeredDate,this.active,this.onChange});
  @override
  _TenantGroupItem createState() => _TenantGroupItem();
}

class  _TenantGroupItem extends State<TenantGroupItem> {

  String registeredDate = '';
  bool active_value = false;
  TextEditingController folderNameController = TextEditingController();
  TextEditingController groupNameController  = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      if(widget.folderName!= null)
          folderNameController.text = widget.folderName!;
      if(widget.groupName!= null)
          groupNameController.text = widget.groupName!;
      if(widget.active!= null)
        active_value = widget.active!;
      if(widget.registeredDate!= null)
        registeredDate = widget.registeredDate!;
    });
  }
  void update(){

    widget.onChange!(widget.folderID!,widget.groupID!,active_value);
  }
  void sendActiveAccountEmail() async{
    String email = widget.tenantEmail!;
    String title = '${widget.groupName} Group Activated';
    String Body  = '<html><body><p>Your Cloud Asset Group ${widget.groupName} has been activated.</p>'
        '<p style = "margin-top:10px">If you have any queries, please contact CloudAsset@minsoft.com.pg or telephone on (675) 3221 2551.</p>'
        '<p style = "margin-top:10px">Thank You</p>'
        '<p style = "margin-top:10px">Cloud Asset Admin</p>'
        '</body></html>';
    sendEmail(email, title, Body);
  }
  void sendDeActiveAccountEmail() async{
    String email = widget.tenantEmail!;
    String title = '${widget.groupName} Group Deactivated';
    String Body  = '<html><body><p>Your Cloud Asset Group ${widget.groupName} has been deactivated.</p>'
        '<p style = "margin-top:10px">If you have any queries, please contact CloudAsset@minsoft.com.pg or telephone on (675) 3221 2551.</p>'
        '<p style = "margin-top:10px">Thank You</p>'
        '<p style = "margin-top:10px">Cloud Asset Admin</p>'
        '</body></html>';
    sendEmail(email, title, Body);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Row(
            children: [
              SizedBox(width:10),
              Image.asset('assets/images/group.png',width: 80,height: 50,),
              SizedBox(
                  height: 35,
                  width: 200,
                  child:
                  Container(
                      margin:EdgeInsets.only(left:20),
                      child: TextField(
                        controller: folderNameController,
                          decoration: InputDecoration(
                            hintText: 'Folder Name',
                          ),
                        readOnly: true,
                      )
                  )
              ),
              SizedBox(
                  height: 35,
                  width: 200,
                  child:
                  Container(
                      margin:EdgeInsets.only(left:20),
                      child: TextField(
                        controller: groupNameController,
                          decoration: InputDecoration(
                            hintText: 'Group Name',
                          ),
                        readOnly: true,
                      )
                  )
              ),
              SizedBox(
                  height: 35,
                  width: 200,
                  child:
                  Container(
                      margin:EdgeInsets.only(left:20),
                      child: TextFormField(
                           initialValue: registeredDate,
                          decoration: InputDecoration(
                            hintText: 'Date registered',
                          ),
                        readOnly: true,
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
                        if(value == true) {
                          sendActiveAccountEmail();
                        }else{
                          sendDeActiveAccountEmail();
                        }
                        update();
                      });
                    },
                  ),
                  SizedBox(
                      width:10
                  ),
                  Text('Active?')
                ],
              )
            ]
        )
    );
  }
}