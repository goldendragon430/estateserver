import 'package:flutter/material.dart';
import 'package:assetmamanger/utils/global.dart';
class TenantFolderItem extends StatefulWidget {
  String? folderID = '';
  String? folderName = '';
  String? registeredDate = '';
  bool? active = false;
  bool? unlimited_group = false;
  String? tenantEmail = '';
  final Function(String id,bool active,bool ugroup)? onChange;
  TenantFolderItem({super.key,this.folderID, this.folderName, this.registeredDate, this.active,this.tenantEmail, this.unlimited_group, this.onChange});
  @override
  _TenantFolderItem createState() => _TenantFolderItem();
}

class  _TenantFolderItem extends State<TenantFolderItem> {

  bool active_value = false;
  bool folder_value = false;
  String folder_name = '';
  String register_date = '';
  TextEditingController nameEditController = TextEditingController();
  TextEditingController dateEditController = TextEditingController();

  void update(){
    widget.onChange!(widget.folderID!,active_value,folder_value);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if(widget.folderName != null) {
        folder_name = widget.folderName!;
        nameEditController.text = folder_name;
      }
      if(widget.registeredDate != null) {
        register_date = widget.registeredDate!;
        dateEditController.text = widget.registeredDate!;
      }
      if(widget.active != null) {
        active_value = widget.active!;
      }
      if(widget.unlimited_group != null) {
        folder_value = widget.unlimited_group!;
      }
    });
  }
  void sendActiveAccountEmail() async{
    String email = widget.tenantEmail!;
    String title = '${folder_name} Folder Activated';
    String Body  = '<html><body><p>Your Cloud Asset Folder ${folder_name} has been activated.</p>'
        '<p style = "margin-top:10px">If you have any queries, please contact CloudAsset@minsoft.com.pg or telephone on (675) 3221 2551.</p>'
        '<p style = "margin-top:10px">Thank You</p>'
        '<p style = "margin-top:10px">Cloud Asset Admin</p>'
        '</body></html>';
    sendEmail(email, title, Body);
  }
  void sendDeActiveAccountEmail() async{
    String email = widget.tenantEmail!;
    String title = '${folder_name} Folder Deactivated';
    String Body  = '<html><body><p>Your Cloud Asset folder ${folder_name} has been deactivated.</p>'
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
              Image.asset('assets/images/folder.png',width: 80,height: 50),
              SizedBox(
                  height: 35,
                  width: 200,
                  child:
                  Container(
                      margin:EdgeInsets.only(left:20),
                      child: TextField(
                        controller: nameEditController,
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
                        controller: dateEditController,
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
                        }
                        else{
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
                        update();
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