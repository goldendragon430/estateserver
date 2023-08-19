import 'dart:convert';
import 'dart:html';

import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/models/assetTypes.dart';
import 'package:assetmamanger/models/assets.dart';
import 'package:assetmamanger/models/folders.dart';
import 'package:assetmamanger/models/groups.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/pages/user/userassetitem.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/tenants.dart';

class UserView extends StatefulWidget {
  UserView({super.key});
  @override
  _UserView createState() => _UserView();
}

class  _UserView extends State<UserView> {

//------------------UI Effect---------------------------//
  int hoveredIndex = -1;
  int hoveredIndex2 = -1;
  int hoveredIndex3 = -1;
  List<String> actions = <String>['Gallery View', 'Grid View', 'Stats View', 'Export'];
  List<Icon> acionIcons = <Icon>[Icon(Icons.calendar_month),Icon(Icons.grid_4x4_outlined),Icon(Icons.show_chart),Icon(Icons.file_copy)];
  List<PlutoColumn> columns = [
    /// Text Column definition
    PlutoColumn(
      title: 'Asset',
      field: 'asset',
      type: PlutoColumnType.text(),
    ),
    /// Number Column definition
    PlutoColumn(
      title: 'Category',
      field: 'category',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    /// Datetime Column definition
    PlutoColumn(
      title: 'Registered',
      field: 'registered',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Last Inspected',
      field: 'inspected',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Comment',
      field: 'comment',
      type: PlutoColumnType.text(),
    )
  ];

  List<PlutoRow> rows = [];
//-------------------Dropdown values------------------//

  String selected_folder_id = '';
  String selected_group_id = '';
  String selected_asset_type_id = '';
  String selected_category_id = '';

//-------------------Search Variable--------------------//

//-------------------Listview variables----------------//

  String user_id = 'bdMg1tPZwEUZA1kimr8b'; // parent user's id
  Tenant m_tenant = Tenant(); // Parent DB's Data
  List<Folder> m_folders = [];
  List<Group>  m_groups = [];
  List<AssetType> m_asset_types = [];
  List<Category> m_categories = [];
  List<Asset>  m_assets = [];

  List<String> m_folder_ids = [];
  List<String> m_category_ids = [];
  late final PlutoGridStateManager stateManager;

//-----------------------------------------------------------//
  TextEditingController searchController = TextEditingController();
  String search_str = '';
  void fetchData() async{

    // String? val =  getStorage('user');
    // Map<String, dynamic>? data =  jsonDecode(val!);
    // print(data);
    // if(data?['parent_user'] != null) {
    //   setState(() {
    //     user_id = data?['parent_user'];
    //   });
    // }
    // else{
    //   return;
    // }

    Tenant? result =  await TenantService().getTenantDetails(user_id);

    if(result != null){
      setState(() {
        m_tenant = result;
        m_folder_ids = [];
        m_folders = result.folders!;
        for (Folder folder in m_folders){
          m_folder_ids.add(folder.id!);
        }
        if(m_folder_ids.length > 0) {
          selected_folder_id = m_folder_ids[0];
          onChangeFolder(m_folder_ids[0]);
        }
      });
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
  String getCategoryName(String category_id){
    for(Category category in m_categories){
      if(category.id == category_id) return category.name!;
    }
    return 'No Selected';
  }
  void onChangeFolder(String new_folder_id){
    for(Folder folder in m_folders){
      if(folder.id == new_folder_id){
        setState(() {
          m_groups = folder.groups!;
          if(m_groups.length > 0){
            selected_group_id = m_groups[0].id!;
            m_asset_types = m_groups[0]!.assetTypes!;
          }
          if(m_asset_types.length > 0){
            selected_asset_type_id = m_asset_types[0].id!;
            m_categories = m_asset_types[0]!.categories!;
            m_category_ids = [];
            for(Category category in m_categories){
              m_category_ids.add(category.id!);
            }
            if(m_category_ids.length > 0) {
              selected_category_id = m_category_ids[0];
              m_assets = m_categories![0].assets!;
              updateAssetsView();
            } else
              selected_category_id = '';
          }
        });
        break;
      }
    }
  }
  void onChangeGroup(String new_group_id){
    for(Group group in m_groups){
      if(group.id == new_group_id){
        setState(() {
          m_asset_types = group.assetTypes!;
          if(m_asset_types.length > 0){
            selected_asset_type_id = m_asset_types[0].id!;
            m_categories = m_asset_types[0].categories!;
            m_category_ids = [];
            for(Category category in m_categories){
              m_category_ids.add(category.id!);
            }
            if(m_category_ids.length > 0) {
              selected_category_id = m_category_ids[0];
              m_assets = m_categories![0].assets!;
              updateAssetsView();
            } else
              selected_category_id = '';
          }
        });
        break;
      }
    }
  }
  void onChangeAssetType(String new_asset_type_id){
    for(AssetType type in m_asset_types){
      if(type.id == new_asset_type_id){
        setState(() {
          m_categories = type.categories!;
          m_category_ids = [];
          for(Category category in m_categories){
            m_category_ids.add(category.id!);
          }
          m_assets = [];
          if(m_category_ids.length > 0) {
            selected_category_id = m_category_ids[0];
            m_assets = m_categories![0].assets!;
            updateAssetsView();
          } else {
            selected_category_id = '';
            stateManager.removeAllRows();
          }
        });
        break;
      }
    }
  }
  void onChangeCategory(String category_id){

    for(Category category in m_categories){
      if(category.id == category_id){
        setState(() {
          m_assets = category.assets!;
          updateAssetsView();
        });
        break;
      }
    }
  }
  void onAdd(){
    // setState(() {
    //   for(Category category in m_categories){
    //     if(category.id == selected_category_id){
    //       Asset asset = Asset(id: generateID(), name : 'New Asset',acquired_date: DateTime(2023,1,1),last_inspection_date: DateTime(2023,1,1),comment: '',inspections: []);
    //       category.assets!.add(asset);
    //       break;
    //     }
    //   }
    // });
  }
  void onSave() async{
    // bool isOk = await TenantService().createTenantDetails(m_tenant);
    // if(isOk){
    //   showSuccess('Success');
    // }else{
    //   showError('Error');
    // }
  }
  void updateAssetsView(){
    setState(() {
      rows = [];
      stateManager.removeAllRows();

      for(Asset asset in m_assets){
        rows.add(PlutoRow(cells: {
                'asset': PlutoCell(value: getAssetTypeName(selected_asset_type_id)),
                'category': PlutoCell(value: getCategoryName(selected_category_id)),
                'name': PlutoCell(value: asset.name),
                'registered': PlutoCell(value: asset.created_date),
                'inspected': PlutoCell(value: ''),
                'comment'  : PlutoCell(value: asset.comment)
              }));
      }
      stateManager.insertRows(0, rows);
    });
  }
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void search(){

  }

  @override
  Widget build(BuildContext context) {
    
    final screenWidth = MediaQuery.of(context).size.width;
    return   Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            width : 200,
            color:Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top:10),
                  child:  Text('Folders',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  width: 250,
                  margin: EdgeInsets.only(top: 10,bottom: 20),
                  child: DropdownButton<String>(
                    value: selected_folder_id,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selected_folder_id = newValue;
                          onChangeFolder(newValue);
                        });
                      }
                    },
                    items: m_folder_ids.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Image.asset('assets/images/folder.png',width: 30, height: 30),
                            SizedBox(width: 10),
                            Text(getFolderName(value))
                          ]
                        )
                      );
                    }).toList(),
                  )
                ),
                Expanded(child: ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: m_groups.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                         setState(() {
                           selected_group_id = m_groups[index].id!;
                           onChangeGroup(m_groups[index].id!);
                         });
                      },
                      child: MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            hoveredIndex = index;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            hoveredIndex = -1;
                          });
                        },

                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 40,
                          color: hoveredIndex == index ? Color.fromRGBO(150, 150, 150, 0.2) : Colors.white,
                          child: Row(
                            children: [
                               Image.asset('assets/images/group.png'),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text('${m_groups[index].name}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ],
            )
        ),
        Container(
            width : 200,
            color:Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top:10),
                  child:  Text('Asset Types',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                // SizedBox(height: 16),
                // SizedBox(
                //     height: 35,
                //     width: 250,
                //     child:
                //     Container(
                //         margin:EdgeInsets.only(left:0),
                //         child: TextField(
                //           controller: assetTypeSearchController,
                //           textAlign: TextAlign.center,
                //           decoration: InputDecoration(
                //             hintText: 'Search Asset Type',
                //           ),
                //           onChanged: (value){
                //             setState(() {
                //               asset_type_search = value;
                //             });
                //           },
                //         )
                //     )
                //
                // ),
                Expanded(child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: m_asset_types.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_asset_type_id = m_asset_types[index].id!;
                          onChangeAssetType(m_asset_types[index].id!);
                        });
                       },
                      child: MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            hoveredIndex2 = index;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            hoveredIndex2 = -1;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 40,
                          color: hoveredIndex2 == index ? Color.fromRGBO(150, 150,150,0.2) : Colors.white,
                          child: Row(
                            children: [
                              Image.asset('assets/images/asset.png'),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text('${m_asset_types[index].type}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ],
            )
        ),
        Expanded(
            child:
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(left:30),
              child: Column(
                children: [
                  TitledContainer(
                      titleText: '',
                      idden: 10,
                      child: Row(
                        children: [
                          Container(
                              width: 200,
                              margin: EdgeInsets.only(top: 10,bottom: 10),
                              child: DropdownButton<String>(
                                value: selected_category_id,
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selected_category_id = newValue;
                                      onChangeCategory(selected_category_id);
                                    });
                                  }
                                },
                                items:  m_category_ids.length > 0 ?
                                            m_category_ids.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Row(children: [
                                                  Image.asset('assets/images/category.png',width: 30, height: 30),
                                                  SizedBox(width: 10),
                                                  Text(getCategoryName(value))
                                                ]),
                                              );
                                            }).toList():
                                          [
                                            DropdownMenuItem<String>(
                                              value: '',
                                              child: Row(children: [
                                                Image.asset('assets/images/category.png',width: 30, height: 30),
                                                SizedBox(width: 10),
                                                Text('No Category')
                                              ]),
                                            )
                                          ]

                              )
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10,bottom:10),
                              child: SizedBox(
                                  height: 45,
                                  width: screenWidth - 1070,
                                  child:
                                  Container(

                                    margin:EdgeInsets.only(left:20),
                                    child: TextField(
                                      controller: searchController,
                                      onChanged: (value) {
                                        setState(() {
                                          search_str = value;
                                          search();
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
                          )
                          // ,
                          // SizedBox(width:20),
                          // ElevatedButton(
                          //     style: ButtonStyle(
                          //         backgroundColor: MaterialStateProperty.all(Colors.green),
                          //         padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                          //
                          //         textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                          //     onPressed: onAdd,
                          //     child: const Text('Add')),
                          // SizedBox(width:20),
                          // ElevatedButton(
                          //     style: ButtonStyle(
                          //         backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                          //         padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                          //         textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                          //     onPressed: onSave,
                          //     child: const Text('Save Changes')),
                        ],
                      )
                  ),
                  SizedBox(height: 10),
                  Expanded(child: TitledContainer(
                      titleText: 'Grid View',
                      idden: 10,
                      child:PlutoGrid(
                          columns: columns,
                          rows: rows,
                          onChanged: (PlutoGridOnChangedEvent event) {
                            print(event);
                          },
                        onLoaded: (PlutoGridOnLoadedEvent event) {
                          setState(() {
                            stateManager = event.stateManager;
                            stateManager.setShowColumnFilter(false);
                          });
                          },
                      )
                  )
                  ),
                  SizedBox(height: 10),
                  Expanded(child: TitledContainer(
                          titleText: 'Gallery View',
                          idden: 10,
                          child : ListView.builder(
                                itemCount:  (m_assets.length/2).ceil(),
                                shrinkWrap: true, ///////////////////////Use This Line
                                itemBuilder: (BuildContext context, int index) {
                                  Asset asset = m_assets[2 * index];
                                  Asset? asset_2 = 2 * index + 1 >= m_assets.length ? null: m_assets[2 * index + 1];
                                  return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          UserAssetItem(asset_name: asset.name,asset_type: getAssetTypeName(selected_asset_type_id),category: getCategoryName(selected_category_id),last_inspected: asset.last_inspection_date.toString()),
                                          if(asset_2 != null)
                                            UserAssetItem(asset_name: asset_2.name,asset_type: getAssetTypeName(selected_asset_type_id),category: getCategoryName(selected_category_id),last_inspected: asset_2.last_inspection_date.toString()),
                                        ],
                                      );

                                },
                              )

                  )
                  ),
                ],
              ),
            )
        ),
        Container(
            width : 150,
            color:Color.fromRGBO(0, 113,255,0.1),
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
                Expanded(child: ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: actions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if(index == 2){
                          Navigator.pushNamed(
                            context,
                            'userdetail',
                              arguments: {
                                'folder_id' : selected_folder_id,
                                'user_id'   : user_id,
                                'group_id'  : selected_group_id,
                                'asset_type_id' : selected_asset_type_id,
                                'category_id'  : selected_category_id
                              }
                          );
                        }
                      },
                      child: MouseRegion(
                        onEnter: (event) {
                          setState(() {
                              hoveredIndex3 = index;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            hoveredIndex3 = -1;
                          });
                        },

                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 80,
                          color: hoveredIndex3 == index ? Color.fromRGBO(0, 113,255,0.4) : Color.fromRGBO(0, 113,255,0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              acionIcons[index],
                              Text('${actions[index]}'),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ],
            )
        ),
      ],
    );
  }
}
