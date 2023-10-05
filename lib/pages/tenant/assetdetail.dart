import 'dart:convert';
import 'dart:math';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:assetmamanger/apis/assets.dart';
import 'package:assetmamanger/apis/organizations.dart';
import 'package:assetmamanger/models/Image.dart';
import 'package:assetmamanger/models/inspections.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'package:intl/intl.dart';
import 'package:assetmamanger/apis/categories.dart';
import 'package:assetmamanger/apis/countries.dart';
import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/apis/types.dart';
import 'package:assetmamanger/models/assetTypes.dart';
import 'package:assetmamanger/models/assets.dart';
import 'package:assetmamanger/models/category.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/pages/customFlutterTree/flutter_tree.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:context_menus/context_menus.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid_export/pluto_grid_export.dart' as pluto_grid_export;
import 'package:flutter/services.dart';
class AssetDetail extends StatefulWidget {
  AssetDetail({super.key});
  @override
  _AssetItem createState() => _AssetItem();
}
class  _AssetItem extends State<AssetDetail> {
  //-------------Main variable------------------//

  String userid = 'yC1ntHsOuPgVS4yGhjqG';
  TreeView? m_treeview = null;
  final _key = GlobalKey<TreeViewState>();
  Tenant? cur_tenant = null;
  List<Asset> m_assets = [];
  String cut_off_level = '1';
  List<AssetType> m_types = [];
  List<String> m_asset_type_ids = [];
  String default_type_id = '';

  List<Category> m_categories = [];
  List<String> m_asset_category_ids = [];
  String default_category_id = '';
  //-----------------Asset Table--------------------//
  List<PlutoColumn> columns = [
    /// Text Column definition
    PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Code',
      field: 'code',
      type: PlutoColumnType.text(),
    ),
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

  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager = null;

  String selected_asset_type = 'No Selected';
  String selected_category = 'No Selected';
  String selected_acquired_year = 'No Selected';
  String selected_year_registered = 'No Selected';
  String selected_last_inspection = 'No Selected';
  String selected_asset_status = 'No Selected';


  //----------------Inspection Table----------------//
  List<PlutoColumn> columns_2 = [
    PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        hide: true
    ),
    PlutoColumn(
      title: 'Inspection Date',
      field: 'inspection_date',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Inspection Status',
      field: 'inspection_status',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Inspection By',
      field: 'inspection_by',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Inspection Comments',
      field: 'inspection_comment',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Inspection Value',
      field: 'inspection_value',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Next Inspection',
      field: 'next_inspection',
      type: PlutoColumnType.text(),
    )
  ];
  final List<PlutoRow> rows_2 = [];
  PlutoGridStateManager? stateManager_2 = null;

  int pageMode = 1; // 1 => Asset Table, 2 => Asset Detail page,3 => inspection detail
  String cur_node_id = '';
  String cur_asset_type_id = '0';
  //---------------------Asset Detail Page---------------------------//
  TextEditingController assetIDController =  TextEditingController();
  TextEditingController assetNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController assetCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController acquiredDateController = TextEditingController();
  TextEditingController acquiredValueController = TextEditingController();
  TextEditingController costCenterController = TextEditingController();
  TextEditingController assetTypeController = TextEditingController();
  TextEditingController assetCategoryController = TextEditingController();
  TextEditingController assetStatusController = TextEditingController();
  TextEditingController registredDateController = TextEditingController();
  TextEditingController registeredByController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  Asset? cur_asset = null;
  List<CustomImage> m_images = [];

  //---------------------Add Dialog Variable------------------------//
  Uint8List? logo_image = null;
  String description_str = '';
  TextEditingController logoDescriptionController = TextEditingController();


  //---------------------Inspection Page variables---------------------//
  List<Inspection> m_inspections = [];
  TextEditingController inspectionByController = TextEditingController();
  TextEditingController inspectionStatusController = TextEditingController();
  TextEditingController inspectionValueController = TextEditingController();
  TextEditingController inspectionCommentController = TextEditingController();
  TextEditingController inspectionDateController = TextEditingController();
  TextEditingController inspectionNextDateController = TextEditingController();
  Inspection? cur_inspection = null;
  List<CustomImage> m_inspection_images = [];
 //-----------------------Owner Dropdowns------------------------------//
  List<String> node_ids_1 = [];
  List<Map<String, dynamic>> level_nodes_1 = [];
  List<String> node_ids_2 = [];
  List<Map<String, dynamic>> level_nodes_2 = [];
  List<String> node_ids_3 = [];
  List<Map<String, dynamic>> level_nodes_3 = [];

  String cur_node_id_1 = '';
  String cur_node_id_2 = '';
  String cur_node_id_3 = '';
  bool show_inspection_box = false;

  //---------------Inspection Status List------------------------------//
  List<String> inspectionStatus = ['ACTIVE', 'MISSING', 'DISPOSED', 'IN-ACTIVE', ''];
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
              'text' : type.type,
              'parent' : data['id']
            },
            title: type.type!,
            expanded: true,
            checked: false,
            children:   [],
          )
      );
    }
    // if (level.toString()  == cut_off_level) {
      if(data['children'].length == 0) {

      if(cur_tenant!.show_asset_types == true) {

        return TreeNodeData(
          extra: data,
          title: data['text'],
          expanded: true,
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
        expanded: true,
        checked: false,
        children:   List.from(data['children'].map((x) => mapServerDataToTreeData(x))),
      );
  }
  void fetchData() async{
//-----------------------Load Country, Tenant, Category and AssetTypes --------------------//

    Tenant? tenant = await TenantService().getTenantDetails(userid);
    setState(() {
      cur_tenant = tenant;
      cut_off_level = tenant!.cut_off_level;
    });
    List<AssetType> result = await TypeService().getTypes(userid);
    List<Category> result_2 = await CategoryService().getCategory(userid);

    m_asset_type_ids = List.from(result.map((x)=>x.id));
    m_asset_category_ids = List.from(result_2.map((x)=>x.id));

    for(AssetType type in result){
      if (type.type!.contains('Default')) {
        default_type_id = type.id!;
        break;
      }
    }
    if(default_type_id == '')
      default_type_id = m_asset_type_ids[0];

    for(Category category in result_2){
      if (category.name!.contains('Default')) {
        default_category_id = category.id!;
        break;
      }
    }
    if(default_category_id == '')
      default_category_id = m_asset_category_ids[0];

    setState(() {
      m_types = result;
      m_categories = result_2;
    });
//---------------------------Generate Tree Data-----------------------------//
    List<TreeNodeData> treeData = [];

    //--------------------Check if current tenant has offices over the countries----------------//
    if(cur_tenant!.hasOffice == true) {
      List<Map<String, dynamic>> serverData = await CountryService().getCountries();
      for(Map<String,dynamic> data in serverData){
        if(data['id'] == cur_tenant!.country) {
          treeData  = [mapServerDataToTreeData(data)];
          break;
        }
      }
    }
    else {
      List<Map<String, dynamic>?> data = await OrganizationService().getOrganizations(userid);
      for (Map<String, dynamic>? item in data) {
        treeData.add(mapServerDataToTreeData(item!));
      }
    }

    setState(() {
      m_treeview = TreeView(
        key : _key,
        data: treeData,
        showActions: false,
        contentTappable: true,

        onTap: (node) {
          setState(() {
            pageMode = 1;
            if(node.children.length == 0 && cur_tenant!.show_asset_types == false) {
              cur_node_id = node.extra['id'];
              cur_asset_type_id = '0';
              LoadAssets();

            }
            if(cur_tenant!.show_asset_types == true && node.children.length == 0) {
              cur_asset_type_id = node.extra['id'];
              cur_node_id = node.extra['parent'];
              LoadAssets();
            }
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
//--------------------------Generate Table Data-----------------------------//

    // stateManager_2.appendRows(m_rows_2);

//-------------------------Get Asset Data-----------------------------------//

  }
  void LoadOwnerList() async{
    List<Map<String, dynamic>> m_list = await OrganizationService().getOrganizations(userid);
    for (Map<String, dynamic> item_1 in m_list) {
      node_ids_1.add(item_1['id']);
      level_nodes_1.add(item_1);
      for(Map<String, dynamic> item_2 in item_1['children']){
        node_ids_2.add(item_2['id']);
        level_nodes_2.add(item_2);
        for(Map<String, dynamic> item_3 in item_2['children']) {
          node_ids_3.add(item_3['id']);
          level_nodes_3.add(item_3);
        }
      }
    }
    if(level_nodes_1.length > 0) {
      cur_node_id_1 = node_ids_1[0];

      onUpdateLevel1Org();
    }
  }
  void onUpdateLevel1Org(){
    for(Map<String, dynamic> item in level_nodes_1){
      if(item['id'] == cur_node_id_1) {
        if(item['children'].length > 0) {
          cur_node_id_2 = item['children'][0]['id'];
          onUpdateLevel2Org();
        }
        break;
      }
    }
  }
  void onUpdateLevel2Org(){
    for(Map<String, dynamic> item in level_nodes_2){
      if(item['id'] == cur_node_id_2) {
        if(item['children'].length > 0) {
          cur_node_id_3 = item['children'][0]['id'];
          if(cur_asset != null)
              cur_asset!.org_id = cur_node_id_3;
        }
        break;
      }
    }
  }
  String getOrganizationName(String id, int level) {

    List<Map<String, dynamic>> data = level_nodes_1;
    if(level == 2) data = level_nodes_2;
    else if(level == 3) data = level_nodes_3;

    for(Map<String, dynamic> item in data) {
      if(item['id'] == id)
        return item['text'];
    }
    return '';
  }
  void LoadAssets(){
    setState(() {
      m_assets.clear();
      stateManager!.removeAllRows();
      selected_asset_type = 'No Selected';
      selected_category = 'No Selected';
      selected_acquired_year = 'No Selected';
      selected_year_registered = 'No Selected';
      selected_last_inspection = 'No Selected';
      selected_asset_status = 'No Selected';
    });
    Future.delayed(const Duration(milliseconds: 100), () async{
      List<Asset> result =  await AssetService().getAssets(cur_tenant!.user_id!, cur_node_id, cur_asset_type_id);
      setState(() {
        m_assets = result;
      });

      List<PlutoRow> m_rows = [];
      for(Asset asset in m_assets){
        m_rows.add(PlutoRow(cells: {
          'name': PlutoCell(value: asset.name),
          'description': PlutoCell(value: asset.description),
          'address': PlutoCell(value: asset.address),
          'contact': PlutoCell(value: asset.contact),
          'phone': PlutoCell(value: asset.phone),
          'acquired_date'  : PlutoCell(value: DateFormat('yyyy-MM-dd').format(asset.acquired_date!)),
          'acquired_value'  : PlutoCell(value: asset.acquired_value),
          'cost_center'  : PlutoCell(value: asset.cost_center),
          'asset_type'  : PlutoCell(value: getAssetTypeName(asset.asset_type_id!)),
          'category_id'  : PlutoCell(value: getCategoryName(asset.category_id!)),
          'status'  : PlutoCell(value: asset.status),
          'registred_date'  : PlutoCell(value: DateFormat('yyyy-MM-dd').format(asset.registered_date!)),
          'registred_by'  : PlutoCell(value: asset.registered_by),
          'id' : PlutoCell(value: asset.id),
          'code' : PlutoCell(value: asset.code)

        }));
      }
      stateManager!.appendRows(m_rows);
    });
  }
  void onDeleteAsset() async{
    bool isOk =  await AssetService().deleteAsset(cur_asset!);
    if(isOk){
      showSuccess('Success');
    }else{
      showError('Error');
    }
    LoadAssets();
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
    LoadOwnerList();
    fetchData();
  }
  String getAssetTypeName(String ID){
    String result = '';
    for(AssetType type in m_types){
      if(type.id == ID) {
        result = type.type!;
        break;
      }
    }
    return result;
  }
  String getCategoryName(String ID){
    String result = '';
    for(Category category in m_categories){
      if(category.id == ID) {
        result = category.name!;
        break;
      }
    }

    return result;
  }
  String generateAssetID(String type, String category){
    Random random = Random();
    int randomNumber = random.nextInt(9000) + 1000;
    String id = '${cur_tenant!.user_id}-${type}-${category}-${DateTime.now().year}-${randomNumber}';
    return id;
  }
  void updateAssetDetailInfo(String selected_cell_id){

    for(Asset asset in m_assets){
      if(asset.id == selected_cell_id) {
        setState(() {
          cur_asset = asset;
          if(cur_asset!.org_id != null) {
            List<String> list = cur_asset!.org_id!.split('-');
            cur_node_id_1 = list[0];
            cur_node_id_2 = list[0] + '-' + list[1];
            cur_node_id_3 = cur_asset!.org_id!;
          }

          selected_asset_type = getAssetTypeName(asset.asset_type_id!);
          selected_category = getCategoryName(asset.category_id!);
          selected_acquired_year = DateFormat('yyyy').format(asset.acquired_date!);
          selected_year_registered =  DateFormat('yyyy').format(asset.registered_date!);
          selected_last_inspection = '2020';
          selected_asset_status = asset.status!;
          m_images = cur_asset!.images!;
          m_inspections = cur_asset!.inspections!;
          updateInspectionTableContent();
        });
        break;
      }
    }
  }
  void updateInspectionTableContent(){
    if(stateManager_2 != null) {
      stateManager_2!.removeAllRows();
      List<Inspection> m_ins = List.from(m_inspections);
      m_inspections.clear();

      Future.delayed(Duration(milliseconds: 300), (){
        List<PlutoRow> m_rows_2 = [];
        setState(() {
          m_inspections = m_ins;
          if(cur_asset != null)
            cur_asset!.inspections = m_inspections;
        });
        for(Inspection ins in m_inspections){
          m_rows_2.add(PlutoRow(cells: {
            'id' : PlutoCell(value: ins.id),
            'inspection_date': PlutoCell(value: DateFormat('yyyy-MM-dd').format(ins.inspection_date!)),
            'inspection_status': PlutoCell(value: ins.status),
            'inspection_by': PlutoCell(value: ins.inspection_by),
            'inspection_comment': PlutoCell(value: ins.comment),
            'inspection_value': PlutoCell(value: ins.value),
            'next_inspection'  : PlutoCell(value: DateFormat('yyyy-MM-dd').format(ins.next_inspect_date!)),
          }));
        }
        stateManager_2!.appendRows(m_rows_2);
      });
    }
  }
  bool isFloat(String input) {
    try {
      double.parse(input);
      return true;
    } catch (e) {
      return false;
    }
  }
  void onAddNewAsset(){
    setState(() {
      cur_asset = Asset(owner_id: cur_tenant!.user_id, node_id: cur_node_id, id:'',code : '',name : 'New',description: '',address : '',contact: '',phone:'',acquired_date: DateTime(2022,2,2),acquired_value: '',cost_center: '',asset_type_id: default_type_id,category_id: default_category_id,status: '',comment: '',registered_date: DateTime(2022,2,2),registered_by: '',inspections: [],images: []);
      m_images = [];
      m_inspections = [];
      if(stateManager_2 != null)
        stateManager_2!.removeAllRows();
      show_inspection_box = false;
    });
    assetIDController.text = cur_asset!.id!;
    assetCodeController.text = cur_asset!.code!;
    assetNameController.text = cur_asset!.name!;
    descriptionController.text = cur_asset!.description!;
    addressController.text = cur_asset!.address!;
    contactController.text = cur_asset!.contact!;
    phoneController.text = cur_asset!.phone!;
    acquiredDateController.text = DateFormat('yyyy-MM-dd').format(cur_asset!.acquired_date!);
    acquiredValueController.text = cur_asset!.acquired_value!;
    costCenterController.text = cur_asset!.cost_center!;
    assetStatusController.text = cur_asset!.status == '' ? 'Acquired' : cur_asset!.status!;
    registredDateController.text = DateFormat('yyyy-MM-dd').format(cur_asset!.registered_date!);
    registeredByController.text = cur_asset!.registered_by!;
    commentController.text  = cur_asset!.comment!;

  }
  void onAddInspection(){
    setState(() {
      cur_inspection = Inspection(id:generateID(),inspection_date: DateTime(2022,2,2),inspection_by: '',comment:'',status:'',value:'0',next_inspect_date: DateTime(2022,2,2),images: []);
      m_inspection_images = [];
    });
    inspectionByController.text = '';
    inspectionCommentController.text = '';
    inspectionStatusController.text = '';
    inspectionValueController.text = '';
    inspectionDateController.text = DateFormat('yyyy-MM-dd').format(cur_inspection!.inspection_date!);
    inspectionNextDateController.text = DateFormat('yyyy-MM-dd').format(cur_inspection!.next_inspect_date!);
  }
  void onAssetDetails(){
    setState(() {
      pageMode = 2;
      show_inspection_box = true;
    });
    if(cur_asset == null) return;
    assetIDController.text = cur_asset!.id!;
    assetCodeController.text = cur_asset!.code!;
    assetNameController.text = cur_asset!.name!;
    descriptionController.text = cur_asset!.description!;
    addressController.text = cur_asset!.address!;
    contactController.text = cur_asset!.contact!;
    phoneController.text = cur_asset!.phone!;
    acquiredDateController.text = DateFormat('yyyy-MM-dd').format(cur_asset!.acquired_date!);
    acquiredValueController.text = cur_asset!.acquired_value!;
    costCenterController.text = cur_asset!.cost_center!;
    assetStatusController.text = cur_asset!.status == '' ? 'Acquired' : cur_asset!.status!;
    registredDateController.text = DateFormat('yyyy-MM-dd').format(cur_asset!.registered_date!);
    registeredByController.text = cur_asset!.registered_by!;
    commentController.text  = cur_asset!.comment!;
  }
  void onSaveChanges () async{
    bool isOk =  await AssetService().changeAsset(cur_asset!);
    if(isOk){
      showSuccess('Success');
      setState(() {
        show_inspection_box = true;
      });
    }else{
      showError('Error');
    }
  }
  void onChangeInspection() {
    print(cur_inspection!.toJson());
    bool isExist = false;
    for(Inspection ins in m_inspections){
      if(ins.id == cur_inspection!.id){
        ins = cur_inspection!;
        isExist = true;
        break;
      }
    }
    if(isExist == false) {
      m_inspections.add(cur_inspection!);
    }
    onSaveChanges();
  }
  void onInspectionDetail(){
    setState(() {
      pageMode = 3;
      inspectionByController.text = cur_inspection!.inspection_by!;
      inspectionCommentController.text = cur_inspection!.comment!;
      inspectionStatusController.text = cur_inspection!.status!;
      inspectionValueController.text = cur_inspection!.value!;
      inspectionDateController.text = DateFormat('yyyy-MM-dd').format(cur_inspection!.inspection_date!);
      inspectionNextDateController.text = DateFormat('yyyy-MM-dd').format(cur_inspection!.next_inspect_date!);
    });
  }
  void onDeleteInspection() {
    if(cur_inspection != null) {
      m_inspections.remove(cur_inspection);
    }
    onSaveChanges();
    updateInspectionTableContent();
  }

  void refreshImages(){
    List<CustomImage> temp = List.from(m_images);
    setState(() {
      m_images = [];
    });
    Future.delayed(const Duration(milliseconds: 300), (){
      setState(() {
        m_images = temp;
        cur_asset!.images = m_images;
      });
    });
  }
  void refreshInspectionImages(){
    List<CustomImage> temp = List.from(m_inspection_images);
    setState(() {
      m_inspection_images = [];
    });
    Future.delayed(const Duration(milliseconds: 300), (){
      setState(() {
        m_inspection_images = temp;
        cur_inspection!.images = m_inspection_images;
      });
    });
  }
  StatefulBuilder gradeDialog() {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text('Add new Image'),
          content:
          Container(
              height: 270,
              child: Column(children: [
                SizedBox(
                    width: 300,
                    child: GestureDetector(
                        onTap:() async{
                          // Image? fromPicker = await ImagePickerWeb.getImageAsWidget();
                          Uint8List? data =  await ImagePickerWeb.getImageAsBytes();
                          _setter(() {
                            logo_image = data!;
                          });
                        },
                        child:  Container(
                            width:200,
                            height: 150,
                            child: logo_image != null? Image.memory(logo_image!) :  Image.asset('assets/images/home.jpg')
                        )
                    )
                ),
                SizedBox(height: 20),
                SizedBox(
                    height: 100,
                    width: 300,
                    child: Container(
                        margin:EdgeInsets.only(left:4),
                        child: TextField(
                            controller: logoDescriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 4,
                            onChanged: (value){
                              _setter((){
                                description_str = value;
                              });
                            }
                        )
                    )
                ),
              ])
          ),

          actions: [
            ElevatedButton(
              onPressed:() async{
                if(logo_image != null) {
                  String url =  await uploadFile(logo_image);
                  CustomImage newImage = CustomImage(id:generateID(),url : url, description: description_str);

                  Navigator.pop(context);
                  _setter(() {
                    description_str = '';
                    logoDescriptionController.text = '';
                    logo_image = null;
                    m_images.add(newImage);
                  });
                  refreshImages();
                }
                else{
                  showError('Please select Image');
                  return;
                }
              },
              child: Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                _setter(() {
                  description_str = '';
                  logoDescriptionController.text = '';
                  logo_image = null;
                });
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  StatefulBuilder gradeDialog_2() {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text('Add new Image'),
          content:
          Container(
              height: 270,
              child: Column(children: [
                SizedBox(
                    width: 300,
                    child: GestureDetector(
                        onTap:() async{
                          // Image? fromPicker = await ImagePickerWeb.getImageAsWidget();
                          Uint8List? data =  await ImagePickerWeb.getImageAsBytes();
                          _setter(() {
                            logo_image = data!;
                          });
                        },
                        child:  Container(
                            width:200,
                            height: 150,
                            child: logo_image != null? Image.memory(logo_image!) :  Image.asset('assets/images/home.jpg')
                        )
                    )
                ),
                SizedBox(height: 20),
                SizedBox(
                    height: 100,
                    width: 300,
                    child: Container(
                        margin:EdgeInsets.only(left:4),
                        child: TextField(
                            controller: logoDescriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 4,
                            onChanged: (value){
                              _setter((){
                                description_str = value;
                              });
                            }
                        )
                    )
                ),
              ])
          ),

          actions: [
            ElevatedButton(
              onPressed:() async{
                if(logo_image != null) {
                  String url =  await uploadFile(logo_image);
                  CustomImage newImage = CustomImage(id:generateID(),url : url, description: description_str);

                  Navigator.pop(context);
                  _setter(() {
                    description_str = '';
                    logoDescriptionController.text = '';
                    logo_image = null;
                    m_inspection_images.add(newImage);
                  });
                  refreshInspectionImages();
                }
                else{
                  showError('Please select Image');
                  return;
                }
              },
              child: Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                _setter(() {
                  description_str = '';
                  logoDescriptionController.text = '';
                  logo_image = null;
                });
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  StatefulBuilder changeDialog(CustomImage m_image) {
    logoDescriptionController.text = m_image.description!;
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text('Edit Asset Image'),
          content:
          Container(
              height: 270,
              child: Column(children: [
                SizedBox(
                    width: 300,
                    child: GestureDetector(
                        onTap:() async{
                          // Image? fromPicker = await ImagePickerWeb.getImageAsWidget();
                          Uint8List? data =  await ImagePickerWeb.getImageAsBytes();
                          _setter(() {
                            logo_image = data!;
                          });
                        },
                        child:  Container(
                            width:200,
                            height: 150,
                            child: logo_image != null? Image.memory(logo_image!) :  Image.network(m_image.url!)
                        )
                    )
                ),
                SizedBox(height: 20),
                SizedBox(
                    height: 100,
                    width: 300,
                    child: Container(
                        margin:EdgeInsets.only(left:4),
                        child: TextField(
                            controller: logoDescriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 4,
                            onChanged: (value){
                              _setter((){
                                description_str = value;
                              });
                            }
                        )
                    )
                ),
              ])
          ),

          actions: [
            ElevatedButton(
              onPressed:() async{
                if(logo_image != null) {
                  String url =  await uploadFile(logo_image);
                  Navigator.pop(context);
                  _setter(() {
                    m_image.description = description_str;
                    m_image.url = url;
                    description_str = '';
                    logoDescriptionController.text = '';
                    logo_image = null;
                  });
                  refreshImages();

                }
                else{
                  showError('Please select Image');
                  return;
                }
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed:() async{
                _setter((){
                  m_images.remove(m_image);
                  description_str = '';
                  logoDescriptionController.text = '';
                  logo_image = null;
                });
                refreshImages();
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                _setter(() {
                  description_str = '';
                  logoDescriptionController.text = '';
                  logo_image = null;
                });
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  StatefulBuilder changeInspectionDialog(CustomImage m_image) {
    logoDescriptionController.text = m_image.description!;
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text('Edit Inspection Image'),
          content:
          Container(
              height: 270,
              child: Column(children: [
                SizedBox(
                    width: 300,
                    child: GestureDetector(
                        onTap:() async{
                          // Image? fromPicker = await ImagePickerWeb.getImageAsWidget();
                          Uint8List? data =  await ImagePickerWeb.getImageAsBytes();
                          _setter(() {
                            logo_image = data!;
                          });
                        },
                        child:  Container(
                            width:200,
                            height: 150,
                            child: logo_image != null? Image.memory(logo_image!) :  Image.network(m_image.url!)
                        )
                    )
                ),
                SizedBox(height: 20),
                SizedBox(
                    height: 100,
                    width: 300,
                    child: Container(
                        margin:EdgeInsets.only(left:4),
                        child: TextField(
                            controller: logoDescriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 4,
                            onChanged: (value){
                              _setter((){
                                description_str = value;
                              });
                            }
                        )
                    )
                ),
              ])
          ),

          actions: [
            ElevatedButton(
              onPressed:() async{
                if(logo_image != null) {
                  String url =  await uploadFile(logo_image);
                  Navigator.pop(context);
                  _setter(() {
                    m_image.description = description_str;
                    m_image.url = url;
                    description_str = '';
                    logoDescriptionController.text = '';
                    logo_image = null;
                  });
                  refreshInspectionImages();

                }
                else{
                  showError('Please select Image');
                  return;
                }
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed:() async{
                _setter((){
                  m_inspection_images.remove(m_image);
                  description_str = '';
                  logoDescriptionController.text = '';
                  logo_image = null;
                });
                refreshInspectionImages();
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                _setter(() {
                  description_str = '';
                  logoDescriptionController.text = '';
                  logo_image = null;
                });
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget getRightContent(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double textfield_width = (screenWidth - 470);
    int rowCount = ((screenWidth - 470)/100 ).floor();
    if(pageMode == 1) {
      return  Column(
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
                      Text(selected_asset_type, style: TextStyle(fontSize: 16 )),
                      SizedBox(height: 7),
                      Text(selected_acquired_year, style: TextStyle(fontSize: 16 )),
                      SizedBox(height: 7),
                      Text(selected_last_inspection, style: TextStyle(fontSize: 16 ))
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
                      Text(selected_category, style: TextStyle(fontSize: 16 )),
                      SizedBox(height: 7),
                      Text(selected_year_registered, style: TextStyle(fontSize: 16 )),
                      SizedBox(height: 7),
                      Text(selected_asset_status, style: TextStyle(fontSize: 16 ))
                    ],
                  )
                ],
              )
          ),
          SizedBox(height: screenHeight - 260,
              child: ContextMenuRegion(
                  contextMenu: GenericContextMenu(
                    buttonConfigs: [
                      ContextMenuButtonConfig(
                        "Add New Asset",
                        onPressed: () {
                          setState(() {
                            pageMode = 2;
                            onAddNewAsset();
                          });
                        },
                      ),
                      ContextMenuButtonConfig(
                        "View Asset Details",
                        onPressed: onAssetDetails,
                      ),
                      ContextMenuButtonConfig(
                        "Delete Asset",
                        onPressed: onDeleteAsset,
                      ),
                      ContextMenuButtonConfig(
                        "Export to CSV",
                        onPressed:() async {
                          String title = "pluto_grid_export";
                          if(stateManager == null) return;
                          var exported = const Utf8Encoder()
                              .convert(pluto_grid_export.PlutoGridExport.exportCSV(stateManager!));
                          // use file_saver from pub.dev
                          await FileSaver.instance.saveFile(name: "download",bytes: exported, ext: 'csv');
                        },
                      ),
                      ContextMenuButtonConfig(
                        "Asset List Report(PDF)",
                        onPressed: (){},
                      ),
                      ContextMenuButtonConfig(
                        "Asset Value Report(PDF)",
                        onPressed: (){},
                      ),
                      ContextMenuButtonConfig(
                        "Asset Value Graph Report(PDF)",
                        onPressed: (){},
                      )
                    ],
                  ),
                  child: LayoutBuilder(
                              builder: (context, constraint) {
                                if (constraint.maxWidth == 0) {
                                  return Container();
                                }
                                return
                                  GestureDetector(
                                    onDoubleTap : (){
                                      if(cur_asset == null)
                                        return;
                                      onAssetDetails();
                                    } ,
                                    child: PlutoGrid(
                                      columns: columns,
                                      rows: rows,
                                      onLoaded: (PlutoGridOnLoadedEvent event) {
                                        if(stateManager == null){
                                          stateManager = event.stateManager;
                                          stateManager!.setShowColumnFilter(true);
                                        }
                                      },
                                      onSelected: (PlutoGridOnSelectedEvent event){
                                        String selected_cell_id = event.row!.cells['id']!.value;
                                        updateAssetDetailInfo(selected_cell_id);
                                      },
                                      mode: PlutoGridMode.selectWithOneTap,
                                    )
                                  );

                              },
                            ),


              )),
        ],
      );
    }
    else if(pageMode == 2) {
      return ListView(
          children: [
            TitledContainer(titleText: 'Asset Details',
                child: Row(children: [
                  Column(
                    children: [
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Asset ID')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 200,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: assetIDController,
                                    onChanged: (value){
                                      cur_asset!.id = value;
                                    },
                                )
                            )
                        ),
                        SizedBox(width:20),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.black),
                                padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                                textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                            onPressed:   (){
                              cur_asset!.id = generateID();
                              assetIDController.text = cur_asset!.id!;
                            },
                            child: const Text('Autofill'))
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Asset Name')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 100,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: assetNameController,

                                    onChanged: (value){
                                      if(cur_asset != null) {
                                        setState(() {
                                          cur_asset!.name = value;
                                        });
                                      }
                                    }
                                )
                            )
                        ),
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Description')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 100,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: descriptionController,

                                    onChanged: (value){
                                      if(cur_asset != null) {
                                        setState(() {
                                          cur_asset!.description = value;
                                        });
                                      }
                                    }
                                )
                            )
                        ),

                      ]),
                      SizedBox(
                        height : 10
                      ),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Asset Code')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 200,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: assetCodeController,
                                    onChanged: (value){
                                      setState(() {
                                        cur_asset!.code = value;
                                      });
                                    }
                                )
                            )
                        ),
                        SizedBox(width:20),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.black),
                                padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                                textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                            onPressed:   (){
                              cur_asset!.code =  generateAssetID(default_type_id,default_category_id);
                              assetCodeController.text = cur_asset!.code!;
                              },
                            child: const Text('Autofill'))
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Address')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 100,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: addressController,

                                    onChanged: (value){
                                      if(cur_asset != null) {
                                        setState(() {
                                          cur_asset!.address = value;
                                        });
                                      }
                                    }
                                )
                            )
                        ),

                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Contact')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 100,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: contactController,


                                    onChanged: (value){
                                      if(cur_asset != null) {
                                        setState(() {
                                          cur_asset!.contact = value;
                                        });
                                      }
                                    }
                                )
                            )
                        ),
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Phone')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 100,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: phoneController,


                                    onChanged: (value){
                                      if(cur_asset != null) {
                                        setState(() {
                                          cur_asset!.phone = value;
                                        });
                                      }
                                    }
                                )
                            )
                        ),

                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Acquired Date')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 100,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                  controller: acquiredDateController,


                                  readOnly: true,
                                  onTap: () async{
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(), //get today's date
                                        firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2101)
                                    );
                                    if(pickedDate!= null)
                                      setState(() {
                                        acquiredDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);//set foratted date to TextField value.
                                        cur_asset!.acquired_date = pickedDate;
                                      });
                                  },
                                )
                            )
                        ),
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Purchased Value')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 100,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: acquiredValueController,
                                    onChanged: (value){
                                      if(value == '') {
                                      setState(() {
                                        acquiredValueController.text = '';
                                        cur_asset!.acquired_value = '0.0';
                                      });
                                      return;
                                      }
                                    if(isFloat(value!) == false) {
                                        setState(() {
                                          acquiredValueController.text = cur_asset!.acquired_value!;
                                        });
                                        return;
                                      }
                                    if(cur_asset != null) {
                                          setState(() {
                                            cur_asset!.acquired_value = value;
                                          });
                                        }
                                    }
                                )
                            )
                        ),
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Cost Center')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 100,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller:  costCenterController,


                                    onChanged: (value){
                                      if(cur_asset != null) {
                                        setState(() {
                                          cur_asset!.cost_center = value;
                                        });
                                      }
                                    }
                                )
                            )
                        ),
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Asset Type')),
                        SizedBox(
                          width : textfield_width - 100,
                          child:
                          Row(
                              children: [
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    SizedBox(height: 18),
                                    SizedBox(
                                        width: textfield_width - 120 ,
                                        child: DropdownButton<String>(
                                          value: cur_asset_type_id == '0' ? (cur_asset == null ? default_type_id : cur_asset!.asset_type_id) : cur_asset_type_id ,
                                          isExpanded: true,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              if(cur_asset_type_id == '0')
                                                cur_asset!.asset_type_id = newValue;
                                              else
                                                cur_asset!.asset_type_id = cur_asset_type_id;
                                            });
                                          },
                                          items: m_asset_type_ids.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(getAssetTypeName(value)),
                                            );
                                          }).toList(),
                                        )
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Category')),
                        SizedBox(
                          width : textfield_width - 100,
                          child:
                          Row(
                              children: [
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    SizedBox(height: 18),
                                    SizedBox(
                                        width: textfield_width - 120 ,
                                        child: DropdownButton<String>(
                                          value: cur_asset == null ? default_category_id : cur_asset!.category_id,
                                          isExpanded: true,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              cur_asset!.category_id = newValue;
                                            });
                                          },
                                          items: m_asset_category_ids.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(getCategoryName(value)),
                                            );
                                          }).toList(),
                                        )
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Status')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 100,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: assetStatusController,
                                    readOnly: true,
                                    onChanged: (value){
                                    }
                                )
                            )
                        ),
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Registered Date')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 100,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                  controller: registredDateController,

                                  readOnly: true,
                                  onTap: () async{
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(), //get today's date
                                        firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2101)
                                    );
                                    if(pickedDate!= null)
                                      setState(() {
                                        registredDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);//set foratted date to TextField value.
                                        cur_asset!.registered_date = pickedDate;
                                      });
                                  },
                                )
                            )
                        ),

                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Registered By')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 100,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: registeredByController,


                                    onChanged: (value){
                                      if(cur_asset != null) {
                                        setState(() {
                                          cur_asset!.registered_by = value;
                                        });
                                      }
                                    }
                                )
                            )
                        ),
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Comment')),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 100,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: commentController,


                                    onChanged: (value){
                                      if(cur_asset != null) {
                                        setState(() {
                                          cur_asset!.comment = value;
                                        });
                                      }
                                    }
                                )
                            )
                        ),
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Level1 Org:')),
                        SizedBox(
                          width : textfield_width - 100,
                          child:
                          Row(
                              children: [
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    SizedBox(height: 18),
                                    SizedBox(
                                        width: textfield_width - 120 ,
                                        child: DropdownButton<String>(
                                          value: cur_node_id_1 ,
                                          isExpanded: true,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              cur_node_id_1 = newValue!;
                                            });
                                            onUpdateLevel1Org();
                                          },
                                          items: node_ids_1.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(getOrganizationName(value,1)),
                                            );
                                          }).toList(),
                                        )
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Level2 Org:')),
                        SizedBox(
                          width : textfield_width - 100,
                          child:
                          Row(
                              children: [
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    SizedBox(height: 18),
                                    SizedBox(
                                        width: textfield_width - 120 ,
                                        child: DropdownButton<String>(
                                          value: cur_node_id_2 ,
                                          isExpanded: true,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              cur_node_id_2 = newValue!;
                                            });
                                            onUpdateLevel2Org();
                                          },
                                          items: node_ids_2.where((element) => element.contains(cur_node_id_1)).map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(getOrganizationName(value,2)),
                                            );
                                          }).toList(),
                                        )
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ]),
                      Row(children: [
                        Container(width : 100, padding: EdgeInsets.only(left : 10,top : 20), child : Text('Level3 Org:')),
                        SizedBox(
                          width : textfield_width - 100,
                          child:
                          Row(
                              children: [
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    SizedBox(height: 18),
                                    SizedBox(
                                        width: textfield_width - 120 ,
                                        child: DropdownButton<String>(
                                          value: cur_node_id_3 ,
                                          isExpanded: true,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                               cur_node_id_3 = newValue!;
                                               cur_asset!.org_id = cur_node_id_3;
                                            });
                                          },
                                          items: node_ids_3.where((element) => element.contains(cur_node_id_2)).map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(getOrganizationName(value,3)),
                                            );
                                          }).toList(),
                                        )
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ]),

                    ],
                  )
                ])
            ),
            SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                      onPressed:   onSaveChanges,
                      child: const Text('Save')),
                  SizedBox(width: 10),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                      onPressed:  (){
                        setState(() {
                          pageMode = 1;
                          LoadAssets();
                        });
                      },
                      child: const Text('Back'))
                ]),
            SizedBox(height: 10),
            if(show_inspection_box) TitledContainer(titleText: 'Asset Images',
                child:  SizedBox(height: 200,
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment : MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                  width: 80,
                                  height:50,
                                  child : FloatingActionButton(
                                    heroTag: "btn1",
                                    onPressed: (){
                                      showDialog(
                                        context: context,
                                        builder: (context) => gradeDialog()  ,
                                      );
                                    },
                                    child: const Icon(Icons.add),
                                  ) )

                            ]
                        ),
                        SizedBox(height:150,child : ListView.builder(
                            padding: const EdgeInsets.only(top: 0),
                            itemCount: (m_images.length / rowCount).ceil() ,
                            itemBuilder: (BuildContext context, int index) {
                              List<Widget> m_list = [];
                              for(int i = 0; i < rowCount; i ++ ){
                                if(index * rowCount + i < m_images.length)
                                  m_list.add(
                                      GestureDetector(
                                          onTap: (){
                                            showDialog(
                                              context: context,
                                              builder: (context) => changeDialog(m_images![index * rowCount + i]!)  ,
                                            );
                                          },
                                          child : Image.network(m_images![index * rowCount + i]!.url!,width: 100)
                                      )

                                  );
                                else
                                  m_list.add(
                                      SizedBox(width:70)
                                  );
                              }
                              return  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children : m_list
                              );
                            }))

                      ],
                    )
                )

            ),
            if(show_inspection_box) SizedBox(height: 10),
            if(show_inspection_box) TitledContainer(
                titleText: 'Asset Inspection',
                child :
                Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width:150,height:40,child:
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.red),
                                  padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                                  textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                              onPressed:  (){
                                setState(() {
                                  pageMode = 3;
                                });
                                onAddInspection();
                              },
                              child: const Text('Add Inspection')))
                        ]),
                    SizedBox(height: 10),
                    SizedBox(height: 320,
                        child: ContextMenuRegion(
                            contextMenu: GenericContextMenu(
                              buttonConfigs: [
                                ContextMenuButtonConfig(
                                  "View Inspection Details",
                                  onPressed: onInspectionDetail,
                                ),
                                ContextMenuButtonConfig(
                                  "Delete Inspection",
                                  onPressed: onDeleteInspection,
                                )
                              ],
                            ),
                            child:  PlutoGrid(
                              columns: columns_2,
                              rows: rows_2,
                              onLoaded: (PlutoGridOnLoadedEvent event) {
                                if(stateManager_2 == null){
                                  stateManager_2 = event.stateManager;
                                  stateManager_2!.setShowColumnFilter(true);
                                  updateInspectionTableContent();
                                }
                              },
                              onSelected: (PlutoGridOnSelectedEvent event){
                                String cur_ins_id = (event.row!.cells['id']!.value);
                                for(Inspection ins in m_inspections){
                                  if(ins.id == cur_ins_id) {
                                    setState(() {
                                      cur_inspection = ins;
                                      m_inspection_images = ins.images!;
                                    });
                                    break;
                                  }
                                }
                              },
                              mode: PlutoGridMode.selectWithOneTap,
                            )
                        )
                    )
                  ],
                )

            )
          ]);
    }
    else{
      return ListView(
          children: [
            TitledContainer(titleText: 'Inspection Details', child:
            Row(children:[
              Column(
                children: [
                SizedBox(
                    height: 50,
                    width: textfield_width,
                    child:
                    Container(
                        margin:EdgeInsets.only(left:20),
                        child: TextFormField(
                          controller: inspectionDateController,
                          decoration: InputDecoration(
                            labelText: 'Inspection Date',
                          ),
                          readOnly: true,
                          onTap: () async{
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(), //get today's date
                                firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );
                            if(pickedDate!= null)
                              setState(() {
                                inspectionDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);//set foratted date to TextField value.
                                cur_inspection!.inspection_date = pickedDate;
                              });
                          },
                        )
                    )
                ),
                SizedBox(
                    height: 50,
                    width: textfield_width,
                    child:
                    Container(
                        margin:EdgeInsets.only(left:20),
                        child: TextFormField(
                            controller: inspectionByController,
                            decoration: InputDecoration(
                              labelText: 'Inspection By',
                            ),
                            onChanged: (value){

                              setState(() {
                                cur_inspection!.inspection_by = value;

                              });
                            }
                        )
                    )
                ),
                  Row(children: [
                    SizedBox(width : 20),
                    SizedBox(
                        width: textfield_width - 20 ,
                        child: DropdownButton<String>(
                          value: cur_inspection!.status,
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              cur_inspection!.status = newValue;
                              cur_asset!.status = newValue;
                              assetStatusController.text = newValue!;
                            });
                          },
                          items: inspectionStatus.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                    )
                  ]),

                SizedBox(
                    height: 50,
                    width: textfield_width,
                    child:
                    Container(
                        margin:EdgeInsets.only(left:20),
                        child: TextFormField(
                            controller: inspectionValueController,
                            decoration: InputDecoration(
                              labelText: 'Inspection Value',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value){
                              setState(() {

                                cur_inspection!.value = value;
                              });
                            }
                        )
                    )
                ),
                SizedBox(
                    height: 50,
                    width: textfield_width,
                    child:
                    Container(
                        margin:EdgeInsets.only(left:20),
                        child: TextFormField(
                            controller: inspectionNextDateController,
                            decoration: InputDecoration(
                              labelText: 'Next Inspection Date',
                            ),
                            readOnly: true,
                            onTap: () async{
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(), //get today's date
                                  firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101)
                              );
                              if(pickedDate!= null)
                                setState(() {
                                  inspectionNextDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);//set foratted date to TextField value.
                                  cur_inspection!.next_inspect_date = pickedDate;
                                });
                            }
                        )
                    )
                ),
                SizedBox(
                    height: 50,
                    width: textfield_width,
                    child:
                    Container(
                        margin:EdgeInsets.only(left:20),
                        child: TextFormField(
                            controller: inspectionCommentController,
                            decoration: InputDecoration(
                              labelText: 'Asset Inspection Comment',
                            ),
                            onChanged: (value){
                              setState(() {
                                cur_inspection!.comment = value;
                              });
                            }
                        )
                    )
                ),
                SizedBox(
                  height: 50,
                  width: textfield_width,

                ),
                SizedBox(
                  height: 50,
                  width: textfield_width,

                ),
              ]
            )] )),
            SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                      onPressed:  onChangeInspection,
                      child: const Text('Save')),
                  SizedBox(width: 10),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                      onPressed:  (){
                        setState(() {
                          pageMode = 2;
                          updateInspectionTableContent();
                        });
                      },
                      child: const Text('Back'))
                ]),
            SizedBox(height: 10),
            TitledContainer(titleText: 'Inspection Images',
                child:  SizedBox(height: 200, child : Column(children: [
                  Row(
                      mainAxisAlignment : MainAxisAlignment.end,
                      children: [
                        SizedBox(
                            width: 80,
                            height:50,
                            child : FloatingActionButton(
                              heroTag: "btn1",
                              onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (context) => gradeDialog_2()  ,
                                );
                              },
                              child: const Icon(Icons.add),
                            ) )

                      ]
                  ),
                  SizedBox(height:150,child : ListView.builder(
                      padding: const EdgeInsets.only(top: 0),
                      itemCount: (m_inspection_images.length / rowCount).ceil() ,
                      itemBuilder: (BuildContext context, int index) {
                        List<Widget> m_list = [];
                        for(int i = 0; i < rowCount; i ++ ){
                          if(index * rowCount + i < m_inspection_images.length)
                            m_list.add(
                                GestureDetector(
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (context) => changeInspectionDialog(m_inspection_images![index * rowCount + i]!)  ,
                                      );
                                    },
                                    child : Image.network(m_inspection_images![index * rowCount + i]!.url!,width: 100)
                                )

                            );
                          else
                            m_list.add(
                                SizedBox(width:70)
                            );
                        }
                        return  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children : m_list
                        );
                      })
                  )
                ]))

            ),
          ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
        padding: EdgeInsets.all(20),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            m_treeview == null?
            SizedBox(
              height: screenHeight - 50,
              width: 300,
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
            ) : SizedBox(width:300,child : m_treeview!),
            Expanded(child:getRightContent(context))
          ])

    );
  }
}
