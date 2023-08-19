import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/models/assetTypes.dart';
import 'package:assetmamanger/models/assets.dart';
import 'package:assetmamanger/models/category.dart';
import 'package:assetmamanger/models/folders.dart';
import 'package:assetmamanger/models/groups.dart';
import 'package:assetmamanger/models/inspections.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/pages/user/inspectionitem.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:typed_data';
import 'dart:math';
import 'package:intl/intl.dart';

class AssetDetailView extends StatefulWidget {
  final dynamic data;
  AssetDetailView({super.key,this.data});
  @override
  _AssetDetailView createState() => _AssetDetailView();
}
class  _AssetDetailView extends State<AssetDetailView> {
  int hoveredIndex = -1;
  int hoveredIndex2 = -1;

  List<String> images = <String>['Image1', 'Image2', 'Image3', 'Image4'];
  List<String> filteredItems = [];


//---------------------Main variables----------------------------//
  String folder_id = 'ztqpy4ld8a';
  String group_id = 'd5mkdmszbj';
  String asset_type_id = 'v2d1ovm3jo';
  String category_id = 'sgl2ecvyv4';
  String user_id = 'bdMg1tPZwEUZA1kimr8b';

  Tenant m_tenant = Tenant(); //DB's instance
  List<Asset>  m_assets = [];
  String asset_logo = '';
//--------------------Asset Detail Variables-----------------------//

  String assetTypeName = '';
  String categoryName = '';
//--------------------ListView Handler------------------------------//

  String selected_asset_id = '';
  Asset? cur_asset = null;
  TextEditingController idEditController = TextEditingController();
  TextEditingController nameEditController = TextEditingController();
  TextEditingController assetTypeEditController = TextEditingController();
  TextEditingController categoryEditController = TextEditingController();
  TextEditingController acquiredDateController = TextEditingController();
  TextEditingController lastInspectionController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  List<Inspection> m_inspections = [];

//--------------------Add dialog Variables----------------------------//
  Uint8List? logo_image = null;
  String filepath = '';
  DateTime new_inspec_date = DateTime(2023);
  bool new_function_condition = false;
  String new_money_value = '';
  DateTime new_next_inspec = DateTime(2023);
  String new_comment = '';
  TextEditingController newInspecController = TextEditingController();
  TextEditingController nextInspecController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  String? status = 'Active';
  String? asset_value;
  List<String> status_list = ['Active','Disposed','Non Operational','UnAccounted','Sold Off'];



  void loadAssetdata(){
    if(cur_asset != null){
      setState(() {
        idEditController.text = cur_asset!.id!;
        nameEditController.text = cur_asset!.name!;
        assetTypeEditController.text = assetTypeName;
        categoryEditController.text = categoryName;
        acquiredDateController.text = DateFormat('yyyy-MM-dd').format(cur_asset!.acquired_date!);
        lastInspectionController.text = DateFormat('yyyy-MM-dd').format(cur_asset!.last_inspection_date!);
        commentController.text = cur_asset!.comment!;
        m_inspections = [];
        asset_logo = '';
      });
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          m_inspections = cur_asset!.inspections!;
        });
      });
    }
  }
  void fetchData() async{
    Tenant? result =  await TenantService().getTenantDetails(user_id);
    if(result != null) {
      m_tenant = result;
      for(Folder folder in m_tenant.folders!){
        if(folder.id == folder_id){
          for(Group group in folder.groups!){
            if(group.id == group_id){
              for(AssetType type in group.assetTypes!){
                if(type.id == asset_type_id){
                  setState(() {
                    assetTypeName = type.type!;
                  });
                  for(Category category in type.categories!){
                    if(category.id == category_id){

                        setState(() {
                          categoryName = category.name!;
                          m_assets = category.assets!;
                          if(m_assets.length > 0){
                            selected_asset_id = m_assets[0].id!;
                            cur_asset = m_assets[0];
                          }
                        });
                        loadAssetdata();
                      break;
                    }
                    break;
                  }
                  break;
                }
              }
              break;
            }
          }
          break;
        }
      }
    }
  }
  void searchItems(String query) {

  }
  void onAdd(){
    Asset new_asset = Asset(id : generateAssetID(),name : 'New Asset',acquired_date: DateTime.now(),last_inspection_date: DateTime.now(),comment: '',inspections: [],created_date: DateTime.now());
    setState(() {
      m_assets.add(new_asset);
      cur_asset = new_asset;
      selected_asset_id = cur_asset!.id!;
      asset_logo = '';
    });
    loadAssetdata();
  }
  void onDelete(){
   if(m_assets.length>0){
     m_assets.remove(cur_asset);
     setState(() {
       cur_asset = m_assets[0];
       selected_asset_id = cur_asset!.id!;
     });
   }
   else
     cur_asset = null;
   loadAssetdata();
  }
  String generateAssetID(){
    Random random = Random();
    int randomNumber = random.nextInt(9000) + 1000;
    String id = '${m_tenant.user_id}-${folder_id}-${group_id}-${asset_type_id}-${category_id}-${DateTime.now().year}-${randomNumber}';
    return id;
  }
  void onSave() async{
    bool isOk = await TenantService().createTenantDetails(m_tenant);
    if(isOk){
      showSuccess('Success');
    }else{
      showError('Error');
    }

  }
  @override
  void initState() {
    super.initState();

    Map<String,String> data = widget.data as Map<String,String>;
    setState(() {
      folder_id = data['folder_id']!;
      group_id  = data['group_id']!;
      asset_type_id = data['asset_type_id']!;
      category_id = data['category_id']!;
      user_id = data['user_id']!;
    });
    fetchData();
  }
  void onInspectionChange(String id, DateTime inspection_date,bool condition,String asset_money_value,DateTime next_inspection, String comment, String value, String status){
    setState(() {
      for(Inspection inspection in m_inspections){
        if(inspection.id == id){
          inspection.inspection_date = inspection_date;
          inspection.full_condition = condition;
          inspection.asset_money_value = asset_money_value;
          inspection.next_inspect_date = next_inspection;
          inspection.comment = comment;
          inspection.status = status;
          inspection.value = value;
          break;
        }
      }
    });

  }
  void onInspectionDelete(String id){
    print(id);

    List<Inspection> t_inspections = [];
    for(Inspection inspection in m_inspections){
      print(inspection.id);
      if(inspection.id == id){
        setState(() {
          m_inspections.remove(inspection);
          t_inspections = List.from(m_inspections);
          m_inspections = [];
        });
        break;
      }
    }

    Future.delayed(const Duration(milliseconds: 50), () {
     setState(() {
       m_inspections = t_inspections;
       cur_asset!.inspections = t_inspections;
     });
    });
  }
  StatefulBuilder gradeDialog() {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text('Add new inspection'),
          content:
          Container(
              height: 500,
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
                    height: 35,
                    width: 300,
                    child: Container(
                        margin:EdgeInsets.only(left:4),
                        child: TextField(
                            controller: newInspecController,
                            decoration: InputDecoration(
                              hintText: 'Inspection_date',
                            ),
                            readOnly: true,
                            onTap: () async{
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(), //get today's date
                                  firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101)
                              );
                              if(pickedDate != null){
                                _setter((){
                                  newInspecController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                });
                              }
                            }
                        )
                    )
                ),
                SizedBox(
                    width : 300,
                    height : 60,
                    child: DropdownButton<String>(
                      value: status,
                      padding: EdgeInsets.all(5),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          status = newValue;
                        });
                      },
                      items: status_list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                ),
                SizedBox(
                    width: 300,
                    height: 35,
                    child:
                    Container(
                        margin:EdgeInsets.only(left:4),
                        child: TextField(
                            controller: valueController,
                            decoration: InputDecoration(
                              hintText: 'Asset Value',
                            ),
                            onChanged: (value){
                              setState(() {
                                asset_value = value;
                              });
                             }
                        )
                    )
                ),
                SizedBox(height: 20),
                SizedBox(
                    height: 35,
                    width: 300,
                    child: Container(
                        margin:EdgeInsets.only(left:4),
                        child: TextField(

                            decoration: InputDecoration(
                              hintText: 'Asset Money Value',
                            ),
                            onChanged: (value){
                            _setter((){
                              new_money_value = value;
                            });
                            }
                        )
                    )
                ),
                SizedBox(height: 20),
                SizedBox(
                    height: 35,
                    width: 300,
                    child: Container(
                        margin:EdgeInsets.only(left:4),
                        child: TextField(
                            controller: nextInspecController,
                            decoration: InputDecoration(
                              hintText: 'Next Inspection Date',
                            ),
                            readOnly: true,
                            onTap: () async{
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(), //get today's date
                                  firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101)
                              );
                              if(pickedDate != null){
                                _setter((){
                                  nextInspecController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                });
                              }
                            }
                        )
                    )
                ),
                SizedBox(height: 20),
                SizedBox(
                    height: 70,
                    width: 300,
                    child: Container(

                        margin:EdgeInsets.only(left:4),
                        child: TextField(

                            decoration: InputDecoration(
                              hintText: 'Comment',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            onChanged: (value){
                                _setter((){
                                  new_comment = value;
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
                  Inspection inspection = Inspection(id:generateID(),status: status,value: asset_value,inspection_date: new_inspec_date,full_condition: new_function_condition,asset_money_value: new_money_value,next_inspect_date: new_next_inspec,comment: new_comment,logo: url);
                  _setter(() {
                    new_inspec_date = DateTime(2023);
                    new_money_value = '';
                    new_next_inspec = DateTime(2023);
                    new_comment = '';
                    newInspecController.text = '';
                    nextInspecController.text = '';
                    logo_image = null;
                    asset_value = '';
                    status = 'Active';
                  });
                  setState(() {
                    m_inspections.add(inspection);
                  });
                  Navigator.pop(context);
                }
                else{
                  showError('Please select Image');
                  return;
                }
              },
              child: Text('Create'),
            ),
            ElevatedButton(
              onPressed: () {
                _setter(() {

                  new_inspec_date = DateTime(2023);
                  new_money_value = '';
                  new_next_inspec = DateTime(2023);
                  new_comment = '';
                  newInspecController.text = '';
                  nextInspecController.text = '';
                  new_function_condition = false;
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
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double textfield_width = screenWidth - 600 > 600 ? 600 : screenWidth - 600;
    return   Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            width : 300,
            color:Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10,bottom: 20),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchItems(value);
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
                ),
                Text('**Search from DM and if found add to the cached list and display'),
                SizedBox(height: 10),
                Expanded(child: ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: m_assets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_asset_id = m_assets[index].id!;
                          cur_asset = m_assets[index];
                        });
                        loadAssetdata();
                      },
                      child: MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            hoveredIndex = index;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            hoveredIndex = -1;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 40,
                          color: hoveredIndex == index ? Color.fromRGBO(150, 150, 150, 0.2) : Colors.white,
                          child: Row(
                            children: [
                               Image.asset('assets/images/asset2.png'),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text('${m_assets[index].name}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:[
                  FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: onAdd,
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton(
                    heroTag: "btn2",
                    backgroundColor: Colors.red,
                    onPressed: onDelete,
                    child: const Icon(Icons.delete),
                  ),
                  FloatingActionButton(
                    heroTag: "btn3",
                    backgroundColor: Colors.green,
                    onPressed : onSave,
                    child: const Icon(Icons.save),
                  ),
                ]),
                SizedBox(height:20),
                Text('**Cached Assets from filtered list'),
              ],
            )
        ),
        Expanded(
            child:
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(left:30),
              child: Column(
                children: [
                  TitledContainer(
                      titleText: 'Asset Details',
                      idden: 10,
                      child:
                      Column(
                          children: [
                            Row(
                              children: [
                                asset_logo == '' ? Image.asset('assets/images/asset2.png',width: 200,height: 150) : Image.network(asset_logo,width: 200,height: 150),
                                Column(
                                  children: [
                                    SizedBox(
                                        height: 35,
                                        width: textfield_width,
                                        child:
                                        Container(
                                            margin:EdgeInsets.only(left:20),
                                            child: TextField(
                                              controller: idEditController,
                                                decoration: InputDecoration(
                                                  hintText: 'Asset ID',
                                                ),
                                              readOnly: true,
                                            )
                                        )

                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(
                                        height: 35,
                                        width: textfield_width,
                                        child:
                                        Container(
                                            margin:EdgeInsets.only(left:20),
                                            child: TextField(
                                              controller: nameEditController,
                                                decoration: InputDecoration(
                                                  hintText: 'Asset Name',
                                                ),
                                              onChanged: (value){
                                                setState(() {
                                                  cur_asset!.name = value;
                                                });
                                              },

                                            )
                                        )

                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(
                                        height: 35,
                                        width: textfield_width,
                                        child:
                                        Container(
                                            margin:EdgeInsets.only(left:20),
                                            child: TextField(
                                              controller: assetTypeEditController,
                                                decoration: InputDecoration(
                                                  hintText: 'Asset Type',
                                                ),
                                              readOnly: true,
                                            )
                                        )

                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(
                                        height: 35,
                                        width: textfield_width,
                                        child:
                                        Container(
                                            margin:EdgeInsets.only(left:20),
                                            child: TextField(
                                              controller: categoryEditController,
                                                decoration: InputDecoration(
                                                  hintText: 'Category Name',
                                                ),
                                              readOnly: true,
                                            )
                                        )

                                    )
                                  ],
                                )

                              ],
                            ),
                            Row(children: [
                               SizedBox(
                                   width: 200,
                                   height:130,
                                   child: ListView.builder(
                                 padding: const EdgeInsets.only(top: 0),
                                 itemCount: m_inspections.length,
                                 itemBuilder: (BuildContext context, int index) {
                                   return GestureDetector(
                                     onTap: () {
                                       String url = m_inspections[index].logo!;
                                       setState(() {
                                         asset_logo = url;
                                       }); 
                                     },
                                     child: MouseRegion(
                                       onEnter: (event) {
                                         setState(() {
                                           hoveredIndex2 = index;
                                         });
                                       },
                                       onExit: (event) {
                                         setState(() {
                                           hoveredIndex2 = -1;
                                         });
                                       },

                                       child: Container(
                                         margin: const EdgeInsets.only(top: 1),
                                         height: 40,
                                         alignment: Alignment.center,
                                         color: hoveredIndex2 == index ? Color.fromRGBO(150, 150, 150, 0.2) : Colors.white,
                                         child: Text('image${index + 1}',textAlign: TextAlign.center,)
                                       ),
                                     ),
                                   );
                                 },
                               )
                               ),Expanded(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                          Row(children: [
                                            SizedBox(
                                                height: 35,
                                                width: 200,
                                                child:
                                                Container(
                                                    margin:EdgeInsets.only(left:20),
                                                    child: TextField(
                                                        controller: acquiredDateController,
                                                        decoration: InputDecoration(
                                                          hintText: 'Acquired Date',
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
                                                              acquiredDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);//set foratted date to TextField value.
                                                              cur_asset!.acquired_date = DateTime.parse(acquiredDateController.text);
                                                            });

                                                      },
                                                    )
                                                )

                                            ),
                                            SizedBox(
                                                height: 35,
                                                width: 200,
                                                child:
                                                Container(
                                                    margin:EdgeInsets.only(left:20),
                                                    child:  TextField(
                                                      controller: lastInspectionController,
                                                      decoration: InputDecoration(
                                                        hintText: 'last Inspected Date',
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
                                                            lastInspectionController.text = DateFormat('yyyy-MM-dd').format(pickedDate);//set foratted date to TextField value.
                                                            cur_asset!.last_inspection_date = DateTime.parse(lastInspectionController.text);
                                                          });

                                                      },
                                                    )
                                                )

                                            ),
                                          ]),
                                          SizedBox(height: 5),
                                          Row(children: [
                                            SizedBox(width:20),
                                            SizedBox(
                                                width:textfield_width - 20,
                                                child:TextField(
                                                    maxLines: 3,
                                                    controller: commentController,
                                                    decoration: InputDecoration(
                                                      hintText: 'Comments',
                                                      border: OutlineInputBorder(),
                                                    ),
                                                  onChanged: (value){
                                                      setState(() {
                                                        cur_asset!.comment = value;
                                                      });
                                                  },
                                                ))
                                          ])
                              ]))
                            ])
                          ],
                      ),
                  ),
                  SizedBox(height:10),
                  Expanded(
                      child: TitledContainer(
                                titleText: 'Inspections',
                                idden: 10,
                                child: Column(
                                          children: [
                                            SizedBox(height: 20),
                                            Row(
                                                mainAxisAlignment : MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width:10),
                                                  ElevatedButton(onPressed: (){
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => gradeDialog()  ,
                                                    );

                                                  }, child: Text('Add Inspection'))
                                                ]),
                                            SizedBox(height: 10),
                                            SizedBox(
                                                height: screenHeight - 540,
                                                child :  ListView.builder(
                                                    padding: const EdgeInsets.only(top: 0),
                                                    itemCount:  m_inspections.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return  InspcetionItem(status: m_inspections[index].status,value: m_inspections[index].value, id : m_inspections[index].id!, logo: m_inspections[index].logo!,inspection_date: m_inspections[index].inspection_date,functional_condition: m_inspections[index].full_condition,asset_money_value: m_inspections[index].asset_money_value,next_inspection: m_inspections[index].next_inspect_date,comment: m_inspections[index].comment,onChange: onInspectionChange,onDelete: onInspectionDelete);
                                                    })
                                            )
                                            ],
                                          )

                  )),

                ],
              ),
            )


        ),
      ],
    );
  }
}
