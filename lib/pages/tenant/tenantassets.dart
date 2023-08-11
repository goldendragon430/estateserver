import 'dart:convert';

import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/models/assetTypes.dart';
import 'package:assetmamanger/models/folders.dart';
import 'package:assetmamanger/models/groups.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/pages/tenant/assetitem.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class TenantAssets extends StatefulWidget {
  TenantAssets({super.key});
  @override
  _TenantAssets createState() => _TenantAssets();
}
class  _TenantAssets extends State<TenantAssets> {
  String userid = 'bdMg1tPZwEUZA1kimr8b';

  //--------------------Main Variables--------------------------------//
  List<Map<String, dynamic>> assetTypes = [] ;
  List<Group> m_groups = [];
  List<Folder> m_folders = [];
  Tenant DB_instance = Tenant();

  //-------------------Search Features-------------------------------//
  List<Map<String, dynamic>> search_asset_types = [] ;
  TextEditingController searchEditController = TextEditingController();
  String search_str = '';

  //-------------------Add Dialog Variables--------------------------//
  String selected_folder_id  = '';
  String selected_group_id  = '';
  String asset_type_name = '';

  List<String> m_folder_ids = [];
  List<String> m_group_ids = [];

  void getAssetTypes() async{
    Tenant? result =  await TenantService().getTenantDetails(userid);
    if(result != null){
      setState(() {

        //-------------------Load Folder Dropdown Data-------------------------//
        m_folder_ids = [];

        m_folders = result.folders!;
        for (Folder folder in m_folders){
          m_folder_ids.add(folder.id!);
          for(Group group in folder.groups!){
            m_groups.add(group);
          }
        }
        if(m_folders.length > 0) {
          selected_folder_id = m_folder_ids[0];
        }
        updateGroupID(selected_folder_id);
        updateAssetTypes();
        //-----------------Load Tenant Data---------------------------------------//
        DB_instance = result;
      });
    }
  }
  void updateGroupID(String folder_id){
    m_group_ids = [];
    for(Folder folder in m_folders){
      if(folder.id == folder_id){
        for(Group group in folder.groups!){
          m_group_ids.add(group.id!);
        }
      }
    }
    if(m_group_ids.length > 0) {
      selected_group_id = m_group_ids[0];
    }
  }
  //-----------------update Asset Type data-----------------------------//
  void updateAssetTypes(){
    setState(() {
      assetTypes.clear();
    });
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        for (Folder folder in m_folders){
          List<Group> groups = folder.groups!;
          for (Group group in groups){
            List<AssetType> m_asset_types = group.assetTypes!;
            for(AssetType type in m_asset_types){
              assetTypes.add({
                'folderID'      : folder.id,
                'groupID'       : group.id,
                'assetTypeData' : type
              });
            }
          }
        }
        searchItems(search_str);
      });
    });
  }

  //-----------------search feature-------------------------------//
  void searchItems(String val){
    setState(() {
      search_asset_types = [];
    });
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        for (Map<String, dynamic> dd in assetTypes){
          AssetType type = dd['assetTypeData'];
          if(type.type!.contains(search_str)) {
            search_asset_types.add(dd);
          }
        }
      });
    });

  }

  //-----------------add features-------------------------------//
  void onAdd() async{
    setState(() {
      for(Folder folder in m_folders){
         if(folder.id == selected_folder_id){
           List<Group> groups = folder.groups!;
           for(Group group in groups){
             if(group.id == selected_group_id){
                group.assetTypes!.add(AssetType(id:generateID(),type:asset_type_name,categories: []));
                break;
             }
           }
         break;
         }
      }
    });
    searchEditController.text = '';
    search_str = '';
    updateAssetTypes();
  }

  //-----------------delete feature-------------------------------//
  void onDeleteItem(String folder_id, String group_id, String asset_type_id) async{
    setState(() {
      for(Folder folder in m_folders){
        if(folder.id == folder_id){
          List<Group> groups = folder.groups!;
          for(Group group in groups){
            if(group.id == group_id){
              List<AssetType> m_asset_types = group.assetTypes!;
              for(AssetType type in m_asset_types){
                if(type.id == asset_type_id) {
                  m_asset_types.remove(type);
                  break;
                }
              }
            break;
            }
          }
        break;
        }
      }
    });
    updateAssetTypes();
  }

  //-----------------change handler -----------------------------//
  void onChangeItem(String folder_id, String group_id, String asset_type_id, String asset_type_name) async{
    setState(() {
      for(Folder folder in m_folders){
        if(folder.id == folder_id){
          List<Group> groups = folder.groups!;
          for(Group group in groups){
            if(group.id == group_id){
              List<AssetType> m_asset_types = group.assetTypes!;
              for(AssetType type in m_asset_types){
                if(type.id == asset_type_id) {
                  type.type = asset_type_name;
                  break;
                }

              }
              break;
            }
          }
          break;
        }
      }
    });

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

  String getFolderName(String folder_id){
    for(Folder folder in m_folders){
      if(folder.id == folder_id) return folder.name!;
    }
    return 'No Selected';
  }

  String getGroupName(String group_id){
    for(Group group in m_groups){
      if(group.id == group_id) return group.name!;
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
    getAssetTypes();
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tile_width = (screenWidth - 300 - 100)/3;

    StatefulBuilder gradeDialog() {
      return StatefulBuilder(
        builder: (context, _setter) {
          return AlertDialog(
            title: Text('Add new asset type'),
            content:
            Container(
                height: 200,
                child: Column(children: [
                  SizedBox(
                      width: 300,
                      child:
                      DropdownButton<String>(
                        value: selected_folder_id,
                        padding: EdgeInsets.all(5),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _setter(() {
                              selected_folder_id = newValue;
                              m_group_ids = [];
                              for(Folder folder in m_folders){
                                if(folder.id == selected_folder_id){
                                  for(Group group in folder.groups!){
                                    m_group_ids.add(group.id!);
                                  }
                                }
                              }
                              if(m_group_ids.length > 0)
                                  selected_group_id = m_group_ids[0];
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
                      width: 300,
                      child:
                      DropdownButton<String>(
                        value: selected_group_id,
                        padding: EdgeInsets.all(5),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _setter(() {
                              selected_group_id = newValue;
                            });
                          }
                        },
                        items: m_group_ids.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(getGroupName(value)),
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
                                hintText: 'Asset Type Name',
                              ),
                              onChanged: (value){
                                asset_type_name = value;
                              }
                          )
                      )
                  )
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

    return   Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left:30),
      child: Column(
        children: [
          Expanded(child: TitledContainer(
              titleText: 'TENANT Assets',
              idden: 10,
              child:
              Column(
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
                          onPressed: () {
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
                          onPressed:onSave,
                          child: const Text('Save Changes')),
                    ],
                  ),
                  SizedBox(height: 30),
                  Expanded(child:
                      ListView.builder(
                        itemCount: (search_asset_types.length/3).ceil(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> ele = search_asset_types[3 * index];
                          Map<String, dynamic>? ele_2 = 3 * index + 1 >= search_asset_types.length ? null: search_asset_types[3 * index + 1];
                          Map<String, dynamic>? ele_3 = 3 * index + 2 >= search_asset_types.length ? null: search_asset_types[3 * index + 2];

                          return Row(children: [
                            SizedBox(width : tile_width, child: Center(child:AssetItem(folderID : ele['folderID'],groupID: ele['groupID'], assetTypeID: (ele['assetTypeData'] as AssetType).id, assetTypeName : (ele['assetTypeData'] as AssetType).type, onChange: onChangeItem, onDelete: onDeleteItem ))) ,
                            if(ele_2 != null)
                              SizedBox(width : tile_width, child: Center(child:AssetItem(folderID : ele_2['folderID'],groupID: ele_2['groupID'], assetTypeID: (ele_2['assetTypeData'] as AssetType).id, assetTypeName : (ele_2['assetTypeData'] as AssetType).type, onChange: onChangeItem, onDelete: onDeleteItem ))) ,
                            if(ele_3 != null)
                              SizedBox(width : tile_width, child: Center(child:AssetItem(folderID : ele_3['folderID'],groupID: ele_3['groupID'], assetTypeID: (ele_3['assetTypeData'] as AssetType).id, assetTypeName : (ele_3['assetTypeData'] as AssetType).type, onChange: onChangeItem, onDelete: onDeleteItem ))) ,
                          ]);
                        },
                      )

                  )
                ],
              )

          ))
        ],
      ),
    );
  }
}
