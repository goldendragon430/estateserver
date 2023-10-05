import 'dart:convert';
import 'dart:html';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/apis/countries.dart';
import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/apis/users.dart';
import 'package:assetmamanger/models/subusers.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/pages/customFlutterTree/flutter_tree.dart';
import 'package:assetmamanger/pages/customFlutterTree/src/tree_view.dart';
import 'package:assetmamanger/pages/tenant/useritem.dart';

import 'package:assetmamanger/utils/global.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';


class TenantUser extends StatefulWidget {
  TenantUser({super.key});
  @override
  _TenantUser createState() => _TenantUser();
}
class  _TenantUser extends State<TenantUser> {
  String userid = 'yC1ntHsOuPgVS4yGhjqG';
  List<SubUser> subusers = [] ;
  Tenant? cur_tenant;

  //-------------------Search Features-------------------------------//
  TextEditingController searchEditController = TextEditingController();
  String search_str = '';
  final _key = GlobalKey<TreeViewState>();

  //------------------------Add Subuser Dialog-------------------------//

  TreeView? m_treeview = null;
  List<String> role_list = ['Asset Manager', 'Asset Inspection Manager', 'Data View Only'];

  String selected_role = '0';
  TextEditingController nodeEditController = TextEditingController();
  String selected_email = '';
  String selected_pass = '';
  String selected_pass_confirm = '';
  String selected_node_id = '';
  String selected_user_name = '';
  void onAdd() {
    showDialog(
      context: context,
      builder: (context) => gradeDialog(),
    );
  }
  //----------------------Change Subuser Dialog---------------------------//
  SubUser? cur_user = null;
  //-----------------search feature-------------------------------//
  void searchItems(String val){

  }
  void fetchData() async{

    Tenant? t  = await TenantService().getTenantDetails(userid);
    setState(()  {
      if(t != null)
        cur_tenant  = t!;
    });

    List<Map<String, dynamic>> serverData = await CountryService().getCountries();

    List<TreeNodeData> treeData = [];
    for(Map<String,dynamic> data in serverData){
      if(data['id'] == cur_tenant!.country) {
        treeData  = [mapServerDataToTreeData(data)];
        break;
      }
    }
    setState(() {
      m_treeview = TreeView(
        key : _key,
        data: treeData,
        showActions: false,
        contentTappable: true,
        append: (parent) {
          return TreeNodeData(
              title: 'New',
              expanded: true,
              checked: false,
              children: [],
              extra: {
                "children": [],
                "id": "${parent.extra['id']}-${generateID(length: 3)}",
                "level" : parent.extra['level'] + 1,
                "text": "New",
              }
          );
        },
        onTap: (node) {

          setState(() {
            selected_node_id = node.extra['id'];
            nodeEditController.text = node.extra['id'];
          });
        },
        onCheck: (checked, node) {

        },
        onCollapse: (node) {

        },
        onExpand: (node) {

        },
        onAppend: (node, parent) {

        },
        onRemove: (node, parent) {

        },
      );
    });

    List<SubUser> users =  await UserService().getSubUsers(userid);
    setState(() {
      subusers = users;
    });

  }
  void onChange(String id, BuildContext context) {

    for(SubUser user in subusers){
      if(user.id == id) {
        setState(() {
          cur_user = user;
        });
        break;
      }
    }
    showDialog(
      context: context,
      builder: (context) => changeDialog(),
    );
  }

  // Map server data to tree node data
  TreeNodeData mapServerDataToTreeData(Map data) {
    int level = data['id'].split('-').length - 1;

    if (level.toString()  == cur_tenant!.cut_off_level) {
         return TreeNodeData(
          extra: data,
          title: data['text'],
          expanded: false,
          checked: false,
          children: [],
        );
    } else
      return TreeNodeData(
        extra: data,
        title: data['text'],
        expanded: true,
        checked: false,
        children:   List.from(data['children'].map((x) => mapServerDataToTreeData(x))),
      );
  }
  //-----------------save features-------------------------------//
  void onSave() async{
   bool isOK = await UserService().saveChanges(subusers,userid);
   if(isOK) {
      showSuccess('Success');
    }
   else{
     showSuccess('Error');
   }
  }
  Future<bool> addUser() async{
    if(selected_pass != selected_pass_confirm) {
      showError("Doesn't match passwords");
      return false;
    }
    if(selected_user_name == '') {
      showError("Please enter user name.");
      return false;
    }
    if(selected_node_id == '') {
      showError("Please selecte node.");
      return false;
    }
    if(selected_email == '' || selected_pass == '' || selected_pass_confirm == '') {
      showError('InValid input.');
      return false;
    }

    var bytes = utf8.encode(selected_pass); // data being hashed
    var digest = sha256.convert(bytes);
    SubUser user = new SubUser(id: generateID(), user_id: userid, role: int.parse(selected_role), node_id: selected_node_id, name : selected_user_name, email: selected_email, password: digest.toString());
    setState(() {
      subusers.add(user);
    });
    return true;
  }
  void updateUsers() async{
    List<SubUser> users = List.from(subusers);
    setState(() {
      subusers.clear();
    });
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
         subusers = users;
         cur_user = null;
      });
    });
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
    fetchData();
  }
  StatefulBuilder changeDialog() {
    final screenHeight = MediaQuery.of(context).size.height;
    if(cur_user != null) {
      nodeEditController.text = cur_user!.node_id;
      selected_node_id = cur_user!.node_id;
      selected_role = cur_user!.role.toString();
      selected_email = cur_user!.email!;
      selected_pass = '';
      selected_pass_confirm = '';
      selected_user_name = cur_user!.name;
    }

    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text('Create Subuser'),
          content:
          Container(
              height: 750,
              child: Column(
                children: [
                  m_treeview == null ?  SizedBox(
                    height: 430,
                    width: 400,
                    child:   Center(
                      child: new SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child:  CircularProgressIndicator(
                          value: null,
                          strokeWidth: 4.0,
                        ),
                      ),
                    ),
                  ) : SizedBox(width:400,height: 430, child : ListView(
                    children: [
                      m_treeview!
                    ],
                  )),
                  SizedBox(
                      width:300,
                      child: TextFormField(
                        initialValue: selected_user_name,
                        decoration: InputDecoration(
                          labelText: 'Username',
                        ),
                        onChanged: (String value){
                          _setter(() {
                            selected_user_name = value;
                          });
                        },
                      )),
                  SizedBox(
                      width: 300 ,
                      child: DropdownButton<String>(
                        value: selected_role,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          _setter(() {
                            selected_role = newValue!;
                          });
                        },
                        items: ['0','1','2'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value ,
                            child: Text(role_list[int.parse(value)]),
                          );
                        }).toList(),
                      )
                  ),
                  SizedBox(
                      width:300,
                      child: TextFormField(
                        initialValue: selected_email,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                        onChanged: (value){
                          _setter(() {
                            selected_email = value;
                          });
                        },
                      )),
                  SizedBox(
                      width:300,
                      child: TextFormField(
                        initialValue: selected_pass,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: '******',
                        ),
                        onChanged: (value){
                          _setter(() {
                            selected_pass = value;
                          });
                        },
                      )),
                  SizedBox(
                      width:300,
                      child: TextFormField(
                        initialValue: selected_pass_confirm,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password Confirmation',
                          hintText: '******',
                        ),
                        onChanged: (value){
                          _setter(() {
                            selected_pass_confirm = value;
                          });
                        },
                      )),
                  SizedBox(
                      width:300,
                      child: TextFormField(
                        controller: nodeEditController,
                        decoration: InputDecoration(
                          labelText: 'Node',
                        ),
                        readOnly: true,
                      )),
                ],
              )
          ),

          actions: [
            ElevatedButton(
              onPressed:() async{
                _setter((){
                  if(cur_user != null)
                    {
                      if(selected_pass != '') {
                        if(selected_pass != selected_pass_confirm) {
                          showError("Doesn't match");
                          return;
                        }
                      }
                        cur_user!.name = selected_user_name;
                        cur_user!.role = int.parse(selected_role) ;
                        cur_user!.node_id = selected_node_id;
                        cur_user!.email = selected_email;

                        if(selected_pass != '') {
                          var bytes = utf8.encode(selected_pass); // data being hashed
                          var digest = sha256.convert(bytes);
                          cur_user!.password = digest.toString();
                        }
                        updateUsers();
                    }
                });

                Navigator.pop(context);
              },
              child: Text('Confirm'),
            ),
            ElevatedButton(
              onPressed:() async{
                if(cur_user != null)
                    subusers.remove(cur_user);
                updateUsers();
                Navigator.pop(context);
              },
              child: Text('Delete'),
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
  StatefulBuilder gradeDialog() {
    final screenHeight = MediaQuery.of(context).size.height;
    nodeEditController.text = '';
    selected_node_id = '';
    selected_email = '';
    selected_pass = '';
    selected_pass_confirm = '';

    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text('Create Subuser'),
          content:
          Container(
              height: screenHeight - 250,
              width: 400,
              child: ListView(
                children: [
                  m_treeview == null ?  SizedBox(
                    height: 430,
                    width: 400,
                    child:   Center(
                      child: new SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child:  CircularProgressIndicator(
                          value: null,
                          strokeWidth: 4.0,
                        ),
                      ),
                    ),
                  ) : SizedBox(width:400,height: 430, child : ListView(
                    children: [
                      m_treeview!
                    ],
                  )),
                  SizedBox(
                      width:300,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Username',
                        ),
                        onChanged: (String value){
                          _setter(() {
                            selected_user_name = value;
                          });
                        },
                      )),
                  SizedBox(
                      width: 300 ,
                      child: DropdownButton<String>(
                        value: selected_role,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                           _setter(() {
                             selected_role = newValue!;
                           });
                        },
                        items: ['0','1','2'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value ,
                            child: Text(role_list[int.parse(value)]),
                          );
                        }).toList(),
                      )
                  ),
                  SizedBox(
                      width:300,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                        onChanged: (value){
                          _setter(() {
                            selected_email = value;
                          });
                        },
                      )),
                  SizedBox(
                      width:300,
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: '******',
                        ),
                        onChanged: (value){
                          _setter(() {
                            selected_pass = value;
                          });
                        },
                      )),
                  SizedBox(
                      width:300,
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password Confirmation',
                          hintText: '******',
                        ),
                        onChanged: (value){
                          _setter(() {
                              selected_pass_confirm = value;
                          });
                        },
                      )),
                  SizedBox(
                      width:300,
                      child: TextFormField(
                        controller: nodeEditController,
                        decoration: InputDecoration(
                          labelText: 'Node',
                        ),
                        readOnly: true,
                      )),
                ],
              )
          ),

          actions: [
            ElevatedButton(
              onPressed:() async{
                bool isSuccess = await addUser();
                if(isSuccess)
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
                onPressed: onAdd,
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
          itemCount: (subusers.length/3).ceil(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            SubUser? ele = subusers[3 * index] ;
            SubUser? ele_2 = 3 * index + 1 >= subusers.length ? null: subusers[3 * index + 1] ;
            SubUser? ele_3 = 3 * index + 2 >= subusers.length ? null: subusers[3 * index + 2] ;
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width : tile_width, child: UserItem(id : ele.id,username : ele.name, onChange: onChange)),
                  ele_2 == null ? SizedBox(width: tile_width) : SizedBox(width : tile_width, child: UserItem(id : ele_2.id,username : ele_2.name, onChange: onChange)),
                  ele_3 == null ? SizedBox(width: tile_width) :SizedBox(width : tile_width, child: UserItem(id : ele_3.id,username : ele_3.name, onChange: onChange))
                ]);
          },
        )

        )
      ],
    );
  }

  Widget getResponsiveWidget(context){
    final screenWidth = MediaQuery.of(context).size.width;
    return getLargeWidget(context);

  }
  @override
  Widget build(BuildContext context) {

    return   Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left:0),
      child: Column(
        children: [
          Expanded(child: TitledContainer(
            titleText: 'Subusers',
            idden: 10,
            child: getResponsiveWidget(context),
            title_color: Colors.orange.withOpacity(0.8),
          ))
        ],
      ),
    );
  }
}
