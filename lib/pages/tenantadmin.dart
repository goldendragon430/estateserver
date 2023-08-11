import 'package:assetmamanger/pages/tenant/customlistile.dart';
import 'package:assetmamanger/pages/tenant/tenantassets.dart';
import 'package:assetmamanger/pages/tenant/tenantcategory.dart';
import 'package:assetmamanger/pages/tenant/tenantgroups.dart';
import 'package:assetmamanger/pages/tenant/tenantsettings.dart';
import 'package:assetmamanger/pages/tenant/tenantfolders.dart';
import 'package:assetmamanger/pages/tenant/tenantusers.dart';
import 'package:flutter/material.dart';
class TenantAdminView extends StatefulWidget {
  TenantAdminView({super.key});
  @override
  _TenantAdminView createState() => _TenantAdminView();
}
class  _TenantAdminView extends State<TenantAdminView> {
  int hoveredIndex = -1;
  int tab_index = 0;
  Widget getTabContentWidget(int index){
    switch(index){
      case 0: return TenantSettings();
      case 1: return TenantFolders();
      case 2: return TenantGroups();
      case 3: return TenantAssets();
      case 4: return TenantCategory();
      case 5: return TenantUsers();
      default: return Text('Not Found Page');
    }
  }
  @override
  Widget build(BuildContext context) {
    return   Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            width : 300,
            color:Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
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
                    setState((){
                      tab_index = 0;
                    });
                  }),
                    CustomListTile(title: Text('Folders'), icon: Icon(Icons.folder),onClick: (){
                          setState((){
                            tab_index = 1;
                          });
                        }
                    ),
                    CustomListTile(title: Text('Groups'), icon: Icon(Icons.group),onClick:(){
                      setState((){
                      tab_index = 2;
                      });}),
                    CustomListTile(title: Text('Assets'), icon: Icon(Icons.assignment_outlined),onClick:(){
                      setState((){
                      tab_index = 3;
                    });}),
                    CustomListTile(title: Text('Categories'), icon: Icon(Icons.category),onClick:(){
                      setState((){
                      tab_index = 4;
                    });}),
                    CustomListTile(title: Text('Subusers'), icon: Icon(Icons.account_circle_outlined),onClick:(){
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
