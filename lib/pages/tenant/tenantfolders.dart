import 'dart:convert';

import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/models/folders.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/pages/tenant/folderitem.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'dart:math';
class TenantFolders extends StatefulWidget {
  TenantFolders({super.key});
  @override
  _TenantFolders createState() => _TenantFolders();
}
class  _TenantFolders extends State<TenantFolders> {
  String userid = 'bdMg1tPZwEUZA1kimr8b';
  List<Folder> folders = [] ;
  List<Folder> search_folders = [] ;
  String search_str = '';
  Tenant DB_instance = Tenant();
  TextEditingController searchEditController = TextEditingController();
  void getFolders()async{
    Tenant? result =  await TenantService().getTenantDetails(userid);
    if(result != null){
      setState(() {
        folders = result.folders!;
        search_folders = List.from(folders);
        DB_instance = result;
      });
    }
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
    getFolders();
  }
  void searchItems(String val){
    setState(() {
      search_folders = [];
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        search_folders = List.from(folders);
        search_folders.removeWhere((folder) => !folder.name!.contains(val));
      });
    });

  }

  void onChangeItem(String id, String name, bool active, bool unlimited_group){
    setState(() {
      for(Folder folder in folders){
        if(folder.id == id){
          folder.name = name;
          folder.active = active;
          folder.unlimited_group = unlimited_group;
        }
      }
      // search_folders = List.from(folders);
      // searchItems(search_str);
    });

  }
  void onDeleteItem(String id) async{
    setState(() {
      folders.removeWhere((folder) => folder.id == id);
      search_folders = [];
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() => search_folders.addAll(folders));
    });
  }
  void onSave() async{
    DB_instance.folders = folders;
    bool isOk = await TenantService().createTenantDetails(DB_instance);
    if(isOk){
      showSuccess('Success');
    }else{
      showError('Error');
    }
  }
  void onAdd() async{
      setState(() {
        Folder folder = Folder(id : generateID(),name:'New Folder',active:DB_instance.unlimited_folder , unlimited_group: false,groups: [],created_date: DateTime.now());
        searchEditController.clear();
        setState(() {
          folders.add(folder);
          search_folders = folders;
        });
      });
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tile_width = (screenWidth - 300 - 100)/3;
    final items_count = 10;

    return   Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left:30),
      child: Column(
        children: [
          Expanded(child: TitledContainer(
              titleText: 'TENANT Folders',
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
                                    searchItems(value);
                                    setState(() {
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
                          onPressed: onAdd,
                          child: const Text('Add')),
                      SizedBox(width:20),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                              padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                              textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                          onPressed:  onSave,
                          child: const Text('Save Changes')),
                    ],
                  ),
                  SizedBox(height: 30),
                  Expanded(child:

                        ListView.builder(
                          itemCount:  (search_folders.length/3).ceil(),
                          shrinkWrap: true, ///////////////////////Use This Line
                          itemBuilder: (BuildContext context, int index) {
                            Folder folder = search_folders[3 * index];
                            Folder? folder2 = 3 * index + 1 >= search_folders.length ? null: search_folders[3 * index + 1];
                            Folder? folder3 = 3 * index + 2 >= search_folders.length ? null: search_folders[3 * index + 2];

                            return Row(children: [
                              SizedBox(width : tile_width, child: Center(child:FolderItem(folderId: folder.id, foldername : folder.name,active :  folder.active, ugroups : folder.unlimited_group, onChange: onChangeItem, onDelete: onDeleteItem,))) ,
                              if(folder2 != null) SizedBox(width : tile_width, child: Center(child:FolderItem(folderId: folder2.id, foldername : folder2.name,active :  folder2.active, ugroups : folder2.unlimited_group, onChange: onChangeItem, onDelete: onDeleteItem,))) ,
                              if(folder3 != null) SizedBox(width : tile_width, child: Center(child:FolderItem(folderId: folder3.id, foldername : folder3.name,active :  folder3.active, ugroups : folder3.unlimited_group, onChange: onChangeItem, onDelete: onDeleteItem,))) ,
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
