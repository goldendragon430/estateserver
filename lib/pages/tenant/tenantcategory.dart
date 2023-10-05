import 'dart:convert';


import 'package:assetmamanger/apis/categories.dart';
import 'package:assetmamanger/models/category.dart';
import 'package:assetmamanger/pages/tenant/categoryitem.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/pages/tenant/assetitem.dart';

class TenantCategory extends StatefulWidget {
  TenantCategory({super.key});
  @override
  _TenantCategory createState() => _TenantCategory();
}
class  _TenantCategory extends State<TenantCategory> {
  String userid = 'yC1ntHsOuPgVS4yGhjqG';
  //-------------------Search Features-------------------------------//
  List<Category> categories = [] ;
  List<Category> search_asset_types = [] ;

  TextEditingController searchEditController = TextEditingController();
  String search_str = '';

  void getcategories() async{
    List<Category> dd = await CategoryService().getCategory(userid);
    setState(() {
      categories = dd;
    });
    searchItems(search_str);

  }

  void onAdd() {
    setState(() {
      categories.add(Category(id: generateID(),name : 'New Category', userid: userid));
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
        for(Category t in categories){
          if(t.name!.contains(val))
            search_asset_types.add(t);
        }
      });
    });
  }

  //-----------------save features-------------------------------//
  void onSave() async{
    bool IsOk = await CategoryService().saveChanges(categories,userid);
    if(IsOk){
      showSuccess('Success');
    }
    else{
      showError('Error');
    }
  }

  void onChangeItem(String ID, String name){
    for(Category category in categories){
      if(category.id == ID) {
        setState(() {
          category.name = name;
        });
        break;
      }
    }
  }
  void onDeleteItem(String ID){
    for(Category category in categories){
      if(category.id == ID) {
        setState(() {
          categories.remove(category);
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
    String? userDataString =  getStorage('user');
    Map<String, dynamic>? data =  jsonDecode(userDataString!);
    setState(() {
      userid = data?['id'];
    });
    getcategories();
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
            Category? ele = search_asset_types[3 * index] ;
            Category? ele_2 = 3 * index + 1 >= search_asset_types.length ? null: search_asset_types[3 * index + 1] ;
            Category? ele_3 = 3 * index + 2 >= search_asset_types.length ? null: search_asset_types[3 * index + 2] ;

            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width : tile_width, child: Center(child:CategoryItem(categoryID : ele.id, categoryName : ele.name, onChange: onChangeItem, onDelete: onDeleteItem ))) ,
                  ele_2 != null ?  SizedBox(width : tile_width, child: Center(child:CategoryItem(categoryID: ele_2.id, categoryName : ele_2.name, onChange: onChangeItem, onDelete: onDeleteItem ))) : SizedBox(width: tile_width),
                  ele_3 != null ?  SizedBox(width : tile_width, child: Center(child:CategoryItem(categoryID: ele_3.id, categoryName : ele_3.name, onChange: onChangeItem, onDelete: onDeleteItem ))) : SizedBox(width: tile_width),
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
              titleText: 'Categories',
              idden: 10,
              child: getResponsiveWidget(context),
            title_color: Colors.orange.withOpacity(0.8),
          ))
        ],
      ),
    );
  }
}
