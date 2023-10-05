import 'dart:convert';
import 'dart:html';

import 'package:assetmamanger/apis/assets.dart';
import 'package:assetmamanger/apis/countries.dart';
import 'package:assetmamanger/apis/organizations.dart';
import 'package:assetmamanger/apis/users.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/customFlutterTree/flutter_tree.dart';


class OrganizationView extends StatefulWidget {
  OrganizationView({super.key}) ;
  @override
  _OrganizationView createState() => _OrganizationView();

}
class  _OrganizationView extends State<OrganizationView> {

  String new_root_name = '';
  TreeView? m_treeview = null;
  final _key = GlobalKey<TreeViewState>();
  String current_node_title = '';
  String userid = 'yC1ntHsOuPgVS4yGhjqG';
  void deleteNode(TreeNodeData node, BuildContext context) async{
       _key.currentState?.remove(node);
    Navigator.pop(context);
  }
  StatefulBuilder gradeDialog(TreeNodeData node) {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text( 'Level ${node.extra['level'] + 1} Node', style: TextStyle(fontSize: 16)),
          content:
          Container(
              height: 50,
              child:
              SizedBox(
                  width:200,
                  child: TextFormField(
                    initialValue: node.title,
                    decoration: InputDecoration(
                      labelText: 'title',
                    ),
                    onChanged: (value){
                      setState(() {
                        current_node_title = value;
                      });
                    },
                  ))

          ),
          actions: [
            ElevatedButton(
              onPressed:(){
                _key.currentState?.rename(node, current_node_title);
                // print(_key.currentState?.getData());
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {

                deleteNode(node,context);
                // print(_key.currentState?.getData());

              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void saveData() async {
    List<Map<String,dynamic>> data = [];
    List<TreeNodeData>? treeData =  _key.currentState?.getData();
    for(int i = 0; i < treeData!.length; i ++){
      data.add(NodeToMap(treeData[i]));
    }
   bool isOK = await OrganizationService().saveChanges(data, userid);
    if(isOK) {
      showSuccess('Success');
      fetchData();
    }else{
      showError('Error');
    }
  }

  void fetchData() async{
    setState(() {
      m_treeview = null;
    });

    List<Map<String, dynamic>?> data = await OrganizationService().getOrganizations(userid);
    List<TreeNodeData> treeData = [];
    for (Map<String, dynamic>? item in data) {
      treeData.add(mapServerDataToTreeData(item!));
    }

    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        m_treeview = TreeView(
          key : _key,
          data: treeData,
          showActions: true,
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
                  'depth': 3
                }
            );
          },
          onTap: (node) {

              showDialog(
                context: context,
                builder: (context) => gradeDialog(node)  ,
              );
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
    });
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
    fetchData();
  }

  // Map server data to tree node data
  TreeNodeData mapServerDataToTreeData(Map data) {
    return TreeNodeData(
      extra: data,
      title: data['text'],
      expanded: true,
      checked: false,
      children: List.from(data['children'].map((x) => mapServerDataToTreeData(x))),
    );
  }
  Map<String, dynamic> NodeToMap(TreeNodeData node){
    return {
      'id' : node.extra['id'],
      'level' : node.extra['level'],
      'text' : node.title,
      'children' : List.from(node.children.map((x) => NodeToMap(x))),
      'owner' : userid,
      'depth' : 3
    };
  }
  void addRoot() async{
    bool isOK = await OrganizationService().createOrganization(new_root_name, generateID(length: 3), userid);
    fetchData();
    if(isOK) {
      showSuccess('Success');
    }
    else{
      showError('Error');
    }
  }
  StatefulBuilder createDialog() {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text( 'Add Root', style: TextStyle(fontSize: 16)),
          content:
          Container(
              height: 50,
              child:
              SizedBox(
                  width:200,
                  child: TextFormField(
                    initialValue: '',
                    decoration: InputDecoration(
                      labelText: 'Root Title',
                    ),
                    onChanged: (value){
                      setState(() {
                        new_root_name = value;
                      });
                    },
                  ))

          ),
          actions: [
            ElevatedButton(
              onPressed:(){
                addRoot();
                Navigator.pop(context);
              },
              child: Text('Add'),
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
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height - 100;

    return
      SizedBox(height:screenHeight , child:  ListView(
        children: [
          SizedBox(height: 50),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                      onPressed: (){
                        showDialog(
                        context: context,
                        builder: (context) => createDialog(),
                        );
                      },
                    child: const Text('Add Root Node')),
                SizedBox(width: 30),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                    onPressed:  saveData,
                    child: const Text('Save Changes')),
                SizedBox(width: 30),
              ]),
          SizedBox(height: 10),
          if(m_treeview != null) m_treeview!
        ],
      ));


  }
}
