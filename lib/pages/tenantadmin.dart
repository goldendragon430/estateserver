import 'package:assetmamanger/pages/tenant/customlistile.dart';
import 'package:assetmamanger/pages/tenant/tenantassets.dart';
import 'package:assetmamanger/pages/tenant/tenantcategory.dart';
import 'package:assetmamanger/pages/tenant/tenantgroups.dart';
import 'package:assetmamanger/pages/tenant/tenantsettings.dart';
import 'package:assetmamanger/pages/tenant/tenantfolders.dart';
import 'package:assetmamanger/pages/tenant/tenantusers.dart';

import 'package:flutter/material.dart';
typedef titlecallback = void Function(String color);
class TenantAdminView extends StatefulWidget {
  final titlecallback onTitleSelect;
  TenantAdminView({super.key,required this.onTitleSelect});
  @override
  _TenantAdminView createState() => _TenantAdminView();
}

class  _TenantAdminView extends State<TenantAdminView> {
  int hoveredIndex = -1;
  int tab_index = 0;
  Widget getTabContentWidget(int index){
    switch(index){
      case 0:
      return TenantSettings();

      case 1:
        return TenantFolders();
      case 2:

        return TenantGroups();
      case 3:

        return TenantAssets();
      case 4:

        return TenantCategory();
      case 5:

        return TenantUsers();
      default: return Text('Not Found Page');
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool is_Mobile_Mode = screenWidth < 1260 ;
    return   Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            width : is_Mobile_Mode ? 90 : 250,
            color:Colors.orange.withOpacity(0.1),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if(is_Mobile_Mode == false)
                  Container(
                      margin: EdgeInsets.only(top:10),
                      child:  Text('Actions',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                Expanded(child: ListView(
                  children: <Widget>[
                    CustomListTile(title: Text('Settings'), icon: Icon(Icons.settings),onClick:(){
                      widget.onTitleSelect('Settings');
                      setState((){
                      tab_index = 0;
                    });
                  }),
                    CustomListTile(title: Text('Folders'), icon: Icon(Icons.folder),onClick: (){
                      widget.onTitleSelect('Folders');
                      setState((){
                            tab_index = 1;
                          });
                        }
                    ),
                    CustomListTile(title: Text('Groups'), icon: Icon(Icons.group),onClick:(){
                      widget.onTitleSelect('Groups');
                      setState((){
                      tab_index = 2;
                      });}),
                    CustomListTile(title: Text('Asset Types'), icon: Icon(Icons.assignment_outlined),onClick:(){
                      widget.onTitleSelect('Asset Types');
                      setState((){
                      tab_index = 3;
                    });}),
                    CustomListTile(title: Text('Categories'), icon: Icon(Icons.category),onClick:(){
                      widget.onTitleSelect('Categories');
                      setState((){
                      tab_index = 4;
                    });}),
                    CustomListTile(title: Text('Subusers'), icon: Icon(Icons.account_circle_outlined),onClick:(){
                      widget.onTitleSelect('Subusers');
                      setState((){
                        tab_index = 5;
                      });}),
                  ],
                )),

              ],
            )
        ),
        Expanded(
            child: getTabContentWidget(tab_index)
        ),

      ],
    );
  }
}
