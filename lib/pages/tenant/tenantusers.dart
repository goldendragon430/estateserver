/*
* Class Logic
* Tenant is Total DB instance.
* groups variable is a main variable to show list.
* search_groups are clone of groups where search condition is true.
* If user delete, change and add new data, groups and m_folders variable are changed.
* m_folders is db and groups is for displaying.
* */

import 'dart:convert';
import 'dart:html';

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
  List<Group> m_groups = [];
  //-------------------Search Features-------------------------------//
  List<User> search_groups = [] ;
  TextEditingController searchEditController = TextEditingController();
  String search_str = '';

  //-------------------Add Dialog Variables--------------------------//
  String username = '';
  String email = '';
  List<String> m_folder_ids = [];
  List<String> m_group_ids = [];
  int selectedOption = 0;
  String selected_folder_id = '';
  String selected_group_id = '';
  void getUsers()async{
    // String? val =  getStorage('user');
    // Map<String, dynamic>? data =  jsonDecode(val!);
    //
    // if(data?['id'] != null) {
    //   setState(() {
    //     userid = data?['id'];
    //   });
    // }
    // else{
    //   return;
    // }

    List<User> users =  await LoginService().getSubUser(userid);
    Tenant? result =  await TenantService().getTenantDetails(userid);
    if(result != null){
      setState(() {
        m_folders = result.folders!;
        if(m_folders.length > 0)
          selected_folder_id = m_folders[0].id!;
      });


      setState(() {
        for(Folder folder in m_folders){
          m_folder_ids.add(folder.id!);
          for(Group group in folder.groups!){
            m_group_ids.add(group.id!);
            m_groups.add(group);
          }
        }
        if(m_groups.length > 0)
        selected_group_id = m_groups[0].id!;
      });
    }

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
    if(selectedOption == 0) {
      User user = User(subuser_id: generateID(),email:email,username: username,parent_user: userid,acess_level: selectedOption);
      setState(() {
        m_users.add(user);
        search_groups = List.from(m_users);
      });
    }
    else if(selectedOption == 1) {
      User user = User(subuser_id: generateID(),email:email,username: username,parent_user: userid,acess_level: selectedOption,acess_id: selected_folder_id);
      setState(() {
        m_users.add(user);
        search_groups = List.from(m_users);
      });
    }
    else{
      User user = User(subuser_id: generateID(),email:email,username: username,parent_user: userid,acess_level: selectedOption,acess_id: selected_group_id);
      setState(() {
        m_users.add(user);
        search_groups = List.from(m_users);
      });
    }
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

  void onChangeItem(String id, BuildContext context)async{
       showDialog(
          context: context,
          builder: (context) => editDialog(id)  ,
        );

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

  String getGroupName (String groupID){
    for(Group group in m_groups){
      if(group.id == groupID) return group.name!;
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
    // getGroups();
    getUsers();
  }
  StatefulBuilder gradeDialog() {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text('Add new Subuser'),
          content:
          Container(
              height: 300,
              child: Column(children: [
                SizedBox(
                    width:400,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      onChanged: (value){
                        _setter(() {
                          username = value;
                        });
                      },
                    )),
                SizedBox(height: 5),
                SizedBox(
                    width:400,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      onChanged: (value){
                        _setter(() {
                          email = value;
                        });
                      },
                    )),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 120,
                      child: ListTile(
                        title : Text('root',style: TextStyle(fontSize: 14),),
                        leading: Radio(
                          value : 0,
                          groupValue : selectedOption,
                          onChanged: (value){
                            _setter(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                      )
                    ),
                    SizedBox(width: 130,child:ListTile(
                      title : Text('folder',style: TextStyle(fontSize: 14)),
                      leading: Radio(
                        value : 1,
                        groupValue : selectedOption,
                        onChanged: (value){
                          _setter(() {
                            selectedOption = value!;
                          });
                        },
                      ),
                    ) ),
                    SizedBox(width: 130,child: ListTile(
                      title : Text('group', style: TextStyle(fontSize: 14)),
                      leading: Radio(
                        value : 2,
                        groupValue : selectedOption,
                        onChanged: (value){
                          _setter(() {
                            selectedOption = value!;
                          });
                        },
                      ),
                    ))
                  ],
                ),
                SizedBox(height: 5),
                if(selectedOption == 1) SizedBox(
                    width: 400,
                    child:
                    DropdownButton<String>(
                      value: selected_folder_id,
                      padding: EdgeInsets.all(5),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        _setter((){
                        selected_folder_id = newValue!;
                        });

                      },
                      items: m_folder_ids.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getFolderName(value)),
                        );
                      }).toList(),
                    )
                ),
                if(selectedOption == 2) SizedBox(
                    width: 400,
                    child:
                    DropdownButton<String>(
                      value: selected_group_id,
                      padding: EdgeInsets.all(5),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        _setter((){
                          selected_group_id = newValue!;
                        });
                      },
                      items: m_group_ids.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getGroupName(value)),
                        );
                      }).toList(),
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
  StatefulBuilder editDialog(String userid) {
    User? m_user = null;
    String username = '';
    String email = '';
    bool active = false;
    String selected_folder_id = m_folders[0].id!;
    String selected_group_id = m_groups[0].id!;
    int selectedOption = 0;
    TextEditingController nameEditController = TextEditingController();
    TextEditingController emailEditController = TextEditingController();
    for(User user in m_users){
      if(user.subuser_id == userid){

        m_user = user;
        selectedOption = user.acess_level;
        if(selectedOption == 1) {
          selected_folder_id = user.acess_id!;
        }
        else if(selectedOption == 2) {
          selected_group_id = user.acess_id!;
        }
        username = user.username!;
        email = user.email!;
        active = user.state;
        nameEditController.text = username;
        emailEditController.text = email;

        break;
      }
    }


    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text('Edit Subuser'),
          content:
          Container(
              height: 300,
              child: Column(children: [
                SizedBox(
                    width:400,
                    height: 50,
                    child: TextField(
                      controller: nameEditController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      onChanged: (value){
                        _setter(() {
                          username = value;
                        });
                      },
                    )),
                SizedBox(height: 5),
                SizedBox(
                    width:400,
                    height: 50,
                    child: TextField(
                      controller: emailEditController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      onChanged: (value){
                        _setter(() {
                          email = value;
                        });
                      },
                    )),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: 120,
                        child: ListTile(
                          title : Text('root',style: TextStyle(fontSize: 14),),
                          leading: Radio(
                            value : 0,
                            groupValue : selectedOption,
                            onChanged: (value){
                              _setter(() {
                                selectedOption = value!;
                              });
                            },
                          ),
                        )
                    ),
                    SizedBox(width: 130,child:ListTile(
                      title : Text('folder',style: TextStyle(fontSize: 14)),
                      leading: Radio(
                        value : 1,
                        groupValue : selectedOption,
                        onChanged: (value){
                          _setter(() {
                            selectedOption = value!;
                          });
                        },
                      ),
                    ) ),
                    SizedBox(width: 130,child: ListTile(
                      title : Text('group', style: TextStyle(fontSize: 14)),
                      leading: Radio(
                        value : 2,
                        groupValue : selectedOption,
                        onChanged: (value){
                          _setter(() {
                            selectedOption = value!;
                          });
                        },
                      ),
                    ))
                  ],
                ),
                SizedBox(height: 5),
                if(selectedOption == 1) SizedBox(
                    width: 400,
                    child:
                    DropdownButton<String>(
                      value: selected_folder_id,
                      padding: EdgeInsets.all(5),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        _setter((){
                          selected_folder_id = newValue!;
                        });

                      },
                      items: m_folder_ids.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getFolderName(value)),
                        );
                      }).toList(),
                    )
                ),
                if(selectedOption == 2) SizedBox(
                    width: 400,
                    child:
                    DropdownButton<String>(
                      value: selected_group_id,
                      padding: EdgeInsets.all(5),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        _setter((){
                          selected_group_id = newValue!;
                        });
                      },
                      items: m_group_ids.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getGroupName(value)),
                        );
                      }).toList(),
                    )
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Checkbox(
                      value: active,
                      onChanged: (bool? value) {
                            _setter((){
                              active = value!;
                            });
                      },
                    ),
                    SizedBox(
                        width:10
                    ),
                    Text('Active')
                  ],
                )
              ])
          ),

          actions: [
            ElevatedButton(
              onPressed:(){
                m_user?.email = email;
                m_user?.username = username;
                m_user?.state = active;
                m_user?.acess_level = selectedOption;
                if(selectedOption == 0)
                  m_user?.acess_id = '';
                else if(selectedOption == 1){
                  m_user?.acess_id = selected_folder_id;
                }
                else{
                  m_user?.acess_id = selected_group_id;
                }
                searchItems(search_str);
                Navigator.pop(context);
              },
              child: Text('Save'),
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
          itemCount: (search_groups.length/3).ceil(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            User ele = search_groups[3 * index];
            User? ele_2 = 3 * index + 1 >= search_groups.length ? null: search_groups[3 * index + 1];
            User? ele_3 = 3 * index + 2 >= search_groups.length ? null: search_groups[3 * index + 2];

            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              SizedBox(width : tile_width, child: Center(child:UserItem(id:ele.subuser_id,username: ele.username,email : ele.email,active: ele.state,onChange: onChangeItem, onDelete: onDeleteItem))),
              ele_2 != null ? SizedBox(width : tile_width, child: Center(child:UserItem(id:ele_2.subuser_id,username: ele_2.username,email : ele_2.email,active: ele_2.state,onChange: onChangeItem, onDelete: onDeleteItem))) : SizedBox(width: tile_width),
              ele_3 != null ? SizedBox(width : tile_width, child: Center(child:UserItem(id:ele_3.subuser_id,username: ele_3.username,email : ele_3.email,active: ele_3.state,onChange: onChangeItem, onDelete: onDeleteItem))) : SizedBox(width: tile_width),
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
          itemCount: (search_groups.length/2).ceil(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            User ele = search_groups[2 * index];
            User? ele_2 = 2 * index + 1 >= search_groups.length ? null: search_groups[2 * index + 1];
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              SizedBox(width : tile_width, child: Center(child:UserItem(id:ele.subuser_id,username: ele.username,email : ele.email,active: ele.state,onChange: onChangeItem, onDelete: onDeleteItem))),
              ele_2 != null ? SizedBox(width : tile_width, child: Center(child:UserItem(id:ele_2.subuser_id,username: ele_2.username,email : ele_2.email,active: ele_2.state,onChange: onChangeItem, onDelete: onDeleteItem))) : SizedBox(width: tile_width),
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
            SizedBox(height:20),
            Container(width: tile_width, child : ElevatedButton(
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
                child: const Text('Add'))),
            SizedBox(height:20),
            Container(width: tile_width, child:  ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                    padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                onPressed: onSave,
                child: const Text('Save Changes'))),
          ],
        ),
        SizedBox(height: 30),
        Expanded(child:
        ListView.builder(
          itemCount: search_groups.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            User ele = search_groups[ index];

            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
              SizedBox(width : tile_width, child: Center(child:UserItem(id:ele.subuser_id,username: ele.username,email : ele.email,active: ele.state,onChange: onChangeItem, onDelete: onDeleteItem))),

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
              titleText: 'TENANT Subusers',
              idden: 10,
              child:  getResponsiveWidget(context)

          ))
        ],
      ),
    );
  }
}
