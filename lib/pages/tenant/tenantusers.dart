/*
* Class Logic
* Tenant is Total DB instance.
* groups variable is a main variable to show list.
* search_groups are clone of groups where search condition is true.
* If user delete, change and add new data, groups and m_folders variable are changed.
* m_folders is db and groups is for displaying.
* */

import 'dart:convert';

import 'package:assetmamanger/apis/auth.dart';
import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/models/folders.dart';
import 'package:assetmamanger/models/groups.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/models/users.dart';
import 'package:assetmamanger/pages/tenant/useritem.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/pages/tenant/groupitem.dart';

class TenantUsers extends StatefulWidget {
  TenantUsers({super.key});
  @override
  _TenantUsers createState() => _TenantUsers();
}
class  _TenantUsers extends State<TenantUsers> {

  String userid = 'bdMg1tPZwEUZA1kimr8b';

  //--------------------Main Variables--------------------------------//
  List<Map<String, dynamic>> groups = [] ;
  List<Folder> m_folders = [];
  Tenant DB_instance = Tenant();
  List<User> m_users = [];
  //-------------------Search Features-------------------------------//
  List<User> search_groups = [] ;
  TextEditingController searchEditController = TextEditingController();
  String search_str = '';

  //-------------------Add Dialog Variables--------------------------//
  String selectedValue  = '';
  bool   active_group = false;
  String group_name = '';
  List<String> m_folder_ids = [];

  void getUsers()async{
    String? val =  getStorage('user');
    Map<String, dynamic>? data =  jsonDecode(val!);

    if(data?['id'] != null) {
      setState(() {
        userid = data?['id'];
      });
    }
    else{
      return;
    }

    List<User> users =  await LoginService().getSubUser(userid);
    setState(() {
      m_users = users;
      search_groups = List.from(m_users);
    });
  }

  //-----------------search feature-------------------------------//
  void searchItems(String val){
    setState(() {
      search_groups = [];
    });
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
         for(User user in m_users){
           if(user.username!.contains(val) == true){
           search_groups.add(user);
           }
         }
      });
    });

  }

  //-----------------add features-------------------------------//
  void onAdd() async{
     User user = User(subuser_id: generateID(),email:'example@gmail.com',username: 'New User',parent_user: userid);
     setState(() {
       m_users.add(user);
       search_groups = List.from(m_users);
     });
  }

  //-----------------save features-------------------------------//
  void onSave() async{

    bool isOk =   await LoginService().saveSubuser(userid, m_users);
    if(isOk){
      showSuccess('Success');
    }else{
      showError('Error');
    }
  }

  void onChangeItem(String email, String username,String id,bool active)async{
    for(User user in m_users){
      if(user.subuser_id == id) {
        setState(() {
           user.email = email;
           user.username = username;
           user.state = active;
        });
        break;
      }
    }
  }
  void onDeleteItem(String id)async{
   for(User user in m_users){
     if(user.subuser_id == id) {
       setState(() {
         m_users.remove(user);
         search_groups = [];
         searchEditController.text = '';
       });
       break;
     }
   }
   Future.delayed(const Duration(milliseconds: 20), () {
     setState(() {
       search_groups = List.from(m_users);
     });
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
    // String? userDataString =  getStorage('user');
    // Map<String, dynamic>? data =  jsonDecode(userDataString!);
    // setState(() {
    //   userid = data?['id'];
    // });
    // getGroups();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tile_width = (screenWidth - 300 - 100)/3;

    StatefulBuilder gradeDialog() {
      return StatefulBuilder(
        builder: (context, _setter) {
          return AlertDialog(
            title: Text('Add new user'),
            content:
            Container(
                height: 150,
                child: Column(children: [
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
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: this.active_group,
                        onChanged: (bool? value) {
                          _setter(() {
                            this.active_group = value!;
                          });
                        },
                      ),
                      SizedBox(
                          width:10
                      ),
                      Text('Group Active')
                    ],
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
    return   Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left:30),
      child: Column(
        children: [
          Expanded(child: TitledContainer(
              titleText: 'TENANT Subusers',
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
                          onPressed: onAdd,
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
                      User ele = search_groups[3 * index];
                      User? ele_2 = 3 * index + 1 >= search_groups.length ? null: search_groups[3 * index + 1];
                      User? ele_3 = 3 * index + 2 >= search_groups.length ? null: search_groups[3 * index + 2];

                      return Row(children: [
                        SizedBox(width : tile_width, child: Center(child:UserItem(id:ele.subuser_id,username: ele.username,email : ele.email,active: ele.state,onChange: onChangeItem, onDelete: onDeleteItem))),
                        if(ele_2 != null)
                          SizedBox(width : tile_width, child: Center(child:UserItem(id:ele_2.subuser_id,username: ele_2.username,email : ele_2.email,active: ele_2.state,onChange: onChangeItem, onDelete: onDeleteItem))),
                        if(ele_3 != null)
                          SizedBox(width : tile_width, child: Center(child:UserItem(id:ele_3.subuser_id,username: ele_3.username,email : ele_3.email,active: ele_3.state,onChange: onChangeItem, onDelete: onDeleteItem))),


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
