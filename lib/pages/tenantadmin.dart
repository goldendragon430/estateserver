import 'dart:convert';

import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/pages/tenant/assetdetail.dart';
import 'package:assetmamanger/pages/tenant/customlistile.dart';
import 'package:assetmamanger/pages/tenant/tenantassets.dart';
import 'package:assetmamanger/pages/tenant/tenantcategory.dart';
import 'package:assetmamanger/pages/tenant/tenantorganization.dart';
import 'package:assetmamanger/pages/tenant/tenantsettings.dart';
import 'package:assetmamanger/pages/tenant/tenantusers.dart';
import 'package:assetmamanger/utils/global.dart';

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

  bool new_flag = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //
    // String? userDataString =  getStorage('user');
    // Map<String, dynamic>? data =  jsonDecode(userDataString!);
    // setState(() {
    //   userid = data?['id'];
    // });


  }
  Widget getTabContentWidget(int index){
    switch(index){
      case 0:
        return TenantSettings();
      case 1:
        return TenantAssets();
      case 2:
        return TenantCategory();
      case 3:
        return AssetDetail();
      case 4:
        return TenantUser();
      case 5:
        return OrganizationView();
      default: return Text('Not Found Page');
    }
  }
  Widget getLeftMenu(bool mode) {

       return  ListView(
      children: <Widget>[
        CustomListTile(isMobileMode: mode, title: Text('Settings'), icon: Icon(Icons.settings),onClick:(){
          widget.onTitleSelect('Settings');
          setState((){
            tab_index = 0;
          });
        }),
        CustomListTile(isMobileMode: mode, title: Text('Asset Types'), icon: Icon(Icons.folder),onClick: (){
          widget.onTitleSelect('Asset Types');
          setState((){
            tab_index = 1;
          });
        }
        ),
        CustomListTile(isMobileMode: mode, title: Text('Asset Categories'), icon: Icon(Icons.group),onClick:(){
          widget.onTitleSelect('Asset Categories');
          setState((){
            tab_index = 2;
          });}),
        CustomListTile(isMobileMode: mode, title: Text('Asset Organization'), icon: Icon(Icons.account_balance_rounded),onClick:(){
          widget.onTitleSelect('Organization');
          setState((){
            tab_index = 5;
          });}),
        CustomListTile(isMobileMode: mode, title: Text('Assets'), icon: Icon(Icons.assignment_outlined),onClick:(){
          widget.onTitleSelect('Assets');
          setState((){
            tab_index = 3;
          });}),
        CustomListTile(isMobileMode: mode, title: Text('Sub Users'), icon: Icon(Icons.category),onClick:(){
          widget.onTitleSelect('Subusers');
          setState((){
            tab_index = 4;
          });})
      ],
    );

  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool is_Mobile_Mode = screenWidth < 1260 || tab_index == 3;
    return   Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            width : is_Mobile_Mode  ? 90 : 250,
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
                Expanded(child: getLeftMenu(is_Mobile_Mode)),

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
