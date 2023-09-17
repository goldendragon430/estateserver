import 'package:assetmamanger/apis/categories.dart';
import 'package:assetmamanger/apis/countries.dart';
import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/apis/types.dart';
import 'package:assetmamanger/models/assetTypes.dart';
import 'package:assetmamanger/models/category.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/pages/customFlutterTree/flutter_tree.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:pluto_grid/pluto_grid.dart';


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

  List<PlutoColumn> columns = [
    /// Text Column definition
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    /// Number Column definition
    PlutoColumn(
      title: 'Description',
      field: 'description',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Address',
      field: 'address',
      type: PlutoColumnType.text(),
    ),
    /// Datetime Column definition
    PlutoColumn(
      title: 'Contact',
      field: 'contact',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Phone',
      field: 'phone',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Acquired Date',
      field: 'acquired_date',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Acquired Value',
      field: 'acquired_value',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Cost Center',
      field: 'cost_center',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Asset Type',
      field: 'asset_type',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Category',
      field: 'category_id',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Status',
      field: 'status',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Registred Date',
      field: 'registred_date',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Registred By',
      field: 'registred_by',
      type: PlutoColumnType.text(),
    )
  ];
  final List<PlutoRow> rows = [];

  late final PlutoGridStateManager stateManager;

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
    List<PlutoRow> m_rows = [];
    m_rows.add(PlutoRow(cells: {
      'name': PlutoCell(value: 'Asset1'),
      'description': PlutoCell(value: 'Net Asset'),
      'address': PlutoCell(value: 'Rose, Canada'),
      'contact': PlutoCell(value: 'Vladyslav@gmail.com'),
      'phone': PlutoCell(value: '16036323781'),
      'acquired_date'  : PlutoCell(value: '2023-2-2'),
      'acquired_value'  : PlutoCell(value: '12'),
      'cost_center'  : PlutoCell(value: 'center'),
      'asset_type'  : PlutoCell(value: 'AssetType1'),
      'category_id'  : PlutoCell(value: 'Category1'),
      'status'  : PlutoCell(value: 'Active'),
      'registred_date'  : PlutoCell(value: '2023-2-2'),
      'registred_by'  : PlutoCell(value: 'KJR'),
    }));
    stateManager.appendRows(m_rows);

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
            Expanded(child: Column(
              children: [
                SizedBox(
                    height: 150,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Asset Type: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(height: 7),
                            Text('Acquired Year: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(height: 7),
                            Text('Last Inspected: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
                          ],
                       ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Default Type', style: TextStyle(fontSize: 16 )),
                            SizedBox(height: 7),
                            Text('2020', style: TextStyle(fontSize: 16 )),
                            SizedBox(height: 7),
                            Text('2020', style: TextStyle(fontSize: 16 ))
                          ],
                        ),
                        SizedBox(width: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Asset Category: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(height: 7),
                            Text('Year Registered: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(height: 7),
                            Text('Asset Status: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Default Category', style: TextStyle(fontSize: 16 )),
                            SizedBox(height: 7),
                            Text('2020', style: TextStyle(fontSize: 16 )),
                            SizedBox(height: 7),
                            Text('Active', style: TextStyle(fontSize: 16 ))
                          ],
                        )
                      ],
                    )
                ),
                Expanded(child:
                    ContextMenuRegion(

                        contextMenu: GenericContextMenu(
                          buttonConfigs: [
                            ContextMenuButtonConfig(
                              "Add New Asset",
                              onPressed: () {},
                            ),
                            ContextMenuButtonConfig(
                              "View Asset Details",
                              onPressed: (){},
                            ),
                            ContextMenuButtonConfig(
                              "Delete Asset",
                              onPressed: (){},
                            ),
                            ContextMenuButtonConfig(
                              "Export to CSV",
                              onPressed: (){},
                            ),
                            ContextMenuButtonConfig(
                              "View Report",
                              onPressed: (){},
                            )
                          ],
                        ),
                        child: PlutoGrid(
                        columns: columns,
                        rows: rows,
                        onLoaded: (PlutoGridOnLoadedEvent event) {
                          stateManager = event.stateManager;
                          stateManager.setShowColumnFilter(true);
                        },
                        onSelected: (PlutoGridOnSelectedEvent event){
                          print(event);
                        },
                        mode: PlutoGridMode.selectWithOneTap,
                      )
                    )

                )
              ],
            ))
          ],
        )
    );
  }
}
