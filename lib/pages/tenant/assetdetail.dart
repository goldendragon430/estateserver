import 'package:assetmamanger/apis/categories.dart';
import 'package:assetmamanger/apis/countries.dart';
import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/apis/types.dart';
import 'package:assetmamanger/models/assetTypes.dart';
import 'package:assetmamanger/models/category.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/pages/customFlutterTree/flutter_tree.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';


class AssetDetail extends StatefulWidget {
  AssetDetail({super.key});
  @override
  _AssetItem createState() => _AssetItem();
}
class  _AssetItem extends State<AssetDetail> {
  String userid = 'bdMg1tPZwEUZA1kimr8b';
  TreeView? m_treeview = null;
  final _key = GlobalKey<TreeViewState>();
  Tenant? cur_tenant = null;
  String cut_off_level = '1';
  List<AssetType> m_types = [];
  TreeNodeData mapServerDataToTreeData(Map data) {
    int level = data['id'].split('-').length - 1;
    List<TreeNodeData> m_asset_types = [];
    for(AssetType type in m_types){
      m_asset_types.add(
          TreeNodeData(
            extra: {
              'id' : type.id,
              'level' : '${int.parse(cut_off_level) + 1}',
              'children' :[],
              'text' : type.type
            },
            title: type.type!,
            expanded: false,
            checked: false,
            children:   [],
          )
      );
    }

    if (level.toString()  == cut_off_level) {
      if(cur_tenant!.show_asset_types == true) {

        return TreeNodeData(
          extra: data,
          title: data['text'],
          expanded: false,
          checked: false,
          children: m_asset_types,
        );
      } else
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
        expanded: false,
        checked: false,
        children:   List.from(data['children'].map((x) => mapServerDataToTreeData(x))),
      );
  }
  void fetchData() async{
    List<Map<String, dynamic>> serverData = await CountryService().getCountries();
    // Generate tree data

    Tenant? tenant = await TenantService().getTenantDetails(userid);
    List<AssetType> result = await TypeService().getTypes();


    setState(() {
      m_types = result;
      cut_off_level = tenant!.cut_off_level;
      cur_tenant = tenant;
    });

    List<TreeNodeData> treeData = List.generate(
      serverData.length,
          (index) => mapServerDataToTreeData(serverData[index]),
    );

    setState(() {

      m_treeview = TreeView(
        key : _key,
        data: treeData,
        showActions: false,
        contentTappable: true,
        onTap: (node) {

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

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(m_treeview != null)
              SizedBox(width: 300,child: m_treeview!),
            Expanded(child: Text('Asset Detail Table'))
          ],
        )
    );
  }
}
