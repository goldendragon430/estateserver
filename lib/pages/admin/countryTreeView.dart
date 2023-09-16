import 'dart:html';

import 'package:assetmamanger/apis/countries.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/customFlutterTree/flutter_tree.dart';


class CountryTreeView extends StatefulWidget {

  CountryTreeView({super.key}) ;
  @override
  _CountryTreeView createState() => _CountryTreeView();
}
class  _CountryTreeView extends State<CountryTreeView> {
  TreeView? m_treeview = null;
  final _key = GlobalKey<TreeViewState>();
  String current_node_title = '';
  StatefulBuilder gradeDialog(TreeNodeData node) {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text( node.extra['level'] > 0 ? 'Level ${node.extra['level']} Node' : 'Country Node',style: TextStyle(fontSize: 16)),
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
                _key.currentState?.remove(node);
                // print(_key.currentState?.getData());
                Navigator.pop(context);
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
     bool isOk = await CountryService().saveChanges(data);
     if(isOk){
       showSuccess('Success');
     }else{
       showError('Error');
     }
  }
  void fetchData() async{
    List<Map<String, dynamic>> serverData = await CountryService().getCountries();

    // Generate tree data
    List<TreeNodeData> treeData = List.generate(
      serverData.length,
          (index) => mapServerDataToTreeData(serverData[index]),
    );
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
                "id": generateID(),
                "level" : parent.extra['level'] + 1,
                "text": "New",
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
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
  // Map server data to tree node data
  TreeNodeData mapServerDataToTreeData(Map data) {
    return TreeNodeData(
      extra: data,
      title: data['text'],
      expanded: true,
      checked: false,
      children:
      List.from(data['children'].map((x) => mapServerDataToTreeData(x))),
    );
  }
  Map<String, dynamic> NodeToMap(TreeNodeData node){
    return {
      'id' : node.extra['id'],
      'level' : node.extra['level'],
      'text' : node.title,
      'children' : List.from(node.children.map((x) => NodeToMap(x)))
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                  onPressed:  (){
                    _key.currentState?.addCountry(
                        TreeNodeData(
                        title: 'New Country',
                        expanded: true,
                        checked: false,
                        children: [],
                        extra: {
                          "children": [],
                          "id": generateID(),
                          "level" : 0,
                          "text": "New Country",
                        })
                    ) ;
                  },
                  child: const Text('Add Country')),
              SizedBox(width: 10),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                  onPressed:  saveData,
                  child: const Text('Save Changes'))
        ]),
        if(m_treeview != null) m_treeview!
      ],
    );


  }
}
