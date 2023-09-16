import 'dart:convert';

import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/apis/types.dart';
import 'package:assetmamanger/models/assetTypes.dart';
import 'package:assetmamanger/models/folders.dart';
import 'package:assetmamanger/models/groups.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/pages/tenant/assetitem.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class TenantAssets extends StatefulWidget {
  TenantAssets({super.key});
  @override
  _TenantAssets createState() => _TenantAssets();
}
class  _TenantAssets extends State<TenantAssets> {
  String userid = 'bdMg1tPZwEUZA1kimr8b';

  //-------------------Search Features-------------------------------//
  List<AssetType> assetTypes = [] ;
  List<AssetType> search_asset_types = [] ;

  TextEditingController searchEditController = TextEditingController();
  String search_str = '';

  void getAssetTypes() async{
    List<AssetType> dd = await TypeService().getTypes();
    setState(() {
      assetTypes = dd;
    });
    searchItems(search_str);

  }

  void onAdd() {
    setState(() {
      assetTypes.add(AssetType(id: generateID(),type : 'New Asset Type'));
      search_str = '';
      searchEditController.text = '';
    });
    searchItems(search_str);
  }
  //-----------------search feature-------------------------------//
  void searchItems(String val){
    setState(() {
      search_asset_types = [];
    });
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        for(AssetType t in assetTypes){
          if(t.type!.contains(val))
            search_asset_types.add(t);
        }
      });
    });
  }

  //-----------------save features-------------------------------//
  void onSave() async{
    bool IsOk = await TypeService().saveChanges(assetTypes);
    if(IsOk){
      showSuccess('Success');
    }
    else{
      showError('Error');
    }
  }

  void onChangeItem(String ID, String Type){
    for(AssetType type in assetTypes){
      if(type.id == ID) {
        setState(() {
          type.type = Type;
        });
        break;
      }
    }
  }
  void onDeleteItem(String ID){
    for(AssetType type in assetTypes){
      if(type.id == ID) {
        setState(() {
          assetTypes.remove(type);
        });
        break;
      }
    }
    search_str = '';
    searchEditController.text = '';
    searchItems(search_str);
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
    getAssetTypes();
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
          itemCount: (search_asset_types.length/3).ceil(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            AssetType? ele = search_asset_types[3 * index] ;
            AssetType? ele_2 = 3 * index + 1 >= search_asset_types.length ? null: search_asset_types[3 * index + 1] ;
            AssetType? ele_3 = 3 * index + 2 >= search_asset_types.length ? null: search_asset_types[3 * index + 2] ;

            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width : tile_width, child: Center(child:AssetItem(assetTypeID: ele.id, assetTypeName : ele.type, onChange: onChangeItem, onDelete: onDeleteItem ))) ,
                  ele_2 != null ?  SizedBox(width : tile_width, child: Center(child:AssetItem(assetTypeID: ele_2.id, assetTypeName : ele_2.type, onChange: onChangeItem, onDelete: onDeleteItem ))) : SizedBox(width: tile_width),
                  ele_3 != null ?  SizedBox(width : tile_width, child: Center(child:AssetItem(assetTypeID: ele_3.id, assetTypeName : ele_3.type, onChange: onChangeItem, onDelete: onDeleteItem ))) : SizedBox(width: tile_width),
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
              titleText: 'Asset Typess',
              idden: 10,
              child: getResponsiveWidget(context),
              title_color: Colors.orange.withOpacity(0.8),
          ))
        ],
      ),
    );
  }
}
