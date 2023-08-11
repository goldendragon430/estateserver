import 'dart:convert';

import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/pages/tenant/categoryitem.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/models/assetTypes.dart';
import 'package:assetmamanger/models/folders.dart';
import 'package:assetmamanger/models/groups.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/models/category.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'dart:math';
class TenantCategory extends StatefulWidget {
  TenantCategory({super.key});
  @override
  _TenantCategory createState() => _TenantCategory();
}
class  _TenantCategory extends State<TenantCategory> {
  String userid = 'bdMg1tPZwEUZA1kimr8b';

  //--------------------Main Variables--------------------------------//
  List<Map<String, dynamic>> categories = [] ;
  List<AssetType> m_asset_types = [];
  List<Group> m_groups = [];
  List<Folder> m_folders = [];
  Tenant DB_instance = Tenant();

  //-------------------Search Features-------------------------------//
  List<Map<String, dynamic>> search_categories = [] ;
  TextEditingController searchEditController = TextEditingController();
  String search_str = '';

  //-------------------Add Dialog Variables--------------------------//
  String selected_folder_id  = '';
  String selected_group_id  = '';
  String selected_asset_type_id  = '';

  String category_name = '';

  List<String> m_folder_ids = [];
  List<String> m_group_ids = [];
  List<String> m_asset_type_ids = [];

  void getCategories() async{
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
            for(AssetType type in group.assetTypes!){
              m_asset_types.add(type);
            }
          }
        }
        if(m_folders.length > 0) {
          selected_folder_id = m_folder_ids[0];
        }
        updateGroupID(selected_folder_id);
        updateAssetTypeID(selected_group_id);
        updateCategories();
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
    if(m_group_ids.length > 0)
        selected_group_id = m_group_ids[0];
  }
  void updateAssetTypeID(String group_id){
    m_asset_type_ids = [];
    for(Group group in m_groups){
      if(group.id == group_id){
        for(AssetType type in group.assetTypes!){
          m_asset_type_ids.add(type.id!);
        }
      }
    }
    if(m_asset_type_ids.length > 0)
        selected_asset_type_id = m_asset_type_ids[0];
  }

  //-----------------update Asset Type data-----------------------------//
  void updateCategories(){
    setState(() {
      categories.clear();
    });
    Future.delayed(const Duration(milliseconds: 20), () {

        for (Folder folder in m_folders){
          List<Group> groups = folder.groups!;
          for (Group group in groups){
            List<AssetType> m_asset_types = group.assetTypes!;
            for(AssetType type in m_asset_types){
              List<Category> m_categories = type.categories!;
              for(Category category in m_categories){
                setState(() {
                  categories.add({
                  'folderID'    : folder.id,
                  'groupID'     : group.id,
                  'assetTypeID' : type.id,
                  'categoryData': category
                });
                });
              }
            }
          }
        }
        searchItems(search_str);
      });

  }

  //-----------------search feature-------------------------------//
  void searchItems(String val){
    setState(() {
      search_categories = [];
    });
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        for (Map<String, dynamic> dd in categories){
          Category category = dd['categoryData'];
          if(category.name!.contains(search_str) || getAssetTypeName(dd['assetTypeID']).contains(search_str)) {
            search_categories.add(dd);
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
               List<AssetType> assets = group.assetTypes!;
               for(AssetType type in assets){
                  if(type.id == selected_asset_type_id) {
                     type.categories!.add(Category(id: generateID(), name : category_name, assets: []));
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
    searchEditController.text = '';
    search_str = '';
    updateCategories();
  }

  //-----------------delete feature-------------------------------//
  void onDeleteItem(String folder_id, String group_id, String asset_type_id,String category_id) async{
    setState(() {
      for(Folder folder in m_folders){
        if(folder.id == selected_folder_id){
          List<Group> groups = folder.groups!;
          for(Group group in groups){
            if(group.id == selected_group_id){
              List<AssetType> assets = group.assetTypes!;
              for(AssetType type in assets){
                if(type.id == selected_asset_type_id) {
                   List<Category> categories =  type.categories!;
                   for(Category category in categories){
                     if(category.id == category_id){
                        categories.remove(category);
                     }
                     break;
                   }
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
    updateCategories();
  }

  //-----------------change handler -----------------------------//
  void onChangeItem(String folder_id, String group_id, String asset_type_id,String category_id, String category_name) async{
    setState(() {
      for(Folder folder in m_folders){
        if(folder.id == folder_id){
          List<Group> groups = folder.groups!;
          for(Group group in groups){
            if(group.id == group_id){
              List<AssetType> m_asset_types = group.assetTypes!;
              for(AssetType type in m_asset_types){
                if(type.id == asset_type_id) {

                  List<Category> categories = type.categories!;
                  for(Category category in categories){
                    if(category.id == category_id){
                      category.name = category_name;
                      break;
                    }
                  }

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

  String getAssetTypeName(String asset_type_id){
    for(AssetType type in m_asset_types){
      if(type.id == asset_type_id) return type.type!;
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
    getCategories();
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tile_width = (screenWidth - 300 - 100)/3;

    StatefulBuilder gradeDialog() {
      return StatefulBuilder(
        builder: (context, _setter) {
          return AlertDialog(
            title: Text('Add new category'),
            content:
            Container(
                height: 250,
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
                                  break;
                                }
                              }
                              if(m_group_ids.length > 0)
                                  selected_group_id = m_group_ids[0];

                              m_asset_type_ids = [];
                              for(Group group in m_groups){
                                if(group.id == selected_group_id){
                                  for(AssetType type in group.assetTypes!){
                                    m_asset_type_ids.add(type.id!);
                                  }
                                  break;
                                }
                              }
                              if(m_asset_type_ids.length > 0)
                                  selected_asset_type_id = m_asset_type_ids[0];


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
                              m_asset_type_ids = [];
                              for(Group group in m_groups){
                                if(group.id == selected_group_id){
                                  for(AssetType type in group.assetTypes!){
                                    m_asset_type_ids.add(type.id!);
                                  }
                                  break;
                                }
                              }
                              if(m_asset_type_ids.length > 0)
                                  selected_asset_type_id = m_asset_type_ids[0];

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
                      width: 300,
                      child:
                      DropdownButton<String>(
                        value: selected_asset_type_id,
                        padding: EdgeInsets.all(5),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _setter(() {
                              selected_asset_type_id = newValue;
                            });
                          }
                        },
                        items: m_asset_type_ids.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(getAssetTypeName(value)),
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
                                hintText: 'Category Name',
                              ),
                              onChanged: (value){
                                setState(() {
                                  category_name = value;
                                });
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
              titleText: 'TENANT Category',
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
                          onPressed: onSave,
                          child: const Text('Save Changes')),
                    ],
                  ),
                  SizedBox(height: 30),
                  Expanded(child:
                        ListView.builder(
                          itemCount: (search_categories.length/3).ceil(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> ele = search_categories[3 * index];
                            Map<String, dynamic>? ele_2 = 3 * index + 1 >= search_categories.length ? null: search_categories[3 * index + 1];
                            Map<String, dynamic>? ele_3 = 3 * index + 2 >= search_categories.length ? null: search_categories[3 * index + 2];

                            return Row(children: [
                              SizedBox(width : tile_width, child: Center(child:CategoryItem(folderID : ele['folderID'],groupID: ele['groupID'],categoryID: (ele['categoryData'] as Category).id,assetTypeName: getAssetTypeName(ele['assetTypeID']),  assetTypeID: ele['assetTypeID'], categoryName : (ele['categoryData'] as Category).name, onChange: onChangeItem, onDelete: onDeleteItem ))) ,
                              if(ele_2 != null)
                                SizedBox(width : tile_width, child: Center(child:CategoryItem(folderID : ele_2['folderID'],groupID: ele_2['groupID'],categoryID: (ele_2['categoryData'] as Category).id,assetTypeName: getAssetTypeName(ele_2['assetTypeID']) , assetTypeID: ele_2['assetTypeID'], categoryName : (ele_2['categoryData'] as Category).name, onChange: onChangeItem, onDelete: onDeleteItem ))) ,
                              if(ele_3 != null)
                                SizedBox(width : tile_width, child: Center(child:CategoryItem(folderID : ele_3['folderID'],groupID: ele_3['groupID'],categoryID: (ele_3['categoryData'] as Category).id,assetTypeName: getAssetTypeName(ele_3['assetTypeID']), assetTypeID: ele_3['assetTypeID'], categoryName : (ele_3['categoryData'] as Category).name, onChange: onChangeItem, onDelete: onDeleteItem ))) ,
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
