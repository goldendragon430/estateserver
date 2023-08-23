/*
* Class Logic
* Tenant is Total DB instance.
* groups variable is a main variable to show list.
* search_groups are clone of groups where search condition is true.
* If user delete, change and add new data, groups and m_folders variable are changed.
* m_folders is db and groups is for displaying.
* */

import 'dart:convert';
import 'dart:typed_data';

import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/models/folders.dart';
import 'package:assetmamanger/models/groups.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/pages/tenant/groupitem.dart';
import 'package:image_picker_web/image_picker_web.dart';

class TenantGroups extends StatefulWidget {
  TenantGroups({super.key});
  @override
  _TenantGroups createState() => _TenantGroups();
}
class  _TenantGroups extends State<TenantGroups> {

  String userid = 'bdMg1tPZwEUZA1kimr8b';

  //--------------------Main Variables--------------------------------//
  List<Map<String, dynamic>> groups = [] ;
  List<Folder> m_folders = [];
  Tenant DB_instance = Tenant();

  //-------------------Search Features-------------------------------//
  List<Map<String, dynamic>> search_groups = [] ;
  TextEditingController searchEditController = TextEditingController();
  String search_str = '';

  //-------------------Add Dialog Variables--------------------------//
  String selectedValue  = '';
  bool   active_group = false;
  String group_name = '';
  Uint8List? new_logo = null;
  List<String> m_folder_ids = [];


  void getGroups()async{
    Tenant? result =  await TenantService().getTenantDetails(userid);
    if(result != null){
      setState(() {

        //-------------------Load Folder Dropdown Data-------------------------//
        m_folder_ids = [];
        m_folders = result.folders!;
        for (Folder folder in m_folders){
          m_folder_ids.add(folder.id!);
        }
        if(m_folders.length > 0) {
          selectedValue = m_folder_ids[0];
        }

        //-----------------Load Group List--------------------------------------//
         updateGroups();

        //-----------------Load Tenant Data---------------------------------------//
        DB_instance = result;
      });
    }
  }

  //-----------------update Group data-----------------------------//
  void updateGroups(){
    setState(() {
      groups.clear();
    });
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        for (Folder folder in m_folders){
          List<Group> m_groups = folder.groups!;
          for (Group group in m_groups){
            groups.add(
                {
                  'folderName' :  folder.name!,
                  'groupData'  :  group,
                  'folderID'   :  folder.id
                });
          }
        }
        searchItems(search_str);
      });
    });
  }

  //-----------------search feature-------------------------------//
  void searchItems(String val){
    setState(() {
      search_groups = [];
    });
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        for (Map<String, dynamic> dd in groups){
          String folderName = dd['folderName'];
          Group group = dd['groupData'];
          if(folderName.contains(search_str) || group.name!.contains(search_str)) {
            search_groups.add(dd);
          }
        }
      });


    });

  }

  //-----------------add features-------------------------------//
  void onAdd() async{
    String url = '';
    if(new_logo != null)
      url = await uploadFile(new_logo!);
    else url = '';

    setState(() {
      for(Folder folder in m_folders){
        if(folder.id == selectedValue){
          folder.groups?.add(Group(logo: url, id : generateID(), name: group_name, assetTypes: [], active:folder.unlimited_group,created_date: DateTime.now() ));
        }
      }
    });
    searchEditController.text = '';
    search_str = '';
    updateGroups();

  }

  //-----------------save features-------------------------------//
  void onSave() async{
    DB_instance.folders = m_folders;
    bool isOk = await TenantService().createTenantDetails(DB_instance);
    if(isOk){
      showSuccess('Success');
    }else{
      showError('Error');
    }
  }

  //-----------------delete feature-------------------------------//
  void onDeleteItem(String folder_id, String id) async{
    for(Folder folder in m_folders){
      if(folder.id == folder_id){
        List<Group> groups = folder.groups!;
        for(Group group in groups){
          if(group.id == id) {
            groups.remove(group);
                break;
          }
        }
        break;
      }
    }
    updateGroups();

  }

  //-----------------change handler -----------------------------//
  void onChangeItem(String folder_id, String id, String group_name, bool group_active, String logo ) async{
    setState(() {
      for(Folder folder in m_folders){
        if(folder.id == folder_id){
          List<Group> groups = folder.groups!;
          for(Group group in groups){
            if(group.id == id) {
              group.name = group_name;
              group.active = group_active;
              group.logo = logo;
              break;
            }
          }
          break;
        }
      }
    });

  }

  //-----------------Convert folder id to folder name -----------//
  String getFolderName (String folderID){
    for(Folder folder in m_folders){
      if(folder.id == folderID) return folder.name!;
    }
    return 'No Selected';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String? userDataString =  getStorage('user');
    Map<String, dynamic>? data =  jsonDecode(userDataString!);
    setState(() {
      userid = data?['id'];
    });

    getGroups();
  }
  StatefulBuilder gradeDialog() {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text('Add new group'),
          content:

          Container(
              height: 350,
              child: Column(children: [
                SizedBox(
                    width: 300,
                    child: GestureDetector(
                      onTap: ()async{
                        Uint8List? data =  await ImagePickerWeb.getImageAsBytes();
                        _setter(() {
                          new_logo = data;
                        });
                      },
                      child: Center(child : new_logo == null ? Image.asset('assets/images/group.png',width: 188,height: 188) : Image.memory(new_logo!,width: 188,height: 188))
                    )

                ),
                SizedBox(
                    width: 300,
                    child:
                    DropdownButton<String>(
                      value: selectedValue,
                      padding: EdgeInsets.all(5),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _setter(() {
                            selectedValue = newValue;
                          });
                        }
                      },
                      items: m_folder_ids.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getFolderName(value)),
                        );
                      }).toList(),
                    )
                ),
                SizedBox(
                    height: 35,
                    width: 300,
                    child: Container(
                        margin:EdgeInsets.only(left:4),
                        child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Group Name',
                            ),
                            onChanged: (value){
                              group_name = value;
                            }
                        )
                    )
                ),
              ])
          ),

          actions: [
            ElevatedButton(
              onPressed:(){
                onAdd();
                Navigator.pop(context);
              },
              child: Text('Create'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  Widget getLargeWidget(context){
    final screenWidth = MediaQuery.of(context).size.width;
    final tile_width = (screenWidth - 300 - 100)/3;
    return Column(
      children: [
        Row(
          children: [
            Container(
                margin: EdgeInsets.only(top: 10,bottom:10),
                child: SizedBox(
                    height: 45,
                    width: 400,
                    child:
                    Container(
                      margin:EdgeInsets.only(left:20),
                      child: TextField(
                        controller: searchEditController,
                        onChanged: (value) {
                          setState(() {
                            searchItems(value);
                            search_str = value;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'Search...',
                            // Add a clear button to the search bar
                            suffixIcon:  Icon(Icons.clear),
                            // Add a search icon or button to the search bar
                            prefixIcon:  Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            fillColor: Colors.white,
                            filled: true
                        ),
                      ),
                    )

                )
            ),
            SizedBox(width:20),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    padding:MaterialStateProperty.all(const EdgeInsets.all(20)),

                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) => gradeDialog()  ,
                  );
                },
                child: const Text('Add')),
            SizedBox(width:20),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                    padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                onPressed: onSave,
                child: const Text('Save Changes')),
          ],
        ),
        SizedBox(height: 30),
        Expanded(child:
        ListView.builder(
          itemCount: (search_groups.length/3).ceil(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> ele = search_groups[3 * index];
            Map<String, dynamic>? ele_2 = 3 * index + 1 >= search_groups.length ? null: search_groups[3 * index + 1];
            Map<String, dynamic>? ele_3 = 3 * index + 2 >= search_groups.length ? null: search_groups[3 * index + 2];
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              SizedBox(width : tile_width, child: Center(child:GroupItem(logo : (ele['groupData'] as Group).logo,  groupID: (ele['groupData'] as Group).id, folderName : ele['folderName'],folderID: ele['folderID'] ,  groupName : (ele['groupData'] as Group).name, groupActive : (ele['groupData'] as Group).active, onChange: onChangeItem, onDelete: onDeleteItem ))) ,
              ele_2 != null ? SizedBox(width : tile_width, child: Center(child:GroupItem(logo : (ele_2['groupData'] as Group).logo, groupID: (ele_2['groupData'] as Group).id, folderName : ele_2['folderName'],folderID: ele_2['folderID'] ,  groupName : (ele_2['groupData'] as Group).name, groupActive : (ele_2['groupData'] as Group).active, onChange: onChangeItem, onDelete: onDeleteItem ))) : SizedBox(width: tile_width),
              ele_3 != null ? SizedBox(width : tile_width, child: Center(child:GroupItem(logo : (ele_3['groupData'] as Group).logo, groupID: (ele_3['groupData'] as Group).id, folderName : ele_3['folderName'],folderID: ele_3['folderID'] ,  groupName : (ele_3['groupData'] as Group).name, groupActive : (ele_3['groupData'] as Group).active, onChange: onChangeItem, onDelete: onDeleteItem )))  : SizedBox(width: tile_width),
            ]);
          },
        )
        )
      ],
    );
  }
  Widget getMediumWidget(context){
    final screenWidth = MediaQuery.of(context).size.width;
    final tile_width = (screenWidth - 200)/2;
    return Column(
      children: [
        Row(
          children: [
            Container(
                margin: EdgeInsets.only(top: 10,bottom:10),
                child: SizedBox(
                    height: 45,
                    width: 400,
                    child:
                    Container(
                      margin:EdgeInsets.only(left:20),
                      child: TextField(
                        controller: searchEditController,
                        onChanged: (value) {
                          setState(() {
                            searchItems(value);
                            search_str = value;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'Search...',
                            // Add a clear button to the search bar
                            suffixIcon:  Icon(Icons.clear),
                            // Add a search icon or button to the search bar
                            prefixIcon:  Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            fillColor: Colors.white,
                            filled: true
                        ),
                      ),
                    )

                )
            ),
            SizedBox(width:20),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    padding:MaterialStateProperty.all(const EdgeInsets.all(20)),

                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) => gradeDialog()  ,
                  );
                },
                child: const Text('Add')),
            SizedBox(width:20),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                    padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                onPressed: onSave,
                child: const Text('Save Changes')),
          ],
        ),
        SizedBox(height: 30),
        Expanded(child:
          ListView.builder(
            itemCount: (search_groups.length/2).ceil(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> ele = search_groups[2 * index];
              Map<String, dynamic>? ele_2 = 2 * index + 1 >= search_groups.length ? null: search_groups[2 * index + 1];

              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                SizedBox(width : tile_width, child: Center(child:GroupItem(logo : (ele['groupData'] as Group).logo, groupID: (ele['groupData'] as Group).id, folderName : ele['folderName'],folderID: ele['folderID'] ,  groupName : (ele['groupData'] as Group).name, groupActive : (ele['groupData'] as Group).active, onChange: onChangeItem, onDelete: onDeleteItem ))) ,
                ele_2 != null ? SizedBox(width : tile_width, child: Center(child:GroupItem(logo : (ele_2['groupData'] as Group).logo, groupID: (ele_2['groupData'] as Group).id, folderName : ele_2['folderName'],folderID: ele_2['folderID'] ,  groupName : (ele_2['groupData'] as Group).name, groupActive : (ele_2['groupData'] as Group).active, onChange: onChangeItem, onDelete: onDeleteItem ))) : SizedBox(width: tile_width) ,
              ]);
            },
          )
        )
      ],
    );
  }
  Widget getSmallWidget(context){
    final screenWidth = MediaQuery.of(context).size.width;
    final tile_width = (screenWidth - 200);
    return Column(
      children: [
        Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 10,bottom:10),
                child: SizedBox(
                    height: 45,
                    width: tile_width,
                    child:
                    Container(
                      margin:EdgeInsets.only(left:0),
                      child: TextField(
                        controller: searchEditController,
                        onChanged: (value) {
                          setState(() {
                            searchItems(value);
                            search_str = value;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'Search...',
                            // Add a clear button to the search bar
                            suffixIcon:  Icon(Icons.clear),
                            // Add a search icon or button to the search bar
                            prefixIcon:  Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            fillColor: Colors.white,
                            filled: true
                        ),
                      ),
                    )

                )
            ),
            SizedBox(height:10),
            Container(width : tile_width,child : ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    padding:MaterialStateProperty.all(const EdgeInsets.all(20)),

                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) => gradeDialog()  ,
                  );
                },
                child: const Text('Add'))),
            SizedBox(height:10),
            Container(width : tile_width, child:ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                    padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                onPressed: onSave,
                child: const Text('Save Changes')) ),
          ],
        ),
        SizedBox(height: 30),
        Expanded(child:
        ListView.builder(
          itemCount: search_groups.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> ele = search_groups[index];
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              SizedBox(width : tile_width, child: Center(child:GroupItem(logo : (ele['groupData'] as Group).logo, groupID: (ele['groupData'] as Group).id, folderName : ele['folderName'],folderID: ele['folderID'] ,  groupName : (ele['groupData'] as Group).name, groupActive : (ele['groupData'] as Group).active, onChange: onChangeItem, onDelete: onDeleteItem ))) ,
            ]);
          },
        )
        )
      ],
    );
  }
  Widget getResponsiveWidget(context){
    final screenWidth = MediaQuery.of(context).size.width;
    if(screenWidth > 1260) return getLargeWidget(context);
    else if(screenWidth > 800) return getMediumWidget(context);
    else return getSmallWidget(context);
  }
  @override
  Widget build(BuildContext context) {


    return   Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left:0),
      child: Column(
        children: [
          Expanded(child: TitledContainer(
              titleText: 'TENANT Groups',
              idden: 10,
              child:  getResponsiveWidget(context)
          ))
        ],
      ),
    );
  }
}
