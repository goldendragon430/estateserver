import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/models/folders.dart';
import 'package:assetmamanger/models/groups.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/pages/tenant/groupitem.dart';

class TenantGroups extends StatefulWidget {
  TenantGroups({super.key});
  @override
  _TenantGroups createState() => _TenantGroups();
}
class  _TenantGroups extends State<TenantGroups> {
  String userid = 'bdMg1tPZwEUZA1kimr8b';
  List<Map<String, Group>> groups = [] ;
  List<Map<String, Group>> search_groups = [] ;
  String search_str = '';
  Tenant DB_instance = Tenant();
  String selectedValue  = 'Type 1';
  TextEditingController searchEditController = TextEditingController();

  void getGroups()async{
    Tenant? result =  await TenantService().getTenantDetails(userid);
    if(result != null){
      List<Folder> folders = result.folders!;
      setState(() {
        for (Folder folder in folders){
          List<Group> m_groups = folder.groups!;
          for (Group group in m_groups){
            groups.add({folder.name! : group});
          }
        }
        DB_instance = result;
      });
    }
  }
  void searchItems(String val){

  }
  void onAdd() async{

  }
  void onSave() async{

  }
  void onDeleteItem(String id) async{

  }
  void onChangeItem(String id, String group_name, bool group_active ) async{

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroups();
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tile_width = (screenWidth - 300 - 100)/3;


    StatefulBuilder gradeDialog() {
      return StatefulBuilder(
        builder: (context, _setter) {
          return AlertDialog(
            title: Text('Add new group'),
            content:
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
                  items: <String>[
                    'Type 1',
                    'Type 2',
                    'Type 3',
                    'Type 4',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
            ),
            actions: [
              ElevatedButton(
                onPressed: () {},
                child: Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('ACCEPT'),
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
              titleText: 'TENANT Groups',
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
                                      search_str = '';
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
                          onPressed: () {
                            setState(() {
                            });
                          },
                          child: const Text('Save Changes')),
                    ],
                  ),
                  SizedBox(height: 30),
                  Expanded(child:
                      ListView.builder(
                        itemCount: 3,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(children: [
                              SizedBox(width : tile_width, child: Center(child:GroupItem(groupID: '111111', folderName : 'New Folder', groupName : 'New Group', groupActive : true, onChange: onChangeItem, onDelete: onDeleteItem, ))) ,
                              SizedBox(width : tile_width, child: Center(child:GroupItem(groupID: '111111', folderName : 'New Folder', groupName : 'New Group', groupActive : true, onChange: onChangeItem, onDelete: onDeleteItem,))) ,
                              SizedBox(width : tile_width, child: Center(child:GroupItem(groupID: '111111', folderName : 'New Folder', groupName : 'New Group', groupActive : true, onChange: onChangeItem, onDelete: onDeleteItem,))) ,
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
